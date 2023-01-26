jib_logistics_admin;
jib_logistics_main_menu;

jib_logistics_debug = true;
jib_logistics_delay = 0.3;
publicVariable "jib_logistics_debug";
publicVariable "jib_logistics_delay";

jib_logistics_insert_menu = [["Insert Units", true]];
publicVariable "jib_logistics_insert_menu";

// Init menu to recruit AI units
jib_logistics_unit_menu_init = {
    if (!isServer) exitWith {};
    params ["_logic"];
    jib_logistics_unit_menu = [
        ["Recruit Units", true],
        [
            "Delete Selected", [2], "", -5, [[
                "expression",
                "[] call jib_logistics_unit_menu_delete"
            ]], "1", "1"
        ]
    ];
    jib_logistics_units = [];
    jib_logistics_unit_pos = getPosATL _logic;
    jib_logistics_unit_direction = direction _logic;
    private _groups = [];
    private _units = [];
    private _vehicles = [];

    synchronizedObjects _logic select {
        vehicle _x call BIS_fnc_objectType select 0 in [
            "Soldier", "Vehicle"
        ]
    } apply {
        _groups pushBackUnique group _x;
        units group _x apply {
            if (vehicle _x == _x) then {
                _units pushBackUnique _x;
            } else {
                _vehicles pushBackUnique vehicle _x;
            };
        };
    };

    private _i = 0;
    _units apply {
        jib_logistics_units pushBack [
            "Soldier",
            [typeOf _x, rank _x, skill _x, getUnitLoadout _x]
        ];
        jib_logistics_unit_menu pushBack [
            _x getVariable [
                "jib_logistics_unit_name",
                getText (
                    configFile >> "CfgVehicles"
                        >> typeOf _x >> "displayName"
                )
            ],
            [_i + 3], "", -5,
            [[
                "expression",
                format [
                    "[%1] call jib_logistics_unit_menu_selected", _i
                ]
            ]],
            "1", "1"
        ];
        _i = _i + 1;
    };

    _vehicles apply {
        jib_logistics_units pushBack [
            "Vehicle", [
                typeOf _x,
                fullCrew [_x, ""] apply {
                    _x params [
                        "_unit",
                        "_role",
                        "_cargoIndex",
                        "_turretPath",
                        "_personTurret"
                    ];
                    [
                        typeOf _unit,
                        rank _unit,
                        skill _unit,
                        getUnitLoadout _unit,
                        _role,
                        _cargoIndex,
                        _turretPath,
                        _personTurret
                    ];
                }
            ]
        ];
        jib_logistics_unit_menu pushBack [
            _x getVariable [
                "jib_logistics_unit_name",
                getText (
                    configFile >> "CfgVehicles"
                        >> typeOf _x >> "displayName"
                )
            ],
            [_i + 3], "", -5,
            [[
                "expression",
                format [
                    "[%1] call jib_logistics_unit_menu_selected",
                    _i
                ]
            ]],
            "1", "1"
        ];
        _i = _i + 1;
    };

    private _deleteVehicles = [];
    _units apply {_deleteVehicles pushBackUnique vehicle _x};
    _vehicles apply {_deleteVehicles pushBackUnique _x};
    _deleteVehicles apply {
        deleteVehicleCrew _x;
        deleteVehicle _x;
    };
    _groups apply {deleteGroup _x};

    publicVariable "jib_logistics_units";
    publicVariable "jib_logistics_unit_menu";
    publicVariable "jib_logistics_unit_pos";
    publicVariable "jib_logistics_unit_direction";
};

// Handle menu delete
jib_logistics_unit_menu_delete = {
    private _deleteVehicles = [];
    groupSelectedUnits player apply {
        _deleteVehicles pushBackUnique vehicle _x;
    };
    _deleteVehicles apply {
        deleteVehicleCrew _x;
        deleteVehicle _x;
    };
    [] spawn {showCommandingMenu "#USER:jib_logistics_unit_menu"};
};
publicVariable "jib_logistics_unit_menu_delete";

// Handle menu selection
jib_logistics_unit_menu_selected = {
    params ["_index"];
    [player, _index] remoteExec [
        "jib_logistics_unit_spawn", group player
    ];
    [] spawn {
        showCommandingMenu "#USER:jib_logistics_unit_menu";
    };
};
publicVariable "jib_logistics_unit_menu_selected";

// Spawn unit
jib_logistics_unit_spawn = {
    params ["_leader", "_index"];
    if (!canSuspend) then {throw "Cannot suspend!"};
    jib_logistics_units # _index params ["_type", "_data"];
    private _add_to_curators = {
        params ["_object"];
        if (jib_logistics_debug) then {
            allCurators apply {
                _x addCuratorEditableObjects [[_object], false];
            };
        };
    };

    private _refreshBackpack = {
        params ["_unit"];
        sleep jib_logistics_delay;
        private _items = backpackItems _unit;
        private _backpack = backpack _unit;
        removeBackpack _unit;
        _unit addBackpack _backpack;
        clearAllItemsFromBackpack _unit;
        _items apply {_unit addItemToBackpack _x};
    };

    switch (_type) do
    {
        case "Soldier": {
            _data params ["_unitType", "_rank", "_skill", "_loadout"];
            private _unit = group _leader createUnit [
                _unitType, jib_logistics_unit_pos, [], 0, "NONE"
            ];
            _unit allowDamage false;
            [_unit] call _add_to_curators;
            _unit setDir jib_logistics_unit_direction;
            _unit setRank _rank;
            _unit setSkill _skill;
            _unit setUnitLoadout _loadout;
            [_unit] call _refreshBackpack;
            sleep jib_logistics_delay;
            _unit allowDamage true;
        };
        case "Vehicle";
        case "VehicleAutonomous": {
            _data params ["_vehicleType", "_crewData"];
            private _vehicle = createVehicle [
                _vehicleType, jib_logistics_unit_pos, [], 0, "NONE"
            ];
            _vehicle allowDamage false;
            [_vehicle] call _add_to_curators;
            _vehicle setDir jib_logistics_unit_direction;
            sleep jib_logistics_delay;
            private _units = _crewData apply {
                _x params [
                    "_unitType", "_rank", "_skill", "_loadout",
                    "_role", "_cargoIndex", "_turretPath",
                    "_personTurret"
                ];
                private _unit = group _leader createUnit [
                    _unitType, jib_logistics_unit_pos, [], 0, "NONE"
                ];
                _unit allowDamage false;
                [_unit] call _add_to_curators;
                _unit setDir jib_logistics_unit_direction;
                _unit setRank _rank;
                _unit setSkill _skill;
                _unit setUnitLoadout _loadout;
                [_unit] call _refreshBackpack;
                switch (_role) do
                {
                    case "driver": {
                        _unit moveInDriver _vehicle;
                    };
                    case "gunner": {
                        _unit moveInGunner _vehicle;
                    };
                    case "commander": {
                        _unit moveInCommander _vehicle;
                    };
                    case "turret": {
                        _unit moveInTurret [_vehicle, _turretPath];
                    };
                    case "cargo": {
                        _unit moveInCargo [
                            _vehicle, _cargoIndex, true
                        ];
                    };
                    default {};
                };
                _unit;
            };
            sleep jib_logistics_delay;
            _vehicle allowDamage true;
            _units apply {_x allowDamage true};
        };
        default {};
    };
};
publicVariable "jib_logistics_unit_spawn";

jib_logistics_menu_setup = {
    if (!isServer) exitWith {};
    if (!canSuspend) exitWith {};
    if ([] call jib_logistics_main_menu) exitWith {};
    waitUntil { sleep 1; alive ([] call jib_logistics_admin) };
    private _admin = [] call jib_logistics_admin;
    [_admin, "jib_logistics_unit_menu"] remoteExecCall [
        "BIS_fnc_addCommMenuItem", _admin
    ];
};

[] spawn jib_logistics_menu_setup;
