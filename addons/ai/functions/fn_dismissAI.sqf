// Delete AI from player group
units player apply {
    if (isPlayer _x) then { continue };
    if (vehicle _x == _x) then {
	deleteVehicle _x;
    } else {
	vehicle _x deleteVehicleCrew _x;
    };
};
