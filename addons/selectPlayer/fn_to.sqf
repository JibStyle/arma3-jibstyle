// Select player and transfer curator ownership
params ["_logic", "_units", "_isActivated"];
if (not _isActivated) exitWith { systemChat "Not activated!"; };
if (not isServer) exitWith { systemChat "Not server!"; };

// Get curator logic
private _curator = getAssignedCuratorLogic jib_selectPlayer_from;

// Get selected unit
private _unit = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];
if (not alive _unit) exitWith {
    [
        objNull,
        "Must place module on unit!"
    ] call BIS_fnc_showCuratorFeedbackMessage;
    deleteVehicle _logic;
    false;
};

// Trigger client
[[_unit, _curator], {
    params ["_unit", "_curator"];

    // Select player
    selectPlayer _unit;

    // Un-force curator and transfer curator ownership
    [false, false] call BIS_fnc_forceCuratorInterface;
    [[player, _curator], {
        params ["_player", "_curator"];
        unassignCurator _curator;
        waitUntil { isNull (getAssignedCuratorUnit _curator) };
        _player assignCurator _curator;
    }] remoteExec ["spawn", 2];

    // Update MARTA
    if (count hcAllGroups player > 0) then {
        setGroupIconsVisible [true, false];
    } else {
        setGroupIconsVisible [false, false];
    };
}] remoteExec ["spawn", jib_selectPlayer_from];

deleteVehicle _logic;
true;
