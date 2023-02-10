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
