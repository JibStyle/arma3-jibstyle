if (!isServer) exitWith {};

jib_group_serialize_soldier;
jib_group_serialize_vehicle;
jib_group_deserialize_batch;
jib_group_rally_soldier_pos;
jib_group_rally_vehicle_pos;
jib_group_rtb;

jib_group_autoload_delay = 10;
publicVariable "jib_group_autoload_delay";
jib_group_physics_delay = 0.5;
publicVariable "jib_group_physics_delay";
jib_group__sort_team_rbgy = true; // Sort RBGY instead of default RGBY
publicVariable "jib_group__sort_team_rbgy";

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
    [[], {
        if (!hasInterface) exitWith {};
        waitUntil {uiSleep 1; alive player};
        player setVariable ["jib_group__unit_speaker", speaker player, true];
    }] remoteExec ["spawn", 0, true];
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
            _x setVariable [
                "jib_group__unit_speaker",
                _x getVariable ["jib_group__unit_speaker", speaker _x]
            ];
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

// Set respawn position of group vehicles
jib_group_rally_vehicle = {
    params ["_group", "_pos"];
    if (!isServer) exitWith {};
    _group setVariable ["jib_group__rally_vehicle", _pos, true];
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
         "[group player] remoteExecCall [""jib_group_save"", 2]", "1", true],
        ["AI Respawn",
         "[group player] remoteExecCall [""jib_group_load"", 2]", "1", true],
        ["AI Auto Respawn",
         "[group player] remoteExecCall [""jib_group_autoload"", 2]",
         "1", true],
        ["AI Stop Respawn",
         "[group player] remoteExecCall [""jib_group_autoload_off"", 2]",
         "1", true],
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
            "jib_group__rejoin_data", [assignedTeam _x, currentCommand _x]
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
        _x getVariable ["jib_group__rejoin_data", []] params [
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

jib_group__vehicle = {
    params ["_group", "_vehicle_id"];
    private _vehicle = objNull;
    units _group apply {
        if (vehicle _x call BIS_fnc_netId == _vehicle_id) then {
            _vehicle = vehicle _x;
        };
    };
    _vehicle;
};

jib_group__seats = {
    params ["_group", "_vehicle"];
    (
        fullCrew [_vehicle, "driver"]
            + fullCrew [_vehicle, "commander"]
            + fullCrew [_vehicle, "gunner"]
    ) select {
        _x params [
            "_unit", "_role", "_cargoIndex", "_turretPath", "_personTurret"
        ];
        _unit in units _group;
    } apply {
        _x params [
            "_unit", "_role", "_cargoIndex", "_turretPath", "_personTurret"
        ];
        [
            _unit call BIS_fnc_netId, _role, _cargoIndex,
            _turretPath, _personTurret
        ];
    };
};

jib_group__seat_soldier = {
    params ["_group", "_seat"];
    _seat params [
        "_soldier_id", "_role", "_cargoIndex", "_turretPath", "_personTurret"
    ];
    [_group, _soldier_id] call jib_group__soldier;
};

jib_group__soldier = {
    params ["_group", "_soldier_id"];
    private _soldier = objNull;
    units _group apply {
        if (_x call BIS_fnc_netId == _soldier_id) then {_soldier = _x};
    };
    _soldier;
};

jib_group_saveautoload = {
    params ["_group"];
    if (!isServer) then {throw "Must be server execution!"};
    if (canSuspend) then {throw "Must be unscheduled!"};
    [_group] spawn {
        params ["_group"];
        waitUntil {uiSleep 1; alive leader _group};
        isNil {
            [_group] call jib_group_save;
            [_group] call jib_group_autoload;
        };
    };
};

jib_group_save = {
    params ["_group"];
    if (!isServer) then {throw "Must be server execution!"};
    if (canSuspend) then {throw "Must be unscheduled!"};
    private _old_data =
        _group getVariable ["jib_group__cereal_data", [[],[]]];
    _old_data params ["_old_soldiers", "_old_vehicles"];

    private _new_soldiers = units _group select {!isPlayer _x} apply {
        private _cur_soldier = _x;
        private _old_soldier_matches =
            _old_soldiers select {_x # 0 == _cur_soldier call BIS_fnc_netId};
        if (count _old_soldier_matches > 0) then {
            _old_soldier_matches # 0;
        } else {
            [
                _cur_soldier call BIS_fnc_netId,
                [_cur_soldier] call jib_group_serialize_soldier
            ];
        };
    };
    private _vehicles = [];
    units _group apply {
        if (vehicle _x != _x) then {_vehicles pushBackUnique vehicle _x};
    };
    private _new_vehicles = _vehicles apply {
        private _cur_vehicle = _x;
        private _cur_seats = [_group, _x] call jib_group__seats;
        private _old_vehicle_matches = _old_vehicles select {
            _x params ["_old_vehicle_id", "_old_vehicle", "_old_seats"];
            _old_vehicle_id == _cur_vehicle call BIS_fnc_netId;
        };
        if (count _old_vehicle_matches > 0) then {
            _old_vehicle_matches # 0 params [
                "_old_vehicle_id", "_old_vehicle", "_old_seats"
            ];
            [_old_vehicle_id, _old_vehicle, _cur_seats];
        } else {
            [
                _cur_vehicle call BIS_fnc_netId,
                [_cur_vehicle] call jib_group_serialize_vehicle,
                _cur_seats
            ];
        };
    };

    _group setVariable [
        "jib_group__cereal_data", [_new_soldiers, _new_vehicles]
    ];
};

jib_group_load = {
    params ["_group"];
    if (!isServer) then {throw "Must be server execution!"};
    if (canSuspend) then {throw "Must be unscheduled!"};

    private _old_data =
        _group getVariable ["jib_group__cereal_data", [[],[],[]]];
    _old_data params ["_old_soldiers", "_old_vehicles"];
    private _vehicle_pos = _group getVariable [
        "jib_group__rally_vehicle", call jib_group_rally_vehicle_pos
    ];
    if (isNil {_vehicle_pos}) then {_vehicle_pos = getPosATL leader _group};
    private _soldier_pos = _group getVariable [
        "jib_group__rally", call jib_group_rally_soldier_pos
    ];
    if (isNil {_soldier_pos}) then {_soldier_pos = getPosATL leader _group};

    private _rtb_vehicles = [];
    private _rtb_vehicle_soldiers = [];
    private _rtb_infantry_soldiers = [];
    private _dismount_soldiers = [];
    _old_vehicles = _old_vehicles apply {
        _x params ["_old_vehicle_id", "_old_vehicle", "_old_seats"];

        private _cur_vehicle = objNull;
        units _group apply {
            if (vehicle _x call BIS_fnc_netId == _old_vehicle_id) then {
                _cur_vehicle = vehicle _x;
            };
        };
        private _cur_seats =
            [_group, _cur_vehicle] call jib_group__seats;
        if (_cur_seats isEqualTo _old_seats) then {
            continueWith [true, _old_vehicle_id, _old_vehicle, _old_seats];
        };
        _rtb_vehicles pushBack _old_vehicle;
        private _cur_crew =
            _cur_seats apply {[_group, _x] call jib_group__seat_soldier};
        private _old_crew =
            _old_seats apply {[_group, _x] call jib_group__seat_soldier};
        private _cur_cargo = crew _cur_vehicle - _cur_crew;
        private _soldiers = _cur_crew + _old_crew + _cur_cargo;
        _soldiers arrayIntersect _soldiers apply {
            switch true do
            {
                case (_x in _cur_crew && _x in _old_crew): {
                    _rtb_vehicle_soldiers
                };
                case (_x in _old_crew && _x in _cur_cargo): {
                    _rtb_vehicle_soldiers
                };
                case (_x in _cur_crew): {_dismount_soldiers};
                case (_x in _old_crew): {_rtb_infantry_soldiers};
                case (_x in _cur_cargo): {_dismount_soldiers};
                default {throw "Unexpected switch default!"};
            } pushBack _x;
        };
        [false, _old_vehicle_id, _old_vehicle, _old_seats];
    };
    private _dismount_groups_vehicles = [];
    _dismount_soldiers apply {
        private _index =
            _dismount_groups_vehicles findIf {_x # 0 == group _x};
        if (index >= 0) then {
            _dismount_groups_vehicles # _index # 1 pushBackUnique vehicle _x;
        } else {
            _dismount_groups_vehicles pushBack [_group, [vehicle _x]];
        };
    };
    _old_soldiers = _old_soldiers apply {
        _x params ["_old_soldier_id", "_old_soldier"];
        private _soldier = [_group, _old_soldier_id] call jib_group__soldier;
        if (
            isNull _soldier
                || _soldier in _rtb_vehicle_soldiers + _rtb_infantry_soldiers
        ) then {
            [false, _old_soldier_id, _old_soldier];
        } else {
            [true, _old_soldier_id, _old_soldier];
        };
    };

    _dismount_groups_vehicles apply {
        _x params ["_dismount_group", "_dismount_vehicles"];
        [_dismount_group, _dismount_vehicles] remoteExecCall [
            "jib_group__dismount_vehicles", groupOwner _dismount_group
        ];
    };
    [
        _group, _vehicle_pos, _soldier_pos,
        _rtb_vehicles, _rtb_vehicle_soldiers, _rtb_infantry_soldiers,
        _old_vehicles, _old_soldiers
    ] remoteExec ["jib_group__load_client", groupOwner _group];
};

jib_group__dismount_vehicles = {
    params ["_group", "_vehicles"];
    if (!local _group) then {throw "Group not local!"};
    if (canSuspend) then {throw "Must be unscheduled!"};
    _vehicles apply {
        private _vehicle = _x;
        _group leaveVehicle _vehicle;
        commandGetOut (units _group select {vehicle _x == _vehicle});
    };
};
publicVariable "jib_group__dismount_vehicles";

jib_group__load_client = {
    params [
        "_group",
        "_vehicle_pos",
        "_soldier_pos",
        "_rtb_vehicles",
        "_rtb_vehicle_soldiers",
        "_rtb_infantry_soldiers",
        "_old_vehicles",
        "_old_soldiers"
    ];
    if (!local _group) then {throw "Group not local!"};
    if (!canSuspend) then {throw "Must be scheduled!"};

    private _fake_soldier = objNull;
    if (
        count (units _group - _rtb_vehicle_soldiers - _rtb_infantry_soldiers)
            == 0
    ) then {
        _fake_soldier = _group createUnit ["C_man_1", [0,0,0], [], 0, "NONE"];
        _fake_soldier joinAsSilent [_group, 100];
        _fake_soldier enableSimulationGlobal false;
    };

    private _rtb_vehicle_group = createGroup [side _group, true];
    _rtb_vehicle_soldiers joinSilent _rtb_vehicle_group;
    _rtb_vehicle_soldiers apply {
        _group leaveVehicle vehicle _x;
        _rtb_vehicle_group addVehicle vehicle _x;
    };
    _rtb_vehicle_group addWaypoint [_vehicle_pos, 0] setWaypointStatements [
        "true", "[this] call jib_group_rtb"
    ];
    private _rtb_infantry_group = createGroup [side _group, true];
    _rtb_infantry_soldiers joinSilent _rtb_infantry_group;
    assignedVehicles _rtb_infantry_group apply {
        _rtb_infantry_group leaveVehicle _x
    };
    _rtb_infantry_soldiers allowGetIn false;
    _rtb_infantry_group addWaypoint [_soldier_pos, 0] setWaypointStatements [
        "true", "[this] call jib_group_rtb"
    ];

    private _pending_soldiers =
        _old_soldiers select {_x # 0 == false} apply {_x # 2};
    private _pending_vehicles =
        _old_vehicles select {_x # 0 == false} apply {_x # 2};
    private _pending_seats = [];
    private _pending_vehicle_index = 0;
    _old_vehicles select {_x # 0 == false} apply {
        _x params [
            "_old_vehicle_active", "_old_vehicle_id",
            "_old_vehicle", "_old_seats"
        ];
        _old_seats apply {
            _x params [
                "_soldier_id", "_role", "_cargoIndex",
                "_turretPath", "_personTurret"
            ];
            private _pending_soldier_index = _old_soldiers select {
                _x # 0 == false
            } findIf {_x # 1 == _soldier_id};
            if (_pending_soldier_index < 0) then {
                throw "Pending soldier ID not found!";
            };
            _pending_seats pushBack [
                _pending_vehicle_index, 0, _pending_soldier_index,
                _role, _cargoIndex, _turretPath, _personTurret
            ];
        };
        _pending_vehicle_index = _pending_vehicle_index + 1;
    };

    [
        _group, _vehicle_pos, _soldier_pos,
        _pending_vehicles, _pending_soldiers, _pending_seats
    ] call jib_group_deserialize_batch params [
        "_spawned_vehicles", "_spawned_soldiers"
    ];
    deleteVehicle _fake_soldier;
    [
        _group, _old_vehicles, _old_soldiers,
        _spawned_vehicles, _spawned_soldiers
    ] remoteExecCall ["jib_group__load_complete", 2];
};
publicVariable "jib_group__load_client";

jib_group__load_complete = {
    params [
        "_group", "_old_vehicles", "_old_soldiers",
        "_spawned_vehicles", "_spawned_soldiers"
    ];
    if (!isServer) then {throw "Must be server execution!"};
    if (canSuspend) then {throw "Must be unscheduled!"};

    private _spawned_soldier_index = 0;
    private _spawned_soldier_id_map = createHashMap;
    private _new_soldiers = _old_soldiers apply {
        _x params ["_old_soldier_active", "_old_soldier_id", "_old_soldier"];
        if (_old_soldier_active) then {
            [_old_soldier_id, _old_soldier];
        } else {
            private _spawned_soldier_id =
                _spawned_soldiers # _spawned_soldier_index call BIS_fnc_netId;
            _spawned_soldier_index = _spawned_soldier_index + 1;
            _spawned_soldier_id_map set [
                _old_soldier_id, _spawned_soldier_id
            ];
            [_spawned_soldier_id, _old_soldier];
        };
    };
    private _spawned_vehicle_index = 0;
    private _new_vehicles = _old_vehicles apply {
        _x params [
            "_old_vehicle_active", "_old_vehicle_id",
            "_old_vehicle", "_old_seats"
        ];
        if (_old_vehicle_active) then {
            [_old_vehicle_id, _old_vehicle, _old_seats];
        } else {
            private _spawned_vehicle_id =
                _spawned_vehicles # _spawned_vehicle_index call BIS_fnc_netId;
            _spawned_vehicle_index = _spawned_vehicle_index + 1;
            [
                _spawned_vehicle_id, _old_vehicle, _old_seats apply {
                    _x params [
                        "_old_soldier_id", "_role", "_cargoIndex",
                        "_turretPath", "_personTurret"
                    ];
                    private _spawned_soldier_id =
                        _spawned_soldier_id_map get _old_soldier_id;
                    if (isNil{_spawned_soldier_id}) then {
                        throw "Spawned soldier ID not found!";
                    };
                    [
                        _spawned_soldier_id, _role, _cargoIndex,
                        _turretPath, _personTurret
                    ];
                }
            ];
        };
    };
    _group setVariable [
        "jib_group__cereal_data", [_new_soldiers, _new_vehicles]
    ];
};

jib_group_autoload = {
    params ["_group"];
    if (!isServer) then {throw "Must be server execution!"};
    if (canSuspend) then {throw "Must be unscheduled!"};

    _group removeEventHandler [
        "UnitLeft", _group getVariable ["jib_group__unitLeft", -1]
    ];
    _group setVariable [
        "jib_group__unitLeft",
        _group addEventHandler ["UnitLeft", {
            params ["_group", "_oldUnit"];
            [_group] remoteExecCall ["jib_group__autoload_debounce", 2];
        }]
    ];
    [_group] remoteExecCall ["jib_group__autoload_client_setup", 0, _group];
    [_group] remoteExecCall ["jib_group__autoload_debounce", 2];
};

jib_group__autoload_client_setup = {
    params ["_group"];
    _group removeEventHandler [
        "VehicleRemoved", _group getVariable ["jib_group__vehicleRemoved", -1]
    ];
    _group setVariable [
        "jib_group__vehicleRemoved",
        _group addEventHandler ["VehicleRemoved", {
            params ["_group", "_oldVehicle"];
            [_group] remoteExecCall ["jib_group__autoload_debounce", 2];
        }]
    ];
};
publicVariable "jib_group__autoload_client_setup";

jib_group__autoload_client_teardown = {
    params ["_group"];
    _group removeEventHandler [
        "VehicleRemoved", _group getVariable ["jib_group__vehicleRemoved", -1]
    ];
};
publicVariable "jib_group__autoload_client_teardown";

jib_group__autoload_debounce = {
    params ["_group"];
    if (!isServer) then {throw "Must be server execution!"};
    if (canSuspend) then {throw "Must be unscheduled!"};
    terminate (_group getVariable ["jib_group__respawn", scriptNull]);
    _group setVariable [
        "jib_group__respawn",
        [_group] spawn {
            params ["_group"];
            uiSleep jib_group_autoload_delay;
            [_group] remoteExecCall ["jib_group_load", 2];
        }
    ];
};

jib_group_autoload_off = {
    params ["_group"];
    if (!isServer) then {throw "Must be server execution!"};
    if (canSuspend) then {throw "Must be unscheduled!"};
    _group removeEventHandler [
        "UnitLeft", _group getVariable ["jib_group__unitLeft", -1]
    ];
    [_group] remoteExecCall [
        "jib_group__autoload_client_teardown", 0, _group
    ];
    terminate (_group getVariable ["jib_group__respawn", scriptNull]);
};
