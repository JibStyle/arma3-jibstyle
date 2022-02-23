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
my_modules_hcSelected = _leader;
{
    if (_x isKindOf "HighCommand") exitWith {
        deleteVehicle _logic;
        true;
    };
} forEach synchronizedObjects _leader;

// Maybe create logic group
if (isNil "my_modules_hcLogicGroup") then {
    my_modules_hcLogicGroup = createGroup sideLogic;
};

// Create logics
private _hc = my_modules_hcLogicGroup createUnit [
    "HighCommand", [0, 0, 0], [], 0, "NONE"
];
private _hcSub = my_modules_hcLogicGroup createUnit [
    "HighCommandSubordinate", [0, 0, 0], [], 0, "NONE"
];
_hc synchronizeObjectsAdd [_leader, _hcSub];

// Enable MARTA
[[], {
    setGroupIconsVisible [true, false];
}] remoteExec ["spawn", _leader];

deleteVehicle _logic;
true;
