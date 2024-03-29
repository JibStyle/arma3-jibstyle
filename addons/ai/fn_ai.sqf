if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_ai_moduleValidate = {};

// Infinite fuel vehicle
jib_ai_infinite_fuel = {
    params ["_vehicle", ["_period", 10, [1]]];
    if (!isServer) exitWith {};
    isNil {
        terminate (
            _vehicle getVariable ["jib_ai__infinite_fuel", scriptNull]
        );
        _vehicle setVariable [
            "jib_ai__infinite_fuel",
            [_vehicle, _period] spawn {
                params ["_vehicle", "_period"];
                private _driver = driver _vehicle;
                while {alive _vehicle && driver _vehicle == _driver} do {
                    uiSleep _period;
                    _vehicle setFuel 1;
                };
            }
        ];
    };
};

// Dependency to draw
jib_ai_drawAdd = {};

// Dependency to reset drawing
jib_ai_drawRemove = {};

// PRIVATE BELOW HERE

// Cancel monitor schedule
jib_ai_monitorReset = {
    params ["_unit"];
    if (not isServer) then {throw "Not server!"};
    if (isNull _unit) then {throw "Null unit!"};

    _unit setVariable ["jib_ai_monitor", "", true];
    [_unit] call jib_ai_drawRemove;
};

// Schedule monitor for targets
jib_ai_monitorTargets = {
    params ["_unit"];
    if (not isServer) then {throw "Not server!"};
    if (isNull _unit) then {throw "Null unit!"};

    [_unit] call jib_ai_monitorReset;
    _unit setVariable ["jib_ai_monitor", "targets", true];
    [[_unit], {
        params ["_unit"];
        while {
            not isNull _unit
                && {
                    _unit getVariable ["jib_ai_monitor", ""]
                        == "targets"
                }
        } do {
            [
                _unit,
                [_unit] call jib_ai_drawText,
                [_unit] call jib_ai_drawLines
            ] remoteExec ["jib_ai_drawAdd", 2];
            uiSleep 1;
        };
    }] remoteExec ["spawn", _unit];
};

// Get draw text for unit
jib_ai_drawText = {
    params ["_unit"];
    if (isNull _unit) then {throw "Null unit!"};
    "";
};

// Get draw lines for unit
jib_ai_drawLines = {
    params ["_unit"];
    if (isNull _unit) then {throw "Null unit!"};

    if (
        _unit getVariable ["jib_ai_monitor", ""] != "targets"
    ) exitWith {[]};

    _unit nearTargets 1500 select {
        _x # 4 isKindOf "AllVehicles"
    } apply {
        _x params ["", "", "", "", "_target", ""];
        [
            _target,
            _unit knowsAbout _target,
            _x,
            _unit targetKnowledge _target,
            _unit getHideFrom _target
        ];
    } apply {
        _x params [
            "_target",
            "_knowsAbout",
            "_nearTarget",
            "_targetKnowledge",
            "_getHideFrom" // ATL aimPos
        ];
        _nearTarget params [
            "_nearTargetPosition",
            "_nearTargetType",
            "_nearTargetSide",
            "_nearTargetSubjectiveCost",
            "_nearTargetObject", // same as _target
            "_nearTargetPositionAccuracy"
        ];
        _targetKnowledge params [
            "_targetKnowledgeKnownByGroup",
            "_targetKnowledgeKnownByUnit",
            "_targetKnowledgeLastSeen",
            "_targetKnowledgeLastThreat",
            "_targetKnowledgeSide",
            "_targetKnowledgeErrorMargin",
            "_targetKnowledgePosition"
        ];

        private _color = [];
        switch (_nearTargetSide) do
        {
            case west: {
                _color = [0, .3, .6, 1];
            };
            case east: {
                _color = [.5, 0, 0, 1];
            };
            case independent: {
                _color = [0, .5, 0, 1];
            };
            case civilian: {
                _color = [.4, 0, .5, 1];
            };
            default {
                _color = [.7, .6, 0, 1];
            };
        };

        [
            _target,
            _color,
            format [
                "%1 (%2, %3, %4)",
                _nearTargetType,
                _knowsAbout,
                _nearTargetSubjectiveCost,
                _nearTargetPositionAccuracy
            ]
        ];
    };
};

// Keeps daemon running
jib_ai_laserControlVariable = "jib_ai_laserControlVariable";

jib_ai_infiniteAmmoEnable = {
    params [
        "_unit",         // Unit
        ["_time", 20, [0]] // Time to reload
    ];
    if (not isServer) exitWith {};
    if (isNull _unit) then {throw "Null unit!"};

    [[_unit, _time], {
        params ["_unit", "_time"];
        _unit setVariable [
            "jib_ai__infiniteammo_reloadtime",
            _time
        ];
        _unit setVariable [
            "jib_ai__infiniteammo_loadout", getUnitLoadout _unit
        ];
        _unit removeEventHandler [
            "Fired",
            _unit getVariable ["jib_ai__infiniteammo_fired", -1]
        ];
        _unit setVariable [
            "jib_ai__infiniteammo_fired",
            _unit addEventHandler [
                "Fired",
                {
                    params ["_unit"];
                    terminate (
                        _unit getVariable [
                            "jib_ai__infiniteammo_reload",
                            scriptNull
                        ]
                    );
                    _unit setVariable [
                        "jib_ai__infiniteammo_reload",
                        [_unit] spawn {
                            params ["_unit"];
                            uiSleep (
                                _unit getVariable [
                                    "jib_ai__infiniteammo_reloadtime",
                                    20
                                ]
                            );
                            _unit setVehicleAmmo 1;
                            _unit setUnitLoadout [
                                _unit getVariable [
                                    "jib_ai__infiniteammo_loadout",
                                    getUnitLoadout typeOf _unit
                                ],
                                true
                            ]
                        }
                    ];
                }
            ]
        ];
    }] remoteExec ["spawn", _unit];
};

jib_ai_infiniteAmmoDisable = {
    params ["_unit"];
    if (not isServer) then {throw "Not server!"};
    if (isNull _unit) then {throw "Null unit!"};

    [[_unit], {
        params ["_unit"];
        _unit removeEventHandler [
            "Fired",
            _unit getVariable [
                "jib_ai__infiniteammo_fired",
                -1
            ]
        ];
    }] remoteExec ["spawn", _unit];
};

// Make some units in group have infinite health and/or ammo
jib_ai_plotArmor = {
    params [
        "_group",
        ["_probInvincible", 0.5, [0]],
        ["_probAmmo", 0.5, [0]]
    ];
    if (not isServer) exitWith {};
    units _group apply {
        if (random 1 < _probInvincible) then {
            [_x, false] remoteExec ["allowDamage"];
        };
        if (random 1 < _probAmmo) then {
            [_x, 120] call jib_ai_infiniteAmmoEnable;
        };
    };
};

// Enable AI lasers when SL laser active
jib_ai_laserControlEnable = {
    params ["_group"];
    if (not isServer) then {throw "Not server!"};
    if (isNull _group) then {throw "Null group!"};

    // Start daemon
    [[_group], {
        params ["_group"];
        private _sleepDelay = 1;
        _group setVariable [jib_ai_laserControlVariable, true];
        while {
            _group getVariable [jib_ai_laserControlVariable, false]
                && local _group
        } do {
	    private _leader = leader _group;
	    if (!isPlayer _leader) then {continue};
	    private _laserOn =
                _leader isIRLaserOn currentWeapon _leader;
	    _group enableIRLasers _laserOn;
            uiSleep _sleepDelay;
        };
    }] remoteExec ["spawn", leader _group];
    true;
};

// Disable AI laser control
jib_ai_laserControlDisable = {
    params ["_group"];
    if (not isServer) then {throw "Not server!"};
    if (isNull _group) then {throw "Null group!"};

    // Signal daemon to exit
    _group setVariable [
        jib_ai_laserControlVariable,
        false,
        owner leader _group
    ];
    true;
};

jib_ai_moduleInfiniteAmmoEnable = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached] call jib_ai_infiniteAmmoEnable;
        }
    ] call jib_ai_moduleValidate;
};

jib_ai_moduleInfiniteAmmoDisable = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached] call jib_ai_infiniteAmmoDisable;
        }
    ] call jib_ai_moduleValidate;
};

// Enable laser control
jib_ai_moduleLaserControlEnable = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [group _attached] call jib_ai_laserControlEnable;
        }
    ] call jib_ai_moduleValidate;
};

// Disable laser control
jib_ai_moduleLaserControlDisable = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [group _attached] call jib_ai_laserControlDisable;
        }
    ] call jib_ai_moduleValidate;
};

// Monitor targets
jib_ai_moduleMonitorTargets = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached] call jib_ai_monitorTargets;
        }
    ] call jib_ai_moduleValidate;
};

// Monitor reset
jib_ai_moduleMonitorReset = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached] call jib_ai_monitorReset;
        }
    ] call jib_ai_moduleValidate;
};

publicVariable "jib_ai_drawAdd";
publicVariable "jib_ai_drawRemove";
publicVariable "jib_ai_drawText";
publicVariable "jib_ai_drawLines";
publicVariable "jib_ai_moduleValidate";
publicVariable "jib_ai_laserControlVariable";
publicVariable "jib_ai_moduleInfiniteAmmoEnable";
publicVariable "jib_ai_moduleInfiniteAmmoDisable";
publicVariable "jib_ai_moduleLaserControlEnable";
publicVariable "jib_ai_moduleLaserControlDisable";
publicVariable "jib_ai_moduleMonitorTargets";
publicVariable "jib_ai_moduleMonitorReset";

// Continuously suppress area
jib_ai_arty = {
    params [
        "_group",    // group
        "_magazine", // classname
        "_rounds",   // num rounds in volley
        "_reload",   // seconds between volleys
        "_area"      // [pos, [a, b, angle, isRect, c]]
    ];
    if (!local _group) exitWith {};
    [_group, _magazine, _rounds, _reload, _area] spawn {
        params ["_group", "_magazine", "_rounds", "_reload", "_area"];
        private _vics = {
            private _result = units _group apply {vehicle _x};
            _result arrayIntersect _result;
        };
        while {count call _vics > 0} do {
            waitUntil {
                uiSleep 1;
                {unitReady _x} count call _vics == count call _vics;
            };
            sleep _reload;
            call _vics apply {
                _x setVehicleAmmo 1;
                _x commandArtilleryFire [
                    _area call BIS_fnc_randomPosTrigger,
                    _magazine,
                    _rounds
                ];
            };
        };
    };
};

// Init group for CQB behavior
jib_ai_cqb = {
    params [
        "_group",                         // Group
        ["_group_weight_guard", 0, [0]],  // Guard WP
        ["_group_weight_engage", 0, [0]], // Combat mode RED
        ["_group_weight_static", 1, [0]], // Static defense
        ["_unit_static_prob", 0.5, [0]],  // Disable AI "TARGET" and "PATH"
        ["_unit_static_dist", -1, [0]],   // Distance to disable static
        ["_group_weight_dismiss", 0, [0]] // Dismiss WP
    ];
    if (!local _group) exitWith {};
    private _group_mode = selectRandomWeighted [
        "static", _group_weight_static, "engage", _group_weight_engage,
        "guard", _group_weight_guard, "dismiss", _group_weight_dismiss
    ];
    [_group, _group_mode, _unit_static_prob, _unit_static_dist] spawn {
        params [
            "_group", "_group_mode", "_unit_static_prob", "_unit_static_dist"
        ];
        waitUntil {alive leader _group || isNull _group};
        switch _group_mode do
        {
            case "static": {
                _group setVariable ["jib_ai__cqb_mode", "static"];
                units _group apply {
                    doStop _x;
                    if (random 1 < _unit_static_prob) then {
                        _x disableAI "TARGET";
                        _x disableAI "PATH";
                    };
                };
                _group setVariable [
                    "jib_ai__cqb_distance", _unit_static_dist
                ];
            };
            case "engage": {
                _group setVariable ["jib_ai__cqb_mode", "engage"];
                units _group apply {doStop _x};
                _group setCombatMode "RED";
            };
            case "guard": {
                _group setVariable ["jib_ai__cqb_mode", "guard"];
                units _group apply {
                    _x disableAI "TARGET";
                    _x disableAI "PATH";
                };
                _group setVariable ["jib_ai__cqb_guard", true];
                private _wp = _group addWaypoint [getPos leader _group, 0];
                _wp setWaypointType "GUARD";
                _wp setWaypointPosition [getPosASL leader _group, -1];
            };
            case "dismiss": {
                _group setVariable ["jib_ai__cqb_mode", "dismiss"];
                private _wp = _group addWaypoint [getPos leader _group, 0];
                _wp setWaypointType "DISMISS";
                _wp setWaypointPosition [getPosASL leader _group, -1];
            };
            default {};
        };
    };

    terminate (
        missionNamespace getVariable ["jib_ai__cqb_distance", scriptNull]
    );
    jib_ai__cqb_distance = [] spawn {
        private _groups = allGroups select {
            _x getVariable ["jib_ai__cqb_distance", -1] > 0
        };
        while {count _groups > 0} do {
            _groups apply {
                private _group = _x;
                private _distance =
                    _x getVariable ["jib_ai__cqb_distance", -1];
                private _nearestPlayer = objNull;
                allPlayers apply {
                    if (
                        _x distance leader _group
                            < _nearestPlayer distance leader _group
                            && isTouchingGround _x
                    ) then {_nearestPlayer = _x};
                };
                if (_nearestPlayer distance leader _group < _distance) then {
                    _group setVariable ["jib_ai__cqb_distance", nil];
                    units _group apply {_x enableAI "TARGET"};
                    units _group apply {_x enableAI "PATH"};
                };
                uiSleep 0.3;
            };
            uiSleep 1;
            _groups = allGroups select {
                _x getVariable ["jib_ai__cqb_distance", -1] > 0
            };
        };
    };

    terminate (
        missionNamespace getVariable ["jib_ai__cqb_guard", scriptNull]
    );
    jib_ai__cqb_guard = [] spawn {
        private _groups = allGroups select {
            _x getVariable ["jib_ai__cqb_guard", false]
        };
        while {count _groups > 0} do {
            _groups apply {
                private _group = _x;
                leader _group enableAI "TARGET";
                leader _group enableAI "PATH";
                if (currentCommand leader _group == "ATTACK AND FIRE") then {
                    _group setVariable ["jib_ai__cqb_guard", nil];
                    units _group apply {_x enableAI "TARGET"};
                    units _group apply {_x enableAI "PATH"};
                };
                uiSleep 0.3;
            };
            uiSleep 1;
            _groups = allGroups select {
                _x getVariable ["jib_ai__cqb_guard", false]
            };
        };
    };
};
