// Dependencies
jib_menu_alive;
jib_menu_group;

// Add global player menu actions
jib_menu_player = {
    params ["_player"];
    if (!isServer) exitWith {};
    [
        _player, [
            "Admin Menu", {showCommandingMenu (_this # 3 # 0)},
            [
                [
                    "Admin Menu",
                    [["ALiVE", "", "1", false, jib_menu_alive]]
                ] call jib_menu_create
            ],
            4, false, true, "",
            toString {
                (!isMultiplayer || serverCommandAvailable "#kick")
                    && _originalTarget == player
            }, 2
        ]
    ] call jib_menu_action;
    [
        _player, [
            "Group Menu", {showCommandingMenu (_this # 3 # 0)},
            [jib_menu_group call jib_menu_create],
            4, false, true, "",
            "leader player == player && _originalTarget == player", 2
        ]
    ] call jib_menu_action;
};

// Add respawn safe action to object on all clients
jib_menu_action = {
    params ["_object", "_action"];
    if (!isServer) exitWith {};
    [
        _object, [_action], [] call jib_menu__unique
    ] remoteExec ["jib_menu__action_add", 0, _object];
    private _respawn = {
        params ["_unit", "_corpse"];
        [
            _unit,
            _unit getVariable ["jib_menu__actions", []]
        ] remoteExec ["jib_menu__action_add", 0, _unit];
    };
    isNil {
        private _actions = _object getVariable ["jib_menu__actions", []];
        _actions pushBack _action;
        _object setVariable ["jib_menu__actions", _actions];
    };
    isNil {
        if (isNil "jib_menu__entity_respawned") then {
            jib_menu__entity_respawned =
                addMissionEventHandler ["EntityRespawned", _respawn];
        };
    };
};

// Create menu with items
//
// Example:
//
// [
//     "My Menu", [
//         ["Foo", "systemChat ""foo"""],
//         [
//             "Bar", "", "1", false,
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

jib_menu__unique = {
    private _count = 0;
    isNil {
        _count = missionNamespace getVariable ["jib_menu__unique_count", 0];
        missionNamespace setVariable ["jib_menu__unique_count", _count + 1];
    };
    format ["jib_menu__%1", _count];
};
