// Setup HC
if (!isServer) exitWith {};

// Transfer HC
jib_hc_fnc_transfer = {
    params ["_oldUnit", "_newUnit"];
    if (!isServer) then {throw "Not server"};
    [
        "JIB hc transfer from %1 to %2",
        _oldUnit,
        _newUnit
    ] call BIS_fnc_logFormat;
    {
        _oldUnit hcRemoveGroup _x;
        _newUnit hcSetGroup [_x];
    } forEach hcAllGroups _oldUnit;
};

// Setup client
jib_hc_fnc_initClient = {
    if (!hasInterface) exitWith {};

    addMissionEventHandler ["CommandModeChanged", {
        params ["_isHighCommand", "_isForced"];
        setGroupIconsVisible [true, false];
    }];

    addMissionEventHandler ["EntityRespawned", {
        params ["_newEntity", "_oldEntity"];
        [
            "JIB hc respawn from %1 to %2",
            _oldEntity,
            _newEntity
        ] call BIS_fnc_logFormat;
        [_oldEntity, _newEntity] remoteExec ["jib_hc_fnc_transfer", 2];
    }];

    addMissionEventHandler ["TeamSwitch", {
        params ["_previousUnit", "_newUnit"];
        [
            "JIB hc teamswitch from %1 to %2",
            _previousUnit,
            _newUnit
        ] call BIS_fnc_logFormat;
        [_previousUnit, _newUnit] remoteExec ["jib_hc_fnc_transfer", 2];
    }];
};
publicVariable "jib_hc_fnc_initClient";
[] remoteExec ["jib_hc_fnc_initClient", 0, true];
