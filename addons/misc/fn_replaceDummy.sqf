// Replace dummy object with specified vehicle type.
//
// Useful for spawning vehicles above ground like on a carrier.
params [
    "_oldVehicle",        // Object to delete
    "_newType",           // Type to spawn
    ["_createCrew", true] // Whether to create crew
];
if (not isServer) then {throw "Not server!"};
if (typeName _newType != "STRING") then {throw "No type selected!"};
[_oldVehicle, _newType, _createCrew] spawn {
    params ["_oldVehicle", "_newType", "_createCrew"];
    private _posATL = getPosATL _oldVehicle;
    private _dir = getDir _oldVehicle;
    deleteVehicleCrew _oldVehicle;
    deleteVehicle _oldVehicle;
    uiSleep 1.0;
    private _newVic = createVehicle [_newType, _posATL];
    if (_createCrew) then {
        createVehicleCrew _newVic;
    };
    _newVic setDir _dir;
};
