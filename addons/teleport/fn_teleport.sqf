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

// Common inner code passed to module validator
jib_teleport_inner = {
    params ["_posATL", "_attached", "_args"];
    _args params ["_units"];
    [_units, _posATL] call jib_teleport_teleport;
};

jib_teleport_moduleFrom = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            jib_teleport_moduleSelectedEntity = _attached;
        },
        [],
        "local"
    ] call jib_teleport_moduleValidate;
};

jib_teleport_moduleTo = {
    [
        _this,
        jib_teleport_inner,
        [[jib_teleport_moduleSelectedEntity]]
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
        _units
    ] call jib_teleport_moduleValidate;
};

publicVariable "jib_teleport_moduleValidate";
publicVariable "jib_teleport_moduleFrom";
publicVariable "jib_teleport_moduleTo";
publicVariable "jib_teleport_moduleSelf";
publicVariable "jib_teleport_moduleAll";
