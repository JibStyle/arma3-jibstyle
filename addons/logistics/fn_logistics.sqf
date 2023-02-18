jib_logistics_activate_crate;
jib_logistics_activate_unit;
jib_logistics_activate_vehicle;
jib_logistics_menu_unit;
jib_logistics_menu_create;
jib_logistics_menu_action;

// Register a logistics crate
jib_logistics_crate = {
    params [
        "_logic",
        ["_name", "", [""]]
    ];
    if (_name == "") then {
        synchronizedObjects _logic apply {
            if (_x call BIS_fnc_objectType select 1 == "AmmoBox") exitWith {
                _name = getText (
                    configFile >> "CfgVehicles" >> typeOf _x >> "displayName"
                );
            };
        };
    };
    _logic setVariable ["jib_logistics__type", "crate"];
    _logic setVariable ["jib_logistics__name", _name];
};

// Register a logistics unit
jib_logistics_unit = {
    params [
        "_logic",
        ["_name", "", [""]]
    ];
    if (_name == "") then {
        synchronizedObjects _logic apply {
            if (_x call BIS_fnc_objectType select 0 == "Soldier") exitWith {
                _name = getText (
                    configFile >> "CfgVehicles" >> typeOf _x >> "displayName"
                );
            };
        };
    };
    _logic setVariable ["jib_logistics__type", "unit"];
    _logic setVariable ["jib_logistics__name", _name];
};

// Register a logistics vehicle
jib_logistics_vehicle = {
    params [
        "_logic",
        ["_name", "", [""]]
    ];
    if (_name == "") then {
        synchronizedObjects _logic apply {
            if (_x call BIS_fnc_objectType select 0 == "Vehicle") exitWith {
                _name = getText (
                    configFile >> "CfgVehicles" >> typeOf _x >> "displayName"
                );
            };
        };
    };
    _logic setVariable ["jib_logistics__type", "vehicle"];
    _logic setVariable ["jib_logistics__name", _name];
};

// Add logistics menu to a playable unit
jib_logistics_player = {
    params [
        "_player",
        "_logic",
        "_leader",
        ["_name", "Logistics", [""]]
    ];
    [
        _player, _logic, _name, 3, false,
        if (_leader) then {
            "leader player == player && _target == player"
        } else {"_target == player"}
    ] spawn jib_logistics__menu;
};

// Add logistics menu to an object
jib_logistics_object = {
    params [
        "_object",
        "_logic",
        ["_name", "Logistics", [""]]
    ];
    [_object, _logic, _name, 5, true, "true"] spawn jib_logistics__menu;
};

jib_logistics__menu = {
    params ["_object", "_logic", "_name", "_priority", "_window", "_condition"];
    if (!isServer) exitWith {};
    if (!canSuspend) then {throw "Must be spawned!"};
    private _expression_format =
        "[%1, player] remoteExec [""jib_logistics__server"", 2]";
    [
        _object, [
            _name,
            {showCommandingMenu (_this # 3 # 0)},
            [
                [
                    _name, synchronizedObjects _logic select {
                        _x getVariable ["jib_logistics__type", ""] in [
                            "crate", "unit", "vehicle"
                        ];
                    } apply {
                        [
                            _x getVariable ["jib_logistics__name", "Object"],
                            format [
                                _expression_format,
                                [_x] call BIS_fnc_objectVar
                            ],
                            "1", true
                        ];
                    }
                ] call jib_logistics_menu_create
            ],
            _priority, _window, true, "", _condition, 2
        ]
    ] call jib_logistics_menu_action;
};

jib_logistics__server = {
    params ["_logic", "_player"];
    switch (_logic getVariable ["jib_logistics__type", ""]) do
    {
        case ("crate"): {
            [_logic] call jib_logistics_activate_crate;
        };
        case ("unit"): {
            [_logic, _player] call jib_logistics_activate_unit;
        };
        case ("vehicle"): {
            [_logic] call jib_logistics_activate_vehicle;
        };
        default {throw "Invalid logistics type!"};
    };
};
