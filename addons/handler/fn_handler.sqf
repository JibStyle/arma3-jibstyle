// Declare event handlers to register
if (!isServer) exitWith {};

// Mission start handlers dependency.
//
// Handler gets no params. Run on server.
jib_handler_missionStart = [];

// Mission event handlers dependency for entity respawned.
//
// Handler params ["_oldUnit", "_newUnit"]. Run on server.
jib_handler_missionEntityRespawned = [];

// Mission event handlers dependency for team switch.
//
// Handler params ["_oldUnit", "_newUnit"]. Run on server.
jib_handler_missionTeamSwitch = [];

// Mission event handlers dependency for admin state change.
//
// Handler gets no params. Run on server.
jib_handler_missionOnUserAdminStateChanged = [];

// Integration finished, run startup handlers.
jib_handler_integrationDone = {
    if (!isServer) then {throw "Not server!"};
    jib_handler_missionStart apply {[] call _x;};
    [] call jib_handler_missionUninstall;
    [] call jib_handler_missionInstall;
};

// Check if in main menu.
jib_handler_isMainMenu = {
    // https://forums.bohemia.net/forums/topic/224307-solved-prevent-function-initialization-in-main-menu/
    allDisplays isEqualTo [findDisplay 0];
};

// PRIVATE

// Install mission event handlers.
jib_handler_missionInstall = {
    missionNamespace setVariable [
        jib_handler_varMissionEntityRespawned,
        addMissionEventHandler ["EntityRespawned", {
            // NOTE: Params swapped
            params ["_newEntity", "_oldEntity"];
            jib_handler_missionEntityRespawned apply {
                [_oldEntity, _newEntity] call _x
            };
        }]
    ];
    missionNamespace setVariable [
        jib_handler_varMissionTeamSwitch,
        addMissionEventHandler ["TeamSwitch", {
            params ["_previousUnit", "_newUnit"];
            jib_handler_missionTeamSwitch apply {
                [_previousUnit, _newUnit] call _x;
            };
        }]
    ];
    missionNamespace setVariable [
        jib_handler_varMissionOnUserAdminStateChanged,
        addMissionEventHandler ["OnUserAdminStateChanged", {
            // NOTE: Params discarded
            params ["_networkId", "_loggedIn", "_votedIn"];
            jib_handler_missionOnUserAdminStateChanged apply {
                [] call _x;
            };
        }]
    ];
};

// Uninstall mission event handlers.
jib_handler_missionUninstall = {
    removeMissionEventHandler [
        "EntityRespawned",
        missionNamespace getVariable [
            jib_handler_varMissionEntityRespawned,
            -1
        ]
    ];
    removeMissionEventHandler [
        "TeamSwitch",
        missionNamespace getVariable [
            jib_handler_varMissionTeamSwitch,
            -1
        ]
    ];
    removeMissionEventHandler [
        "OnUserAdminStateChanged",
        missionNamespace getVariable [
            jib_handler_varMissionOnUserAdminStateChanged,
            -1
        ]
    ];
};

jib_handler_varMissionEntityRespawned =
    "jib_handler_idMissionEntityRespawned";
jib_handler_varMissionTeamSwitch =
    "jib_handler_idMissionTeamSwitch";
jib_handler_varMissionOnUserAdminStateChanged =
    "jib_handler_idMissionOnUserAdminStateChanged";

// Publish variables and functions
publicVariable "jib_handler_isMainMenu";
publicVariable "jib_handler_missionStart";
publicVariable "jib_handler_integrationDone";
