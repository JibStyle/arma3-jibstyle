jib_garbage__period = 5;
jib_garbage__sentinel = 1e+010;
jib_garbage__handle = scriptNull;
jib_garbage__vehicle_limit = 5;
jib_garbage__ground_limit = 5;
jib_garbage__ttl_min = 10;
jib_garbage__ttl_max = 20;
jib_garbage__distance = 50;

// Start garbage collector
jib_garbage_start = {
    if (!isServer) exitWith {};
    if (!isNull jib_garbage_handle) exitWith {};

    jib_garbage__handle = [] spawn {
        while {true} do {
            [] call jib_garbage__cycle apply {
                deleteVehicleCrew _x;
                deleteVehicle _x;
            };
            uiSleep jib_garbage__period;
        };
    };
};

// Stop garbage collector
jib_garbage_stop = {
    terminate jib_garbage__handle;
};

jib_garbage__cycle = {
    private _toDelete = [];
    private _vehicles = [];
    [] call jib_garbage__allVehicles apply {
        if ([_x] call jib_garbage__isCollectableVehicle) then {
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
                    _vehicles pushBack _x;
                };
                default {};
            };
        } else {
            _x setVariable [
                "jib_garbage__start", jib_garbage__sentinel
            ];
        };
    };
    private _vehiclesSorted = [
        _vehicles, [], {
            _x getVariable [
                "jib_garbage__start", jib_garbage__sentinel
            ]
        }
    ] call BIS_fnc_sortBy;
    _vehiclesSorted select [
        0, count _vehiclesSorted - jib_garbage__vehicle_limit
    ] apply {
        _toDelete pushBack _x;
    };
    _toDelete;
};

jib_garbage__allVehicles = {
    vehicles select {
        _x call BIS_fnc_objectType select 0 == "Vehicle"
    };
};

jib_garbage__isCollectableVehicle = {
    params ["_vehicle"];
    _vehicle getVariable ["jib_garbage__include", true] // TODO false
        && {{alive _x} count crew _vehicle == 0}
        && {
            [_vehicle] call jib_garbage__playerDistance
                > jib_garbage__distance
        };
};

jib_garbage__getGarbage = {
    private _vehicles = vehicles select {
        {alive _x} count crew _x == 0
    };
    private _groundHolders =
        allMissionObjects "GroundWeaponHolder";
    private _simulatedHolders =
        allMissionObjects "WeaponHolderSimulated";
    [_vehicles, _groundHolders, _simulatedHolders];
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
