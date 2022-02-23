// Update MARTA configuration
addMissionEventHandler ["CommandModeChanged", {
    params ["_isHighCommand", "_isForced"];
    setGroupIconsVisible [true, false];
}];
