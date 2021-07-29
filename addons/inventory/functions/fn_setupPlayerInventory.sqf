// Setup player inventory custom items
[] spawn {
    waitUntil { alive player };
    if (player isKindOf "B_Soldier_A_F") then {
        [player] call jib_inventory_fnc_setupUnitAmmoBearer;
    };
    [player, "ACE_EarPlugs"] call jib_inventory_fnc_maybeAddItem;
    if (player isKindOf "B_officer_F") then {
        removeBackpack player;
        if (faction player find "BLU_F" >= 0) then {
            player addBackpack "TFAR_rt1523g";
        } else {
            player addBackpack "TFAR_rt1523g_bwmod";
        };
    };
    if (player isKindOf "B_Soldier_SL_F") then {
        removeBackpack player;
        if (faction player find "BLU_F" >= 0) then {
            player addBackpack "TFAR_rt1523g";
        } else {
            player addBackpack "TFAR_rt1523g_bwmod";
        };
        [player, "ACE_CableTie", 2] call jib_inventory_fnc_maybeAddItem;
    };
    switch (rank player) do
    {
        case "PRIVATE": {
	    [player, "ItemMicroDAGR"] call jib_inventory_fnc_maybeAddItem;
	    player linkItem "TFAR_rf7800str";
        };
        case "CORPORAL": {
	    [player, "ItemMicroDAGR"] call jib_inventory_fnc_maybeAddItem;
	    player linkItem "TFAR_rf7800str";
        };
        case "SERGEANT": {
	    [player, "ItemAndroid"] call jib_inventory_fnc_maybeAddItem;
	    player linkItem "TFAR_anprc152";
        };
        default {
	    [player, "ItemAndroid"] call jib_inventory_fnc_maybeAddItem;
	    player linkItem "TFAR_anprc152";
        };
    };
    if (leader player == player) then {
	[player, "Alive_Tablet"] call jib_inventory_fnc_maybeAddItem;
    };
    call jib_inventory_fnc_client_loadoutSave;
};
