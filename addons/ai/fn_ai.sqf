if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_ai_moduleValidate = {};

// PRIVATE BELOW HERE

// Keeps daemon running
jib_ai_laserControlVariable = "jib_ai_laserControlVariable";

// Enable AI lasers when SL laser active
jib_ai_laserControlEnable = {
    params ["_group"];
    if (not isServer) throw "Not server!";
    if (isNull _group) throw "Null group!";

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
    }] remoteExec ["spawn", _group]; // NOTE: Group remoteExec bad!
    true;
};

// Disable AI laser control
jib_ai_laserControlDisable = {
    params ["_group"];
    if (not isServer) throw {"Not server!"};
    if (isNull _group) throw {"Null group!"};

    // Signal daemon to exit
    _group setVariable [
        jib_ai_laserControlVariable,
        false,
        owner leader _group
    ];
    true;
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
publicVariable "jib_ai_moduleLaserControlEnable";
publicVariable "jib_ai_moduleLaserControlDisable";
