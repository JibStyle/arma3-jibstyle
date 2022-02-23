// Make admin zeus
if (!isServer) exitWith { "Not server!" };

// Maybe create curator
if (isNil "jib_zeus_curator") then {
    jib_zeus_group = createGroup sideLogic;
    jib_zeus_curator = jib_zeus_group createUnit [
        "ModuleCurator_F",
        [500,500,0],
        [],
        0.5,
        "NONE"
    ];
    publicVariable "jib_zeus_group";
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
[jib_zeus_admin, jib_zeus_curator] spawn {
    params ["_admin", "_curator"];
    unassignCurator _curator;
    waitUntil { isNull (getAssignedCuratorUnit _curator) };
    _admin assignCurator _curator;
};
