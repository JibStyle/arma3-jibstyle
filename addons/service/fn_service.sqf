jib_service_group_rally;
jib_service_group_rally_vehicle;

jib_service_menu_condition = {
    alive getAssignedCuratorLogic player && _originalTarget == player;
};

jib_service_menu_data = [
    "Service Menu",
    [
        [
            "Update Rally Point",
            toString {
                [player] remoteExec ["jib_service_rally_update_soldier", 2]
            },
            "1", true
        ],
        [
            "Update Vehicle Staging",
            toString {
                [player] remoteExec ["jib_service_rally_update_vehicle", 2]
            },
            "1", true
        ],
        [
            "Update Base",
            toString {
                [player] remoteExec ["jib_service_rally_update_base", 2]
            },
            "1", true
        ]
    ]
];

jib_service_rally_soldier_pos = {
    getPosATL (missionNamespace getVariable "jib_service_rally_field");
};
jib_service_rally_vehicle_pos = {
    getPosATL (missionNamespace getVariable "jib_service_rally_vehicle");
};

// Move field teleporter to player
jib_service_rally_update_soldier = {
    params ["_player"];
    if (!isServer) exitWith {};

    [_player] call jib_service__rally_setup;

    jib_service_rally_field setVehiclePosition [
        getPos _player, [], 0, "NONE"
    ];
    if (getMarkerType "jib_service_rally_marker" == "") then {
        createMarker ["jib_service_rally_marker", _player];
        // "jib_service_rally_marker" setMarkerType "mil_join";
    };
    "jib_service_rally_marker" setMarkerAlphaLocal 1;
    "jib_service_rally_marker" setMarkerPos _player;
    allGroups apply {
        [_x, getPos _player] call jib_service_group_rally;
    };
};

// Move vehicle spawn teleporter to player
jib_service_rally_update_vehicle = {
    params ["_player"];
    if (!isServer) exitWith {};

    [_player] call jib_service__rally_setup;

    jib_service_rally_vehicle setVehiclePosition [
        getPos _player, [], 0, "NONE"
    ];
    if (getMarkerType "jib_service_rally_vehicle_marker" == "") then {
        createMarker ["jib_service_rally_vehicle_marker", _player];
        // "jib_service_rally_vehicle_marker" setMarkerType "mil_join";
    };
    "jib_service_rally_vehicle_marker" setMarkerAlphaLocal 1;
    "jib_service_rally_vehicle_marker" setMarkerPos _player;
    allGroups apply {
        [_x, getPos _player] call jib_service_group_rally_vehicle;
    };
};

// Move vehicle spawn teleporter to player
jib_service_rally_update_base = {
    params ["_player"];
    if (!isServer) exitWith {};

    [_player] call jib_service__rally_setup;

    jib_service_rally_base setVehiclePosition [
        getPos _player, [], 0, "NONE"
    ];
    if (getMarkerType "jib_service_rally_base_marker" == "") then {
        createMarker ["jib_service_rally_base_marker", _player];
        // "jib_service_rally_base_marker" setMarkerType "mil_join";
    };
    "jib_service_rally_base_marker" setMarkerAlphaLocal 1;
    "jib_service_rally_base_marker" setMarkerPos _player;
};

jib_service__rally_setup = {
    params ["_player"];
    if (!isServer) exitWith {};

    if (
        !alive (
            missionNamespace getVariable ["jib_service_rally_base", objNull]
        )
    ) then {
        jib_service_rally_base =
            "Land_Laptop_unfolded_F" createVehicle position _player;
        jib_service_rally_base allowdamage false;
        publicVariable "jib_service_rally_base";
    };
    if (
        !alive (
            missionNamespace getVariable ["jib_service_rally_field", objNull]
        )
    ) then {
        jib_service_rally_field =
            "Land_TentDome_F" createVehicle position _player;
        jib_service_rally_field allowdamage false;
        publicVariable "jib_service_rally_field";
    };
    if (
        !alive (
            missionNamespace getVariable [
                "jib_service_rally_vehicle", objNull
            ]
        )
    ) then {
        jib_service_rally_vehicle =
            "Land_Cargo10_military_green_F" createVehicle position _player;
        jib_service_rally_vehicle allowdamage false;
        publicVariable "jib_service_rally_vehicle";
        // TODO: Set IG texture
    };
    [
        jib_service_rally_base, [
            [jib_service_rally_field, "Rally Point"],
            [jib_service_rally_vehicle, "Vehicle Staging"]
        ]
    ] call jib_service_teleport_init;
    [
        jib_service_rally_field, [
            [jib_service_rally_base, "Base"],
            [jib_service_rally_vehicle, "Vehicle Staging"]
        ], 3
    ] call jib_service_teleport_init;
    [
        jib_service_rally_vehicle, [
            [jib_service_rally_base, "Base"],
            [jib_service_rally_field, "Rally Point"]
        ], 4
    ] call jib_service_teleport_init;
    jib_service_rally_base hideObjectGlobal false;
    jib_service_rally_field hideObjectGlobal false;
    jib_service_rally_vehicle hideObjectGlobal false;
};

// Init object to teleport to other objects
// [a, [[b, "Bravo"], [c, "Charlie"]]] call jib_service_teleport_init;
jib_service_teleport_init = {
    params ["_object", "_destinations", ["_distance", 2, [0]]];
    if (!isServer) exitWith {};
    [[_object, _destinations, _distance], {
        params ["_object", "_destinations", "_distance"];
        _object getVariable ["jib_service_teleport_actions", []] apply {
            _object removeAction _x;
        };
        _object setVariable [
            "jib_service_teleport_actions",
            _destinations apply {
                _x params ["_other", "_name"];
                _object addAction [
                    format ["Teleport to %1", _name],
                    {
                        params ["", "", "", "_arguments"];
                        _arguments params ["_other"];
                        if (isNull _other) exitWith {};
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
                    [_other], 10, true, true, "", "true", _distance
                ];
            }
        ];
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
