// Enable AI lasers when SL laser active
params ["_logic", "", "_isActivated"];
if (not _isActivated) exitWith { systemChat "Not activated!"; };
if (not isServer) exitWith { systemChat "Not server!"; };
#define LASER_CONTROL_VARIABLE "jib_ai_laserControlEnabled"
#define SLEEP_DELAY 1

// Get chosen group
private _group = group (
    _logic getvariable [
        "bis_fnc_curatorAttachObject_object",
        objNull
    ]
);

// Start daemon
[[_group], {
    params ["_group"];
    _group setVariable [LASER_CONTROL_VARIABLE, true];
    while {
        _group getVariable [LASER_CONTROL_VARIABLE, false]
            && local _group
    } do {
	private _leader = leader _group;
	if (!isPlayer _leader) then {continue};
	private _laserOn = _leader isIRLaserOn currentWeapon _leader;
	_group enableIRLasers _laserOn;
        uiSleep SLEEP_DELAY;
    };
}] remoteExec ["spawn", _group];

[_logic, _group] spawn {
    params ["_logic", "_group"];
    waitUntil { isNull _logic };
    _group setVariable [LASER_CONTROL_VARIABLE, false, owner _group];
};
