// Add unit's group to selected HC commander.
//
// HC commander should already have been selected by a `fn_hcPromote`
// call.
params ["_logic", "", "_isActivated"];
if (not _isActivated) exitWith { systemChat "Not activated!"; };
if (not isServer) exitWith { systemChat "Not server!"; };

// Validate previously selected HC commander
if (isNil "my_modules_hcSelected") exitWith {
    [
        objNull,
        "First, select leader with HC promote"
    ] call BIS_fnc_showCuratorFeedbackMessage;
    deleteVehicle _logic;
    false;
};
private _commander = my_modules_hcSelected;

// Validate chosen subordinate
private _subordinate = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];
if (not alive _subordinate) exitWith {
    [
        objNull,
        "Must place module on unit!"
    ] call BIS_fnc_showCuratorFeedbackMessage;
    deleteVehicle _logic;
    false;
};
private _group = group _subordinate;

// Add group to HC
if (hcLeader _group != _commander) then {
    hcLeader _group hcRemoveGroup _group;
    _commander hcSetGroup [_group];
};
deleteVehicle _logic;
true;
