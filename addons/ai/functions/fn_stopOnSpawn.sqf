// Call from group init field
params ["_group"];
if (!isServer) exitWith {};

doStop (units _group - [leader _group]);

{
    _x addEventHandler ["Respawn", {
	params ["_unit", "_corpse"];
	if (leader _unit == _unit) exitWith {};
	doStop _unit;
    }];
} forEach units _group;
