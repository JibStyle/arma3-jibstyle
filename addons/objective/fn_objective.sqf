if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_objective_moduleValidate = {};

// Setup hostage rescue objective.
jib_objective_hostage = {
    params [
        "_unit",             // Hostage
        ["_injured", false], // True if injured
        ["_callback", {}]    // Code upon release (run on server)
    ];
    if (!isServer) then {throw "Not server!"};
    if (!alive _unit) then {throw "Hostage not alive!"};

    _unit setVariable ["jib_objective_hostageCallback", _callback];
    [_unit, _injured] remoteExec ["jib_objective_hostageSetup", 0, true];
};

// Client side hostage setup
jib_objective_hostageSetup = {
    params ["_unit", "_injured"];
    if (local _unit) then {
        _unit setCaptive true;
        removeAllWeapons _unit;
        removeBackpack _unit;
        removeVest _unit;
        removeAllAssignedItems _unit;
        _unit disableAI "all";
        if (_injured) then {
            _unit setDamage 0.5;
        };
    };
    if (_injured) then {
        _unit switchMove "Acts_ExecutionVictim_Loop";
    } else {
        _unit switchMove "Acts_AidlPsitMstpSsurWnonDnon01";
    };
    [
        _unit,
        "Free Hostage",
        "\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_unbind_ca.paa",
        "\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_unbind_ca.paa",
        "alive _target && _target distance _this < 2 && !captive player",
        "alive _target && _target distance _caller < 2",
        {},
        {},
        {
            params ["_unit", "_caller", "_actionID", "_arguments"];
            _arguments params ["_injured"];
            [_unit, _injured, group _caller, _actionID] remoteExec [
                "jib_objective_hostageFree", 0, true
            ];
        },
        {},
        [_injured],
        5,
        10
    ] call BIS_fnc_holdActionAdd;
};

// Client side hostage free
jib_objective_hostageFree = {
    params ["_unit", "_injured", "_group", "_actionID"];
    [] call (
        _unit getVariable ["jib_objective_hostageCallback", {}]
    );
    if (_injured) then {
        _unit playMove "Acts_ExecutionVictim_Unbow";
    } else {
        _unit switchMove "Acts_AidlPsitMstpSsurWnonDnon_out";
    };
    if (local _unit) then {
        _unit enableAI "all";
        [_unit] join _group;
    };
    [_unit, _actionID] call BIS_fnc_holdActionRemove;
};

// Setup hostage
jib_objective_moduleHostage = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached] call jib_objective_hostage;
        }
    ] call jib_objective_moduleValidate;
};

// Setup injured hostage
jib_objective_moduleHostageInjured = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached, true] call jib_objective_hostage;
        }
    ] call jib_objective_moduleValidate;
};

// Remote calls
publicVariable "jib_objective_hostageSetup";
publicVariable "jib_objective_hostageFree";
publicVariable "jib_objective_moduleHostage";
publicVariable "jib_objective_moduleHostageInjured";
publicVariable "jib_objective_moduleValidate";
