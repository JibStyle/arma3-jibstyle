// Zeus functions
if (!isServer) exitWith { "Not server!" };

// Event handler for mission start.
jib_zeus_handlerMissionStart = {
    if (!isServer) then {throw "Not server!"};
    [] call jib_zeus_adminCreate;
    [allCurators] call jib_zeus_setupInventory;
    [allCurators] call jib_zeus_addRespawnPositions;
    [] spawn jib_zeus_adminAssign;
};

// Mission event handler for entity respawn.
jib_zeus_handlerMissionEntityRespawned = {
    params ["_oldUnit", "_newUnit"];
    if (!isServer) then {throw "Not server!"};
    [_oldUnit, _newUnit] spawn jib_zeus_transfer;
};

// Mission event handler for team switch.
jib_zeus_handlerMissionTeamSwitch = {
    params ["_oldUnit", "_newUnit"];
    if (!isServer) then {throw "Not server!"};
    [_oldUnit, _newUnit] spawn jib_zeus_transfer;
};

// Mission event handler for admin state change.
jib_zeus_handlerMissionOnUserAdminStateChanged = {
    if (!isServer) then {throw "Not server!"};
    [] spawn jib_zeus_adminAssign;
};

// Event handler for select player.
jib_zeus_selectPlayerHandler = {
    params ["_oldUnit", "_newUnit"];
    [_oldUnit, _newUnit] remoteExec ["jib_zeus_transfer", 2];
    [false, false] call BIS_fnc_forceCuratorInterface;
};

// PRIVATE

// Assign admin curator
jib_zeus_adminAssign = {
    if (!isServer) then {throw "Not server!"};
    if (!canSuspend) then {throw "Cannot suspend!"};

    // Wait for mission start
    waitUntil {
        time > 0
            && count allPlayers > 0
            && count (allPlayers select {local _x}) == 0
    };

    // Get admin
    private _admin = objNull
    if (hasInterface) then {
        _admin = player;
    } else {
        allPlayers apply {
            if (admin owner _x > 0) then {
                _admin = _x;
            };
        };
    };

    // Assign curator
    [jib_zeus_adminCurator, _admin] call jib_zeus_assign;
};

// Create special curator for admin
jib_zeus_adminCreate = {
    if (!isServer) then {throw "Not server!"};
    jib_zeus_adminCurator = createGroup sideLogic createUnit [
        "ModuleCurator_F",
        [500,500,0],
        [],
        0,
        "NONE"
    ];
    jib_zeus_adminCurator setVariable ["Addons", 3];
    jib_zeus_adminCurator setVariable ["owner", "#adminLogged"];
    jib_zeus_adminCurator setVariable [
        "BIS_fnc_initModules_disableAutoActivation", false
    ];
};

// Assign curator to unit
jib_zeus_assign = {
    params ["_curator", "_unit"];
    if (!isServer) then {throw "Not server!"};
    if (!canSuspend) then {throw "Cannot suspend!"};
    unassignCurator _curator;
    waitUntil { isNull getAssignedCuratorUnit _curator };
    _unit assignCurator _curator;
};

// Transfer curator between units
jib_zeus_transfer = {
    params ["_oldUnit", "_newUnit"];
    if (!isServer) then {throw "Not server!"};
    private _curator = getAssignedCuratorUnit _oldUnit;
    if (_curator) then {
        [_curator, _newUnit] call jib_zeus_assign;
    };
};

// Activate all addons loaded in game.
//
// By default, only items referenced by a mission are activated.
jib_zeus_activateAddons = {
    private _addons = [];
    private _cfgPatches = configfile >> "cfgpatches";
    for "_i" from 0 to (count _cfgPatches - 1) do {
        _class = _cfgPatches select _i;
        if (isclass _class) then {
            _addons set [count _addons, configname _class];
        };
    };
    activateAddons _addons;
};

// Default Respawn Inventories
jib_zeus_setupInventory = {
    params ["_curators"];
    {
        [
            _x,  // Curator
            false // true for all, false for units curator can place
        ] call BIS_fnc_moduleRespawnInventory
    } forEach _curators;
    [west, ["B_Protagonist_VR_F"]] call BIS_fnc_setRespawnInventory;
    [east, ["O_Protagonist_VR_F"]] call BIS_fnc_setRespawnInventory;
    [independent, ["I_Protagonist_VR_F"]] call BIS_fnc_setRespawnInventory;
    [civilian, ["C_Protagonist_VR_F"]] call BIS_fnc_setRespawnInventory;
};

// Add respawn positions to curators
jib_zeus_addRespawnPositions = {
    params ["_curators"];
    if (!isServer) then {throw "Not server!"};
    _curators apply {
        _x addCuratorEditableObjects [
            allMissionObjects "ModuleRespawnPosition_F",
            true
        ];
    };
};

// Publish variables
publicVariable "jib_zeus_activateAddons";
