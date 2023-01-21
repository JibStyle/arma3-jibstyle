if (!isServer) exitWith {};

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
                [_other], 10, false, true, "", "true", 2
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
            {forceRespawn player}, [], 10, false, true, "", "true", 2
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
            }, [], 10, false, true, "", "true", 2
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
                "Full Vehicle Service",
                {
                    private _vehicle = vehicle player;
                    private _commander = effectiveCommander _vehicle;
                    private _oldCrew = crew _vehicle;
                    _vehicle setVehicleAmmo 1;
                    _vehicle setFuel 1;
                    _vehicle setDamage 0;
                    _oldCrew apply {
                        if (alive _x) then {
                            [_x] remoteExec ["jib_service_heal", 2];
                            [[_x]] remoteExec [
                                "jib_service_loadout_load", 2
                            ];
                        } else {
                            _vehicle deleteVehicleCrew _x;
                        };
                    };
                    createVehicleCrew _vehicle;
                    private _newCrew = crew _vehicle - _oldCrew;
                    _newCrew join _commander;
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

// Init object to provide loadout service
jib_service_loadout_init = {
    params ["_object"];
    if (!isServer) exitWith {};
    [[_object], {
        params ["_object"];
        _object addAction [
            "Loadout Menu",
            {showCommandingMenu "#USER:jib_service_loadout_menu"},
            [], 10, true, true, "", "true", 2
        ];
    }] remoteExec ["spawn", 0, true];
};

jib_service_loadout_menu = [
    ["Loadout Menu", true],
    [
        "Save Loadout", [2], "", -5,
        [["expression", "[] call jib_service_loadout_menu_save"]],
        "1", "1"
    ],
    [
        "Load Loadout", [3], "", -5,
        [["expression", "[] call jib_service_loadout_menu_load"]],
        "1", "1"
    ],
    [
        "Reset Loadout", [4], "", -5,
        [["expression", "[] call jib_service_loadout_menu_reset"]],
        "1", "1"
    ]
];
publicVariable "jib_service_loadout_menu";

jib_service_loadout_menu_save = {
    private _selected = groupSelectedUnits player;
    if (leader player == player && count _selected > 0) then {
        private _units = _selected select {_x distance player < 10};
        [_units] remoteExec ["jib_service_loadout_save", 2];
        systemChat format ["Saved %1 loadouts.", count _units];
    } else {
        [[player]] remoteExec ["jib_service_loadout_save", 2];
        systemChat "Saved player loadout.";
    };
};
publicVariable "jib_service_loadout_menu_save";

jib_service_loadout_menu_load = {
    private _selected = groupSelectedUnits player;
    if (leader player == player && count _selected > 0) then {
        private _units = _selected select {_x distance player < 10};
        [_units] remoteExec ["jib_service_loadout_load", 2];
        systemChat format ["Loaded %1 loadouts.", count _units];
    } else {
        [[player]] remoteExec ["jib_service_loadout_load", 2];
        systemChat "Loaded player loadout.";
    };
};
publicVariable "jib_service_loadout_menu_load";

jib_service_loadout_menu_reset = {
    private _selected = groupSelectedUnits player;
    if (leader player == player && count _selected > 0) then {
        private _units = _selected select {_x distance player < 10};
        [_units] remoteExec ["jib_service_loadout_reset", 2];
        systemChat format ["Reset %1 loadouts.", count _units];
    } else {
        [[player]] remoteExec ["jib_service_loadout_reset", 2];
        systemChat "Reset player loadout.";
    };
};
publicVariable "jib_service_loadout_menu_reset";

// Save loadout of units
jib_service_loadout_save = {
    params ["_units"];
    if (!isServer) then {throw "Not server!"};
    _units apply {
        _x setVariable ["jib_service_loadout", getUnitLoadout _x]
    };
    if (not isNil "jib_service_loadout_handler") then {
        removeMissionEventHandler [
            "EntityRespawned", jib_service_loadout_handler
        ];
    };
    jib_service_loadout_handler = addMissionEventHandler [
        "EntityRespawned", {
            params ["_unit", "_corpse"];
            private _loadout =
                _corpse getVariable ["jib_service_loadout", false];
            _unit setVariable ["jib_service_loadout", _loadout];
            if (typeName _loadout == "BOOL") then {
                _unit setUnitLoadout typeOf _unit;
            } else {
                _unit setUnitLoadout [_loadout, true];
            };
        }
    ];
};

// Load loadout of units
jib_service_loadout_load = {
    params ["_units"];
    if (!isServer) then {throw "Not server!"};
    _units apply {
        private _loadout =
            _x getVariable ["jib_service_loadout", false];
        if (typeName _loadout == "BOOL") then {
            _x setUnitLoadout typeOf _x;
        } else {
            _x setUnitLoadout [_loadout, true];
        };
    };
};

// Reset loadout of units
jib_service_loadout_reset = {
    params ["_units"];
    if (!isServer) then {throw "Not server!"};
    _units apply {
        _x setVariable ["jib_service_loadout", false];
        _x setUnitLoadout typeOf _x;
    };
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

jib_service_group_top = {
    params ["_leader", "_selected"];
    if (!isServer) then {throw "Not server!"};
    private _group = group _leader;
    if (count _selected == 0) then {_selected = [_leader]};
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
    [_group, _leader] remoteExec ["selectLeader", groupOwner _group];
};

jib_service_group_bottom = {
    params ["_leader", "_selected"];
    if (!isServer) then {throw "Not server!"};
    private _group = group _leader;
    if (count _selected == 0) then {_selected = [_leader]};
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
    [_group, _leader] remoteExec ["selectLeader", groupOwner _group];
};

jib_service_spawnUnit = {
    params ["_leader", "_type", "_position"];
    private _unit =
        group _leader createUnit [_type, _position, [], 0, "NONE"];
    doStop _unit;
};
publicVariable "jib_service_spawnUnit";

jib_service_spawnVehicle = {
    params ["_leader", "_type", "_position"];
    private _vehicle = _type createVehicle _position;
    _vehicle setVariable ["jib_service_disposable", true, true];
    createVehicleCrew _vehicle;
    crew _vehicle join _leader;
    doStop effectiveCommander _vehicle;
};
publicVariable "jib_service_spawnVehicle";

jib_service_despawn = {
    params ["_leader", "_selected"];
    _selected select {
        isPlayer _x == false
    } apply {
        if (vehicle _x == _x) then {
            deleteVehicle _x;
        } else {
            private _vehicle = vehicle _x;
            _vehicle deleteVehicleCrew _x;
            if (
                _vehicle getVariable [
                    "jib_service_disposable", false
                ] && count crew _vehicle == 0
            ) then {
                deleteVehicle _vehicle;
            };
        };
    };
};
publicVariable "jib_service_despawn";
