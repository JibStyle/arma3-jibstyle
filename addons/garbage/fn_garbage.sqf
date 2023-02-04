jib_garbage_soldier_limit = 10;
jib_garbage_soldier_distance = 50;
jib_garbage_soldier_ttl_min = 120;
jib_garbage_soldier_ttl_max = 1200;
jib_garbage_vehicle_limit = 5;
jib_garbage_vehicle_distance = 50;
jib_garbage_vehicle_ttl_min = 120;
jib_garbage_vehicle_ttl_max = 1200;
jib_garbage_ground_limit = 0;
jib_garbage_ground_distance = 50;
jib_garbage_ground_ttl_min = 120;
jib_garbage_ground_ttl_max = 1200;
jib_garbage_simulated_limit = 10;
jib_garbage_simulated_distance = 50;
jib_garbage_simulated_ttl_min = 120;
jib_garbage_simulated_ttl_max = 1200;
jib_garbage_debug = false;

jib_garbage__period = 10;
jib_garbage__sentinel = 1e+010;

// Start garbage collector
jib_garbage_start = {
    if (!isServer) exitWith {};
    [] call jib_garbage_stop;

    jib_garbage__handle = [] spawn {
        while {true} do {
            private _collectors = [
                [
                    "soldiers",
                    jib_garbage_soldier_limit,
                    jib_garbage_soldier_distance,
                    jib_garbage_soldier_ttl_min,
                    jib_garbage_soldier_ttl_max,
                    jib_garbage__soldier_all,
                    jib_garbage__soldier_collectible,
                    jib_garbage__soldier_dispose
                ],
                [
                    "vehicles",
                    jib_garbage_vehicle_limit,
                    jib_garbage_vehicle_distance,
                    jib_garbage_vehicle_ttl_min,
                    jib_garbage_vehicle_ttl_max,
                    jib_garbage__vehicle_all,
                    jib_garbage__vehicle_collectible,
                    jib_garbage__vehicle_dispose
                ],
                [
                    "ground holders",
                    jib_garbage_ground_limit,
                    jib_garbage_ground_distance,
                    jib_garbage_ground_ttl_min,
                    jib_garbage_ground_ttl_max,
                    jib_garbage__ground_all,
                    jib_garbage__ground_collectible,
                    jib_garbage__ground_dispose
                ],
                [
                    "simulated holders",
                    jib_garbage_simulated_limit,
                    jib_garbage_simulated_distance,
                    jib_garbage_simulated_ttl_min,
                    jib_garbage_simulated_ttl_max,
                    jib_garbage__simulated_all,
                    jib_garbage__simulated_collectible,
                    jib_garbage__simulated_dispose
                ]
            ];
            _collectors apply {
                _x params [
                    "_name", "_limit", "_distance", "_ttl_min", "_ttl_max",
                    "_all_fn", "_collectible", "_dispose"
                ];
                if (jib_garbage_debug) then {
                    private _all = [] call _all_fn;
                    private _collected = [
                        _all, _collectible, _limit,
                        _distance, _ttl_min, _ttl_max
                    ] call jib_garbage__collect;
                    systemChat format [
                        "jib_garbage collected: %1",
                        [_name, count _all, count _collected]
                    ];
                    _collected apply {[_x] call _dispose}
                } else {
                    [
                        [] call _all_fn, _collectible, _limit,
                        _distance, _ttl_min, _ttl_max
                    ] call jib_garbage__collect apply {[_x] call _dispose}
                };
                uiSleep jib_garbage__period / count _collectors;
            };
        };
    };
};

// Stop garbage collector
jib_garbage_stop = {
    terminate (
        missionNamespace getVariable ["jib_garbage__handle", scriptNull]
    );
};

// Include or exempt object from collection
jib_garbage_include = {
    params ["_object", "_include"];
    _object setVariable ["jib_garbage__include", _include];
};

jib_garbage__collect = {
    params [
        "_candidates", "_collectible", "_limit",
        "_distance", "_ttl_min", "_ttl_max"
    ];
    private _toDelete = [];
    private _collection = [];
    _candidates apply {
        if (
            [_x] call _collectible
                && {[_x] call jib_garbage__playerDistance > _distance}
        ) then {
            private _start = _x getVariable [
                "jib_garbage__start", jib_garbage__sentinel
            ];
            switch (true) do
            {
                case (_start == jib_garbage__sentinel): {
                    _x setVariable ["jib_garbage__start", time];
                };
                case (_start + _ttl_max < time): {
                    _toDelete pushBack _x;
                };
                case (_start + _ttl_min < time): {
                    _collection pushBack _x;
                };
                default {};
            };
        } else {
            _x setVariable ["jib_garbage__start", jib_garbage__sentinel];
        };
    };
    private _collectionSorted = [
        _collection, [], {
            _x getVariable ["jib_garbage__start", jib_garbage__sentinel]
        }
    ] call BIS_fnc_sortBy;
    _collectionSorted select [
        0, count _collectionSorted - _limit
    ] apply {
        _toDelete pushBack _x;
    };
    _toDelete;
};

jib_garbage__soldier_all = {
    allDeadMen;
};

jib_garbage__soldier_collectible = {
    params ["_soldier"];
    _soldier getVariable ["jib_garbage__include", true];
};

jib_garbage__soldier_dispose = {
    params ["_soldier"];
    deleteVehicle _soldier;
};

jib_garbage__vehicle_all = {
    vehicles select {_x isKindOf "WeaponHolderSimulated" == false};
};

jib_garbage__vehicle_collectible = {
    params ["_vehicle"];
    _vehicle getVariable ["jib_garbage__include", true]
        && {{alive _x} count crew _vehicle == 0};
};

jib_garbage__vehicle_dispose = {
    params ["_vehicle"];
    deleteVehicleCrew _vehicle;
    deleteVehicle _vehicle;
};

jib_garbage__ground_all = {
    8 allObjects 0 select {_x isKindOf "GroundWeaponHolder"};
};

jib_garbage__ground_collectible = {
    params ["_ground"];
    true;
};

jib_garbage__ground_dispose = {
    params ["_ground"];
    deleteVehicle _ground;
};

jib_garbage__simulated_all = {
    entities "WeaponHolderSimulated";
};

jib_garbage__simulated_collectible = {
    params ["_simulated"];
    true;
};

jib_garbage__simulated_dispose = {
    params ["_simulated"];
    deleteVehicle _simulated;
};

jib_garbage__playerDistance = {
    params ["_object"];
    private _nearestPlayer = objNull;
    allPlayers apply {
        if (
            _x distance _object < _nearestPlayer distance _object
        ) then {
            _nearestPlayer = _x;
        };
    };
    _nearestPlayer distance _object;
};
