// Check if player can service vehicle
if (
    isNil "jib_service_serviceVehicleClassnames"
	|| vehicle player == player
) exitWith {false};
jib_service_serviceVehicleClassnames findIf {
    _object = nearestObject [player, _x];
    _object getVariable ["jib_service_serviceVehicleProvider", false]
	&& (
	    _object getVariable ["jib_service_serviceVehicleDistance", 7]
		> _object distance vehicle player
	)
} > -1;
