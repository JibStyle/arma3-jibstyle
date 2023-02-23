// Init object to teleport to other objects
// [a, [[b, "Bravo"], [c, "Charlie"]]] call jib_service_teleport_init;
jib_service_teleport_init = {
    params ["_object", "_destinations"];
    if (!isServer) exitWith {};
    [[_object, _destinations], {
        params ["_object", "_destinations"];
        _destinations apply {
            _x params ["_other", "_name"];
            _object addAction [
                format ["Teleport to %1", _name],
                {
                    params ["", "", "", "_arguments"];
                    _arguments params ["_other"];
                    private _teleport = {
                        params ["_unit"];
                        _unit setVehiclePosition [
                            getPos _other, [], 0, "NONE"
                        ];
                    };
                    private _selected = units group player;
                    if (
                        leader player == player && count _selected > 0
                    ) then {
                        private _units = _selected select {
                            _x distance player < 10
                        };
                        _units apply {
                            [_x] call _teleport;
                            uiSleep 0.3;
                        };
                        systemChat format [
                            "Teleported %1 units.", count _units
                        ];
                    } else {
                        [player] call _teleport;
                        systemChat "Teleported player.";
                    };
                },
                [_other], 10, true, true, "", "true", 2
            ];
        };
    }] remoteExec ["spawn", 0, true];
};

// Init object to force respawn
// [laptop] call jib_service_respawn_init;
jib_service_respawn_init = {
    params ["_object"];
    if (!isServer) exitWith {};
    [[_object], {
        params ["_object"];
        _object addAction [
            "Respawn (without counting death)",
            {forceRespawn player}, [], 5, true, true, "", "true", 2
        ];
    }] remoteExec ["spawn", 0, true];
};

// Init object to heal players
// [object] call jib_service_fak_init;
jib_service_fak_init = {
    params ["_object"];
    if (!isServer) exitWith {};
    [[_object], {
        params ["_object"];
        _object addAction [
            "Heal Nearby Group Units",
            {
                private _units = units group player select {
                    _x distance player < 10
                };
                _units apply {
                    [_x] remoteExec ["jib_service_heal", 2];
                };
                systemChat format ["Healed %1 units", count _units];
            }, [], 10, true, true, "", "true", 2
        ];
    }] remoteExec ["spawn", 0, true];
};

// Init object to provide vehicle service
// [depot] call jib_service_depot_init;
jib_service_depot_init = {
    params [
        "_object",
        ["_service", true, [true]],
        ["_pylon", true, [true]],
        ["_inventory", true, [true]]
    ];
    if (!isServer) exitWith {};
    [[_object, _service, _pylon, _inventory], {
        params ["_object", "_service", "_pylon", "_inventory"];
        jib_service_depot_allowed = {
            vehicle player != player
                && effectiveCommander player == player;
        };
        if (_service) then {
            _object addAction [
                "Service Vehicle",
                {
                    private _vehicle = vehicle player;
                    // private _commander = effectiveCommander _vehicle;
                    // private _oldCrew = crew _vehicle;
                    [[_vehicle], {
                        params ["_vehicle"];
                        _vehicle setVehicleAmmo 1;
                        _vehicle setFuel 1;
                        _vehicle setDamage 0;
                    }] remoteExec ["spawn", 0];
                    // _oldCrew apply {
                    //     if (alive _x) then {
                    //         [_x] remoteExec ["jib_service_heal", 2];
                    //         [[_x]] remoteExec [
                    //             "jib_service_loadout_load", 2
                    //         ];
                    //     } else {
                    //         _vehicle deleteVehicleCrew _x;
                    //     };
                    // };
                    // createVehicleCrew _vehicle;
                    // private _newCrew = crew _vehicle - _oldCrew;
                    // _newCrew join _commander;
                },
                [], 10, true, true, "",
                "[] call jib_service_depot_allowed", 30
            ];
        };
        if (_pylon) then {
            _object addAction [
                "Pylon Manager",
                {[vehicle player] call zen_pylons_fnc_configure},
                [], 10, true, true, "",
                "[] call jib_service_depot_allowed", 30
            ];
        };
        if (_inventory) then {
            _object addAction [
                "Edit Inventory",
                {[vehicle player] call zen_inventory_fnc_configure},
                [], 10, true, true, "",
                "[] call jib_service_depot_allowed", 30
            ];
        };
    }] remoteExec ["spawn", 0, true];
};

// Heal a unit
jib_service_heal = {
    params ["_unit"];
    if (!isServer) then {throw "Not server!"};
    if (isNil "ace_medical_treatment_fnc_fullHeal") then {
        _unit setDamage 0;
    } else {
        [_unit, _unit] remoteExec [
            "ace_medical_treatment_fnc_fullHeal", _unit
        ];
    };
};

jib_service_group_menu = [
    "Group Menu",
    [
        ["Selected Up", "[] call jib_service__group_top", "1", true],
        ["Selected Down", "[] call jib_service__group_bottom", "1", true],
        [
            "Delete Selected", "", "1", false, [
                "Confirm Delete?", [
                    ["CONFIRM", "[] call jib_service__group_delete", "1"]
                ]
            ]
        ]
    ]
];

jib_service__group_top = {
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
publicVariable "jib_service__group_top";

jib_service__group_bottom = {
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
publicVariable "jib_service__group_bottom";

jib_service__group_delete = {
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
publicVariable "jib_service__group_delete";
