// Choose positions for specified number of units.
//
// NOTE: Mutates Occupied entries in _buildings argument!
params [
    "_buildings",   // [[[PositionASL, [Direction, Weight, ...], Occupied]]]
    "_numSpecial",  // Special positions
    "_probability", // Normal position probability, -1 to ignore
    "_numNormal"    // If no probabiliy, approx normals
];

// Preprocess slots for assignment
private _buildingWeights = []; // [IndexBuilding, Weight, ...]
private _buildingSlots = [];   // [[IndexSlot, ...]]
private _numSlots = 0;
for "_i" from 0 to count _buildings - 1 do {
    private _building = _buildings # _i;
    _buildingWeights append [_i, count _building];
    _buildingSlots pushBack [];
    for "_j" from 0 to count _building - 1 do {
        _buildingSlots # _i pushBack _j;
        _numSlots = _numSlots + 1;
    };
};
if (_numSlots < _numSpecial) exitWith {
    ["JIB garrison: Too many special positions!"] call BIS_fnc_logFormat;
};
_numSlots = _numSlots - _numSpecial;

// Assign special slots
private _specials = []; // [[PositionASL, Direction]]
for "_i" from 0 to _numSpecial - 1 do {
    private _indexBuilding = selectRandomWeighted _buildingWeights;
    private _indexWeight = _indexBuilding * 2 + 1;
    _buildingWeights set [
        _indexWeight,
        _buildingWeights # _indexWeight - 1
    ];
    private _slots = _buildingSlots # _indexBuilding;
    private _indexSlot = floor random count _slots;
    _slots deleteAt _indexSlot;
    private _position = _buildings # _indexBuilding # _indexSlot;
    _position set [2, true];
    _specials pushBack [
        _position # 0,
        selectRandomWeighted (_position # 1)
    ];
};

// Assign normal slots
if (_probability < 0) then {
    _probability = _numNormal / (_numSlots max 1) min 1;
};
private _normals = []; // [[[PositionASL, Direction]]]
for "_indexBuilding" from 0 to count _buildings - 1 do {
    private _building = _buildings # _indexBuilding;
    private _slots = _buildingSlots # _indexBuilding;
    if (count _slots == 0) then { continue; };
    private _didPushBack = false;
    for "_indexSlot" from 0 to count _slots - 1 do {
        if (random 1 >= _probability) then { continue; };
        private _position =
            _buildings # _indexBuilding # (_slots # _indexSlot);
        _position set [2, true];
        if (not _didPushBack) then {
            _normals pushBack [];
            _didPushBack = true;
        };
        _normals # (count _normals - 1) pushBack [
            _position # 0,
            selectRandomWeighted (_position # 1)
        ];
    };
};

// Return
[
    _specials, // [[PositionASL, Direction]]
    _normals   // [[[PositionASL, Direction]]]
];
