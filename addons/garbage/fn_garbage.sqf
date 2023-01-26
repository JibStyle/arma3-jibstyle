jib_garbage__soldier_limit = 15;
jib_garbage__vehicle_limit = 5;
jib_garbage__ground_limit = 15;
jib_garbage__simulated_limit = 30;
jib_garbage__ttl_min = 120;
jib_garbage__ttl_max = 1800;
jib_garbage__distance = 50;

jib_garbage__period = 10;
jib_garbage__sentinel = 1e+010;
jib_garbage__handle = scriptNull;

// Start garbage collector
jib_garbage_start = {
    if (!isServer) exitWith {};
    if (!isNull jib_garbage__handle) exitWith {};

    jib_garbage__handle = [] spawn {
        while {true} do {
            private _collectors = [
                [
                    jib_garbage__soldier_all,
                    jib_garbage__soldier_collectible,
                    jib_garbage__soldier_limit,
                    jib_garbage__soldier_dispose
                ],
                [
                    jib_garbage__vehicle_all,
                    jib_garbage__vehicle_collectible,
                    jib_garbage__vehicle_limit,
                    jib_garbage__vehicle_dispose
                ],
                [
                    jib_garbage__ground_all,
                    jib_garbage__ground_collectible,
                    jib_garbage__ground_limit,
                    jib_garbage__ground_dispose
                ],
                [
                    jib_garbage__simulated_all,
                    jib_garbage__simulated_collectible,
                    jib_garbage__simulated_limit,
                    jib_garbage__simulated_dispose
                ]
            ];
            _collectors apply {
                _x params [
                    "_all", "_collectible", "_limit", "_dispose"
                ];
                [
                    [] call _all, _collectible, _limit
                ] call jib_garbage__collect apply {
                    [_x] call _dispose;
                };
                uiSleep jib_garbage__period / count _collectors;
            };
        };
    };
};

// Stop garbage collector
jib_garbage_stop = {
    terminate jib_garbage__handle;
};

jib_garbage__collect = {
    params ["_candidates", "_collectible", "_limit"];
    private _toDelete = [];
    private _collection = [];
    _candidates apply {
        if (
            [_x] call _collectible
                && {
                    [_x] call jib_garbage__playerDistance
                        > jib_garbage__distance
                }
        ) then {
            private _start = _x getVariable [
                "jib_garbage__start", jib_garbage__sentinel
            ];
            switch (true) do
            {
                case (_start == jib_garbage__sentinel): {
                    _x setVariable ["jib_garbage__start", time];
                };
                case (_start + jib_garbage__ttl_max < time): {
                    _toDelete pushBack _x;
                };
                case (_start + jib_garbage__ttl_min < time): {
                    _collection pushBack _x;
                };
                default {};
            };
        } else {
            _x setVariable [
                "jib_garbage__start", jib_garbage__sentinel
            ];
        };
    };
    private _collectionSorted = [
        _collection, [], {
            _x getVariable [
                "jib_garbage__start", jib_garbage__sentinel
            ]
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
    vehicles select {
        _x call BIS_fnc_objectType select 0 == "Vehicle"
    };
};

jib_garbage__vehicle_collectible = {
    params ["_vehicle"];
    _vehicle getVariable ["jib_garbage__include", true] // TODO false
        && {{alive _x} count crew _vehicle == 0};
};

jib_garbage__vehicle_dispose = {
    params ["_vehicle"];
    deleteVehicleCrew _vehicle;
    deleteVehicle _vehicle;
};

jib_garbage__ground_all = {
    allMissionObjects "GroundWeaponHolder";
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
    allMissionObjects "WeaponHolderSimulated";
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
