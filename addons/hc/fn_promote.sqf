// Make unit a commander.
//
// If unit already a commander, they are unaffected. Also, HC module
// saved in global variable and used in subsequent `fn_add` calls.
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
jib_hc_selected = _leader;
{
    if (_x isKindOf "HighCommand") exitWith {
        deleteVehicle _logic;
        true;
    };
} forEach synchronizedObjects _leader;

// Maybe create logic group
if (isNil "jib_hc_group") then {
    jib_hc_group = createGroup sideLogic;
};

// Create logics
private _hc = jib_hc_group createUnit [
    "HighCommand", [0, 0, 0], [], 0, "NONE"
];
private _hcSub = jib_hc_group createUnit [
    "HighCommandSubordinate", [0, 0, 0], [], 0, "NONE"
];
_hc synchronizeObjectsAdd [_leader, _hcSub];

// Enable MARTA
[[], {
    setGroupIconsVisible [true, false];
}] remoteExec ["spawn", _leader];

deleteVehicle _logic;
true;
