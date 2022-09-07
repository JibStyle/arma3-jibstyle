// Setup HC
if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_hc_moduleValidate = {};

// Register client event handlers
jib_hc_registerEH = {
    if (!hasInterface) exitWith {};

    addMissionEventHandler ["CommandModeChanged", {
        params ["_isHighCommand", "_isForced"];
        setGroupIconsVisible [true, false];
    }];

    addMissionEventHandler ["EntityRespawned", {
        params ["_newEntity", "_oldEntity"];
        [
            "JIB hc respawn from %1 to %2",
            _oldEntity,
            _newEntity
        ] call BIS_fnc_logFormat;
        [_oldEntity, _newEntity] remoteExec ["jib_hc_transfer", 2];
    }];

    addMissionEventHandler ["TeamSwitch", {
        params ["_previousUnit", "_newUnit"];
        [
            "JIB hc teamswitch from %1 to %2",
            _previousUnit,
            _newUnit
        ] call BIS_fnc_logFormat;
        [_previousUnit, _newUnit] remoteExec ["jib_hc_transfer", 2];
    }];
};

// Transfer HC
jib_hc_transfer = {
    params ["_oldUnit", "_newUnit"];
    if (!isServer) then {throw "Not server"};
    [
        "JIB hc transfer from %1 to %2",
        _oldUnit,
        _newUnit
    ] call BIS_fnc_logFormat;
    {
        _oldUnit hcRemoveGroup _x;
        _newUnit hcSetGroup [_x];
    } forEach hcAllGroups _oldUnit;
};

// Make unit a commander.
jib_hc_promote = {
    params ["_leader"];
    if (not isServer) then {throw "Not server!"};
    if (not alive _leader) then {throw "Leader not alive!"};

    // Throw if already HC
    {
        if (_x isKindOf "HighCommand") then {throw "Already HC"};
    } forEach synchronizedObjects _leader;

    // Maybe create logic group
    if (isNil "jib_hc_group") then {
        jib_hc_group = createGroup sideLogic;
    };

    // Create logics
    private _hc = jib_hc_group createUnit [
        "HighCommand", [0, 0, 0], [], 0, "NONE"
    ];
    private _hcSub = jib_hc_group createUnit [
        "HighCommandSubordinate", [0, 0, 0], [], 0, "NONE"
    ];
    _hc synchronizeObjectsAdd [_leader, _hcSub];

    // Enable MARTA
    [[], {
        setGroupIconsVisible [true, false];
        if (isNil "jib_hc_promoteDidRegisterEH") then {
            addMissionEventHandler ["CommandModeChanged", {
                params ["_isHighCommand", "_isForced"];
                setGroupIconsVisible [true, false];
            }];
        };
        jib_hc_promoteDidRegisterEH = true;
    }] remoteExec ["spawn", _leader];

    true;
};

// Add group to HC commander.
jib_hc_add = {
    params ["_commander", "_group"];
    if (not isServer) then {throw "Not server!"};
    if (isNull _commander) then {throw "Commander not alive!"};
    if (isNull _group) then {throw "Null group!"};
    private _timeout = 5;

    // Add group to HC
    if (hcLeader _group != _commander) then {
        hcLeader _group hcRemoveGroup _group;
        private _t = time + _timeout;
        waitUntil { isNull hcLeader _group || time > _t };
        _commander hcSetGroup [_group];
        _t = time + _timeout;
        waitUntil { hcLeader _group == _commander || time > _t};
    };
    true;
};

// Print all commanders and their subordinate groups
jib_hc_debug = {
    {
        private _groups = hcAllGroups _x;
        if (count _groups == 0) then { continue };
        systemChat format ["Leader: %1 -- Groups: %2", _x, _groups];
    } forEach allUnits; // NOTE: Waiting to respawn not counted
    true;
};

// Remove all subordinate groups from commander.
jib_hc_demote = {
    params ["_leader"];
    if (not isServer) then {throw "Not server!"};
    if (isNull _leader) then {throw "Null leader!"};

    // Remove all groups
    hcRemoveAllGroups _leader;

    // Disable MARTA
    [[], {
        setGroupIconsVisible [false, false];
    }] remoteExec ["spawn", _leader];

    true;
};

// Remove group from HC.
jib_hc_remove = {
    params ["_group"];
    if (not isServer) then {throw "Not server!"};
    if (isNull _group) then {throw "Null group!"};
    hcLeader _group hcRemoveGroup _group;
    true;
};

// Make unit a commander.
//
// If unit already a commander, they are unaffected. Also, unit saved
// in global variable and used later by HC Add module.
jib_hc_modulePromote = {
    [
        _this,
        {
            params ["_entity", "_client"];
            jib_hc_selectedCommander = _entity;
            [_entity] call jib_hc_promote;
            [] remoteExec ["jib_hc_debug", _client];
        }
    ] call jib_hc_moduleValidate;
};

// Add unit's group to selected HC commander.
//
// HC commander should already have been selected by a `fn_hcPromote`
// call.
jib_hc_moduleAdd = {
    [
        _this,
        {
            params ["_entity", "_client"];
            [
                jib_hc_selectedCommander,
                group _entity
            ] call jib_hc_add;
            [] remoteExec ["jib_hc_debug", _client];
        }
    ] call jib_hc_moduleValidate;
};

// Print all commanders and their subordinate groups
jib_hc_moduleDebug = {
    [
        _this,
        {[] call jib_hc_debug;},
        "local"
    ] call jib_hc_moduleValidate;
};

// Remove all subordinate groups from commander.
jib_hc_moduleDemote = {
    [
        _this,
        {
            params ["_entity", "_client"];
            [_entity] call jib_hc_demote;
            [] remoteExec ["jib_hc_debug", _client];
        }
    ] call jib_hc_moduleValidate;
};

// Remove unit's group from HC.
jib_hc_moduleRemove = {
    [
        _this,
        {
            params ["_entity", "_client"];
            [group _entity] call jib_hc_remove;
            [] remoteExec ["jib_hc_debug", _client];
        }
    ] call jib_hc_moduleValidate;
};

// Remote calls
publicVariable "jib_hc_modulePromote";
publicVariable "jib_hc_moduleAdd";
publicVariable "jib_hc_moduleDebug";
publicVariable "jib_hc_moduleDemote";
publicVariable "jib_hc_moduleRemove";
publicVariable "jib_hc_debug";
publicVariable "jib_hc_registerEH";
[] remoteExec ["jib_hc_registerEH", 0, true];
