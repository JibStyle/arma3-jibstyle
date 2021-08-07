/// Backpacks

// Ammo Bearer
class B_Carryall_oli_BTAmmo_F;
class JIB_P_B_Carryall_oli_BTAmmo_F : B_Carryall_oli_BTAmmo_F {
    scope = 1;
    class TransportItems {
        ITEM_XX(ACE_fieldDressing,4);
        ITEM_XX(ACE_packingBandage,4);
        ITEM_XX(ACE_morphine,4);
        ITEM_XX(ACE_tourniquet,4);
    };
    class TransportMagazines {
        MAG_XX(100Rnd_65x39_caseless_khaki_mag,2);
        MAG_XX(1Rnd_HE_Grenade_shell,3);
        MAG_XX(30Rnd_65x39_caseless_khaki_mag,6);
        MAG_XX(MRAWS_HEAT_F,2);
        MAG_XX(HandGrenade,2);
        MAG_XX(MiniGrenade,2);
    };
};

// Assistant AR
class B_Kitbag_rgr_AAR;
class JIB_P_B_Kitbag_rgr_AAR : B_Kitbag_rgr_AAR {
    scope = 1;
    class TransportItems {
        ITEM_XX(muzzle_snds_H,1);
    };
    class TransportMagazines {
        MAG_XX(100Rnd_65x39_caseless_khaki_mag,4);
        MAG_XX(100Rnd_65x39_caseless_khaki_mag_tracer,4);
    };
};

// Assistant AT
class B_Carryall_oli_BTAAT_F;
class JIB_P_B_Carryall_oli_BTAAT_F : B_Carryall_oli_BTAAT_F {
    scope = 1;
    class TransportMagazines {
        MAG_XX(Titan_AT,3);
    };
};

/// Misc

// Wildman
class B_Survivor_F;
class JIB_P_B_Wildman_F : B_Survivor_F {
    author = "JibStyle";
    displayName = "Wildman";
    faction = "JIB_P_BLU_F";
    editorPreview = "x\jib\addons\jib_factions\images\B_JIB_NATO_Wildman_01.jpg";
    items[] = {MAG_9("ACE_Banana")};
    linkedItems[] = {"ItemMicroDAGR","TFAR_anprc152"};
    respawnlinkedItems[] = {"ItemMicroDAGR","TFAR_anprc152"};
};

// Supply Crate
class B_SupplyCrate_F;
class JIB_P_B_SupplyCrate : B_SupplyCrate_F {
    author = "JibStyle";
    displayName = "JIB NATO Supply Crate";
    class TransportItems {
        ITEM_XX(TFAR_anprc152,10);
        ITEM_XX(ItemMicroDAGR,10);
        ITEM_XX(ACE_EarPlugs,10);
    };
};
