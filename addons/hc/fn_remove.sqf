// Remove unit's group from HC.
params ["_logic", "", "_isActivated"];
if (not _isActivated) exitWith { systemChat "Not activated!"; };
if (not isServer) exitWith { systemChat "Not server!"; };

// Validate subordinate
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

// Remove group from HC
hcLeader _group hcRemoveGroup _group;
deleteVehicle _logic;
true;
