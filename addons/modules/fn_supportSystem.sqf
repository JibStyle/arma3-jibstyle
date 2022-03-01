// Create artillery support provider synced to selected requester
params ["_logic", "", "_isActivated"];
if (!_isActivated) exitWith {};
if (not local _logic) exitWith {};
if (!hasInterface) then {throw "No interface!"};

private _posATL = getPosATL _logic;
private _curator = getAssignedCuratorLogic player;

[[_posATL, _curator], {
    params ["_posATL", "_curator"];
    private _newLogics = [
        _posATL // Expects AGL but we only have ATL
    ] call jib_support_fnc_createSystem;
    if (not isNull _curator) then {
        _curator addCuratorEditableObjects [_newLogics];
    };
}] remoteExec ["spawn", 2];

deleteVehicle _logic;
