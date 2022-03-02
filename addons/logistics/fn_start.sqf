// Start logistics vehicle
#define VAR_START "jib_logistics_start"
params ["_unit"];
if (!isServer) then {throw "Not server!"};
if (!alive _unit) then {throw "Vehicle not alive!"};

// Vehicle variable
private _vehicle = vehicle _unit;
_vehicle setVariable [VAR_START, true, true];
