// Setup paradrop waypoints
params ["_logic", "", "_isActivated"];
if (not _isActivated) exitWith { "Not activated!"; };
if (not isServer) then {throw "Not server!"};

// Get synced entity
private _entity = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];

// Vehicle data
private _offsets = [];
private _brightness = [0,0,0];
private _doors = [["", 0], ["", 0]];
switch true do
{
    case (_entity isKindOf "VTOL_01_base_F"): {
        _offsets = [
            [0, -3, -2],
            [0, -6, -2],
            [0, -9, -2],
            [0, -12, -2],
            [0, -15, -2]
        ];
        _brightness = [.08, .1, .1];
        _doors = [["Door_1_source", 1], ["Door_1_source", 0]];
    };
    default {};
};

// Call function
try {
    [_entity, _offsets, _brightness, _doors] call jib_logistics_fnc_paradrop;
} catch {
    [objNull, str _exception] call BIS_fnc_showCuratorFeedbackMessage;
};
deleteVehicle _logic;
