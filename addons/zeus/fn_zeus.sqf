// Zeus functions
if (!isServer) exitWith { "Not server!" };

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_zeus_moduleValidate = {};

// Logging dependency.
jib_zeus_log = {};

// Select player dependency.
jib_zeus_selectPlayer = {};

// Event handler for select player.
jib_zeus_selectPlayerHandler = {
    params ["_oldUnit", "_newUnit"];
    [_oldUnit, _newUnit] remoteExec ["jib_zeus_transfer", 2];
    [false, false] call BIS_fnc_forceCuratorInterface;
};

// PRIVATE

// Register mission event handlers
removeMissionEventHandler [
    "EntityRespawned",
    missionNamespace getVariable ["jib_zeus_handlerEntityRespawned", -1]
];
missionNamespace setVariable [
    "jib_zeus_handlerEntityRespawned",
    addMissionEventHandler ["EntityRespawned", {
        params ["_newUnit", "_oldUnit"];
        [_oldUnit, _newUnit] spawn jib_zeus_transfer;
        allCurators apply {
            if (_oldUnit in curatorEditableObjects _x) then {
                _x addCuratorEditableObjects [[_newUnit], true];
            };
        };
    }]
];
removeMissionEventHandler [
    "TeamSwitch",
    missionNamespace getVariable ["jib_zeus_handlerTeamSwitch", -1]
];
missionNamespace setVariable [
    "jib_zeus_handlerTeamSwitch",
    addMissionEventHandler ["TeamSwitch", {
        params ["_oldUnit", "_newUnit"];
        [_oldUnit, _newUnit] spawn jib_zeus_transfer;
    }]
];
removeMissionEventHandler [
    "OnUserAdminStateChanged",
    missionNamespace getVariable [
        "jib_zeus_handlerOnUserAdminStateChanged", -1
    ]
];
missionNamespace setVariable [
    "jib_zeus_handlerOnUserAdminStateChanged",
    addMissionEventHandler ["OnUserAdminStateChanged", {
        params ["_networkId", "_loggedIn", "_votedIn"];
        [] call jib_zeus_adminAssign;
    }]
];

// Get admin
jib_zeus_admin = {
    private _admin = objNull;
    if (hasInterface) then {
        _admin = player;
    } else {
        allPlayers apply {
            if (admin owner _x > 0) then {
                _admin = _x;
            };
        };
    };
    _admin;
};

// Assign admin curator
jib_zeus_adminAssign = {
    if (!isServer) then {throw "Not server!"};
    [] spawn {
        waitUntil {
            uiSleep 0.5;
            private _admin = [] call jib_zeus_admin;
            alive _admin || damage _admin == 1;
        };
        private _admin = [] call jib_zeus_admin;
        if (!alive _admin) then {
            [_admin, jib_zeus_virtualCurator] call jib_zeus_selectPlayer;
            [jib_zeus_curator, jib_zeus_virtualCurator] call jib_zeus_assign;
        } else {
            [jib_zeus_curator, _admin] call jib_zeus_assign;
        };
    };
};

// Create special curator for admin
jib_zeus_adminCreate = {
    if (!isServer) then {throw "Not server!"};
    jib_zeus_curator = createGroup sideLogic createUnit [
        "ModuleCurator_F",
        [500,500,10],
        [],
        0,
        "NONE"
    ];
    jib_zeus_curator setVariable ["Addons", 3];
    jib_zeus_curator setVariable ["owner", ""];
    jib_zeus_curator setVariable [
        "BIS_fnc_initModules_disableAutoActivation", false
    ];
    jib_zeus_virtualCurator = group jib_zeus_curator createUnit [
        "VirtualCurator_F",
        [500,500,10],
        [],
        0,
        "NONE"
    ];
};

// Assign curator to unit
jib_zeus_assign = {
    params ["_curator", "_unit"];
    if (!isServer) then {throw "Not server!"};
    if (!canSuspend) then {throw "Cannot suspend!"};
    if (!alive _unit) then {throw "Unit not alive!"};
    private _objects = curatorEditableObjects _curator;
    unassignCurator _curator;
    waitUntil { isNull getAssignedCuratorUnit _curator };
    _unit assignCurator _curator;
    waitUntil { getAssignedCuratorUnit _curator == _unit };
    _curator addCuratorEditableObjects [_objects, false];
};

// Transfer curator between units
jib_zeus_transfer = {
    params ["_oldUnit", "_newUnit"];
    if (!isServer) then {throw "Not server!"};
    [
        format ["jib_zeus_transfer [%1, %2]", _oldUnit, _newUnit]
    ] call jib_zeus_log;
    private _curator = getAssignedCuratorLogic _oldUnit;
    if (not isNull _curator) then {
        [_curator, _newUnit] spawn jib_zeus_assign;
    };
};

// Default Respawn Inventories
jib_zeus_setupInventory = {
    params ["_curators"];
    [
        format ["jib_zeus_setupInventory [%1]", _curators]
    ] call jib_zeus_log;
    {
        [
            _x,  // Curator
            true // true for all, false for units curator can place
        ] call BIS_fnc_moduleRespawnInventory
    } forEach _curators;
    [west, ["B_Protagonist_VR_F"]] call BIS_fnc_setRespawnInventory;
    [east, ["O_Protagonist_VR_F"]] call BIS_fnc_setRespawnInventory;
    [independent, ["I_Protagonist_VR_F"]] call BIS_fnc_setRespawnInventory;
    [civilian, ["C_Protagonist_VR_F"]] call BIS_fnc_setRespawnInventory;
};

// Add respawn positions to curators
jib_zeus_addRespawnPositions = {
    params ["_curators"];
    if (!isServer) then {throw "Not server!"};
    [
        format [
            "jib_zeus_addRespawnPositions [%1, %2]",
            _curators,
            allMissionObjects "ModuleRespawnPosition_F"
        ]
    ] call jib_zeus_log;
    _curators apply {
        _x addCuratorEditableObjects [
            allMissionObjects "ModuleRespawnPosition_F",
            true
        ];
    };
};

// Get all players and their vehicles
jib_zeus_allPlayers = {
    allPlayers + allPlayers apply {vehicle _x};
};

// Get all units and their vehicles
jib_zeus_allUnits = {
    allUnits + allUnits apply {vehicle _x};
};

// Get all logics
jib_zeus_allLogics = {
    units sideLogic;
};

// Get all units and vehicles of a side
jib_zeus_allUnitsSide = {
    params ["_side"];
    allUnits + vehicles select {side _x == _side};
};

jib_zeus_moduleAddAllPlayers = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_curator"];
            _curator addCuratorEditableObjects [
                [] call jib_zeus_allPlayers,
                true
            ];
        },
        [getAssignedCuratorLogic player]
    ] call jib_zeus_moduleValidate;
};

jib_zeus_moduleRemoveAllPlayers = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_curator"];
            _curator removeCuratorEditableObjects [
                [] call jib_zeus_allPlayers,
                true
            ];
        },
        [getAssignedCuratorLogic player]
    ] call jib_zeus_moduleValidate;
};

jib_zeus_moduleAddAllUnits = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_curator"];
            _curator addCuratorEditableObjects [
                [] call jib_zeus_allUnits,
                true
            ];
        },
        [getAssignedCuratorLogic player]
    ] call jib_zeus_moduleValidate;
};

jib_zeus_moduleRemoveAllUnits = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_curator"];
            _curator removeCuratorEditableObjects [
                [] call jib_zeus_allUnits,
                true
            ];
        },
        [getAssignedCuratorLogic player]
    ] call jib_zeus_moduleValidate;
};

jib_zeus_moduleAddAllDead = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_curator"];
            _curator addCuratorEditableObjects [
                allDead,
                true
            ];
        },
        [getAssignedCuratorLogic player]
    ] call jib_zeus_moduleValidate;
};

jib_zeus_moduleRemoveAllDead = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_curator"];
            _curator removeCuratorEditableObjects [
                allDead,
                true
            ];
        },
        [getAssignedCuratorLogic player]
    ] call jib_zeus_moduleValidate;
};

jib_zeus_moduleAddAllLogic = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_curator"];
            _curator addCuratorEditableObjects [
                [] call jib_zeus_allLogics,
                true
            ];
        },
        [getAssignedCuratorLogic player]
    ] call jib_zeus_moduleValidate;
};

jib_zeus_moduleRemoveAllLogic = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_curator"];
            _curator removeCuratorEditableObjects [
                [] call jib_zeus_allLogics,
                true
            ];
        },
        [getAssignedCuratorLogic player]
    ] call jib_zeus_moduleValidate;
};

jib_zeus_moduleAddAllWest = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_curator"];
            _curator addCuratorEditableObjects [
                [west] call jib_zeus_allUnitsSide,
                true
            ];
        },
        [getAssignedCuratorLogic player]
    ] call jib_zeus_moduleValidate;
};

jib_zeus_moduleRemoveAllWest = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_curator"];
            _curator removeCuratorEditableObjects [
                [west] call jib_zeus_allUnitsSide,
                true
            ];
        },
        [getAssignedCuratorLogic player]
    ] call jib_zeus_moduleValidate;
};

jib_zeus_moduleAddAllEast = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_curator"];
            _curator addCuratorEditableObjects [
                [east] call jib_zeus_allUnitsSide,
                true
            ];
        },
        [getAssignedCuratorLogic player]
    ] call jib_zeus_moduleValidate;
};

jib_zeus_moduleRemoveAllEast = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_curator"];
            _curator removeCuratorEditableObjects [
                [east] call jib_zeus_allUnitsSide,
                true
            ];
        },
        [getAssignedCuratorLogic player]
    ] call jib_zeus_moduleValidate;
};

jib_zeus_moduleAddAllIndependent = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_curator"];
            _curator addCuratorEditableObjects [
                [independent] call jib_zeus_allUnitsSide,
                true
            ];
        },
        [getAssignedCuratorLogic player]
    ] call jib_zeus_moduleValidate;
};

jib_zeus_moduleRemoveAllIndependent = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_curator"];
            _curator removeCuratorEditableObjects [
                [independent] call jib_zeus_allUnitsSide,
                true
            ];
        },
        [getAssignedCuratorLogic player]
    ] call jib_zeus_moduleValidate;
};

jib_zeus_moduleAddAllCivilian = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_curator"];
            _curator addCuratorEditableObjects [
                [civilian] call jib_zeus_allUnitsSide,
                true
            ];
        },
        [getAssignedCuratorLogic player]
    ] call jib_zeus_moduleValidate;
};

jib_zeus_moduleRemoveAllCivilian = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_curator"];
            _curator removeCuratorEditableObjects [
                [civilian] call jib_zeus_allUnitsSide,
                true
            ];
        },
        [getAssignedCuratorLogic player]
    ] call jib_zeus_moduleValidate;
};

// Publish variables
publicVariable "jib_zeus_log";
publicVariable "jib_zeus_moduleAddAllPlayers";
publicVariable "jib_zeus_moduleRemoveAllPlayers";
publicVariable "jib_zeus_moduleAddAllUnits";
publicVariable "jib_zeus_moduleRemoveAllUnits";
publicVariable "jib_zeus_moduleAddAllDead";
publicVariable "jib_zeus_moduleRemoveAllDead";
publicVariable "jib_zeus_moduleAddAllLogic";
publicVariable "jib_zeus_moduleRemoveAllLogic";
publicVariable "jib_zeus_moduleAddAllWest";
publicVariable "jib_zeus_moduleRemoveAllWest";
publicVariable "jib_zeus_moduleAddAllEast";
publicVariable "jib_zeus_moduleRemoveAllEast";
publicVariable "jib_zeus_moduleAddAllIndependent";
publicVariable "jib_zeus_moduleRemoveAllIndependent";
publicVariable "jib_zeus_moduleAddAllCivilian";
publicVariable "jib_zeus_moduleRemoveAllCivilian";
publicVariable "jib_zeus_moduleValidate";

// Init zeus module.
jib_zeus_init = {
    if (!isServer) then {throw "Not server!"};
    [] call jib_zeus_adminCreate;
    [allCurators] call jib_zeus_setupInventory;
    [allCurators] call jib_zeus_addRespawnPositions;
    [] call jib_zeus_adminAssign;
};

jib_zeus = jib_zeus_adminAssign;
