if (!isServer) exitWith {};

jib_group_serialize_soldier;
jib_group_deserialize_soldiers;

jib_group_autoload_delay;

jib_group__sort_team_rbgy = true; // Sort RBGY instead of default RGBY

jib_group_setup = {
    if (!isServer) exitWith {};
    removeMissionEventHandler [
        "GroupCreated",
        missionNamespace getVariable ["jib_group__group_created_handler", -1]
    ];
    jib_group__group_created_handler = addMissionEventHandler [
        "GroupCreated", {
	    params ["_group"];
            [_group] call jib_group__setup_group;
        }
    ];
    allGroups apply {
        [_x] call jib_group__setup_group;
    };
};

jib_group__setup_group = {
    params ["_group"];
    _group removeEventHandler [
        "UnitJoined",
        _group getVariable ["jib_group__unit_joined_handler", -1]
    ];
    _group removeEventHandler [
        "UnitLeft",
        _group getVariable ["jib_group__unit_left_handler", -1]
    ];
    _group setVariable [
        "jib_group__unit_joined_handler",
        _group addEventHandler ["UnitJoined", {
	    params ["_group", "_newUnit"];
            [_group] call jib_group__update_speakers;
        }]
    ];
    _group setVariable [
        "jib_group__unit_left_handler",
        _group addEventHandler ["UnitLeft", {
	    params ["_group", "_oldUnit"];
            [_group] call jib_group__update_speakers;
        }]
    ];
    [_x] call jib_group__update_speakers;
};

jib_group__update_speakers = {
    params ["_group"];
    if ({isPlayer _x} count units _group == count units _group) then {
        units _group apply {
            _x setVariable ["jib_group__unit_speaker", speaker _x];
            [_x, "NoVoice"] remoteExec ["setSpeaker", 0, _x];
        };
    } else {
        units _group apply {
            [
                _x, _x getVariable ["jib_group__unit_speaker", speaker _x]
            ] remoteExec ["setSpeaker", 0, _x];
        };
    };
};

// Set respawn position of group AI
jib_group_rally = {
    params ["_group", "_pos"];
    if (!isServer) exitWith {};
    _group setVariable ["jib_group__rally", _pos, true];
};

jib_group_menu_condition = {
    leader player == player && _originalTarget == player;
};

jib_group_menu_data = [
    "Group Menu",
    [
        ["Sort Selected Up",
         "[] call jib_group__sort_selected_up", "1", true],
        ["Sort Selected Down",
         "[] call jib_group__sort_selected_down", "1", true],
        ["Sort Players Up",
         "[] call jib_group__sort_players_up", "1", true],
        ["Sort Players Down",
         "[] call jib_group__sort_players_down", "1", true],
        ["Sort by Fireteam",
         "[] call jib_group__sort_team", "1", true],
        ["AI Save",
         "[group player] call jib_group_save", "1", true],
        ["AI Respawn",
         "[group player] call jib_group_load", "1", true],
        ["AI Auto Respawn",
         "[group player] call jib_group_autoload", "1", true],
        ["AI Stop Respawn",
         "[group player] call jib_group_autoload_off", "1", true],
        ["Delete Selected", "", "1", false,
         ["Confirm Delete?", [["CONFIRM", "[] call jib_group__delete", "1"]]]]
    ]
];

jib_group__sort_selected_up = {
    private _group = group player;
    private _selected = groupSelectedUnits player;
    if (count _selected == 0) then {_selected = [player]};
    private _rest = units _group - _selected;
    [_group, player, _selected + _rest] spawn jib_group__rejoin;
};
publicVariable "jib_group__sort_selected_up";

jib_group__sort_selected_down = {
    private _group = group player;
    private _selected = groupSelectedUnits player;
    if (count _selected == 0) then {_selected = [player]};
    private _rest = units _group - _selected;
    [_group, player, _rest + _selected] spawn jib_group__rejoin;
};
publicVariable "jib_group__sort_selected_down";

jib_group__sort_players_up = {
    private _group = group player;
    private _units = [
        units _group, [], {if (isPlayer _x) then {0} else {1}}
    ] call BIS_fnc_sortBy;
    [_group, player, _units] spawn jib_group__rejoin;
};
publicVariable "jib_group__sort_players_up";

jib_group__sort_players_down = {
    private _group = group player;
    private _units = [
        units _group, [], {if (isPlayer _x) then {1} else {0}}
    ] call BIS_fnc_sortBy;
    [_group, player, _units] spawn jib_group__rejoin;
};
publicVariable "jib_group__sort_players_down";

jib_group__sort_team = {
    private _group = group player;
    private _units = [
        units _group, [], {
            if (jib_group__sort_team_rbgy) then {
                switch (assignedTeam _x) do
                {
                    case "RED": {0};
                    case "BLUE": {1};
                    case "GREEN": {2};
                    case "YELLOW": {3};
                    default {4};
                };
            } else {
                switch (assignedTeam _x) do
                {
                    case "RED": {0};
                    case "GREEN": {1};
                    case "BLUE": {2};
                    case "YELLOW": {3};
                    default {4};
                };
            };
        }
    ] call BIS_fnc_sortBy;
    [_group, player, _units] spawn jib_group__rejoin;
};
publicVariable "jib_group__sort_team";

jib_group__rejoin = {
    params ["_group", "_leader", "_units"];
    if (!local _group) then {throw "Group not local!"};

    private _formMap = createHashMap;
    _units apply {
        _x setVariable [
            "jib_group__data", [assignedTeam _x, currentCommand _x]
        ];
        _formMap set [
            formLeader _x call BIS_fnc_netId,
            [
                formLeader _x,
                expectedDestination formLeader _x select 0,
                (
                    _formMap getOrDefault [
                        formLeader _x call BIS_fnc_netId, [objNull, [], []]
                    ] select 2
                ) + [_x]
            ]
        ];
    };

    private _i = 0;
    private _base = 100;
    _units apply {
        _x joinAsSilent [_group, _base + _i];
        _i = _i + 1;
    };
    _i = 0;
    _units apply {
        _x joinAsSilent [_group, _i];
        _i = _i + 1;
    };

    waitUntil {uiSleep 0.2; _leader in units _group};
    [_group, _leader] remoteExec ["selectLeader", _group];
    waitUntil {uiSleep 0.2; leader _group == _leader && local _group};

    _formMap apply {
        _y params ["_formLeader", "_destination", "_units"];
        if (_formLeader == _leader) then {continue};
        _units doMove _destination;
    };
    units _group apply {
        _x getVariable ["jib_group__data", []] params [
            ["_assignedTeam", "MAIN"],
            ["_currentCommand", ""]
        ];
        _x assignTeam _assignedTeam;
        switch (_currentCommand) do
        {
            case "STOP": {doStop _x};
            default {};
        };
    };
};
publicVariable "jib_group__rejoin";

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

jib_group_save = {
    params ["_group"];
    [[_group], {
        params ["_group"];
        private _data = _group getVariable ["jib_group__data", []];
        private _new_data = units _group apply {
            private _soldier = _x;
            private _soldier_id =
                _soldier getVariable ["jib_group__id", call jib_group__id_fn];
            _soldier setVariable ["jib_group__id", _soldier_id, true];
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
    }] remoteExec [
        "spawn", if !(isNull leader _group) then {leader _group} else {2}
    ];
};
publicVariable "jib_group_save";

// Load missing units from group
jib_group_load = {
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
                _new_soldiers # _index setVariable [
                    "jib_group__id", _id, true
                ];
                _result = [_data_soldier, _id];
                _index = _index + 1;
            };
            _result;
        };
        _group setVariable ["jib_group__data", _new_data, true];
    }] remoteExec [
        "spawn", if !(isNull leader _group) then {leader _group} else {2}
    ];
};
publicVariable "jib_group_load";

jib_group_autoload = {
    params ["_group"];
    _group setVariable [
        "jib_group__unitLeft",
        _group addEventHandler ["UnitLeft", {
            params ["_group", "_oldUnit"];
            [_group, _oldUnit] spawn {
                params ["_group", "_oldUnit"];
                uiSleep 1;
                if (alive _oldUnit) exitWith {};
                terminate (
                    _group getVariable ["jib_group__respawn", scriptNull]
                );
                _group setVariable [
                    "jib_group__respawn",
                    [_group] spawn {
                        params ["_group"];
                        uiSleep (
                            missionNamespace getVariable [
                                "jib_group_autoload_delay", 5
                            ]
                        );
                        [_group] call jib_group_load;
                    }
                ];
            };
        }]
    ];
    [_group] call jib_group_load;
};
publicVariable "jib_group_autoload";

jib_group_autoload_off = {
    params ["_group"];
    _group removeEventHandler [
        "UnitLeft", _group getVariable ["jib_group__unitLeft", -1]
    ];
    terminate (
        _group getVariable ["jib_group__respawn", scriptNull]
    );
};
publicVariable "jib_group_autoload_off";

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
