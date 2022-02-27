// Print all commanders and their subordinate groups
params ["_logic", "", "_isActivated"];
if (not _isActivated) exitWith { systemChat "Not activated!"; };
if (not local _logic) exitWith { false };

// Call function
try {
    [] call jib_hc_fnc_debug;
} catch {
    [objNull, str _exception] call BIS_fnc_showCuratorFeedbackMessage;
};
deleteVehicle _logic;
