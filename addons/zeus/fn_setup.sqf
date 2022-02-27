// Make admin zeus
if (!isServer) exitWith { "Not server!" };

// Maybe create curator
if (isNil "jib_zeus_curator") then {
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
};

// Get admin
if (isNil "jib_zeus_admin" || { not alive jib_zeus_admin }) then {
    if (isServer && hasInterface) then {
        jib_zeus_admin = player;
    } else {
        {
            if (admin owner _x > 0) then { jib_zeus_admin = _x };
        } forEach allPlayers;
    };
    publicVariable "jib_zeus_admin";
};

// Assign curator
[] spawn {
    waitUntil { not isNil "jib_zeus_curator" };
    unassignCurator jib_zeus_curator;
    waitUntil { isNull (getAssignedCuratorUnit jib_zeus_curator) };
    jib_zeus_admin assignCurator jib_zeus_curator;
};

// Handle Zeus Respawn
if (isNil "jib_zeus_registeredEntityRespawnedEH") then {
    addMissionEventHandler ["EntityRespawned", {
        params ["_newEntity", "_oldEntity"];
        private _curator = getAssignedCuratorLogic _oldEntity;
        if (isNull _curator) exitWith {};
        unassignCurator _curator;
        waitUntil { isNull (getAssignedCuratorUnit _curator) };
        _newEntity assignCurator _curator;
    }];
};
jib_zeus_registeredEntityRespawnedEH = true;
