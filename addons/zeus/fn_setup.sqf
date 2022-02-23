// Make admin zeus
if (!isServer) exitWith { "Not server!" };

// Maybe create curator
if (isNil "my_curator_zeus") then {
    my_group_zeus = createGroup sideLogic;
    my_curator_zeus = my_group_zeus createUnit [
        "ModuleCurator_F",
        [500,500,0],
        [],
        0.5,
        "NONE"
    ];
    publicVariable "my_group_zeus";
    publicVariable "my_curator_zeus";
};

// Get admin
if (isNil "my_unit_admin" || { not alive my_unit_admin }) then {
    if (isServer && hasInterface) then {
        my_unit_admin = player;
    } else {
        {
            if (admin owner _x > 0) then { my_unit_admin = _x };
        } forEach allPlayers;
    };
    publicVariable "my_unit_admin";
};

// Assign curator
[my_unit_admin, my_curator_zeus] spawn {
    params ["_admin", "_curator"];
    unassignCurator _curator;
    waitUntil { isNull (getAssignedCuratorUnit _curator) };
    _admin assignCurator _curator;
};
