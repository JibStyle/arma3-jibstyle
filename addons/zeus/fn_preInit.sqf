// Activate addons
private _addons = [];
private _cfgPatches = configfile >> "cfgpatches";
for "_i" from 0 to (count _cfgPatches - 1) do {
    _class = _cfgPatches select _i;
    if (isclass _class) then {
        _addons set [count _addons,configname _class];
    };
};
activateAddons _addons;

// Rest server only
if (!isServer) exitWith { "Not server!" };

// Create curator
jib_zeus_group = createGroup sideLogic;
publicVariable "jib_zeus_group";
jib_zeus_curator = jib_zeus_group createUnit [
    "ModuleCurator_F",
    [500,500,0],
    [],
    0,
    "NONE"
];
jib_zeus_curator setVariable ["Addons", 3];
jib_zeus_curator setVariable ["owner", "#adminLogged"];
jib_zeus_curator setVariable [
    "BIS_fnc_initModules_disableAutoActivation", false
];
publicVariable "jib_zeus_curator";

jib_zeus_fnc_ascend = {
    // Assign admin curator
    if (!isServer) exitWith {};

    // Get admin
    if (hasInterface) then {
        jib_zeus_admin = player;
    } else {
        ["JIB zeus ascend checking: %1", allPlayers] call BIS_fnc_logFormat;
        {
            if (admin owner _x > 0) then {
                jib_zeus_admin = _x;
                ["JIB zeus ascend admin: %1", _x] call BIS_fnc_logFormat;
            };
        } forEach allPlayers;
    };

    // Assign curator
    if (getAssignedCuratorUnit jib_zeus_curator != jib_zeus_admin) then {
        unassignCurator jib_zeus_curator;
        waitUntil { isNull getAssignedCuratorUnit jib_zeus_curator };
        jib_zeus_admin assignCurator jib_zeus_curator;
    };
};

// Setup client
jib_zeus_fnc_initClient = {
    // Detect player respawn
    addMissionEventHandler ["EntityRespawned", {
        params ["_newEntity", "_oldEntity"];
        [
            "JIB zeus respawn from %1 to %2",
            _oldEntity,
            _newEntity
        ] call BIS_fnc_logFormat;
        [] remoteExec ["jib_zeus_fnc_ascend", 2];
    }];

    // Detect team switch
    addMissionEventHandler ["TeamSwitch", {
        params ["_previousUnit", "_newUnit"];
        [
            "JIB zeus teamswitch from %1 to %2",
            _previousUnit,
            _newUnit
        ] call BIS_fnc_logFormat;
        [] remoteExec ["jib_zeus_fnc_ascend", 2];
    }];
};
publicVariable "jib_zeus_fnc_initClient";
[] remoteExec ["jib_zeus_fnc_initClient", 0, true];

// Detect mission start
[] spawn {
    waitUntil {
        time > 0
            && count allPlayers > 0
            && count (allPlayers select {local _x}) == 0
    };
    ["JIB zeus mission start allPlayers: %1", allPlayers] call BIS_fnc_logFormat;
    [] call jib_zeus_fnc_ascend;
};

// Detect admin state change
addMissionEventHandler ["OnUserAdminStateChanged", {
    params ["_networkId", "_loggedIn", "_votedIn"];
    [] spawn jib_zeus_fnc_ascend;
}];

// Default Respawn Inventories
{ [_x, true] call BIS_fnc_moduleRespawnInventory } forEach allCurators;
[west, ["B_Protagonist_VR_F"]] call BIS_fnc_setRespawnInventory;
[east, ["O_Protagonist_VR_F"]] call BIS_fnc_setRespawnInventory;
[independent, ["I_Protagonist_VR_F"]] call BIS_fnc_setRespawnInventory;
[civilian, ["C_Protagonist_VR_F"]] call BIS_fnc_setRespawnInventory;

// Make respawn module curator editable
{
    _x addCuratorEditableObjects [
        allMissionObjects "ModuleRespawnPosition_F",
        true
    ];
} forEach allCurators;
