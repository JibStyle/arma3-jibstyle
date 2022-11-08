if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_replacement_moduleValidate = {};

// PRIVATE BELOW HERE

jib_replacement_register = {
    params [
        "_unit" // Unit
    ];
    if (not isServer) then {throw "Not server!"};
    if (isNull _unit) then {throw "Null unit!"};
};

jib_replacement_register = {
    params [
        "_unit" // Unit
    ];
    if (not isServer) then {throw "Not server!"};
    if (isNull _unit) then {throw "Null unit!"};
};

jib_replacement_moduleRegister = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached] call jib_replacement_register;
        }
    ] call jib_replacement_moduleValidate;
};

jib_replacement_moduleReplace = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached] call jib_replacement_replace;
        }
    ] call jib_replacement_moduleValidate;
};

publicVariable "jib_replacement_moduleValidate";
publicVariable "jib_replacement_moduleRegister";
publicVariable "jib_replacement_moduleReplace";
