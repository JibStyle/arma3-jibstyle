if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_teleport_moduleValidate = {};

// Teleport units
jib_teleport_teleport = {
    params ["_units", "_posATL"];
    private _minRadius = 0;
    private _maxRadius = 50;
    if (not isServer) then {throw "Not server!"};
    {
        private _maxDistance = _maxRadius - _minRadius;
        private _emptyPosATL = _posATL findEmptyPosition [
            _minRadius, _maxDistance, typeOf _x
        ];
        if (count _emptyPosATL == 3) then {
            _x setPosATL _emptyPosATL;
        } else {
            _x setPosATL _posATL;
        };
    } forEach _units;
};

// Load cargo or units into vehicle
jib_teleport_vehicleLoad = {
    params ["_transport", "_cargo", ["_units", []]];
    if (not isServer) then {throw "Not server!"};
    if (isNull _transport) then {throw "No transport selected!"};
    if (not isNull _cargo) then {
        if (_transport setVehicleCargo _cargo == false) then {
            throw "Cargo did not fit!";
        };
    };
    if (count _units > 0) then {
        _units apply {
            _x moveInAny _transport;
        };
    };
};

// Unload vehicle in vehicle cargo
jib_teleport_vehicleUnloadCargo = {
    params ["_cargo"];
    if (not isServer) then {throw "Not server!"};
    objNull setVehicleCargo _cargo;
};

// Unload vehicle in vehicle transport
jib_teleport_vehicleUnloadTransport = {
    params ["_transport"];
    if (not isServer) then {throw "Not server!"};
    _transport setVehicleCargo objNull;
};

// PRIVATE

// Common inner code passed to module validator
jib_teleport_inner = {
    params ["_posATL", "_attached", "_args"];
    _args params ["_units"];
    [_units, _posATL] call jib_teleport_teleport;
};

jib_teleport_moduleSelectedTeleportFrom = objNull;

jib_teleport_moduleSelectedVehicleLoadTransport = objNull;

jib_teleport_moduleFrom = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            jib_teleport_moduleSelectedTeleportFrom = _attached;
        },
        [],
        "local"
    ] call jib_teleport_moduleValidate;
};

jib_teleport_moduleTo = {
    [
        _this,
        jib_teleport_inner,
        [[jib_teleport_moduleSelectedTeleportFrom]]
    ] call jib_teleport_moduleValidate;
};

jib_teleport_moduleSelf = {
    [
        _this,
        jib_teleport_inner,
        [[vehicle player]]
    ] call jib_teleport_moduleValidate;
};

jib_teleport_moduleAll = {
    // Gather units
    private _units = [];
    allPlayers apply {_units pushBackUnique vehicle _x;};
    [
        _this,
        jib_teleport_inner,
        [_units]
    ] call jib_teleport_moduleValidate;
};

jib_teleport_moduleVehicleLoadTransport = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            jib_teleport_moduleSelectedVehicleLoadTransport =
                _attached;
        },
        [],
        "local"
    ] call jib_teleport_moduleValidate;
};

jib_teleport_moduleVehicleLoadCargo = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_transport"];
            [_transport, _attached] call jib_teleport_vehicleLoad;
        },
        [jib_teleport_moduleSelectedVehicleLoadTransport]
    ] call jib_teleport_moduleValidate;
};

jib_teleport_moduleVehicleLoadGroup = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_transport"];
            [
                _transport,
                objNull,
                units group _attached
            ] call jib_teleport_vehicleLoad;
        },
        [jib_teleport_moduleSelectedVehicleLoadTransport]
    ] call jib_teleport_moduleValidate;
};

jib_teleport_moduleVehicleUnloadCargo = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached] call jib_teleport_vehicleUnloadCargo;
        }
    ] call jib_teleport_moduleValidate;
};

jib_teleport_moduleVehicleUnloadTransport = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached] call jib_teleport_vehicleUnloadTransport;
        }
    ] call jib_teleport_moduleValidate;
};

publicVariable "jib_teleport_moduleValidate";
publicVariable "jib_teleport_moduleSelectedTeleportFrom";
publicVariable "jib_teleport_moduleSelectedVehicleLoadTransport";
publicVariable "jib_teleport_moduleFrom";
publicVariable "jib_teleport_moduleTo";
publicVariable "jib_teleport_moduleSelf";
publicVariable "jib_teleport_moduleAll";
publicVariable "jib_teleport_moduleVehicleLoadTransport";
publicVariable "jib_teleport_moduleVehicleLoadCargo";
publicVariable "jib_teleport_moduleVehicleLoadGroup";
publicVariable "jib_teleport_moduleVehicleUnloadCargo";
publicVariable "jib_teleport_moduleVehicleUnloadTransport";
publicVariable "jib_teleport_inner";
