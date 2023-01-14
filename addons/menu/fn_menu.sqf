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
jib_menu_zeus_admin;

jib_menu_admin = [
    ["Admin Menu", true],
    ["ALiVE", [2], "#USER:jib_menu_alive", -5, [], "1", "1"],
    ["Capture", [3], "#USER:jib_menu_capture", -5, [], "1", "1"]
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
};
publicVariable "jib_menu_alive_start";

jib_menu_alive_stop = {
    [[], {
        [] call jib_menu_alive_profile_disable;
        [] call jib_menu_alive_opcom_disable;
    }] remoteExec ["spawn", 2];
};
publicVariable "jib_menu_alive_stop";

jib_menu_alive_registerEnable = {
    [] remoteExec ["jib_menu_alive_register_enable", 2];
};
publicVariable "jib_menu_alive_registerEnable";

jib_menu_alive_registerDisable = {
    [] remoteExec ["jib_menu_alive_register_disable", 2];
};
publicVariable "jib_menu_alive_registerDisable";

jib_menu_capture = [
    ["Capture", true],
    [
        "Capture Start", [2], "", -5, [
            ["expression", "[] call jib_menu_capture_start"]
        ], "1", "1"
    ],
    [
        "Capture Stop", [3], "", -5, [
            ["expression", "[] call jib_menu_capture_stop"]
        ], "1", "1"
    ]
];
publicVariable "jib_menu_capture";

jib_menu_capture_start = {
    [] remoteExec ["jib_menu_objective_capture_start", 0];
};
publicVariable "jib_menu_capture_start";

jib_menu_capture_stop = {
    [] remoteExec ["jib_menu_objective_capture_stop", 0];
};
publicVariable "jib_menu_capture_stop";

jib_menu_group = [
    ["Group Menu", true],
    [
        "Selected Units to Top", [2], "", -5,
        [["expression", "[] call jib_menu_group_top"]], "1", "1"
    ],
    [
        "Selected Units to Bottom", [3], "", -5,
        [["expression", "[] call jib_menu_group_bottom"]], "1", "1"
    ]
];
publicVariable "jib_menu_group";

jib_menu_group_top = {
    [player, groupSelectedUnits player] remoteExec [
        "jib_menu_service_group_top", 2
    ];
    showCommandingMenu "#USER:jib_menu_group";
};
publicVariable "jib_menu_group_top";

jib_menu_group_bottom = {
    [player, groupSelectedUnits player] remoteExec [
        "jib_menu_service_group_bottom", 2
    ];
    showCommandingMenu "#USER:jib_menu_group";
};
publicVariable "jib_menu_group_bottom";

jib_menu_setup = {
    if (!isServer) exitWith {};
    if (!canSuspend) exitWith {};
    if ([] call jib_menu_handler_main_menu) exitWith {};
    waitUntil { sleep 1; alive ([] call jib_menu_zeus_admin) };
    private _admin = [] call jib_menu_zeus_admin;
    [_admin, "jib_menu_admin"] remoteExecCall [
        "BIS_fnc_addCommMenuItem", _admin
    ];
    [_admin, "jib_menu_group"] remoteExecCall [
        "BIS_fnc_addCommMenuItem", _admin
    ];
};

[] spawn jib_menu_setup;
