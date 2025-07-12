jib_patrol_debug = true;
jib_patrol_precision_factor = 100;
jib_patrol_sources = 1000;
jib_patrol_salesman_iterations = 1000;

jib_patrol_start = {
    params [
        "_group",
        "_expression",
        "_n",
        "_p_cycle",
        "_whitelist",
        "_blacklist",
        ["_timeout", [0, 0, 0], [[]]]
    ];
    { deleteWaypoint _x } forEachReversed waypoints _group;
    private _positions = [
        getPos leader _group,
        [
            _expression,
            _n,
            _whitelist,
            _blacklist
        ] call jib_patrol__best_places
    ] call jib_patrol__salesman;
    _positions apply {
        private _wp = _group addWaypoint [_x, 0];
        _wp setWaypointTimeout _timeout;
    };
    private _wp = _group addWaypoint [getPos leader _group, 0];
    if (random 1 < _p_cycle) then {
        _wp setWaypointType "CYCLE";
    } else {
        _wp setWaypointType "SCRIPTED";
        _group setVariable [
            "jib_patrol__data",
            [
                _expression,
                _n,
                0,
                _whitelist,
                _blacklist,
                _timeout
            ]
        ];
        _wp setWaypointStatements ["true", toString {
            private _group = group this;
            if (!local _group) exitWith {};
            private _data = _group getVariable "jib_patrol__data";
            if (isNil {_data}) then {throw "Missing group data."};
            [_group] + _data spawn jib_patrol_start;
        }];
    };
};

jib_patrol__salesman = {
    params [
        "_start",
        "_positions"
    ];
    private _result = _positions;
    private _result_distance = 1e9;
    for "_i" from 0 to jib_patrol_salesman_iterations - 1 do {
        private _permutation = _positions apply {[random 1, _x]};
        _permutation sort true;
        _permutation = _permutation apply {_x # 1};
        private _last = _start;
        private _distance = 0;
        for "_j" from 0 to count _permutation - 1 do {
            _distance = _distance + (_last distance _permutation # _j);
            _last = _permutation # _j;
        };
        if (_distance < _result_distance) then {
            _result = _permutation;
            _result_distance = _distance;
        };
    };
    _result;
};

jib_patrol__best_places = {
    params [
        "_expression",
        "_n",
        "_whitelist",
        "_blacklist"
    ];
    private _results = [];
    _whitelist apply {
        _x params ["_pos", "_a", "_b", "_angle", "_isRect", "_c"];
        private _radius = (_a max _b) * 1.42;
        private _area = _x;
        selectBestPlaces [
            _pos,
            _radius,
            _expression,
            _radius / jib_patrol_precision_factor,
            jib_patrol_sources
        ] apply {
            _x params ["_pos", "_value"];
            if (
                _pos inArea _area && {
                    {_pos inArea _x} count _blacklist == 0
                }
            ) then {
                _results pushBack [_value, _pos];
            };
        };
    };
    _results sort false;
    [format ["Best place: %1", _results # 0]] call jib_patrol__log;
    _results select [0, _n] apply {
        _x params ["_value", "_pos"];
        _pos;
    };
};

jib_patrol__log = {
    params ["_message"];
    diag_log format ["jib_patrol: %1", _message];
    if (jib_patrol_debug) then {
        systemChat format ["jib_patrol: %1", _message];
    };
};
