// Setup to service player vehicle
params [
    "_object",  // Service provider
    "_distance" // Service max distance
];
_classname = typeOf _object;
_object setVariable ["jib_service_serviceVehicleProvider", true];
_object setVariable ["jib_service_serviceVehicleDistance", _distance];

if (isNil "jib_service_serviceVehicleClassnames") then {
    jib_service_serviceVehicleClassnames = [];
};
if (_classname in jib_service_serviceVehicleClassnames == false) then {
    jib_service_serviceVehicleClassnames pushBack _classname;
};
