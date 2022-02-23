// Remove all subordinate groups from commander.
params ["_logic", "", "_isActivated"];
if (not _isActivated) exitWith { systemChat "Not activated!"; };
if (not isServer) exitWith { systemChat "Not server!"; };

// Validate leader
private _leader = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];
if (not alive _leader) exitWith {
    [
        objNull,
        "Must place module on unit!"
    ] call BIS_fnc_showCuratorFeedbackMessage;
    deleteVehicle _logic;
    false;
};

// Remove all groups
hcRemoveAllGroups _leader;

// Disable MARTA
[[], {
    setGroupIconsVisible [false, false];
}] remoteExec ["spawn", _leader];

deleteVehicle _logic;
true;
