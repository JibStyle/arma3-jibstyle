// Add unit's group to selected HC commander.
//
// HC commander should already have been selected by a `fn_hcPromote`
// call.
params ["_logic", "", "_isActivated"];
if (not _isActivated) exitWith { "Not activated!"; };
if (not isServer) then {throw "Not server!"};

// Validate previously selected HC commander
if (isNil "jib_modules_hcSelected") exitWith {
    [
        objNull,
        "First, select leader with HC promote"
    ] call BIS_fnc_showCuratorFeedbackMessage;
    deleteVehicle _logic;
    false;
};
private _commander = jib_modules_hcSelected;

// Validate chosen subordinate
private _subordinate = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];
private _group = group _subordinate;

// Do it
try {
    [_commander, _group] call jib_hc_fnc_add;
    [] call jib_hc_fnc_debug;
} catch {
    [objNull, str _exception] call BIS_fnc_showCuratorFeedbackMessage;
};
deleteVehicle _logic;
