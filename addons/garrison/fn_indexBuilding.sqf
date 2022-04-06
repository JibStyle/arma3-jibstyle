// Calculate direction weights for positions in building.
//
// Returns array with [PositionASL, [Direction, Weight, ...]] entry
// for each position in the building. This can be used with
// selectRandomWeighted to lookup a direction to face a unit at each
// position in the building.
//
// Direction weights are calculated based on:
//
// 1. How far unit can see.
// 2. How much direction points outwards from building origin.
params [
    "_building" // Building
];

// Eye height for visibility distance tests.
//
// A bit lower than actual eye height for two reasons:
// 1. Muzzle height when in firing stance.
// 2. Some middle east buildings have positions above ground such that
//    full eye height would miss window.
private _eyeHeight = 1.4;

// Distances to test for visibility.
private _distances = [1, 2, 4, 8, 16, 32];

// Weight for how far unit at position can see in direction.
private _distanceWeight = .5;

// Weight for direction pointing away from building origin.
private _directionWeight = .5;

private _positions = _building buildingPos -1 apply {AGLToASL _x};
private _result = [];
for "_i" from 0 to count _positions - 1 do {
    private _pos = _positions # _i;
    private _eyes = _pos vectorAdd [0, 0, _eyeHeight];
    private _directionsWeights = [];
    for "_dir" from 0 to 359 step 15 do {
        _directionsWeights pushBack _dir;
        _directionsWeights pushBack 1;
        for "_j" from 0 to count _distances - 1 do {
            private _dist = _distances # _j;
            if (
                lineIntersects [
                    _eyes,
                    _eyes vectorAdd (
                        [
                            [0, _dist, 0],
                            _dir,
                            2
                        ] call BIS_fnc_rotateVector3D
                    )
                ]
            ) then {
                continue;
            } else {
                _directionsWeights set [
                    count _directionsWeights - 1,
                    _distanceWeight * (
                        _dist / selectMax _distances
                    ) + _directionWeight * (
                        0.5 + 0.5 * cos (
                            (getPosASL _building getDir _pos) - _dir
                        )
                    )
                ];
            };
        };
    };
    _result pushBack [_pos, _directionsWeights];
};
_result;
