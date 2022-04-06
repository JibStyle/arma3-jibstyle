// Garrison area
params [
    "_trigger",               // Delimits area
    "_blacklist",             // Exclude building classes
    "_specialUnits",          // Move to special positions
    "_probability",           // Normal position probability, -1 to ignore
    "_numNormal",             // If no probabiliy, approx normals
    "_normalClassesWeighted", // Spawn with selectRandomWeighted
    "_normalSide",            // Side of normal groups
    "_normalDisableTarget",   // Probabiliy to disable TARGET
    "_grouping"               // "ONE", "BUILDING", or "MANY"
];

// Get positions
private _buildings = _trigger nearObjects [
    "House",
    triggerArea _trigger # 0 + triggerArea _trigger # 1
] inAreaArray _trigger select {
    private _building = _x;
    private _include = _blacklist findIf {
        private _classname = _x;
        _building isKindOf _classname;
    } < 0;
    [
        "JIB garrison - In trigger: %1, found building: %2, whitelisted: %3",
        _trigger,
        _building,
        _include
    ] call BIS_fnc_logFormat;
    _include;
} apply {
    private _building = _x;
    [_x] call jib_garrison_fnc_indexBuilding apply {
        private _position = _x;
        [_position # 0, _position # 1, false];
    };
}; // [[[PositionASL, [Direction, Weight, ...], Occupied]]]

// Choose positions
[
    _buildings,
    count _specialUnits,
    _probability,
    _numNormal
] call jib_garrison_fnc_chooseSlots params [
    "_specials",
    "_normals"
];

// Move special units
if (count _specials != count _specialUnits) exitWith {
    ["JIB garrison: Specials wrong size!"] call BIS_fnc_logFormat;
};
for "_i" from 0 to count _specialUnits - 1 do {
    _specials # _i params ["_positionASL", "_direction"];
    _specialUnits # _i setFormDir _direction;
    _specialUnits # _i setDir _direction;
    _specialUnits # _i setPosASL _positionASL;
};

// Spawn normal units
private _superGroup = grpNull;
if (_grouping == "ONE") then {
    _superGroup = createGroup [_normalSide, true];
    _superGroup setCombatMode "RED";
};
for "_indexBuilding" from 0 to count _normals - 1 do {
    private _building = _normals # _indexBuilding;
    private _group = grpNull;
    if (_grouping == "ONE") then {
        _group = _superGroup;
    } else {
        if (_grouping == "BUILDING") then {
            _group = createGroup [_normalSide, true];
            _group setCombatMode "RED";
        };
    };
    for "_indexPosition" from 0 to count _building - 1 do {
        _building # _indexPosition params [
            "_positionASL",
            "_direction"
        ];
        private _classname =
            selectRandomWeighted _normalClassesWeighted;
        if (_grouping == "MANY") then {
            _group = createGroup [_normalSide, true];
            _group setCombatMode "RED";
        };
        private _unit = _group createUnit [
            _classname,
            _positionASL,
            [],
            0,
            "NONE"
        ];
        _unit setFormDir _direction;
        _unit setDir _direction;
        _unit setPosASL _positionASL;
        doStop _unit;
        if (random 1 < _normalDisableTarget) then {
            _unit disableAI "TARGET";
        };
    };
    if (_grouping == "BUILDING") then {
        _group selectLeader selectRandom units _group;
    };
};
if (_grouping == "ONE") then {
    _superGroup selectLeader selectRandom units _superGroup;
};
