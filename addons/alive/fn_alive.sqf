// ALiVE functions
if (!isServer) exitWith { "Not server!" };

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_alive_moduleValidate = {};

// Disable ALiVE zeus registering
jib_alive_registerDisable = {
    if (not isServer) then {throw "Not server!"};
    [] spawn {
        private _t = time;
        waitUntil {
            isNil "ALiVE_fnc_ZeusRegister" == false
                || {time > _t + 5}
        };
        if (isNil "ALiVE_fnc_ZeusRegister") exitWith {};
        jib_alive_register = ALiVE_fnc_ZeusRegister;
        ALiVE_fnc_ZeusRegister = {};
    };
};

// Enable ALiVE zeus registering
jib_alive_registerEnable = {
    if (not isServer) then {throw "Not server!"};
    [] spawn {
        sleep 1;
        if (isNil "jib_alive_register") exitWith {};
        ALiVE_fnc_ZeusRegister = jib_alive_register;
    };
};

// Disable ALiVE OPCOM
jib_alive_opcomDisable = {
    if (not isServer) then {throw "Not server!"};
    [] spawn {
        private _t = time;
        waitUntil {
            isNil "ALiVE_fnc_pauseModule" == false
                && {time > _t + 1}
        };
        if (isNil "ALiVE_fnc_pauseModule") exitWith {};
        ["ALIVE_MIL_OPCOM"] call ALiVE_fnc_pauseModule;
    };
};

// Enable ALiVE OPCOM
jib_alive_opcomEnable = {
    if (not isServer) then {throw "Not server!"};
    [] spawn {
        sleep 1;
        if (isNil "ALiVE_fnc_unPauseModule") exitWith {};
    };
    ["ALIVE_MIL_OPCOM"] call ALiVE_fnc_unPauseModule;
};

// Disable ALiVE Profiles
jib_alive_profileDisable = {
    if (not isServer) then {throw "Not server!"};
    [] spawn {
        private _t = time;
        waitUntil {
            isNil "ALiVE_fnc_pauseModule" == false
                && {time > _t + 1}
        };
        if (isNil "ALiVE_fnc_pauseModule") exitWith {};
        ["ALIVE_SYS_PROFILE"] call ALiVE_fnc_pauseModule;
    };
};

// Enable ALiVE Profiles
jib_alive_profileEnable = {
    if (not isServer) then {throw "Not server!"};
    [] spawn {
        sleep 1;
        if (isNil "ALiVE_fnc_unPauseModule") exitWith {};
    };
    ["ALIVE_SYS_PROFILE"] call ALiVE_fnc_unPauseModule;
};

// PRIVATE

// Get admin
jib_alive_moduleRegisterEnable = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [] call jib_alive_registerEnable;
        }
    ] call jib_alive_moduleValidate;
};

jib_alive_moduleRegisterDisable = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [] call jib_alive_registerDisable;
        }
    ] call jib_alive_moduleValidate;
};

jib_alive_moduleOpcomDisable = {
    [
        _this,
        {
            [] call jib_alive_opcomDisable;
        }
    ] call jib_alive_moduleValidate;
};

jib_alive_moduleOpcomEnable = {
    [
        _this,
        {
            [] call jib_alive_opcomEnable;
        }
    ] call jib_alive_moduleValidate;
};

jib_alive_moduleProfileDisable = {
    [
        _this,
        {
            [] call jib_alive_profileDisable;
        }
    ] call jib_alive_moduleValidate;
};

jib_alive_moduleProfileEnable = {
    [
        _this,
        {
            [] call jib_alive_profileEnable;
        }
    ] call jib_alive_moduleValidate;
};

// Publish variables
publicVariable "jib_alive_moduleRegisterEnable";
publicVariable "jib_alive_moduleRegisterDisable";
publicVariable "jib_alive_moduleOpcomDisable";
publicVariable "jib_alive_moduleOpcomEnable";
publicVariable "jib_alive_moduleProfileDisable";
publicVariable "jib_alive_moduleProfileEnable";
publicVariable "jib_alive_moduleValidate";

jib_alive_menu = [
    "ALiVE Menu",
    [
        [
            "Register Disable",
            "[] remoteExec [""jib_alive_registerDisable"", 2]", "1", true
        ],
        [
            "Register Enable",
            "[] remoteExec [""jib_alive_registerEnable"", 2]", "1", true
        ],
        [
            "Profile Disable",
            "[] remoteExec [""jib_alive_profileDisable"", 2]", "1", true
        ],
        [
            "Profile Enable",
            "[] remoteExec [""jib_alive_profileEnable"", 2]", "1", true
        ],
        [
            "OPCOM Disable",
            "[] remoteExec [""jib_alive_opcomDisable"", 2]", "1", true
        ],
        [
            "OPCOM Enable",
            "[] remoteExec [""jib_alive_opcomEnable"", 2]", "1", true
        ]
    ]
];

[] call jib_alive_registerDisable;
[] call jib_alive_opcomDisable;
[] call jib_alive_profileDisable;
