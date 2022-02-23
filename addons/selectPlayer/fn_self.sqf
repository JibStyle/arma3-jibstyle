// Select player and transfer curator ownership
params ["_logic", "_units", "_isActivated"];
if (not _isActivated) exitWith { systemChat "Not activated!"; };
if (not hasInterface) exitWith { systemChat "Not client!"; };
if (not local _logic) exitWith { false };

// Get curator logic
private _curatorLogic = getAssignedCuratorLogic player;
if (isNull _curatorLogic) exitWith {
    systemChat "No curator assigned to player!";
};

// Get selected unit
private _curatorUnit = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];
if (not alive _curatorUnit) exitWith {
    [
        objNull,
        "Must place module on unit!"
    ] call BIS_fnc_showCuratorFeedbackMessage;
    deleteVehicle _logic;
    false;
};

// Select player
selectPlayer _curatorUnit;

// Un-force curator and transfer curator ownership
[false, false] call BIS_fnc_forceCuratorInterface;
[[player, _curatorLogic], {
    params ["_player", "_curatorLogic"];
    unassignCurator _curatorLogic;
    waitUntil { isNull (getAssignedCuratorUnit _curatorLogic) };
    _player assignCurator _curatorLogic;
}] remoteExec ["spawn", 2];

// Update MARTA
if (count hcAllGroups player > 0) then {
    setGroupIconsVisible [true, false];
} else {
    setGroupIconsVisible [false, false];
};

deleteVehicle _logic;
true;
