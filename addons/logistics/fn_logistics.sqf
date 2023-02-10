jib_logistics_activate_crate;
jib_logistics_activate_unit;
jib_logistics_activate_vehicle;
jib_logistics_menu_unit;

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

// Add logistics menu to object
jib_logistics_menu = {
    params [
        "_logic",
        "_object",
        ["_name", "Logistics Menu", [""]]
    ];
    if (!isServer) exitWith {};
    private _menu_var = [_logic, _name] call jib_logistics__create_menu;
    private _menu = format ["#USER:%1_%2", _menu_var, 0];
    [
        _object,
        [
            _name,
            {
                params ["_target", "_caller", "_actionId", "_arguments"];
                _arguments params ["_menu"];
                showCommandingMenu _menu;
            },
            [_menu], 5, true, true, "", "true", 2
        ]
    ] remoteExec ["addAction", 0, true];
};

// Add logistics menu to player
jib_logistics_player = {
    params [
        "_player",
        "_logic",
        ["_name", "Logistics Menu", [""]]
    ];
    if (!isServer) exitWith {};
    private _menu_var = [_logic, _name] call jib_logistics__create_menu;
    private _menu = format ["#USER:%1_%2", _menu_var, 0];

    [
        _player, [[_name, "leader player == player", _menu]]
    ] spawn jib_logistics_menu_unit;
};

jib_logistics__create_menu = {
    params [
        "_logic",
        ["_name", "Logistics Menu", [""]]
    ];
    private _menu_var = [] call jib_logistics__new_menu;
    private _page_menu_vars = [];
    private _logics = synchronizedObjects _logic select {
        _x getVariable ["jib_logistics__type", ""] in [
            "crate", "unit", "vehicle"
        ]
    };
    private _num_pages = ceil (count _logics / 9);
    for "_page" from 0 to _num_pages - 1 do {
        private _page_logics = _logics select [_page * 9, 9];
        private _page_menu_var = format ["%1_%2", _menu_var, _page];
        _page_menu_vars pushBack _page_menu_var;
        private _menu_items = [[_name, true]];
        for "_i" from 0 to count _page_logics - 1 do {
            private _expression = format [
                "[%1, player, ""%2""] call jib_logistics__client",
                [_page_logics # _i, "jib_logistics__"] call BIS_fnc_objectVar,
                format ["#USER:%1_0", _menu_var]
            ];
            _menu_items pushBack [
                _page_logics # _i getVariable [
                    "jib_logistics__name", "ERROR"
                ], [_i + 2], "", -5, [["expression", _expression]], "1", "1"
            ];
        };
        if (_page + 1 < _num_pages) then {
            private _next_page = format ["#USER:%1_%2", _menu_var, _page + 1];
            _menu_items pushBack [
                "More", [11], _next_page, -5, [], "1", "1"
            ];
        };
        missionNamespace setVariable [_page_menu_var, _menu_items, true];
    };
    missionNamespace setVariable [_menu_var, _page_menu_vars, true];
    _menu_var;
};

jib_logistics__new_menu = {
    private _var = "";
    for "_i" from 0 to 999 do {
        _var = format ["jib_logistics__menu_%1", _i];
        isNil {
            if (isNil _var) then {
                missionNamespace setVariable [_var, []];
            } else {
                _var = "";
            };
        }; // should be atomic
        if (_var != "") then {break};
    };
    if (_var == "") then {
        throw "Too many logistics menus!";
    };
    _var;
};

jib_logistics__client = {
    params ["_logic", "_player", "_menu"];
    [_logic, _player] remoteExec ["jib_logistics__server", 2];
    [_menu] spawn {
        params ["_menu"];
        showCommandingMenu _menu;
    };
};
publicVariable "jib_logistics__client";

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
