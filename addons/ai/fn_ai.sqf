if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_ai_moduleValidate = {};

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

jib_ai_infiniteAmmoReloadTime = "jib_ai_infiniteAmmoReloadTime";

jib_ai_infiniteAmmoFiredHandler = "jib_ai_infiniteAmmoFiredHandler";

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
            jib_ai_infiniteAmmoReloadTime,
            _time
        ];
        _unit setVariable [
            jib_ai_infiniteAmmoFiredHandler,
            _unit addEventHandler [
                "Fired",
                {
                    params ["_unit"];
                    [_unit] spawn {
                        params ["_unit"];
                        uiSleep (
                            _unit getVariable [
                                jib_ai_infiniteAmmoReloadTime,
                                20
                            ]
                        );
                        _unit setVehicleAmmo 1;
                    };
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
                jib_ai_infiniteAmmoFiredHandler,
                -1
            ]
        ];
    }] remoteExec ["spawn", _unit];
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
publicVariable "jib_ai_infiniteAmmoFiredHandler";
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
