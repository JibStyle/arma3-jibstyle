if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_sync_moduleValidate = {};

jib_sync_moduleSyncFrom = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            jib_sync_selectedSyncFrom = _attached;
        },
        [],
        "local"
    ] call jib_sync_moduleValidate;
};

jib_sync_moduleSyncTo = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_from"];
            if (
                isNull _from || isNull _attached
            ) then {throw "Null object!"};
            _from synchronizeObjectsAdd [_attached];
        },
        [jib_sync_selectedSyncFrom]
    ] call jib_sync_moduleValidate;
};

jib_sync_moduleUnsyncFrom = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            jib_sync_selectedUnsyncFrom = _attached;
        },
        [],
        "local"
    ] call jib_sync_moduleValidate;
};

jib_sync_moduleUnsyncTo = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_from"];
            if (
                isNull _from || isNull _attached
            ) then {throw "Null object!"};
            _from synchronizeObjectsRemove [_attached];
        },
        [jib_sync_selectedUnsyncFrom]
    ] call jib_sync_moduleValidate;
};

publicVariable "jib_sync_moduleSyncFrom";
publicVariable "jib_sync_moduleSyncTo";
publicVariable "jib_sync_moduleUnsyncFrom";
publicVariable "jib_sync_moduleUnsyncTo";
publicVariable "jib_sync_moduleValidate";
