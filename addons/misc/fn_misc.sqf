if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_misc_moduleValidate = {};

// Push group IDs from current machine to all
jib_misc_pushGroupIDs = {
    allGroups apply {
        private _id = groupId _x;
        _x setGroupIdGlobal [_id];
    };
};

// Replace dummy object with specified vehicle type.
//
// Useful for spawning vehicles above ground like on a carrier.
jib_misc_replaceDummy = {
    params [
        "_oldVehicle", // Object to delete
        "_newType",    // Type to spawn
        "_createCrew", // Whether to create crew
        "_curators"    // Curators to add new vic to
    ];
    if (not isServer) then {throw "Not server!"};
    if (typeName _newType != "STRING") then {
        throw "No type selected!"
    };
    [_oldVehicle, _newType, _createCrew, _curators] spawn {
        params ["_oldVehicle", "_newType", "_createCrew", "_curators"];
        private _posATL = getPosATL _oldVehicle;
        private _dir = getDir _oldVehicle;
        deleteVehicleCrew _oldVehicle;
        deleteVehicle _oldVehicle;
        uiSleep 1.0;
        private _newVic = createVehicle [_newType, _posATL];
        if (_createCrew) then {
            createVehicleCrew _newVic;
        };
        _newVic setDir _dir;
        _curators apply {
            _x addCuratorEditableObjects [[_newVic], true];
        };
    };
};

// PRIVATE BELOW HERE

// Select type to replace with
jib_misc_moduleReplaceFrom = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            jib_misc_moduleReplaceType = typeOf _attached;
        },
        [],
        "local"
    ] call jib_misc_moduleValidate;
};

// Replace selected object
jib_misc_moduleReplaceTo = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_type", "_curators"];
            [
                _attached,
                _type,
                true,
                _curators
            ] call jib_misc_replaceDummy
        },
        [jib_misc_moduleReplaceType, [getAssignedCuratorLogic player]]
    ] call jib_misc_moduleValidate;
};

// Replace selected object without vehicle crew
jib_misc_moduleReplaceToUncrewed = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_type", "_curators"];
            [
                _attached,
                _type,
                false,
                _curators
            ] call jib_misc_replaceDummy
        },
        [jib_misc_moduleReplaceType, [getAssignedCuratorLogic player]]
    ] call jib_misc_moduleValidate;
};

// Push group IDs from local machine to all
jib_misc_modulePushGroupIDs = {
    [
        _this,
        {[] call jib_misc_pushGroupIDs;},
        [],
        "local"
    ] call jib_misc_moduleValidate;
};

// Remote calls
publicVariable "jib_misc_pushGroupIDs";
publicVariable "jib_misc_moduleValidate";
publicVariable "jib_misc_moduleReplaceFrom";
publicVariable "jib_misc_moduleReplaceTo";
publicVariable "jib_misc_moduleReplaceToUncrewed";
publicVariable "jib_misc_modulePushGroupIDs";
[] call jib_misc_pushGroupIDs;
