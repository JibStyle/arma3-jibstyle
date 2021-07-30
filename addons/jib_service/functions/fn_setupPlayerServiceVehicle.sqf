// Add conditional vehicle service action to player
player addAction [
    "Repair, refuel, and rearm",	      // title
    {
        // params ["_target", "_caller", "_actionId", "_arguments"];
	vehicle player setDamage 0;
	vehicle player setFuel 1;
	vehicle player setVehicleAmmo 1;
    },                                        // code
    nil,				      // arguments
    10,                                       // priority
    true,				      // showWindow
    true,				      // hideOnUse
    "",                                       // shortcut
    "call jib_service_fnc_canServiceVehicle", // condition
    50,                                       // radius
    false,				      // unconscious
    "",                                       // selection
    ""                                        // memoryPoint
];
