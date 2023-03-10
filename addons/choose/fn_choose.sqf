// Init a game logic to choose a number of buckets.
jib_choose_number = {
    params [
        "_logic",          // Logic synced to triggers
        "_number",         // Number of buckets to choose
        ["_level", 0, [0]] // Higher levels pruned from search
    ];
    if (!isServer) exitWith {};
    _logic setVariable ["jib_choose__level", _level];
    [_logic, _number, _level] spawn {
        params ["_logic", "_number", "_level"];
        [
            [_logic] call jib_choose__buckets, _number, -1
        ] call jib_choose__filter;
    };
};

// Init a game logic to choose buckets by probability.
jib_choose_probability = {
    params [
        "_logic",          // Logic synced to triggers
        "_probability",    // Probability to choose each bucket
        ["_level", 0, [0]] // Higher levels pruned from search
    ];
    if (!isServer) exitWith {};
    _logic setVariable ["jib_choose__level", _level];
    [_logic, _probability, _level] spawn {
        params ["_logic", "_probability", "_level"];
        [
            [_logic] call jib_choose__buckets, -1, _probability
        ] call jib_choose__filter;
    };
};

jib_choose__buckets = {
    params ["_logic"];
    private _level = _logic getVariable ["jib_choose__level", -1];
    synchronizedObjects _logic select {
        if (_x isKindOf "Logic") then {
            _x getVariable ["jib_choose__level", -1] < _level;
        } else {true};
    } apply {
        switch true do
        {
            case (_x isKindOf "EmptyDetector"): {
                [[getPosATL _x] + triggerArea _x] call jib_choose__area;
            };
            case (_x isKindOf "Logic"): {
                flatten ([_x] call jib_choose__buckets);
            };
            default {
                [_x];
            };
        };
    };
};

jib_choose__area = {
    params ["_area"]; // [[x, y, z], a, b, rot, square, h]
    _area params ["_positionAGL", "_a", "_b"];

    // Subset we don't want (eg houses, trees)
    private _terrainObjects = nearestTerrainObjects [
        _positionAGL,
        [],
        (_a max _b) * 1.42,
        false
    ] inAreaArray _area;

    // Superset of what we want (eg units, sandbags, houses, trees)
    private _objects = (
        _positionAGL nearObjects (_a max _b) * 1.42
    ) inAreaArray _area;

    _objects select { _x in _terrainObjects == false };
};

jib_choose__filter = {
    params [
        "_buckets",    // Array of arrays of objects
        "_number",     // Number of buckets to choose, or -1
        "_probability" // Probability to choose each bucket, or -1
    ];
    if (!isServer) then {throw "Not server!"};

    // Results
    private _yes = [];
    private _no = [];

    // For number based choosing
    private _slots = _number;
    private _pending = count _buckets;

    // Classify buckets
    _buckets apply {
        // Determine this probability
        private _p = 0;
        if (_probability > -1) then {
            // Choose by probability
            _p = _probability;
        } else {
            // Choose by number
            _p = _slots / _pending;
        };

        // Perform random test
        if (random 1.0 < _p) then {
            _yes pushBack _x;
            _slots = _slots - 1;
        } else {
            _no pushBack _x;
        };
        _pending = _pending - 1;
    };

    // Delete failed objects
    _no apply {
        private _bucketObjects = _x;
        _bucketObjects apply {
            private _object = _x;
            private _group = group _object;
            if (
                (_object call BIS_fnc_objectType) # 0 == "Logic"
                    || isNull _group
            ) then {
                // Delete individual unit
                deleteVehicle _object;
            } else {
                // Delete whole group
                private _vehicles = [];
                units _group apply {
                    _vehicles pushBackUnique vehicle _x;
                };
                _vehicles apply {
                    deleteVehicleCrew _x;
                    deleteVehicle _x;
                };
                deleteGroup _group;
            };
        };
    };
};

// Deprecated
jib_random_logicChooseNumber = jib_choose_number;
jib_random_logicChooseProbability = jib_choose_probability;
