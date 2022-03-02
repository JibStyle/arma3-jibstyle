// Setup hostage rescue objective.
params [
    "_unit",             // Hostage
    ["_injured", false], // True if injured
    ["_callback", {}]    // Code upon release
];
if (!isServer) then {throw "Not server!"};
if (!alive _unit) then {throw "Hostage not alive!"};

if (isNil "jib_objectives_hostage_setup") then {
    jib_objectives_hostage_setup = {
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
                    "jib_objectives_hostage_free", 0, true
                ];
            },
            {},
            [_injured],
            5,
            10
        ] call BIS_fnc_holdActionAdd;
    };
    publicVariable "jib_objectives_hostage_setup";
};

if (isNil "jib_objectives_hostage_free") then {
    jib_objectives_hostage_free = {
        params ["_unit", "_injured", "_group", "_actionID"];
        [] call (
            _unit getVariable ["jib_objectives_hostage_callback", {}]
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
    publicVariable "jib_objectives_hostage_free";
};

_unit setVariable ["jib_objectives_hostage_callback", _callback];
[_unit, _injured] remoteExec ["jib_objectives_hostage_setup", 0, true];
