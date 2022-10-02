if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_ai_moduleValidate = {};

// PRIVATE BELOW HERE

// Keeps daemon running
jib_ai_laserControlVariable = "jib_ai_laserControlVariable";

jib_ai_infiniteAmmoFiredHandler = "jib_ai_infiniteAmmoFiredHandler";

jib_ai_infiniteAmmoEnable = {
    params ["_unit"];
    if (not isServer) then {throw "Not server!"};
    if (isNull _unit) then {throw "Null unit!"};

    [[_unit], {
        params ["_unit"];
        _unit setVariable [
            jib_ai_infiniteAmmoFiredHandler,
            _unit addEventHandler [
                "Fired",
                {
                    params ["_unit"];
                    _unit setVehicleAmmo 1;
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

publicVariable "jib_ai_moduleValidate";
publicVariable "jib_ai_infiniteAmmoFiredHandler";
publicVariable "jib_ai_laserControlVariable";
publicVariable "jib_ai_moduleInfiniteAmmoEnable";
publicVariable "jib_ai_moduleInfiniteAmmoDisable";
publicVariable "jib_ai_moduleLaserControlEnable";
publicVariable "jib_ai_moduleLaserControlDisable";
