// Push group IDs from current machine to all
params ["_logic", "", "_isActivated"];
if (not _isActivated) exitWith { "Not activated!"; };
if (not local _logic) exitWith { false };

// Call function
try {
    [] call jib_misc_fnc_syncGroupIDs;
} catch {
    [objNull, str _exception] call BIS_fnc_showCuratorFeedbackMessage;
};
deleteVehicle _logic;
