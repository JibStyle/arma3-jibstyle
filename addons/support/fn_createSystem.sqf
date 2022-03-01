// Create support system modules.
//
// NOTE: Support modules may only be created once. Cannot add more
// later, so be sure to create enough in first pass.
params [
    ["_posAGL", [500, 500, 0], [[]]], // Where to create modules
    ["_radius", 0, [0]]               // Placement radius
];
if (not isServer) then {throw "Not server!"};

#define SYSTEM_RADIUS 50
#define NUM_HUBS 4
#define HUB_RADIUS 10
#define HUB_HEIGHT 10

private _systemPosAGL = _posAGL vectorAdd (
    [
        [0, random _radius, 0],
        random 360,
        2
    ] call BIS_fnc_rotateVector3D
);

if (isNil "jib_support_group") then {
    jib_support_group = createGroup sideLogic;
};
private _group = jib_support_group;

private _newLogics = [];
for "_i" from 0 to NUM_HUBS - 1 do {
    private _hubPosAGL = _systemPosAGL vectorAdd (
        [
            [0, SYSTEM_RADIUS, 0],
            _i * 360 / NUM_HUBS,
            2
        ] call BIS_fnc_rotateVector3D
    );
    private _requesterLogicPosAGL = _hubPosAGL vectorAdd [0, 0, HUB_HEIGHT];

    private _requesterLogic = _group createUnit [
        "SupportRequester", _requesterLogicPosAGL, [], 0, "NONE"
    ];
    _requesterLogic setVariable ["BIS_SUPP_custom_HQ", "", true];
    _requesterLogic setVariable ["BIS_SUPP_limit_Artillery", 1e11, true];
    _requesterLogic setVariable ["BIS_SUPP_limit_CAS_Bombing", 1e11, true];
    _requesterLogic setVariable ["BIS_SUPP_limit_CAS_Heli", 1e11, true];
    _requesterLogic setVariable ["BIS_SUPP_limit_Drop", 1e11, true];
    _requesterLogic setVariable ["BIS_SUPP_limit_Transport", 1e11, true];
    _requesterLogic setVariable ["BIS_SUPP_limit_UAV", 1e11, true];
    _requesterLogic setVariable [
        "BIS_fnc_initModules_disableAutoActivation", false, true
    ];
    _newLogics pushBack _requesterLogic;

    private _classesAndArguments =
        [["SupportProvider_Artillery", []],
         ["SupportProvider_Virtual_Artillery", [
             ["BIS_SUPP_vehicles", "[]"],
             ["BIS_SUPP_vehicleInit", ""],
             ["BIS_SUPP_filter", "Side"],
             ["BIS_SUPP_cooldown", 0]]],
         ["SupportProvider_CAS_Heli", []],
         ["SupportProvider_Virtual_CAS_Heli", [
             ["BIS_SUPP_vehicles", "[]"],
             ["BIS_SUPP_vehicleInit", ""],
             ["BIS_SUPP_filter", "Side"],
             ["BIS_SUPP_cooldown", 0]]],
         ["SupportProvider_CAS_Bombing", []],
         ["SupportProvider_Virtual_CAS_Bombing", [
             ["BIS_SUPP_vehicles", "[]"],
             ["BIS_SUPP_vehicleInit", ""],
             ["BIS_SUPP_filter", "Side"],
             ["BIS_SUPP_cooldown", 0]]],
         ["SupportProvider_Drop", [["BIS_SUPP_crateInit", ""]]],
         ["SupportProvider_Virtual_Drop", [
             ["BIS_SUPP_vehicles", "[]"],
             ["BIS_SUPP_vehicleInit", ""],
             ["BIS_SUPP_crateInit", ""],
             ["BIS_SUPP_filter", "Side"],
             ["BIS_SUPP_cooldown", 0]]],
         ["SupportProvider_Transport", []],
         ["SupportProvider_Virtual_Transport", [
             ["BIS_SUPP_vehicles", "[]"],
             ["BIS_SUPP_vehicleInit", ""],
             ["BIS_SUPP_filter", "Side"],
             ["BIS_SUPP_cooldown", 0]]]];
    for "_j" from 0 to count _classesAndArguments - 1 do {
        _classesAndArguments # _j params ["_class", "_arguments"];
        private _providerLogicPosAGL = _hubPosAGL vectorAdd (
            [
                [0, HUB_RADIUS, 0],
                _j * 360 / count _classesAndArguments,
                2
            ] call BIS_fnc_rotateVector3D
        );
        private _providerLogic = _group createUnit [
            _class, _providerLogicPosAGL, [], 0, "NONE"
        ];
        for "_k" from 0 to count _arguments - 1 do {
            _arguments # _k params ["_key", "_value"];
            _providerLogic setVariable [_key, _value, true];
        };
        _providerLogic setVariable [
            "BIS_fnc_initModules_disableAutoActivation", false, true
        ];
        // _providerLogic synchronizeObjectsAdd [_requesterLogic];
        _newLogics pushBack _providerLogic;
    };
};

_newLogics;
