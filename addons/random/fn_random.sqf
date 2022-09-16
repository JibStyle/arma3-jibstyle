// Random functions
if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_random_moduleValidate = {};

// Set seed used by other functions.
jib_random_seed = random 1000;

// Classification based on identity token and num classes.
//
// Multiple calls with same args, during same mission, give same
// result.
//
// Params:
// - token: Number, should be same for calls to be consistent.
// - numClasses: Integer, how many possible cases to choose from.
// Returns: Integer in range [0, numClasses).
jib_random_classify = {
    params [
        ["_token", 0, [0]],
        ["_numClasses", 1, [0]]
    ];
    floor ((jib_random_seed + _token) random _numClasses);
};

// Continuous random calculation based on identity token.
//
// Multiple calls with same args, during same mission, give same
// result.
//
// Params:
// - token: Number, should be same for calls to be consistent.
// Returns: Number in range [0, 1).
jib_random_continuous = {
    params [
        ["_token", 0, [0]]
    ];
    (jib_random_seed + _token) random 1;
};

// Choose buckets of objects to keep and delete the rest.
jib_random_chooseBuckets = {
    params ["_buckets", "_number", "_probability"];

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
            if (isNull _group) then {
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
            };
        };
    };
};

// PRIVATE

jib_random_moduleBucketObjects = "jib_random_moduleBucketObjects";

// Process system of choose module combined with bucket modules
jib_random_moduleSystem = {
    params ["_logic", "_synchronized"];

    // Get variables
    private _number = _logic getVariable [
        "jib_random_moduleNumber",
        -1
    ];
    private _probability = _logic getVariable [
        "jib_random_moduleProbability",
        -1
    ];

    // Get bucket modules
    private _logics = _synchronized select {
        _x isKindOf "jib_random_moduleBucket"
    };
    if (count _logics == 0) then {throw "No buckets synced!"};

    // Wait for bucket variables
    [_logics, _number, _probability] spawn {
        params ["_logics", "_number", "_probability"];
        waitUntil {
            {
                isNil {_x getVariable jib_random_moduleBucketObjects}
            } count _logics == 0
        };

        // Get bucket objects
        private _buckets = _logics apply {
            _x getVariable jib_random_moduleBucketObjects;
        };

        _logics apply {deleteVehicle _x};

        // Choose objects to keep
        [
            _buckets,
            _number,
            _probability
        ] remoteExec ["jib_random_chooseBuckets", 2];
    };

};

jib_random_moduleChooseNumber = {
    [
        _this,
        {
            params ["", "", "", "_logic", "_synchronized", "_inArea"];
            [_logic, _synchronized] call jib_random_moduleSystem;
        },
        [],
        "local"
    ] call jib_random_moduleValidate;
};

jib_random_moduleChooseProbability = {
    [
        _this,
        {
            params ["", "", "", "_logic", "_synchronized", "_inArea"];
            [_logic, _synchronized] call jib_random_moduleSystem;
        },
        [],
        "local"
    ] call jib_random_moduleValidate;
};

jib_random_moduleBucket = {
    [
        _this,
        {
            params ["", "", "", "_logic", "_synchronized", "_inArea"];
            _logic setVariable [
                jib_random_moduleBucketObjects,
                _synchronized,
                true
            ];
        },
        [],
        "local",
        false
    ] call jib_random_moduleValidate;
};

jib_random_moduleBucketArea = {
    [
        _this,
        {
            params ["", "", "", "_logic", "_synchronized", "_inArea"];
            _logic setVariable [
                jib_random_moduleBucketObjects,
                _synchronized + _inArea,
                true
            ];
        },
        [],
        "local",
        false
    ] call jib_random_moduleValidate;
};

publicVariable "jib_random_moduleValidate";
publicVariable "jib_random_moduleBucketObjects";
publicVariable "jib_random_moduleSystem";
publicVariable "jib_random_moduleChooseNumber";
publicVariable "jib_random_moduleChooseProbability";
publicVariable "jib_random_moduleBucket";
publicVariable "jib_random_moduleBucketArea";
