// Datas much be publicVariable, condition doesn't need to be
jib_menu_group_data;
jib_menu_group_condition;
jib_menu_hc_condition;
jib_menu_hc_data;
jib_menu_service_condition;
jib_menu_service_data;

jib_menu_condition_admin = {
    (!isMultiplayer || serverCommandAvailable "#kick")
        && _originalTarget == player
};
publicVariable "jib_menu_condition_admin";

jib_menu_condition_zeus = {
    alive getAssignedCuratorLogic player && _originalTarget == player;
};
publicVariable "jib_menu_condition_zeus";

// Setup player menus
jib_menu_setup = {
    private _menus = call {[
        // TODO: Add admin menu
        [jib_menu_group_condition, jib_menu_group_data],
        [jib_menu_hc_condition, jib_menu_hc_data],
        [jib_menu_service_condition, jib_menu_service_data]
    ]};
    [[_menus], {
        params ["_menus"];
        if (!hasInterface) exitWith {};
        if (!isNil "jib_menu__player_watchdog") then {
            terminate jib_menu__player_watchdog;
        };
        jib_menu__player_watchdog = [_menus] spawn {
            params ["_menus"];
            jib_menu__player_menus = _menus;
            jib_menu__player_units = [];
            private _should_register =
                {alive player && !(player in jib_menu__player_units)};
            private _do_register = {
                player getVariable ["jib_menu__player_actions", []] apply {
                    player removeAction _x;
                };
                player setVariable [
                    "jib_menu__player_actions",
                    _menus apply {
                        _x params ["_condition", "_menu_data"];
                        [
                            player, _condition, _menu_data
                        ] call jib_menu_dynamic_action;
                    }
                ];
                jib_menu__player_units pushBack player;
            };
            while {true} do {
                uiSleep 1;
                isNil {if (call _should_register) then _do_register;};
            };
        };
    }] remoteExec ["spawn", 0, true];
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
        for "_page_item_index" from 0 to count _page_items - 1 do {
            _page_items # _page_item_index params [
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
                _item_name, [_page_item_index + 2], _submenu, -5,
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

// Add action to open dynamic menu
jib_menu_dynamic_action = {
    params ["_object", "_condition_fn", "_menu_data"];
    _object addAction [
        _menu_data # 0,
        {
            params ["_target", "_caller", "_actionId", "_arguments"];
            _arguments params ["_menu_data"];
            _menu_data call jib_menu_dynamic
        },
        [_menu_data], 4, false, true, "", toString _condition_fn, 2
    ];
};
publicVariable "jib_menu_dynamic_action";

// Create dynamic menu
jib_menu_dynamic = {
    params [
        ["_name", "Menu", [""]],
        ["_items", [], [[]]],
        ["_path", [], [[]]]
    ];
    if (count _items == 0) exitWith {""};
    if (!hasInterface) exitWith {};
    private _menu_root = "jib_menu__dynamic";
    private _menu = if (count _path > 0) then {
        format ["%1_%2", _menu_root, _path joinString "_"];
    } else {
        _menu_root;
    };
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
        for "_page_item_index" from 0 to count _page_items - 1 do {
            private _item_index = _page_index * _page_size + _page_item_index;
            _page_items # _page_item_index params [
                "_item_name",
                ["_expression", "", [""]],
                ["_condition", "1", [""]],
                ["_persistent", false, [false]],
                ["_recursive", ["", []], [[]]]
            ];
            if (_persistent) then {
                _expression = _expression + format [
                    "; [] spawn {showCommandingMenu ""%1""}",
                    [_page_index] call _page_id
                ];
            };
            _recursive params ["_recursive_name", "_recursive_items"];
            private _submenu = [
                _recursive_name, _recursive_items, _path + [_item_index]
            ] call jib_menu_dynamic;
            _page_data pushBack [
                _item_name, [_page_item_index + 2], _submenu, -5,
                [["expression", _expression]], _condition, "1"
            ];
        };
        if (_page_index + 1 < _page_count) then {
            private _page_id_next = [_page_index + 1] call _page_id;
            _page_data pushBack [
                "More", [11], _page_id_next, -5, [], "1", "1"
            ];
        };
        missionNamespace setVariable [_page, _page_data];
    };
    if (count _path == 0) then {
        missionNamespace setVariable [_menu, _pages];
        showCommandingMenu ([0] call _page_id);
    };
    [0] call _page_id;
};
publicVariable "jib_menu_dynamic";

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
