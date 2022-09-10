if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_support_moduleValidate = {};

// Setup client
jib_support_initClient = {
    // Detect player respawn
    addMissionEventHandler ["EntityRespawned", {
        params ["_newEntity", "_oldEntity"];
        [
            "JIB support respawn from %1 to %2",
            _oldEntity,
            _newEntity
        ] call BIS_fnc_logFormat;
        [_oldEntity, _newEntity] remoteExec ["jib_support_transfer", 2];
    }];

    // Detect team switch
    addMissionEventHandler ["TeamSwitch", {
        params ["_previousUnit", "_newUnit"];
        [
            "JIB support teamswitch from %1 to %2",
            _previousUnit,
            _newUnit
        ] call BIS_fnc_logFormat;
        [_previousUnit, _newUnit] remoteExec ["jib_support_transfer", 2];
    }];
};

// Get support data from unit
jib_support_get = {
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

// Set support data to unit
jib_support_set = {
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

// Transfer support data from old to new unit
jib_support_transfer = {
    if (!isServer) then {throw "Not server"};
    params ["_oldUnit", "_newUnit"];
    [
        "JIB support transfer from %1 to %2",
        [_oldUnit, owner _oldUnit],
        [_newUnit, owner _newUnit]
    ] call BIS_fnc_logFormat;
    [_oldUnit, _newUnit, {
        params ["_data", "_newUnit"];
        [_newUnit, _data] remoteExec ["jib_support_set", _newUnit];
    }] remoteExec ["jib_support_get", _oldUnit];
};

// Create support system modules.
//
// NOTE: Support modules may only be created once. Cannot add more
// later, so be sure to create enough in first pass.
jib_support_create = {
    params [
        ["_posAGL", [500, 500, 0], [[]]], // Where to create modules
        ["_radius", 0, [0]]               // Placement radius
    ];
    if (not isServer) then {throw "Not server!"};

    private _systemRadius = 50;
    private _numHubs = 4;
    private _hubRadius = 10;
    private _hubHeight = 10;

    private _systemPosAGL = _posAGL vectorAdd (
        [
            [0, random _radius, 0],
            random 360,
            2
        ] call BIS_fnc_rotateVector3D
    );

    if (isNil "jib_support_group") then {
        jib_support_group = createGroup sideLogic;
    };
    private _group = jib_support_group;

    private _newLogics = [];
    for "_i" from 0 to _numHubs - 1 do {
        private _hubPosAGL = _systemPosAGL vectorAdd (
            [
                [0, _systemRadius, 0],
                _i * 360 / _numHubs,
                2
            ] call BIS_fnc_rotateVector3D
        );
        private _requesterLogicPosAGL = _hubPosAGL vectorAdd [0, 0, _hubHeight];

        private _requesterLogic = _group createUnit [
            "SupportRequester", _requesterLogicPosAGL, [], 0, "NONE"
        ];
        _requesterLogic setVariable ["BIS_SUPP_custom_HQ", "", true];
        _requesterLogic setVariable ["BIS_SUPP_limit_Artillery", 1e11, true];
        _requesterLogic setVariable ["BIS_SUPP_limit_CAS_Bombing", 1e11, true];
        _requesterLogic setVariable ["BIS_SUPP_limit_CAS_Heli", 1e11, true];
        _requesterLogic setVariable ["BIS_SUPP_limit_Drop", 1e11, true];
        _requesterLogic setVariable ["BIS_SUPP_limit_Transport", 1e11, true];
        _requesterLogic setVariable ["BIS_SUPP_limit_UAV", 1e11, true];
        _requesterLogic setVariable [
            "BIS_fnc_initModules_disableAutoActivation", false, true
        ];
        _newLogics pushBack _requesterLogic;

        private _classesAndArguments =
            [["SupportProvider_Artillery", []],
             ["SupportProvider_Virtual_Artillery", [
                 ["BIS_SUPP_vehicles", "[]"],
                 ["BIS_SUPP_vehicleInit", ""],
                 ["BIS_SUPP_filter", "Side"],
                 ["BIS_SUPP_cooldown", 0]]],
             ["SupportProvider_CAS_Heli", []],
             ["SupportProvider_Virtual_CAS_Heli", [
                 ["BIS_SUPP_vehicles", "[]"],
                 ["BIS_SUPP_vehicleInit", ""],
                 ["BIS_SUPP_filter", "Side"],
                 ["BIS_SUPP_cooldown", 0]]],
             ["SupportProvider_CAS_Bombing", []],
             ["SupportProvider_Virtual_CAS_Bombing", [
                 ["BIS_SUPP_vehicles", "[]"],
                 ["BIS_SUPP_vehicleInit", ""],
                 ["BIS_SUPP_filter", "Side"],
                 ["BIS_SUPP_cooldown", 0]]],
             ["SupportProvider_Drop", [["BIS_SUPP_crateInit", ""]]],
             ["SupportProvider_Virtual_Drop", [
                 ["BIS_SUPP_vehicles", "[]"],
                 ["BIS_SUPP_vehicleInit", ""],
                 ["BIS_SUPP_crateInit", ""],
                 ["BIS_SUPP_filter", "Side"],
                 ["BIS_SUPP_cooldown", 0]]],
             ["SupportProvider_Transport", []],
             ["SupportProvider_Virtual_Transport", [
                 ["BIS_SUPP_vehicles", "[]"],
                 ["BIS_SUPP_vehicleInit", ""],
                 ["BIS_SUPP_filter", "Side"],
                 ["BIS_SUPP_cooldown", 0]]]];
        for "_j" from 0 to count _classesAndArguments - 1 do {
            _classesAndArguments # _j params ["_class", "_arguments"];
            private _providerLogicPosAGL = _hubPosAGL vectorAdd (
                [
                    [0, _hubRadius, 0],
                    _j * 360 / count _classesAndArguments,
                    2
                ] call BIS_fnc_rotateVector3D
            );
            private _providerLogic = _group createUnit [
                _class, _providerLogicPosAGL, [], 0, "NONE"
            ];
            for "_k" from 0 to count _arguments - 1 do {
                _arguments # _k params ["_key", "_value"];
                _providerLogic setVariable [_key, _value, true];
            };
            _providerLogic setVariable [
                "BIS_fnc_initModules_disableAutoActivation", false, true
            ];
            // _providerLogic synchronizeObjectsAdd [_requesterLogic];
            _newLogics pushBack _providerLogic;
        };
    };

    _newLogics;
};

jib_support_moduleCreate = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_curator"];
            private _logics = [_posATL] call jib_support_create;
            if (not isNull _curator) then {
                _curator addCuratorEditableObjects [_newLogics];
            };
        },
        [getAssignedCuratorLogic player]
    ] call jib_support_moduleValidate;
};

publicVariable "jib_support_moduleValidate";
publicVariable "jib_support_get";
publicVariable "jib_support_set";
publicVariable "jib_support_initClient";
[] remoteExec ["jib_support_initClient", 0, true];
