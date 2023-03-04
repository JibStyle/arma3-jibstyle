if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_objective_moduleValidate = {};

// Spawn minefield in trigger area
jib_objective_minefield = {
    params [
        "_trigger",
        ["_spacing", 20, [0]],
        ["_radius", 5, [0]]
    ];
    if (!isServer) exitWith {};
    if (!canSuspend) then {throw "Cannot suspend!"};
    while {triggerActivated _trigger} do {
        uiSleep 0.5;
        list _trigger apply {
            if (
                _x getVariable [
                    "jib_objective_minefield_last", [0, 0, 0]
                ] distance2D _x > _spacing && isTouchingGround _x
            ) then {
                private _posATL = getPosATL _x;
                private _setLast = {
                    _this setVariable [
                        "jib_objective_minefield_last", _posATL
                    ];
                };
                private _mine = {
                    params ["_type"];
                    createMine [
                        _type,
                        [_posATL # 0, _posATL # 1, 0],
                        [],
                        _radius
                    ] setDamage 1;
                };
                _x call _setLast;
                crew _x apply {_x call _setLast};
                switch (_x call BIS_fnc_objectType select 0) do
                {
                    case "Soldier": {
                        ["APERSMine"] call _mine;
                    };
                    case "Vehicle";
                    case "VehicleAutonomous": {
                        ["ATMine"] call _mine;
                    };
                };
            };
        };
    };
};

// Setup data terminal objective
jib_objective_dataTerminal = {
    params [
        "_dataTerminal",  // Data terminal to setup
        ["_owner", true], // Bool, object, group, side, or array
        ["_assign", true] // Auto assign task with notification
    ];
    if (!isServer) then {throw "Not server!"};

    // Create task unless owner false
    if (typeName _owner != "BOOL" || {_owner}) then {
        // Generate task ID
        private _taskID = format [
            "%1%2",
            jib_objective_dataTerminalTask,
            jib_objective_dataTerminalCount
        ];
        jib_objective_dataTerminalCount =
            jib_objective_dataTerminalCount + 1;
        jib_objective_dataTerminalRemaining =
            jib_objective_dataTerminalRemaining + 1;
        _dataTerminal setVariable [
            jib_objective_dataTerminalTask,
            _taskID
        ];

        // Create task
        [
            _owner,        // task owner(s)
            _taskID,       // task identifier
            [
                "Hack into the data terminal to gain valuable intel!",
                "Hack Data Terminal",
                ""
            ],             // [description, title, marker]
            _dataTerminal, // position
            "CREATED",     // state
            -1,            // priority
            false,         // notification
            "intel",       // type
            false          // visible 3D
        ] call BIS_fnc_taskCreate;

        // Assign task
        if (_assign) then {
            [_taskID] spawn {
                params ["_taskID"];
                uiSleep 1;
                [_taskID, "ASSIGNED", true] call BIS_fnc_taskSetState;
            };
        };
    };

    // Setup clients
    [_dataTerminal] remoteExec [
        "jib_objective_dataTerminalHoldActionAdd",
        0,
        true
    ];
};

// Check if all data terminal tasks completed
jib_objective_dataTerminalAllComplete = {
    if (!isServer) then {throw "Not server!"};
    jib_objective_dataTerminalCount > 0
        && jib_objective_dataTerminalRemaining == 0;
};

// Setup hostage rescue objective.
jib_objective_hostage = {
    params [
        "_hostage",          // Hostage
        ["_injured", false], // True if injured (not ACE compatible)
        ["_owner", true],    // Bool, object, group, side, or array
        ["_assign", true]    // Auto assign task with notification
    ];
    if (!isServer) then {throw "Not server!"};
    if (!alive _hostage) then {throw "Hostage not alive!"};

    // Create task unless owner false
    if (typeName _owner != "BOOL" || {_owner}) then {
        // Generate task ID
        private _taskID = format [
            "%1%2",
            jib_objective_hostageTask,
            jib_objective_hostageCount
        ];
        jib_objective_hostageCount =
            jib_objective_hostageCount + 1;
        jib_objective_hostageRemaining =
            jib_objective_hostageRemaining + 1;
        _hostage setVariable [
            jib_objective_hostageTask,
            _taskID
        ];

        // Create task
        [
            _owner,    // task owner(s)
            _taskID,   // task identifier
            [
                "Rescue the hostage and extract them to safety!",
                "Rescue Hostage",
                ""
            ],         // [description, title, marker]
            _hostage,  // position
            "CREATED", // state
            -1,        // priority
            false,     // notification
            "help",    // type
            false      // visible 3D
        ] call BIS_fnc_taskCreate;

        // Assign task
        if (_assign) then {
            [_taskID] spawn {
                params ["_taskID"];
                uiSleep 1;
                [_taskID, "ASSIGNED", true] call BIS_fnc_taskSetState;
            };
        };
    };

    // Setup clients
    [_hostage, _injured] remoteExec [
        "jib_objective_hostageSetup",
        0,
        true
    ];
};

// Check if all hostage tasks completed
jib_objective_hostageAllComplete = {
    if (!isServer) then {throw "Not server!"};
    jib_objective_hostageCount > 0
        && jib_objective_hostageRemaining == 0;
};

jib_objective_capture_enable = true;
jib_objective_capture_delay = 0.25;
jib_objective_capture_distance = 7;
publicVariable "jib_objective_capture_enable";
publicVariable "jib_objective_capture_delay";
publicVariable "jib_objective_capture_distance";

jib_objective_capture_register = {
    params ["_unit"];
    _unit setVariable ["jib_objective_capture_registered", true];
    if (local _unit) then {
        _unit setCaptive true;
    };
};
publicVariable "jib_objective_capture_register";

jib_objective_capture_start = {
    jib_objective_capture_enable = false;
    uiSleep jib_objective_capture_delay * 2;
    jib_objective_capture_enable = true;
    while {jib_objective_capture_enable} do {
        uiSleep jib_objective_capture_delay;
        private _target = cursorObject;
        if (
            _target getVariable [
                "jib_objective_capture_registered", false
            ] && (
                _target distance player
                    < jib_objective_capture_distance
            )
        ) then {
            [
                "ace_captives_setSurrendered",
                [_target, true],
                _target
            ] call CBA_fnc_targetEvent;
        };
    };
};
publicVariable "jib_objective_capture_start";

jib_objective_capture_stop = {
    jib_objective_capture_enable = false;
};
publicVariable "jib_objective_capture_stop";

// PRIVATE

// Server vars
jib_objective_dataTerminalTask = "jib_objective_dataTerminalTask";
jib_objective_dataTerminalCount = 0;
jib_objective_dataTerminalRemaining = 0;
jib_objective_hostageTask = "jib_objective_hostageTask";
jib_objective_hostageCount = 0;
jib_objective_hostageRemaining = 0;

// Local vars
jib_objective_dataTerminalSoundProgress =
    "a3\missions_f_oldman\data\sound\intel_pc\2sec\intel_pc_2sec_01.wss";
jib_objective_dataTerminalSoundComplete =
    "A3\Missions_F_Oldman\Data\sound\Computer\Reboot.wss";
jib_objective_dataTerminalHoldActionID =
    "jib_objective_dataTerminalHoldActionID";
jib_objective_dataTerminalHoldActionIcon =
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa";

// Complete data terminal objective
jib_objective_dataTerminalComplete = {
    params ["_dataTerminal"];
    if (!isServer) then {throw "Not server!"};

    // Cleanup clients
    [_dataTerminal] remoteExec [
        "jib_objective_dataTerminalHoldActionRemove",
        0,
        true
    ];

    // Complete task
    private _taskID = _dataTerminal getVariable [
        jib_objective_dataTerminalTask,
        ""
    ];
    if (_taskID != "") then {
        jib_objective_dataTerminalRemaining =
            jib_objective_dataTerminalRemaining - 1;
        [
            _taskID,
            "SUCCEEDED"
        ] call BIS_fnc_taskSetState;
    };
};

// Data terminal remove hold action (local).
jib_objective_dataTerminalHoldActionRemove = {
    params ["_dataTerminal"];
    [
        _dataTerminal,
        _dataTerminal getVariable [
            jib_objective_dataTerminalHoldActionID,
            -1
        ]
    ] call BIS_fnc_holdActionRemove;
};

// Data terminal add hold action (local).
jib_objective_dataTerminalHoldActionAdd = {
    params ["_dataTerminal"];

    [_dataTerminal] call jib_objective_dataTerminalHoldActionRemove;

    _dataTerminal setVariable [
        jib_objective_dataTerminalHoldActionID,
        [
            _dataTerminal,
            "Activate Data Terminal",
            jib_objective_dataTerminalHoldActionIcon, // start
            jib_objective_dataTerminalHoldActionIcon, // prog
            "player distance _target < 2", // condition show
            "true", // condition progress
            {_this call jib_objective_dataTerminalHoldActionStart;},
            // Progress called on integers 1..24
            {_this call jib_objective_dataTerminalHoldActionProgress;},
            {_this call jib_objective_dataTerminalHoldActionComplete;},
            {_this call jib_objective_dataTerminalHoldActionInterrupt;},
            [],     // args
            7,      // duration
            1000,   // priority (default 1000)
            true,   // remove completed
            false,  // show unconscious
            true    // show window
        ] call BIS_fnc_holdActionAdd
    ];
};

// Hold action start condition (local).
jib_objective_dataTerminalHoldActionStart = {
    params ["_target", "_caller", "_actionId", "_arguments"];
    [_target, 3] call BIS_fnc_dataTerminalAnimate;
};

// Hold action progress condition (local).
jib_objective_dataTerminalHoldActionProgress = {
    params ["_target", "", "", "", "_progress", "_maxProgress"];
    if (_progress == 13) then {
        playSound3D [
            jib_objective_dataTerminalSoundProgress,
            _target
        ];
    };
};

// Hold action completion handler (local).
jib_objective_dataTerminalHoldActionComplete = {
    params ["_target", "_caller", "_actionId", "_arguments"];
    playSound3D [
        jib_objective_dataTerminalSoundComplete,
        _target
    ];
    [_target] remoteExec ["jib_objective_dataTerminalComplete", 2];
};

// Hold action interrupt handler (local).
jib_objective_dataTerminalHoldActionInterrupt = {
    params ["_target", "_caller", "_actionId", "_arguments"];
    [_target, 1] call BIS_fnc_dataTerminalAnimate;
};

// Server side hostage complete
jib_objective_hostageComplete = {
    params ["_hostage"];
    if (!isServer) then {throw "Not server!"};

    // Complete task
    private _taskID = _hostage getVariable [
        jib_objective_hostageTask,
        ""
    ];
    if (_taskID != "") then {
        jib_objective_hostageRemaining =
            jib_objective_hostageRemaining - 1;
        [
            _taskID,
            "SUCCEEDED"
        ] call BIS_fnc_taskSetState;
    };
};

// Client side hostage setup
jib_objective_hostageSetup = {
    params ["_hostage", "_injured"];
    if (local _hostage) then {
        _hostage setCaptive true;
        removeAllWeapons _hostage;
        removeBackpack _hostage;
        removeVest _hostage;
        removeAllAssignedItems _hostage;
        _hostage disableAI "all";
        if (_injured) then {
            _hostage setDamage 0.5;
        };
    };
    if (_injured) then {
        _hostage switchMove "Acts_ExecutionVictim_Loop";
    } else {
        _hostage switchMove "Acts_AidlPsitMstpSsurWnonDnon01";
    };
    [
        _hostage,
        "Free Hostage",
        "\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_unbind_ca.paa",
        "\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_unbind_ca.paa",
        "alive _target && _target distance _this < 2 && !captive player",
        "alive _target && _target distance _caller < 2",
        {},
        {},
        {
            params ["_hostage", "_caller", "_actionID", "_arguments"];
            _arguments params ["_injured"];
            [_hostage, _injured, group _caller, _actionID] remoteExec [
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
    params ["_hostage", "_injured", "_group", "_actionID"];
    if (isServer) then {
        [_hostage] call jib_objective_hostageComplete;
    };
    if (_injured) then {
        _hostage playMove "Acts_ExecutionVictim_Unbow";
    } else {
        _hostage switchMove "Acts_AidlPsitMstpSsurWnonDnon_out";
    };
    if (local _hostage) then {
        _hostage enableAI "all";
        [_hostage] join _group;
    };
    [_hostage, _actionID] call BIS_fnc_holdActionRemove;
};

// Setup data terminal none
jib_objective_moduleDataTerminalNone = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached, false, true] call jib_objective_dataTerminal;
        }
    ] call jib_objective_moduleValidate;
};

// Setup data terminal all
jib_objective_moduleDataTerminalAll = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached, true, true] call jib_objective_dataTerminal;
        }
    ] call jib_objective_moduleValidate;
};

// Setup data terminal west
jib_objective_moduleDataTerminalWest = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached, west, true] call jib_objective_dataTerminal;
        }
    ] call jib_objective_moduleValidate;
};

// Setup data terminal east
jib_objective_moduleDataTerminalEast = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached, east, true] call jib_objective_dataTerminal;
        }
    ] call jib_objective_moduleValidate;
};

// Setup data terminal independent
jib_objective_moduleDataTerminalIndependent = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached, independent, true] call jib_objective_dataTerminal;
        }
    ] call jib_objective_moduleValidate;
};

// Setup data terminal civilian
jib_objective_moduleDataTerminalCivilian = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached, civilian, true] call jib_objective_dataTerminal;
        }
    ] call jib_objective_moduleValidate;
};

// Setup hostage none
jib_objective_moduleHostageNone = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached, false, false, true] call jib_objective_hostage;
        }
    ] call jib_objective_moduleValidate;
};

// Setup hostage all
jib_objective_moduleHostageAll = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached, false, true, true] call jib_objective_hostage;
        }
    ] call jib_objective_moduleValidate;
};

// Setup hostage west
jib_objective_moduleHostageWest = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached, false, west, true] call jib_objective_hostage;
        }
    ] call jib_objective_moduleValidate;
};

// Setup hostage east
jib_objective_moduleHostageEast = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached, false, east, true] call jib_objective_hostage;
        }
    ] call jib_objective_moduleValidate;
};

// Setup hostage independent
jib_objective_moduleHostageIndependent = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached, false, independent, true] call jib_objective_hostage;
        }
    ] call jib_objective_moduleValidate;
};

// Setup hostage civilian
jib_objective_moduleHostageCivilian = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [_attached, false, civilian, true] call jib_objective_hostage;
        }
    ] call jib_objective_moduleValidate;
};

// Remote calls
publicVariable "jib_objective_dataTerminalSoundProgress";
publicVariable "jib_objective_dataTerminalSoundComplete";
publicVariable "jib_objective_dataTerminalHoldActionID";
publicVariable "jib_objective_dataTerminalHoldActionIcon";
publicVariable "jib_objective_dataTerminalHoldActionRemove";
publicVariable "jib_objective_dataTerminalHoldActionAdd";
publicVariable "jib_objective_dataTerminalHoldActionStart";
publicVariable "jib_objective_dataTerminalHoldActionProgress";
publicVariable "jib_objective_dataTerminalHoldActionComplete";
publicVariable "jib_objective_dataTerminalHoldActionInterrupt";
publicVariable "jib_objective_hostageSetup";
publicVariable "jib_objective_hostageFree";
publicVariable "jib_objective_moduleDataTerminalNone";
publicVariable "jib_objective_moduleDataTerminalAll";
publicVariable "jib_objective_moduleDataTerminalWest";
publicVariable "jib_objective_moduleDataTerminalEast";
publicVariable "jib_objective_moduleDataTerminalIndependent";
publicVariable "jib_objective_moduleDataTerminalCivilian";
publicVariable "jib_objective_moduleHostageNone";
publicVariable "jib_objective_moduleHostageAll";
publicVariable "jib_objective_moduleHostageWest";
publicVariable "jib_objective_moduleHostageEast";
publicVariable "jib_objective_moduleHostageIndependent";
publicVariable "jib_objective_moduleHostageCivilian";
publicVariable "jib_objective_moduleValidate";

// Add hold action to objects to show markers on alive arrows
jib_objective_intel = {
    params ["_objects", "_compositions", "_message_fn"];
    _compositions apply {
        _x params ["_markers", "_arrows"];
        _markers apply {_x setMarkerAlpha 0};
    };
    [[_objects, _compositions, _message_fn], {
        params ["_objects", "_compositions", "_message_fn"];
        _objects apply {
            [
                _x,
                "Examine Intel",
                "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
                "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
                "true",
                "true",
                {},
                {},
                {
                    params ["_target", "_caller", "_actionId", "_arguments"];
                    _arguments params [
                        "_objects", "_compositions", "_message_fn"
                    ];
                    // _objects apply {deleteVehicle _x};
                    _compositions apply {
                        _x params ["_markers", "_arrows"];
                        private _alive_arrows = _arrows select {!isNull _x};
                        if (count _alive_arrows > count _markers) then {
                            throw "More arrows than markers!";
                        };
                        private _index = 0;
                        _alive_arrows apply {
                            private _marker = _markers # _index;
                            _marker setMarkerPosLocal getPosATL _x;
                            _marker setMarkerAlphaLocal 1;
                            _index = _index + 1;
                        };
                    };
                    hint call _message_fn;
                    uiSleep 10;
                    hintSilent "";
                },
                {},
                [_objects, _compositions, _message_fn],
                5
            ] call BIS_fnc_holdActionAdd;
        };
    }] remoteExec ["spawn", 0, true];
};
