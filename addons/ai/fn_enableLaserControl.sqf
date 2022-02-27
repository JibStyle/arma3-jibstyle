// Enable AI lasers when SL laser active
params ["_group"];
#define LASER_CONTROL_VARIABLE "jib_ai_laserControlEnabled"
#define SLEEP_DELAY 1
if (not isServer) throw "Not server!";
if (isNull _group) throw "Null group!";

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
true;
