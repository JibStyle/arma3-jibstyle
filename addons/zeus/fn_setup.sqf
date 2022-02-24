// Make admin zeus
if (!isServer) exitWith { "Not server!" };

// Maybe create curator
if (isNil "jib_zeus_curator") then {
    jib_zeus_group = createGroup sideLogic;
    publicVariable "jib_zeus_group";
    "ModuleCurator_F" createUnit [
        [500,500,0],
        jib_zeus_group,
        "this setVariable ['Addons', 3]; this setVariable ['owner', '#adminLogged']; this setVariable ['BIS_fnc_initModules_disableAutoActivation', false]; jib_zeus_curator = this; publicVariable 'jib_zeus_curator'"
    ];
    // jib_zeus_curator = jib_zeus_group createUnit [
    //     "ModuleCurator_F",
    //     [500,500,0],
    //     [],
    //     0,
    //     "NONE"
    // ];
    // jib_zeus_curator setVariable ["Addons", 3];
    // jib_zeus_curator setVariable ["owner", "#adminLogged"];
    // [jib_zeus_curator] spawn BIS_fnc_moduleInit;
    // publicVariable "jib_zeus_curator";
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
