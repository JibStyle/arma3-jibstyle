// Dependencies
jib_traffic_serialize_batch;
jib_traffic_deserialize_batch;

// Config
jib_traffic_debug = true;
jib_traffic_sleep_delay = 0.1;
jib_traffic_outside_roads_count = 10;
jib_traffic_outside_roads_margin = 100;

// Default param values
jib_traffic_default_radius = 100;

jib_traffic_radius_read = {
    params [
        "_pos",
        ["_radius", jib_traffic_default_radius, [0]]
    ];
    private _vehicles = _pos nearObjects _radius select {
        driver _x != _x && driver _x in allUnits
    };
    private _data = _vehicles apply {
        [[_x], [group _x]] call jib_traffic_serialize_batch;
    };
    _data;
};

jib_traffic_radius_write = {
    params [
        "_pos",
        "_data",
        ["_radius", jib_traffic_default_radius, [0]],
        ["_timeout", [0, 0, 0], [[]]]
    ];
    [_pos, _radius] call jib_traffic__pos_outside_radius params [
        "_start", "_dir"
    ];
    [
        selectRandom _data,
        _start
    ] call jib_cereal_deserialize_batch params ["_vehicles", "_groups"];
    _vehicles apply {_x setDir _dir};
    _groups apply {
        private _mid = [_pos, _radius] call jib_traffic__pos_inside_radius;
        private _wp_mid = _x addWaypoint [_mid, 0];
        _wp_mid setWaypointTimeout _timeout;
        [_pos, _radius] call jib_traffic__pos_outside_radius params [
            "_end"
        ];
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
};

jib_traffic__pos_outside_radius = {
    params [
        "_pos",
        "_radius"
    ];
    private _road = selectRandom (
        _pos nearRoads 1e9 select {
            _x distance _pos < _radius + jib_traffic_outside_roads_margin
                && _x distance _pos > _radius
        } select {
            getRoadInfo _x params [
                "_mapType", "_width", "_isPedestrian", "_texture",
                "_textureEnd", "_material", "_begPos", "_endPos", "_isBridge",
                "_aiPathOffset"
            ];
            not _isPedestrian;
        }
    );
    getRoadInfo _road params [
        "_mapType", "_width", "_isPedestrian", "_texture",
        "_textureEnd", "_material", "_begPos", "_endPos", "_isBridge",
        "_aiPathOffset"
    ];
    [getPos _road, _begPos getDir _endPos];
};

jib_traffic__pos_inside_radius = {
    params [
        "_pos",
        "_radius"
    ];
    private _roads = _pos nearRoads _radius select {
        getRoadInfo _x params [
            "_mapType", "_width", "_isPedestrian", "_texture",
            "_textureEnd", "_material", "_begPos", "_endPos", "_isBridge",
            "_aiPathOffset"
        ];
        not _isPedestrian;
    };
    if (count _roads == 0) exitWith {throw "No inside roads."};
    getPos selectRandom _roads;
};

jib_traffic__log = {
    params ["_message"];
    diag_log format ["jib_traffic: %1", _message];
    if (jib_traffic_debug) then {
        systemChat format ["jib_traffic: %1", _message];
    };
};
