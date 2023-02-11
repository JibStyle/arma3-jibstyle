if (!isServer) exitWith {};

// Dependencies
jib_menu_alive_opcom_disable;
jib_menu_alive_opcom_enable;
jib_menu_alive_profile_disable;
jib_menu_alive_profile_enable;
jib_menu_alive_register_disable;
jib_menu_alive_register_enable;
jib_menu_handler_main_menu;
jib_menu_objective_capture_start;
jib_menu_objective_capture_stop;
jib_menu_service_group_bottom;
jib_menu_service_group_top;
jib_menu_service_group_delete;
jib_menu_zeus_admin;

jib_menu_admin = [
    ["Admin Menu", true],
    ["ALiVE", [2], "#USER:jib_menu_alive", -5, [], "1", "1"]
];
publicVariable "jib_menu_admin";

jib_menu_alive = [
    ["ALiVE", true],
    [
        "ALiVE Start", [2], "", -5, [
            ["expression", "[] call jib_menu_alive_start"]
        ], "1", "1"
    ],
    [
        "ALiVE Stop", [3], "", -5, [
            ["expression", "[] call jib_menu_alive_stop"]
        ], "1", "1"
    ],
    [
        "ALiVE Register Enable", [4], "", -5, [
            ["expression", "[] call jib_menu_alive_registerEnable"]
        ], "1", "1"
    ],
    [
        "ALiVE Register Disable", [5], "", -5, [
            ["expression", "[] call jib_menu_alive_registerDisable"]
        ], "1", "1"
    ]
];
publicVariable "jib_menu_alive";

jib_menu_alive_start = {
    [[], {
        [] call jib_menu_alive_profile_enable;
        [] call jib_menu_alive_opcom_enable;
    }] remoteExec ["spawn", 2];
    [] spawn {showCommandingMenu "#USER:jib_menu_alive"};
};
publicVariable "jib_menu_alive_start";

jib_menu_alive_stop = {
    [[], {
        [] call jib_menu_alive_profile_disable;
        [] call jib_menu_alive_opcom_disable;
    }] remoteExec ["spawn", 2];
    [] spawn {showCommandingMenu "#USER:jib_menu_alive"};
};
publicVariable "jib_menu_alive_stop";

jib_menu_alive_registerEnable = {
    [] remoteExec ["jib_menu_alive_register_enable", 2];
    [] spawn {showCommandingMenu "#USER:jib_menu_alive"};
};
publicVariable "jib_menu_alive_registerEnable";

jib_menu_alive_registerDisable = {
    [] remoteExec ["jib_menu_alive_register_disable", 2];
    [] spawn {showCommandingMenu "#USER:jib_menu_alive"};
};
publicVariable "jib_menu_alive_registerDisable";

jib_menu_group = [
    ["Group Menu", true],
    [
        "Selected Units to Top", [2], "", -5,
        [["expression", "[] call jib_menu_group_top"]], "1", "1"
    ],
    [
        "Selected Units to Bottom", [3], "", -5,
        [["expression", "[] call jib_menu_group_bottom"]], "1", "1"
    ],
    [
        "Delete Selected Units", [4], "", -5,
        [["expression", "[] call jib_menu_group_delete"]], "1", "1"
    ]
];
publicVariable "jib_menu_group";

jib_menu_group_top = {
    [player, groupSelectedUnits player] remoteExec [
        "jib_menu_service_group_top", groupOwner group player
    ];
    [] spawn {showCommandingMenu "#USER:jib_menu_group"};
};
publicVariable "jib_menu_group_top";

jib_menu_group_bottom = {
    [player, groupSelectedUnits player] remoteExec [
        "jib_menu_service_group_bottom", groupOwner group player
    ];
    [] spawn {showCommandingMenu "#USER:jib_menu_group"};
};
publicVariable "jib_menu_group_bottom";

jib_menu_group_delete = {
    [player, groupSelectedUnits player] remoteExec [
        "jib_menu_service_group_delete", groupOwner group player
    ];
    [] spawn {showCommandingMenu "#USER:jib_menu_group"};
};
publicVariable "jib_menu_group_delete";

jib_menu_setup = {
    if (!isServer) exitWith {};
    if (!canSuspend) exitWith {};
    if ([] call jib_menu_handler_main_menu) exitWith {};
    waitUntil { sleep 1; alive ([] call jib_menu_zeus_admin) };
    private _admin = [] call jib_menu_zeus_admin;
    [_admin, "jib_menu_mission"] remoteExecCall [
        "BIS_fnc_addCommMenuItem", _admin
    ];
    [_admin, "jib_menu_admin"] remoteExecCall [
        "BIS_fnc_addCommMenuItem", _admin
    ];
    // [_admin, "jib_menu_group"] remoteExecCall [
    //     "BIS_fnc_addCommMenuItem", _admin
    // ];
};

[] spawn jib_menu_setup;

// Set menus of unit
jib_menu_unit = {
    params ["_unit", "_menus"];
    waitUntil {alive _unit};

    // Temp hack
    _menus pushBack [
        "Group Menu",
        "leader player == player",
        "#USER:jib_menu_group"
    ];

    [[_unit, _menus], {
        params ["_unit", "_menus"];
        _menus apply {
            _x params ["_name", "_condition", "_menu"];
            _unit addAction [
                _name,
                {
                    params ["", "", "", "_arguments"];
                    _arguments params ["_menu"];
                    showCommandingMenu _menu;
                },
                [_menu], 5, false, true, "", _condition, 2
            ];
        };

        _unit setVariable ["jib_menu__unit", _menus];
        _unit setVariable [
            "jib_menu__respawn",
            _unit addEventHandler ["Respawn", {
                params ["_unit", "_corpse"];
                _unit getVariable ["jib_menu__unit", []] apply {
                    _x params ["_name", "_condition", "_menu"];
                    _unit addAction [
                        _name,
                        {
                            params ["", "", "", "_arguments"];
                            _arguments params ["_menu"];
                            showCommandingMenu _menu;
                        },
                        [_menu], 5, false, true, "", _condition, 2
                    ];
                };
            }]
        ];
    }] remoteExec ["spawn", 0];
};

// Add respawn-safe action to object
//
// Example:
//
// [
//     player, "Foo", "true", {systemChat (_this # 3 # 0)}, ["foo"]
// ] call jib_menu_action;
jib_menu_action = {
    params ["_object", "_action"];
    if (!isServer) exitWith {};

    [
        _object, [_action], [] call jib_menu__unique
    ] remoteExec ["jib_menu__action_add", 0, _object];
    private _respawn = {
        params ["_unit", "_corpse"];
        [_unit, _unit getVariable ["jib_menu__actions", []]] remoteExec [
            "jib_menu__action_add", 0, _unit
        ];
    };
    isNil {
        private _actions = _object getVariable ["jib_menu__actions", []];
        _actions pushBack _action;
        _object setVariable ["jib_menu__actions", _actions];
    };
    isNil {
        if (isNil "jib_menu__respawn") then {
            jib_menu__respawn =
                addMissionEventHandler ["EntityRespawned", _respawn];
        };
    };
};

jib_menu__action_add = {
    params ["_object", "_actions", ["_unique", "", [""]]];

    // Workaround for duplicate remoteExec engine bug
    private _duplicate = false;
    if (_unique != "") then {
        isNil {
            if (isNil _unique) then {
                missionNamespace setVariable [_unique, true];
            } else {
                _duplicate = true;
            };
        };
    };
    if (_duplicate) exitWith {};

    // Now the actual code
    _actions apply {_object addAction _x};
};
publicVariable "jib_menu__action_add";

// Create menu with items
//
// Example:
//
// [
//     "My Menu", [
//         ["Foo", "systemChat ""foo"""],
//         [
//             "Bar", "", "1", true,
//             ["Confirm Bar", [["Yes", "systemChat ""bar"""], ["No"]]]
//         ]
//     ]
// ] call jib_menu_create;
//
// Returns: "#USER:jib_menu__0_0"
jib_menu_create = {
    params [
        ["_name", "Menu", [""]],
        ["_items", [], [[]]]
    ];
    if (count _items == 0) exitWith {""};
    private _menu = [] call jib_menu__unique;
    private _page_id = {
        params ["_page_index"];
        format ["#USER:%1_%2", _menu, _page_index];
    };
    private _pages = [];
    private _page_size = 9;
    private _page_count = ceil (count _items / _page_size);
    for "_page_index" from 0 to _page_count - 1 do {
        private _page_items =
            _items select [_page_index * _page_size, _page_size];
        private _page = format ["%1_%2", _menu, _page_index];
        _pages pushBack _page;
        private _page_data = [[_name, true]];
        for "_item_index" from 0 to count _page_items - 1 do {
            _page_items # _item_index params [
                "_item_name",
                ["_expression", "", [""]],
                ["_condition", "1", [""]],
                ["_persistent", false, [false]],
                ["_recursive", [], [[]]]
            ];
            if (_persistent) then {
                _expression = _expression + format [
                    "; [] spawn {showCommandingMenu ""%1""}",
                    [_page_index] call _page_id
                ];
            };
            private _submenu = _recursive call jib_menu_create;
            _page_data pushBack [
                _item_name, [_item_index + 2], _submenu, -5,
                [["expression", _expression]], _condition, "1"
            ];
        };
        if (_page_index + 1 < _page_count) then {
            private _page_id_next = [_page_index + 1] call _page_id;
            _page_data pushBack [
                "More", [11], _page_id_next, -5, [], "1", "1"
            ];
        };
        missionNamespace setVariable [_page, _page_data, true];
    };
    missionNamespace setVariable [_menu, _pages, true];
    [0] call _page_id;
};

jib_menu__unique = {
    private _count = 0;
    isNil {
        _count = missionNamespace getVariable ["jib_menu__unique_count", 0];
        missionNamespace setVariable ["jib_menu__unique_count", _count + 1];
    };
    format ["jib_menu__%1", _count];
};
