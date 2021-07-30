class CfgVehicles {

    class B_T_Officer_F;
    class JIB_B_T_Officer_F : B_T_Officer_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        backpack = "TFAR_rt1523g_green";
        magazines[] = {"30Rnd_65x39_caseless_khaki_mag","30Rnd_65x39_caseless_khaki_mag","30Rnd_65x39_caseless_khaki_mag","30Rnd_65x39_caseless_khaki_mag","11Rnd_45ACP_Mag","11Rnd_45ACP_Mag","11Rnd_45ACP_Mag","SmokeShell","SmokeShellGreen","Chemlight_green","Chemlight_green","Laserbatteries"};
        respawnMagazines[] = {"30Rnd_65x39_caseless_khaki_mag","30Rnd_65x39_caseless_khaki_mag","30Rnd_65x39_caseless_khaki_mag","30Rnd_65x39_caseless_khaki_mag","11Rnd_45ACP_Mag","11Rnd_45ACP_Mag","11Rnd_45ACP_Mag","SmokeShell","SmokeShellGreen","Chemlight_green","Chemlight_green","Laserbatteries"};
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie"),"ItemcTab","ALIVE_Tablet"};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie"),"ItemcTab","ALIVE_Tablet"};
        linkedItems[] = {"H_MilCap_tna_F","V_BandollierB_rgr","ItemGPS","ItemMap","ItemCompass","B_UavTerminal","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_MilCap_tna_F","V_BandollierB_rgr","ItemGPS","ItemMap","ItemCompass","B_UavTerminal","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        weapons[] = {"arifle_MXC_khk_ACO_F","hgun_Pistol_heavy_01_F","Throw","Put","Laserdesignator_01_khk_F"};
        respawnWeapons[] = {"arifle_MXC_khk_ACO_F","hgun_Pistol_heavy_01_F","Throw","Put","Laserdesignator_01_khk_F"};
    };

    class B_T_Soldier_SL_F;
    class JIB_B_T_Soldier_SL_F : B_T_Soldier_SL_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        backpack = "TFAR_rt1523g_green";
        magazines[] = {mag_4("30Rnd_65x39_caseless_khaki_mag"),mag_2("30Rnd_65x39_caseless_khaki_mag_Tracer"),mag_3("16Rnd_9x21_Mag"),"HandGrenade","HandGrenade","B_IR_Grenade","B_IR_Grenade","SmokeShell","SmokeShellGreen","SmokeShellBlue","SmokeShellOrange","Chemlight_green","Chemlight_green","Laserbatteries"};
        respawnMagazines[] = {mag_4("30Rnd_65x39_caseless_khaki_mag"),mag_2("30Rnd_65x39_caseless_khaki_mag_Tracer"),mag_3("16Rnd_9x21_Mag"),"HandGrenade","HandGrenade","B_IR_Grenade","B_IR_Grenade","SmokeShell","SmokeShellGreen","SmokeShellBlue","SmokeShellOrange","Chemlight_green","Chemlight_green","Laserbatteries"};
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie"),"ItemcTab","ALIVE_Tablet"};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie"),"ItemcTab","ALIVE_Tablet"};
        linkedItems[] = {"H_HelmetB_Enh_tna_F","V_PlateCarrierGL_tna_F","ItemMap","ItemCompass","B_UavTerminal","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnlinkedItems[] = {"H_HelmetB_Enh_tna_F","V_PlateCarrierGL_tna_F","ItemMap","ItemCompass","B_UavTerminal","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        weapons[] = {"arifle_MX_khk_Hamr_Pointer_F","hgun_P07_khk_F","Throw","Put","Laserdesignator_01_khk_F"};
        respawnWeapons[] = {"arifle_MX_khk_Hamr_Pointer_F","hgun_P07_khk_F","Throw","Put","Laserdesignator_01_khk_F"};
    };

    class B_T_Soldier_TL_F;
    class JIB_B_T_Soldier_TL_F : B_T_Soldier_TL_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_Enh_tna_F","V_PlateCarrierGL_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","TFAR_anprc152","NVGoggles_tna_F"};
        respawnlinkedItems[] = {"H_HelmetB_Enh_tna_F","V_PlateCarrierGL_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","TFAR_anprc152","NVGoggles_tna_F"};
    };

    class B_Carryall_oli_BTAmmo_F;
    class JIB_B_Carryall_oli_BTAmmo_F : B_Carryall_oli_BTAmmo_F {
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

    class B_T_Soldier_A_F;
    class JIB_B_T_Soldier_A_F : B_T_Soldier_A_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        backpack = "JIB_B_Carryall_oli_BTAmmo_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_tna_F","V_PlateCarrier1_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_tna_F","V_PlateCarrier1_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_Kitbag_rgr_AAR;
    class JIB_B_Kitbag_rgr_AAR : B_Kitbag_rgr_AAR {
        scope = 1;
        class TransportItems {
            item_xx(muzzle_snds_H,1);
        };
        class TransportMagazines {
            mag_xx(100Rnd_65x39_caseless_khaki_mag,4);
            mag_xx(100Rnd_65x39_caseless_khaki_mag_tracer,4);
        };
    };

    class B_T_Soldier_AAR_F;
    class JIB_B_T_Soldier_AAR_F : B_T_Soldier_AAR_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        backpack = "JIB_B_Kitbag_rgr_AAR";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_Light_tna_F","V_Chestrig_rgr","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_Light_tna_F","V_Chestrig_rgr","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_Carryall_oli_BTAAT_F;
    class JIB_B_Carryall_oli_BTAAT_F : B_Carryall_oli_BTAAT_F {
        scope = 1;
        class TransportMagazines {
            mag_xx(Titan_AT,3);
        };
    };

    class B_T_Soldier_AAT_F;
    class JIB_B_T_Soldier_AAT_F : B_T_Soldier_AAT_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        backpack = "JIB_B_Carryall_oli_BTAAT_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_Light_tna_F","V_Chestrig_rgr","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_Light_tna_F","V_Chestrig_rgr","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Soldier_AAA_F;
    class JIB_B_T_Soldier_AAA_F : B_T_Soldier_AAA_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_Light_tna_F","V_Chestrig_rgr","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_Light_tna_F","V_Chestrig_rgr","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Engineer_F;
    class JIB_B_T_Engineer_F : B_T_Engineer_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_Clacker","ACE_DefusalKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie"),"ACE_EntrenchingTool"};
        respawnItems[] = {"FirstAidKit","ACE_Clacker","ACE_DefusalKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie"),"ACE_EntrenchingTool"};
        linkedItems[] = {"H_HelmetB_tna_F","V_Chestrig_rgr","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_tna_F","V_Chestrig_rgr","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Medic_F;
    class JIB_B_T_Medic_F : B_T_Medic_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_Light_tna_F","V_PlateCarrierSpec_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_Light_tna_F","V_PlateCarrierSpec_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_soldier_M_F;
    class JIB_B_T_soldier_M_F : B_T_soldier_M_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_tna_F","V_PlateCarrier1_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_tna_F","V_PlateCarrier1_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Soldier_LAT2_F;
    class JIB_B_T_Soldier_LAT2_F : B_T_Soldier_LAT2_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_tna_F","V_PlateCarrier2_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_tna_F","V_PlateCarrier2_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Soldier_AT_F;
    class JIB_B_T_Soldier_AT_F : B_T_Soldier_AT_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_Light_tna_F","V_PlateCarrier1_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_Light_tna_F","V_PlateCarrier1_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Soldier_AA_F;
    class JIB_B_T_Soldier_AA_F : B_T_Soldier_AA_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_Light_tna_F","V_PlateCarrier1_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_Light_tna_F","V_PlateCarrier1_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Soldier_AR_F;
    class JIB_B_T_Soldier_AR_F : B_T_Soldier_AR_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_tna_F","V_PlateCarrier2_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_tna_F","V_PlateCarrier2_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Soldier_GL_F;
    class JIB_B_T_Soldier_GL_F : B_T_Soldier_GL_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_Enh_tna_F","V_PlateCarrierGL_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_Enh_tna_F","V_PlateCarrierGL_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Soldier_F;
    class JIB_B_T_Soldier_F : B_T_Soldier_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_tna_F","V_PlateCarrier1_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_tna_F","V_PlateCarrier1_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Helipilot_F;
    class JIB_B_T_Helipilot_F : B_T_Helipilot_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50"};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50"};
        linkedItems[] = {"V_TacVest_blk","H_PilotHelmetHeli_B","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"V_TacVest_blk","H_PilotHelmetHeli_B","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Helicrew_F;
    class JIB_B_T_Helicrew_F : B_T_Helicrew_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50"};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50"};
        linkedItems[] = {"V_TacVest_blk","H_CrewHelmetHeli_B","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"V_TacVest_blk","H_CrewHelmetHeli_B","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Pilot_F;
    class JIB_B_T_Pilot_F : B_T_Pilot_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50"};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50"};
        linkedItems[] = {"H_PilotHelmetFighter_B","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio"};
        respawnLinkedItems[] = {"H_PilotHelmetFighter_B","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio"};
    };

    class B_T_Crew_F;
    class JIB_B_T_Crew_F : B_T_Crew_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50"};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50"};
        linkedItems[] = {"H_HelmetCrew_B","V_BandollierB_rgr","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetCrew_B","V_BandollierB_rgr","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Soldier_UAV_F;
    class JIB_B_T_Soldier_UAV_F : B_T_Soldier_UAV_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie"),"ItemMicroDAGR"};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie"),"ItemMicroDAGR"};
        linkedItems[] = {"H_HelmetB_tna_F","V_PlateCarrierSpec_tna_F","ItemMap","ItemCompass","B_UavTerminal","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_tna_F","V_PlateCarrierSpec_tna_F","ItemMap","ItemCompass","B_UavTerminal","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Soldier_PG_F;
    class JIB_B_T_Soldier_PG_F : B_T_Soldier_PG_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_tna_F","V_PlateCarrierSpec_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_tna_F","V_PlateCarrierSpec_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_soldier_mine_F;
    class JIB_B_T_soldier_mine_F : B_T_soldier_mine_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_Clacker","ACE_DefusalKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_Clacker","ACE_DefusalKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_Enh_tna_F","V_PlateCarrierGL_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_Enh_tna_F","V_PlateCarrierGL_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Soldier_Exp_F;
    class JIB_B_T_Soldier_Exp_F : B_T_Soldier_Exp_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_Clacker","ACE_DefusalKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_Clacker","ACE_DefusalKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_Enh_tna_F","V_PlateCarrierGL_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_Enh_tna_F","V_PlateCarrierGL_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Soldier_Repair_F;
    class JIB_B_T_Soldier_Repair_F : B_T_Soldier_Repair_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_Light_tna_F","V_PlateCarrier1_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_Light_tna_F","V_PlateCarrier1_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Soldier_LAT_F;
    class JIB_B_T_Soldier_LAT_F : B_T_Soldier_LAT_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"H_HelmetB_tna_F","V_PlateCarrier2_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"H_HelmetB_tna_F","V_PlateCarrier2_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_T_Soldier_unarmed_F;
    class JIB_B_T_Soldier_unarmed_F : B_T_Soldier_unarmed_F {
        author = "JibStyle";
        faction = "JIB_BLU_T_F";
        items[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        respawnItems[] = {"FirstAidKit","ACE_EarPlugs","ACE_MapTools","ACE_Flashlight_XL50",mag_2("ACE_CableTie")};
        linkedItems[] = {"V_PlateCarrier1_tna_F","H_HelmetB_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
        respawnLinkedItems[] = {"V_PlateCarrier1_tna_F","H_HelmetB_tna_F","ItemMap","ItemCompass","ItemMicroDAGR","ItemWatch","ItemRadio","NVGoggles_tna_F"};
    };

    class B_Survivor_F;
    class JIB_B_Wildman_F : B_Survivor_F {
        author = "JibStyle";
        displayName = "Wildman";
        faction = "JIB_BLU_F";
        editorPreview = "jib_factions\data\images\B_JIB_NATO_Wildman_01.jpg";
        items[] = {mag_10("ACE_Banana")};
        linkedItems[] = {"ItemMicroDAGR","TFAR_anprc152"};
        respawnlinkedItems[] = {"ItemMicroDAGR","TFAR_anprc152"};
    };

    class B_SupplyCrate_F;
    class JIB_B_SupplyCrate : B_SupplyCrate_F {
        author = "JibStyle";
        displayName = "JIB NATO Supply Crate";
        class TransportItems {
            item_xx(TFAR_anprc152,10);
            item_xx(ItemMicroDAGR,10);
            item_xx(ACE_EarPlugs,10);
        };
    };

};
