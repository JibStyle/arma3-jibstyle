// Dependencies
jib_traffic_serialize_batch;
jib_traffic_deserialize_batch;

// Config
jib_traffic_debug = true;
jib_traffic_sleep_delay = 0.1;
jib_traffic_outside_roads_count = 10;
jib_traffic_outside_roads_margin = 200;

// Default param values
jib_traffic_default_radius = 100;
jib_traffic_default_area = [1000, 1000, 0, false, -1];
jib_traffic_default_n = 10;
jib_traffic_default_interval = 10;

jib_traffic_read = {
    params [
        "_pos",
        ["_area", jib_traffic_default_area, [[]]]
    ];
    _area params ["_a", "_b", "_angle", "_isRect", "_c"];
    private _vehicles = _pos nearObjects (_a max _b) * 1.42 select {
        _x inArea [_pos] + _area;
    } select {
        driver _x != _x && driver _x in allUnits;
    };
    private _groups = _vehicles apply {group _x};
    _groups = _groups arrayIntersect _groups;
    private _data = _groups apply {
        [assignedVehicles _x, [_x]] call jib_traffic_serialize_batch;
    };
    _groups apply {
        private _vehicles = [];
        units _x apply {
            _vehicles pushBackUnique vehicle _x;
        };
        _vehicles apply {
            deleteVehicleCrew _x;
            deleteVehicle _x;
        };
        deleteGroup _x;
    };
    _data;
};

jib_traffic_write = {
    params [
        "_pos",
        "_data",
        ["_area", jib_traffic_default_area, [[]]],
        ["_timeout", [0, 0, 0], [[]]]
    ];
    _area params ["_a", "_b", "_angle", "_isRect", "_c"];
    if (!canSuspend) then {throw "Cannot suspend!"};
    [_pos, _area, false] call jib_traffic__pos_area params ["_start", "_dir"];
    [
        selectRandom _data, _start
    ] call jib_cereal_deserialize_batch params ["_vehicles", "_groups"];
    _vehicles apply {_x setDir _dir};
    _groups apply {
        [_pos, _area, true] call jib_traffic__pos_area params ["_mid"];
        private _wp_mid = _x addWaypoint [_mid, 0];
        _wp_mid setWaypointTimeout _timeout;
        [_pos, _area, false] call jib_traffic__pos_area params ["_end"];
        private _wp_end = _x addWaypoint [_end, 0];
        _wp_end setWaypointStatements [
            "true", toString {
                private _leader = this;
                private _vehicles = [];
                private _group = group _leader;
                units _group apply {
                    _vehicles pushBackUnique vehicle _x;
                };
                _vehicles apply {
                    deleteVehicleCrew _x;
                    deleteVehicle _x;
                };
                deleteGroup _group;
            }
        ];
    };
    _vehicles;
};

jib_traffic_start = {
    params [
        "_pos",
        "_data",
        ["_area", jib_traffic_default_area, [[]]],
        ["_timeout", [0, 0, 0], [[]]],
        ["_n", jib_traffic_default_n, [0]],
        ["_interval", jib_traffic_default_interval, [0]]
    ];
    _area params ["_a", "_b", "_angle", "_isRect", "_c"];
    private _counter = -1;
    isNil {
        _counter = jib_traffic__token_count;
        jib_traffic__token_count = jib_traffic__token_count + 1;
    };
    private _script = [
        _counter, _pos, _data, _area, _timeout, _n, _interval
    ] spawn {
        params [
            "_counter", "_pos", "_data", "_area", "_timeout", "_n", "_interval"
        ];
        private _variable = format ["jib_traffic__vehicles_%1", _counter];
        missionNamespace setVariable [_variable, []];
        while {
            not isNil {missionNamespace getVariable _variable};
        } do {
            waitUntil {
                uiSleep random [0, _interval, _interval * 2];
                {alive _x && alive driver _x} count (
                    missionNamespace getVariable [_variable, []]
                ) < _n;
            };
            private _vehicles =
                [_pos, _data, _area, _timeout] call jib_traffic_write;
            isNil {
                private _old = missionNamespace getVariable _variable;
                if (not isNil {_old}) then {
                    missionNamespace setVariable [_variable, _old + _vehicles];
                };
            };
        };
    };
    [_script, _counter];
};

jib_traffic_stop = {
    params ["_token"];
    _token params ["_script", "_counter"];
    private _variable = format ["jib_traffic__vehicles_%1", _counter];
    missionNamespace setVariable [_variable, nil];
};

jib_traffic__pos_area = {
    params [
        "_pos",
        "_area",
        "_inside"
    ];
    _area params ["_a", "_b", "_angle", "_isRect", "_c"];
    private _roads = [];
    if (_inside) then {
        _roads = _pos nearRoads (_a max _b) * 1.42 inAreaArray [_pos] + _area;
    } else {
        private _margin = jib_traffic_outside_roads_margin;
        _roads = _pos nearRoads 1e9 select {
            _x inArea [_pos, _a + _margin, _b + _margin, _angle, _isRect, _c];
        } select {
            not (_x inArea [_pos] + _area);
        };
    };
    _roads = _roads select {
        getRoadInfo _x params [
            "_mapType", "_width", "_isPedestrian", "_texture",
            "_textureEnd", "_material", "_begPos", "_endPos", "_isBridge",
            "_aiPathOffset"
        ];
        not _isPedestrian;
    };
    private _road = selectRandom _roads;
    getRoadInfo _road params [
        "_mapType", "_width", "_isPedestrian", "_texture",
        "_textureEnd", "_material", "_begPos", "_endPos", "_isBridge",
        "_aiPathOffset"
    ];
    [getPos _road, _begPos getDir _endPos];
};

jib_traffic__pos_outside_radius = {
    params [
        "_pos",
        "_radius"
    ];
    [_pos, [_radius, _radius, 0, false, -1], false] call jib_traffic__pos_area;
};

jib_traffic__pos_inside_radius = {
    params [
        "_pos",
        "_radius"
    ];
    [_pos, [_radius, _radius, 0, false, -1], true] call jib_traffic__pos_area;
};

jib_traffic__log = {
    params ["_message"];
    diag_log format ["jib_traffic: %1", _message];
    if (jib_traffic_debug) then {
        systemChat format ["jib_traffic: %1", _message];
    };
};

jib_traffic__token_count = 0;
