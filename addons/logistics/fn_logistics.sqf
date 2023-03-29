jib_logistics_activate_crate;
jib_logistics_activate_unit;
jib_logistics_activate_vehicle;
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
        ["_leader", true, [false]],
        ["_name", "Logistics", [""]]
    ];
    [
        _player, _logic, _name, 3, false,
        if (_leader) then {
            "leader player == player && _originalTarget == player"
        } else {"_originalTarget == player"}
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

// Standard basic loadout
jib_logistics_loadout_basic = [
    ["ACE_EarPlugs", 1],
    ["ACE_Flashlight_XL50", 1]
];

// Standard loadout map
jib_logistics_loadout_map = [
    [
        "FirstAidKit", [
            ["ACE_fieldDressing", 2], ["ACE_packingBandage", 2],
            ["ACE_morphine", 1], ["ACE_tourniquet", 1]
        ]
    ],
    [
        "Medikit", [
            ["ACE_fieldDressing", 5],
            ["ACE_packingBandage", 5],
            ["ACE_adenosine", 5],
            ["ACE_epinephrine", 5],
            ["ACE_morphine", 5],
            ["ACE_salineIV_500", 5],
            ["ACE_splint", 5],
            ["ACE_tourniquet", 5]
        ]
    ]
];

// Filter a unit loadout
jib_logistics_loadout_filter = {
    params [
        "_unit",
        ["_basic", jib_logistics_loadout_basic],
        ["_map", jib_logistics_loadout_map]
    ];
    private _items = [];
    _basic apply {
        _x params ["_item", "_quantity"];
        _unit removeItems _item;
        private _index = _items find _item;
        if (_index < 0) then {
            _items pushBack [_item, _quantity];
        } else {
            private _entry = _items # _index;
            _entry params ["", "_entry_quantity"];
            _items set [_index, [_item, _entry_quantity + _quantity]];
        };
    };
    _map apply {
        _x params ["_from", "_to"];
        private _multiplier = {_x == _from} count items _unit;
        _unit removeItems _from;
        _to apply {
            _x params ["_item", "_quantity"];
            private _index = _items find _item;
            if (_index < 0) then {
                _items pushBack [_item, _multiplier * _quantity];
            } else {
                private _entry = _items # _index;
                _entry params ["", "_entry_quantity"];
                _items set [
                    _index, [_item, _entry_quantity + _multiplier * _quantity]
                ];
            };
        };
    };
    _items apply {
        _x params ["_item", "_quantity"];
        for "_i" from 0 to _quantity - 1 do (
            switch true do
            {
                case (_unit canAddItemToUniform [_item, _quantity]): {
                    {_unit addItemToUniform _item}
                };
                case (_unit canAddItemToVest [_item, _quantity]): {
                    {_unit addItemToVest _item}
                };
                case (_unit canAddItemToBackpack [_item, _quantity]): {
                    {_unit addItemToBackpack _item}
                };
                default {{_unit addItem _item}};
            }
        );
    };
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
