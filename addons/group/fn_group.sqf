if (!isServer) exitWith {};

jib_group_action;
jib_group_menu_dynamic;
jib_group_serialize_soldier;
jib_group_deserialize_soldiers;

// Set respawn position of group AI
jib_group_rally = {
    params ["_group", "_pos"];
    if (!isServer) exitWith {};
    _group setVariable ["jib_group__rally", _pos, true];
};

// Add group menu to player
jib_group__menu = {
    params ["_player"];
    if (!isServer) exitWith {};
    [[_player], {
        params ["_player"];
        private _action = [
            "Group Menu",
            {[] call jib_group__menu_data call jib_group_menu_dynamic},
            [], 4, false, true, "", toString {
                leader player == player && _originalTarget == player
            }, 2
        ];
        isNil {
            _player removeAction (
                _player getVariable ["jib_group__menu_action", -1]
            );
            _player setVariable [
                "jib_group__menu_action", _player addAction _action
            ];
        };
    }] remoteExec ["spawn", _player];
};

jib_group__menu_data = {
    [
        "Group Menu",
        [
            ["Selected Up", "[] call jib_group__top", "1", true],
            ["Selected Down", "[] call jib_group__bottom", "1", true],
            [
                "Save Group Composition",
                "[group player] call jib_group__save", "1", true
            ],
            [
                "Load Group Composition",
                "[group player] call jib_group__load", "1", true
            ],
            [
                "Delete Selected", "", "1", false, [
                    "Confirm Delete?", [
                        ["CONFIRM", "[] call jib_group__delete", "1"]
                    ]
                ]
            ]
        ]
    ]
};
publicVariable "jib_group__menu_data";

jib_group__top = {
    private _group = group player;
    private _selected = groupSelectedUnits player;
    if (!local _group) then {throw "Group not local!"};
    if (count _selected == 0) then {_selected = [player]};
    private _rest = units _group - _selected;
    private _i = count units _group;
    private _base = 100;
    units _group apply {
        _x joinAsSilent [_group, _base + _i];
        _i = _i + 1;
    };
    _i = 0;
    _selected apply {
        _x joinAsSilent [_group, _i];
        _i = _i + 1;
    };
    _rest apply {
        _x joinAsSilent [_group, _i];
        _i = _i + 1;
    };
    [_group, player] remoteExec ["selectLeader", _group];
};
publicVariable "jib_group__top";

jib_group__bottom = {
    private _group = group player;
    private _selected = groupSelectedUnits player;
    if (!local _group) then {throw "Group not local!"};
    if (count _selected == 0) then {_selected = [player]};
    private _rest = units _group - _selected;
    private _i = count units _group;
    private _base = 100;
    units _group apply {
        _x joinAsSilent [_group, _base + _i];
        _i = _i + 1;
    };
    _i = 0;
    _rest apply {
        _x joinAsSilent [_group, _i];
        _i = _i + 1;
    };
    _selected apply {
        _x joinAsSilent [_group, _i];
        _i = _i + 1;
    };
    [_group, player] remoteExec ["selectLeader", _group];
};
publicVariable "jib_group__bottom";

jib_group__delete = {
    private _selected = groupSelectedUnits player;
    private _deleteVehicles = [];
    _selected apply {
        _deleteVehicles pushBackUnique vehicle _x;
    };
    _deleteVehicles apply {
        deleteVehicleCrew _x;
        deleteVehicle _x;
    };
};
publicVariable "jib_group__delete";

jib_group__save = {
    params ["_group"];
    private _data = _group getVariable ["jib_group__data", []];
    private _new_data = units _group apply {
        private _soldier = _x;
        private _soldier_id =
            _soldier getVariable ["jib_group__id", call jib_group__id_fn];
        _soldier setVariable ["jib_group__id", _soldier_id];
        private _matches = _data select {
            _x params ["_data_soldier", "_data_id"];
            _data_id == _soldier_id;
        };
        if (count _matches > 0) then {
            _matches # 0;
        } else {
            [[_soldier] call jib_group_serialize_soldier, _soldier_id];
        };
    };
    _group setVariable ["jib_group__data", _new_data, true];
};
publicVariable "jib_group__save";

// Load missing units from group
jib_group__load = {
    params ["_group"];
    [[_group], {
        params ["_group"];
        private _data = _group getVariable ["jib_group__data", []];
        private _pos =
            _group getVariable ["jib_group__rally", getPosATL leader _group];
        private _new_soldiers = [
            _group,
            _data select {
                _x params ["_data_soldier", "_data_id"];
                {
                    _x getVariable ["jib_group__id", -1] == _data_id
                } count units _group == 0;
            } apply {
                _x params ["_data_soldier", "_data_id"];
                _data_soldier;
            },
            _pos
        ] call jib_group_deserialize_soldiers;
        private _index = 0;
        private _new_data = _data apply {
            _x params ["_data_soldier", "_data_id"];
            private _result = [];
            if (
                _data_id in (
                    units _group apply {_x getVariable ["jib_group__id", -1]}
                )
            ) then {
                _result = [_data_soldier, _data_id];
            } else {
                private _id = call jib_group__id_fn;
                _new_soldiers # _index setVariable ["jib_group__id", _id];
                _result = [_data_soldier, _id];
                _index = _index + 1;
            };
            _result;
        };
        _group setVariable ["jib_group__data", _new_data, true];
    }] remoteExec ["spawn", leader _group];
};
publicVariable "jib_group__load";

jib_group__id_fn = {
    private _id = -1;
    isNil {
        if (isNil "jib_group__id_index") then {
            jib_group__id_index = 0;
        };
        _id = jib_group__id_index;
        jib_group__id_index = jib_group__id_index + 1;
    };
    format ["jib_group__id_%1", _id];
};
publicVariable "jib_group__id_fn";

jib_group__setup = {
    private _handler_mission = {
        params ["_network_id", "_player"];
        [_player] call jib_group__menu;
        private _handler_player = {
            params ["_player"];
            [_player] call jib_group__menu;
        };
        isNil {
            _player removeEventHandler [
                "Local", _player getVariable ["jib_group__handler_player", -1]
            ];
            _player setVariable [
                "jib_group__handler_player",
                _player addEventHandler ["Local", _handler_player]
            ];
        };
    };
    isNil {
        removeMissionEventHandler [
            "OnUserSelectedPlayer",
            missionNamespace getVariable ["jib_group__handler_mission", -1]
        ];
        jib_group__handler_mission =
            addMissionEventHandler ["OnUserSelectedPlayer", _handler_mission];
    };
};
[] call jib_group__setup;
