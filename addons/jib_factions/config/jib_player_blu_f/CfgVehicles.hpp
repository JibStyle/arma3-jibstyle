/// Backpacks

// Ammo Bearer
class B_Carryall_oli_BTAmmo_F;
class JIB_P_B_Carryall_oli_BTAmmo_F : B_Carryall_oli_BTAmmo_F {
    scope = 1;
    class TransportItems {
        item_xx(ACE_fieldDressing,4);
        item_xx(ACE_packingBandage,4);
        item_xx(ACE_morphine,4);
        item_xx(ACE_tourniquet,4);
    };
    class TransportMagazines {
        mag_xx(100Rnd_65x39_caseless_khaki_mag,2);
        mag_xx(1Rnd_HE_Grenade_shell,3);
        mag_xx(30Rnd_65x39_caseless_khaki_mag,6);
        mag_xx(MRAWS_HEAT_F,2);
        mag_xx(HandGrenade,2);
        mag_xx(MiniGrenade,2);
    };
};

// Assistant AR
class B_Kitbag_rgr_AAR;
class JIB_P_B_Kitbag_rgr_AAR : B_Kitbag_rgr_AAR {
    scope = 1;
    class TransportItems {
        item_xx(muzzle_snds_H,1);
    };
    class TransportMagazines {
        mag_xx(100Rnd_65x39_caseless_khaki_mag,4);
        mag_xx(100Rnd_65x39_caseless_khaki_mag_tracer,4);
    };
};

// Assistant AT
class B_Carryall_oli_BTAAT_F;
class JIB_P_B_Carryall_oli_BTAAT_F : B_Carryall_oli_BTAAT_F {
    scope = 1;
    class TransportMagazines {
        mag_xx(Titan_AT,3);
    };
};

/// Misc

// Wildman
class B_Survivor_F;
class JIB_P_B_Wildman_F : B_Survivor_F {
    author = "JibStyle";
    displayName = "Wildman";
    faction = "JIB_P_BLU_F";
    editorPreview = "jib_factions\data\images\B_JIB_NATO_Wildman_01.jpg";
    items[] = {mag_9("ACE_Banana")};
    linkedItems[] = {"ItemMicroDAGR","TFAR_anprc152"};
    respawnlinkedItems[] = {"ItemMicroDAGR","TFAR_anprc152"};
};

// Supply Crate
class B_SupplyCrate_F;
class JIB_P_B_SupplyCrate : B_SupplyCrate_F {
    author = "JibStyle";
    displayName = "JIB NATO Supply Crate";
    class TransportItems {
        item_xx(TFAR_anprc152,10);
        item_xx(ItemMicroDAGR,10);
        item_xx(ACE_EarPlugs,10);
    };
};
