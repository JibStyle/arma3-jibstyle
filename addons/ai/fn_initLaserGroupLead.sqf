// Call in group init
params ["_group"];
if (!isServer) exitWith {};
[_group] spawn {
    while {true} do {
	sleep 1;
	params ["_group"];
	private _leader = leader _group;
	if (!isPlayer _leader) then {continue};

	private _laserOn = _leader isIRLaserOn currentWeapon _leader;
	_group enableIRLasers _laserOn;
    };
};
