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
jib_traffic_default_n = 10;
jib_traffic_default_interval = 10;

jib_traffic_read = {
    params [
        "_area"
    ];
    _area params ["_pos", "_a", "_b", "_angle", "_isRect", "_c"];
    private _vehicles = _pos nearObjects (_a max _b) * 1.42 select {
        _x inArea _area;
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
        "_data",
        "_beg_whitelist",
        "_beg_blacklist",
        "_mid_whitelist",
        "_mid_blacklist",
        "_end_whitelist",
        "_end_blacklist",
        ["_timeout", [0, 0, 0], [[]]]
    ];
    if (!canSuspend) then {throw "Cannot suspend!"};
    [
        _beg_whitelist, _beg_blacklist
    ] call jib_traffic__pos_area params ["_beg", "_dir"];
    [
        selectRandom _data, _beg
    ] call jib_cereal_deserialize_batch params ["_vehicles", "_groups"];
    _vehicles apply {_x setDir _dir};
    _groups apply {
        [
            _mid_whitelist, _mid_blacklist
        ] call jib_traffic__pos_area params ["_mid"];
        private _wp_mid = _x addWaypoint [_mid, 0];
        _wp_mid setWaypointTimeout _timeout;
        [
            _end_whitelist, _end_blacklist
        ] call jib_traffic__pos_area params ["_end"];
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
        "_data",
        "_beg_whitelist",
        "_beg_blacklist",
        "_mid_whitelist",
        "_mid_blacklist",
        "_end_whitelist",
        "_end_blacklist",
        ["_timeout", [0, 0, 0], [[]]],
        ["_n", jib_traffic_default_n, [0]],
        ["_interval", jib_traffic_default_interval, [0]]
    ];
    private _counter = -1;
    isNil {
        _counter = jib_traffic__token_count;
        jib_traffic__token_count = jib_traffic__token_count + 1;
    };
    private _script = [
        _counter, _data,
        _beg_whitelist, _beg_blacklist,
        _mid_whitelist, _mid_blacklist,
        _end_whitelist, _end_blacklist,
        _timeout, _n, _interval
    ] spawn {
        params [
            "_counter", "_data",
            "_beg_whitelist", "_beg_blacklist",
            "_mid_whitelist", "_mid_blacklist",
            "_end_whitelist", "_end_blacklist",
            "_timeout", "_n", "_interval"
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
                [
                    _data,
                    _beg_whitelist, _beg_blacklist,
                    _mid_whitelist, _mid_blacklist,
                    _end_whitelist, _end_blacklist,
                    _timeout
                ] call jib_traffic_write;
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

jib_traffic_logic = {
    params [
        "_logic",
        ["_timeout", [0, 0, 0], [[]]],
        ["_n", jib_traffic_default_n, [0]],
        ["_interval", jib_traffic_default_interval, [0]]
    ];
    if (!isServer) exitWith {};
    private _data = [];
    [_logic, "jib_traffic_vehicles"] call jib_traffic__logic_areas apply {
        _data = _data + ([_x] call jib_traffic_read);
    };
    private _beg_whitelist =
        [_logic, "jib_traffic_beg_whitelist"] call jib_traffic__logic_areas;
    private _beg_blacklist =
        [_logic, "jib_traffic_beg_blacklist"] call jib_traffic__logic_areas;
    private _mid_whitelist =
        [_logic, "jib_traffic_mid_whitelist"] call jib_traffic__logic_areas;
    private _mid_blacklist =
        [_logic, "jib_traffic_mid_blacklist"] call jib_traffic__logic_areas;
    private _end_whitelist =
        [_logic, "jib_traffic_end_whitelist"] call jib_traffic__logic_areas;
    private _end_blacklist =
        [_logic, "jib_traffic_end_blacklist"] call jib_traffic__logic_areas;
    private _token = [
        _data,
        _beg_whitelist, _beg_blacklist,
        _mid_whitelist, _mid_blacklist,
        _end_whitelist, _end_blacklist,
        _timeout, _n, _interval
    ] spawn jib_traffic_start;
    _logic setVariable ["jib_traffic__token", _token];
};

jib_traffic__logic_areas = {
    params [
        "_logic",
        "_variable"
    ];
    private _areas = [];
    synchronizedObjects _logic select {_x isKindOf "Logic";} select {
        _x getVariable [_variable, false];
    } apply {
        synchronizedObjects _x select {_x isKindOf "EmptyDetector";} apply {
            _areas pushBack [getPos _x] + triggerArea _x;
        };
    };
    _areas;
};

jib_traffic__pos_area = {
    params [
        "_whitelist",
        "_blacklist"
    ];
    private _roads = [];
    _whitelist apply {
        _x params ["_pos", "_a", "_b", "_angle", "_isRect", "_c"];
        _pos nearRoads (_a max _b) * 1.42 inAreaArray _x apply {
            private _road = _x;
            _blacklist apply {
                if (_road inArea _x) then {
                    _road = objNull;
                };
            };
            if (not isNull _road) then {
                _roads pushBackUnique _road;
            };
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

jib_traffic__log = {
    params ["_message"];
    diag_log format ["jib_traffic: %1", _message];
    if (jib_traffic_debug) then {
        systemChat format ["jib_traffic: %1", _message];
    };
};

jib_traffic__token_count = 0;
