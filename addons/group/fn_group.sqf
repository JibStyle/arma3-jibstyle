jib_group_action;
jib_group_menu_dynamic;
jib_group_serialize_soldier;
jib_group_deserialize_soldiers;

// Add group menu to player
jib_group_menu = {
    params ["_player"];
    if (!isServer) exitWith {};
    [
        _player, [
            "Group Menu",
            {[] call jib_group__menu call jib_group_menu_dynamic},
            [], 4, false, true, "", toString {
                leader player == player && _originalTarget == player
            }, 2
        ]
    ] call jib_group_action;
};

// Set respawn position of group AI
jib_group_rally = {
    params ["_group", "_pos"];
    if (!isServer) exitWith {};
    _group setVariable ["jib_group__rally", _pos, true];
};

jib_group__menu = {
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
publicVariable "jib_group__menu";

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
        private _matches = _data select {
            _x params ["_data_serialized_soldier", "_data_soldier"];
            _data_soldier == _soldier;
        };
        if (count _matches > 0) then {
            _matches # 0;
        } else {
            [[_soldier] call jib_group_serialize_soldier, _soldier];
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
                _x params ["_serialized_soldier", "_soldier"];
                _soldier in units _group == false;
            } apply {
                _x params ["_serialized_soldier", "_soldier"];
                _serialized_soldier;
            },
            _pos
        ] call jib_group_deserialize_soldiers;
        private _index = 0;
        private _new_data = _data apply {
            _x params ["_serialized_soldier", "_soldier"];
            private _result = [];
            if (_soldier in units _group) then {
                _result = [_serialized_soldier, _soldier];
            } else {
                _result = [_serialized_soldier, _new_soldiers # _index];
                _index = _index + 1;
            };
            _result;
        };
        _group setVariable ["jib_group__data", _new_data, true];
    }] remoteExec ["spawn", leader _group];
};
publicVariable "jib_group__load";
