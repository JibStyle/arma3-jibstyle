// Setup to auto service AI and its vehicle
if (not isServer) exitWith {};
params [
    "_object",  // Service provider
    "_distance" // Service max distance
];
if (isNil "_distance") then {_distance = 7};
[_object, _distance] spawn {
    params ["_object", "_distance"];
    while {true} do {
        uiSleep 1;
        _object nearEntities ["AllVehicles", _distance] select {
            _driver = driver _x;
            not isNull _driver
                && { not isPlayer _driver };
        } apply {
            crew _x select {
                alive _x && { not isPlayer _x };
            } apply {
                [_x, _x] call ace_medical_treatment_fnc_fullHeal;
                _x setUnitLoadout typeOf _x;
                [_x] call jib_inventory_fnc_setupAIInventory;
            };
            _x setDamage 0;
            _x setFuel 1;
            _x setVehicleAmmo 1;
        };
    };
};
