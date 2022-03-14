if (!isServer) exitWith {};

// Get support data from unit
jib_support_fnc_get = {
    params ["_unit", "_context", "_callback"];

    // Get module pairs synced to unit
    private _supportLinks = [];
    {
        if (!(_x isKindOf "SupportRequester")) then {continue};
        private _requester = _x;
        {
            if (!(_x isKindOf "SupportProvider_Base")) then { continue };
            private _provider = _x;
            _supportLinks pushBack [_requester, _provider];
        } forEach (synchronizedObjects _requester);
    } forEach (synchronizedObjects _unit);

    // Get simple variables
    private _hq = _unit getVariable ["BIS_SUPP_HQ", objNull];
    private _artillery = _unit getVariable ["BIS_SUPP_used_Artillery", 0];
    private _casBombing = _unit getVariable ["BIS_SUPP_used_CAS_Bombing", 0];
    private _casHeli = _unit getVariable ["BIS_SUPP_used_CAS_Heli", 0];
    private _drop = _unit getVariable ["BIS_SUPP_used_Drop", 0];
    private _transport = _unit getVariable ["BIS_SUPP_used_Transport", 0];
    private _uav = _unit getVariable ["BIS_SUPP_used_UAV", 0];

    // Pack into result
    private _result = [
        _supportLinks,
        _hq,
        _artillery,
        _casBombing,
        _casHeli,
        _drop,
        _transport,
        _uav
    ];
    [_result, _context] call _callback;
};
publicVariable "jib_support_fnc_get";

// Set support data to unit
jib_support_fnc_set = {
    params [
        "_unit",
        "_data"
    ];
    _data params [
        ["_supportLinks", [], [[]]],
        ["_hq", objNull, [objNull]],
        ["_artillery", 0, [0]],
        ["_casBombing", 0, [0]],
        ["_casHeli", 0, [0]],
        ["_drop", 0, [0]],
        ["_transport", 0, [0]],
        ["_uav", 0, [0]]
    ];

    // Add links
    {
        _x params ["_requester", "_provider"];
        [_unit, _requester, _provider] call BIS_fnc_addSupportLink; // race?
    } forEach _supportLinks;

    // Set simple variables
    _unit setVariable ["BIS_SUPP_HQ", _hq, true];
    _unit setVariable ["BIS_SUPP_used_Artillery", _artillery, true];
    _unit setVariable ["BIS_SUPP_used_CAS_Bombing", _casBombing, true];
    _unit setVariable ["BIS_SUPP_used_CAS_Heli", _casHeli, true];
    _unit setVariable ["BIS_SUPP_used_Drop", _drop, true];
    _unit setVariable ["BIS_SUPP_used_Transport", _transport, true];
    _unit setVariable ["BIS_SUPP_used_UAV", _uav, true];

    // Perform static setup
    _unit setVariable ["BIS_SUPP_transmitting", false];
    _unit kbAddTopic [
        "BIS_SUPP_protocol",
        "A3\Modules_F\supports\kb\protocol.bikb",
        "A3\Modules_F\supports\kb\protocol.fsm",
        {
            call compile preprocessFileLineNumbers
            "A3\Modules_F\supports\kb\protocol.sqf"
        }
    ];
};
publicVariable "jib_support_fnc_set";

// Transfer support data from old to new unit
jib_support_fnc_transfer = {
    if (!isServer) then {throw "Not server"};
    params ["_oldUnit", "_newUnit"];
    [
        "JIB support transfer from %1 to %2",
        [_oldUnit, owner _oldUnit],
        [_newUnit, owner _newUnit]
    ] call BIS_fnc_logFormat;
    [_oldUnit, _newUnit, {
        params ["_data", "_newUnit"];
        [_newUnit, _data] remoteExec ["jib_support_fnc_set", _newUnit];
    }] remoteExec ["jib_support_fnc_get", _oldUnit];
};

// Setup client
jib_support_fnc_initClient = {
    // Detect player respawn
    addMissionEventHandler ["EntityRespawned", {
        params ["_newEntity", "_oldEntity"];
        [
            "JIB support respawn from %1 to %2",
            _oldEntity,
            _newEntity
        ] call BIS_fnc_logFormat;
        [_oldEntity, _newEntity] remoteExec ["jib_support_fnc_transfer", 2];
    }];

    // Detect team switch
    addMissionEventHandler ["TeamSwitch", {
        params ["_previousUnit", "_newUnit"];
        [
            "JIB support teamswitch from %1 to %2",
            _previousUnit,
            _newUnit
        ] call BIS_fnc_logFormat;
        [_previousUnit, _newUnit] remoteExec ["jib_support_fnc_transfer", 2];
    }];
};
publicVariable "jib_support_fnc_initClient";
[] remoteExec ["jib_support_fnc_initClient", 0, true];
