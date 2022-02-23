// Print all commanders and their subordinate groups
params ["_logic", "", "_isActivated"];
if (not _isActivated) exitWith { systemChat "Not activated!"; };
if (not local _logic) exitWith { false };

systemChat "High Command printing debug info...";
{
    private _groups = hcAllGroups _x;
    if (count _groups == 0) then { continue };
    systemChat format ["Leader: %1 -- Groups: %2", _x, _groups];
} forEach allUnits; // NOTE: Waiting to respawn not counted
systemChat "Done.";
deleteVehicle _logic;
true;
