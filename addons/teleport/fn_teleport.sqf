// Teleport units
#define MIN_RADIUS 0
#define MAX_RADIUS 50
params ["_units", "_posATL"];
if (not isServer) then {throw "Not server!"};
{
    private _maxDistance = MAX_RADIUS - MIN_RADIUS;
    private _emptyPosATL = _posATL findEmptyPosition [
        MIN_RADIUS, _maxDistance, typeOf _x
    ];
    if (count _emptyPosATL == 3) then {
        _x setPosATL _emptyPosATL;
    } else {
        _x setPosATL _posATL;
    };
} forEach _units;
