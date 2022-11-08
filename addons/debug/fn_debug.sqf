if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_debug_moduleValidate = {};

// PRIVATE BELOW HERE

jib_debug_moduleCopyPositionASL = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            private _posASL = ATLToASL _posATL;
            jib = _posASL; // Special convenience var
            copyToClipboard str _posASL;
            systemChat format ["%1 copied and set to jib.", _posASL];
        },
        [],
        "local"
    ] call jib_debug_moduleValidate;
};

jib_debug_moduleCopyPositionATL = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            jib = _posATL; // Special convenience var
            copyToClipboard str _posATL;
            systemChat format ["%1 copied and set to jib.", _posATL];
        },
        [],
        "local"
    ] call jib_debug_moduleValidate;
};

jib_debug_moduleSelectEntity = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            jib = _attached; // Special convenience var
            systemChat format ["%1 set to jib.", _attached];
        },
        [],
        "local"
    ] call jib_debug_moduleValidate;
};

publicVariable "jib_debug_moduleValidate";
publicVariable "jib_debug_moduleCopyPositionASL";
publicVariable "jib_debug_moduleCopyPositionATL";
publicVariable "jib_debug_moduleSelectEntity";
