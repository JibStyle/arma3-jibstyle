class jib_usarmy_wd
{
    name="JIB US Army (woodland)";
    class infantry
    {
        name="Infantry";
        class infantry_company_hq
        {
            name="$STR_RHSUSF_GROUPS_COMPANY_HQ";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_hq.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_officer";
                rank="CAPTAIN";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_officer";
                rank="LIEUTENANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman_m4";
                rank="PRIVATE";
                position[]={5,0,0};
            };
        };
        class infantry_platoon_hq
        {
            name="$STR_RHSUSF_GROUPS_PLATOON_HQ";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_hq.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_officer";
                rank="LIEUTENANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_medic";
                rank="SERGEANT";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman_m4";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman_m4";
                rank="PRIVATE";
                position[]={9,0,0};
            };
        };
        class infantry_squad
        {
            name="$STR_RHSUSF_GROUPS_SQUAD";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={13,0,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class infantry_weaponsquad
        {
            name="$STR_RHSUSF_GROUPS_WEAPONSQUAD";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="CORPORAL";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="CORPORAL";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={13,0,0};
            };
        };
        class infantry_squad_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_SNIPER";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={13,0,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class infantry_team
        {
            name="$STR_RHSUSF_GROUPS_TEAM";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={5,0,0};
            };
        };
        class infantry_team_MG
        {
            name="$STR_RHSUSF_GROUPS_TEAM_MG";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={5,0,0};
            };
        };
        class infantry_team_AA
        {
            name="$STR_RHSUSF_GROUPS_TEAM_AA";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_aa";
                rank="PRIVATE";
                position[]={5,0,0};
            };
        };
        class infantry_team_support
        {
            name="$STR_RHSUSF_GROUPS_TEAM_SUPPORT";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_medic";
                rank="PRIVATE";
                position[]={5,0,0};
            };
        };
        class infantry_team_heavy_AT
        {
            name="$STR_RHSUSF_GROUPS_TEAM_AT";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_javelin";
                rank="PRIVATE";
                position[]={5,0,0};
            };
        };
        class airborne_company_hq
        {
            name="$STR_RHSUSF_GROUPS_COMPANY_HQ";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_hq.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_officer";
                rank="CAPTAIN";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_officer";
                rank="LIEUTENANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_squadleader";
                rank="SERGEANT";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_rifleman";
                rank="PRIVATE";
                position[]={5,0,0};
            };
        };
        class airborne_platoon_hq
        {
            name="$STR_RHSUSF_GROUPS_PLATOON_HQ";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_hq.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_officer";
                rank="LIEUTENANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_medic";
                rank="SERGEANT";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_squadleader";
                rank="SERGEANT";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_rifleman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_rifleman";
                rank="PRIVATE";
                position[]={9,0,0};
            };
        };
        class airborne_squad
        {
            name="$STR_RHSUSF_GROUPS_SQUAD";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_teamleader";
                rank="CORPORAL";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_rifleman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_autorifleman";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_grenadier";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_teamleader";
                rank="CORPORAL";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_autorifleman";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_grenadier";
                rank="PRIVATE";
                position[]={13,0,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_riflemanat";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class airborne_weaponsquad
        {
            name="$STR_RHSUSF_GROUPS_WEAPONSQUAD";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_machinegunner";
                rank="CORPORAL";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_machinegunnera";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_grenadier";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_machinegunner";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_machinegunnera";
                rank="CORPORAL";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_grenadier";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_riflemanat";
                rank="PRIVATE";
                position[]={13,0,0};
            };
        };
        class airborne_squad_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_SNIPER";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_teamleader";
                rank="CORPORAL";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_marksman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_autorifleman";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_grenadier";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_teamleader";
                rank="CORPORAL";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_autorifleman";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_grenadier";
                rank="PRIVATE";
                position[]={13,0,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_riflemanat";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class airborne_team
        {
            name="$STR_RHSUSF_GROUPS_TEAM";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_autorifleman";
                rank="PRIVATE";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_grenadier";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_riflemanat";
                rank="PRIVATE";
                position[]={5,0,0};
            };
        };
        class airborne_team_MG
        {
            name="$STR_RHSUSF_GROUPS_TEAM_MG";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_machinegunner";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_grenadier";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_machinegunnera";
                rank="PRIVATE";
                position[]={5,0,0};
            };
        };
        class airborne_team_AA
        {
            name="$STR_RHSUSF_GROUPS_TEAM_AA";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_autorifleman";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_grenadier";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_aa";
                rank="PRIVATE";
                position[]={5,0,0};
            };
        };
        class airborne_team_support
        {
            name="$STR_RHSUSF_GROUPS_TEAM_SUPPORT";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_autorifleman";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_grenadier";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_medic";
                rank="PRIVATE";
                position[]={5,0,0};
            };
        };
        class airborne_team_heavy_AT
        {
            name="$STR_RHSUSF_GROUPS_TEAM_AT";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_autorifleman";
                rank="PRIVATE";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_arb_grenadier";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_javelin";
                rank="PRIVATE";
                position[]={5,0,0};
            };
        };
    };
    class motorized
    {
        name="Motorized";
        class mrap_squad
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_RG33";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_M1232_usarmy_wd";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class mrap_squad_2mg
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_2MG_RG33";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="CORPORAL";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_M1232_usarmy_wd";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={13,0,0};
            };
        };
        class mrap_squad_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_SNIPER_RG33";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="CORPORAL";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_M1232_usarmy_wd";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_medic";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={13,0,0};
            };
        };
        class mrap_squad_mg_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_MG_SNIPER_RG33";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_M1232_usarmy_wd";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={13,0,0};
            };
        };
        class mrap_m2_squad
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_RG33_M2";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_M1232_M2_usarmy_wd";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class mrap_m2_squad_2mg
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_2MG_RG33_M2";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="CORPORAL";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_M1232_M2_usarmy_wd";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={13,0,0};
            };
        };
        class mrap_m2_squad_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_SNIPER_RG33_M2";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="CORPORAL";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_M1232_M2_usarmy_wd";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_medic";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={13,0,0};
            };
        };
        class mrap_m2_squad_mg_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_MG_SNIPER_RG33_M2";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_M1232_M2_usarmy_wd";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={13,0,0};
            };
        };
        class truck15_squad
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_1078";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_M1078A1P2_wd_fmtv_usarmy";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={13,0,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class truck15_squad_2mg
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_2MG_1078";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="CORPORAL";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_M1078A1P2_wd_fmtv_usarmy";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={13,0,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class truck15_squad_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_SNIPER_1078";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="CORPORAL";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_M1078A1P2_wd_fmtv_usarmy";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_medic";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={13,0,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class truck15_squad_mg_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_MG_SNIPER_1078";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_M1078A1P2_wd_fmtv_usarmy";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={13,0,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class truck17_squad
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_1083";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_M1083A1P2_wd_fmtv_usarmy";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={13,0,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class truck17_squad_2mg
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_2MG_1083";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="CORPORAL";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_M1083A1P2_wd_fmtv_usarmy";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={13,0,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class truck17_squad_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_SNIPER_1083";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="CORPORAL";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_M1083A1P2_wd_fmtv_usarmy";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_medic";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={13,0,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class truck17_squad_mg_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_MG_SNIPER_1083";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_M1083A1P2_wd_fmtv_usarmy";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={13,0,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class humvee_team_GMG
        {
            name="Mot. Team (GMG)";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1025_w_mk19";
                rank="SERGEANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="CORPORAL";
                position[]={-12,-12,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={14,-13,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="CORPORAL";
                position[]={5,0,0};
            };
        };
        class humvee_team_HMG: humvee_team_GMG
        {
            name="Mot. Team (HMG)";
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1025_w_m2";
                rank="SERGEANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="CORPORAL";
                position[]={-12,-12,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={14,-13,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="CORPORAL";
                position[]={5,0,0};
            };
        };
        class humvee_team_AT: humvee_team_GMG
        {
            name="Mot. Anti-armor Team";
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1025_w";
                rank="SERGEANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="CORPORAL";
                position[]={13,-12,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_javelin";
                rank="CORPORAL";
                position[]={-12,-13,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_javelin";
                rank="PRIVATE";
                position[]={18,-17,-2};
            };
        };
        class humvee_team_AA: humvee_team_GMG
        {
            name="Mot. Air-defense Team";
            icon="\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1025_w";
                rank="SERGEANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="CORPORAL";
                position[]={13,-12,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_aa";
                rank="CORPORAL";
                position[]={-12,-13,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_aa";
                rank="PRIVATE";
                position[]={18,-17,-2};
            };
        };
    };
    class mechanized
    {
        name="Mechanized";
        class m113_squad
        {
            name="$STR_RHSUSF_GROUPS_SQUAD";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_m113_usarmy";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={13,0,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class m113_squad_2mg
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_2MG";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="CORPORAL";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_m113_usarmy";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={13,0,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class m113_squad_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_SNIPER";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="CORPORAL";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_m113_usarmy";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_medic";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={13,0,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class m113_squad_mg_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_MG_SNIPER";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="SERGEANT";
                position[]={-5,0,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={3,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_m113_usarmy";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_riflemanat";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={13,0,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={15,0,0};
            };
        };
        class m2a2ods_squad
        {
            name="$STR_RHSUSF_GROUPS_SQUAD";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A2_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A2_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_javelin";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a2ods_squad_2mg
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_2MG";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A2_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A2_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a2ods_squad_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_SNIPER";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A2_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A2_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a2ods_squad_mg_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_MG_SNIPER";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A2_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A2_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a2odsbusk1_squad
        {
            name="$STR_RHSUSF_GROUPS_SQUAD";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A2_BUSKI_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A2_BUSKI_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_javelin";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a2odsbusk1_squad_2mg
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_2MG";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A2_BUSKI_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A2_BUSKI_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a2odsbusk1_squad_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_SNIPER";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A2_BUSKI_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A2_BUSKI_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a2odsbusk1_squad_mg_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_MG_SNIPER";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A2_BUSKI_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A2_BUSKI_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a3_squad
        {
            name="$STR_RHSUSF_GROUPS_SQUAD";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A3_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A3_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_javelin";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a3_squad_2mg
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_2MG";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A3_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A3_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a3_squad_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_SNIPER";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A3_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A3_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a3_squad_mg_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_MG_SNIPER";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A3_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A3_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a3busk1_squad
        {
            name="$STR_RHSUSF_GROUPS_SQUAD";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A3_BUSKI_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A3_BUSKI_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_javelin";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a3busk1_squad_2mg
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_2MG";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A3_BUSKI_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A3_BUSKI_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a3busk1_squad_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_SNIPER";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A3_BUSKI_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A3_BUSKI_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a3busk1_squad_mg_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_MG_SNIPER";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A3_BUSKI_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A3_BUSKI_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a3busk3_squad
        {
            name="$STR_RHSUSF_GROUPS_SQUAD";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A3_BUSKIII_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A3_BUSKIII_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_javelin";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a3busk3_squad_2mg
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_2MG";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A3_BUSKIII_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A3_BUSKIII_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a3busk3_squad_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_SNIPER";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A3_BUSKIII_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A3_BUSKIII_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class m2a3busk3_squad_mg_sniper
        {
            name="$STR_RHSUSF_GROUPS_SQUAD_MG_SNIPER";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="RHS_M2A3_BUSKIII_wd";
                rank="CORPORAL";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M2A3_BUSKIII_wd";
                rank="CORPORAL";
                position[]={16,-14,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={-16,-16,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={27,-27,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-27,-27,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={31,-31,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-31,-31,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={37,-37,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={-37,-37,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_marksman";
                rank="PRIVATE";
                position[]={40,-40,0};
            };
            class Unit10
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={-40,-40,0};
            };
        };
        class stryker_squad
        {
            name="$STR_RHSUSF_GROUPS_SQUAD";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_stryker_m1126_m2_d";
                rank="CORPORAL";
                position[]={0,-5,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={5,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_teamleader";
                rank="CORPORAL";
                position[]={-5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_autorifleman";
                rank="PRIVATE";
                position[]={-7,0,0};
            };
            class Unit6
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={9,0,0};
            };
            class Unit7
            {
                side=1;
                vehicle="rhsusf_army_ucp_grenadier";
                rank="PRIVATE";
                position[]={-9,0,0};
            };
            class Unit8
            {
                side=1;
                vehicle="rhsusf_army_ucp_rifleman";
                rank="PRIVATE";
                position[]={11,0,0};
            };
            class Unit9
            {
                side=1;
                vehicle="rhsusf_army_ucp_javelin";
                rank="PRIVATE";
                position[]={-11,0,0};
            };
        };
        class stryker_wpnsquad
        {
            name="$STR_RHSUSF_GROUPS_WEAPONSQUAD";
            faction="jib_usarmy_wd";
            side=1;
            rarityGroup=0.75;
            icon="\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_army_ucp_squadleader";
                rank="SERGEANT";
                position[]={0,5,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_stryker_m1126_m2_d";
                rank="CORPORAL";
                position[]={0,-5,0};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={5,0,0};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunner";
                rank="PRIVATE";
                position[]={-5,0,0};
            };
            class Unit4
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={7,0,0};
            };
            class Unit5
            {
                side=1;
                vehicle="rhsusf_army_ucp_machinegunnera";
                rank="PRIVATE";
                position[]={-7,0,0};
            };
        };
    };
    class armored
    {
        name="Armored";
        class m1a1aim_platoon
        {
            name="M1A1AIM Platoon";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_armor.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1a1aimwd_usarmy";
                rank="LIEUTENANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_m1a1aimwd_usarmy";
                rank="SERGEANT";
                position[]={-20,-30,3};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_m1a1aimwd_usarmy";
                rank="SERGEANT";
                position[]={20,-30,3};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_m1a1aimwd_usarmy";
                rank="CORPORAL";
                position[]={40,-60,3};
            };
        };
        class m1a1aim_platoon_AA
        {
            name="M1A1AIM Platoon (Combined)";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_armor.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1a1aimwd_usarmy";
                rank="LIEUTENANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M6_wd";
                rank="SERGEANT";
                position[]={-20,-30,3};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_m1a1aimwd_usarmy";
                rank="SERGEANT";
                position[]={20,-30,3};
            };
            class Unit3
            {
                side=1;
                vehicle="RHS_M6_wd";
                rank="CORPORAL";
                position[]={40,-60,3};
            };
        };
        class m1a1aim_section
        {
            name="M1A1AIM Section";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_armor.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1a1aimwd_usarmy";
                rank="LIEUTENANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_m1a1aimwd_usarmy";
                rank="SERGEANT";
                position[]={-20,-30,2};
            };
        };
        class m1a1aimtusk1_platoon
        {
            name="M1A1AIM (TUSK I) Platoon";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_armor.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1a1aim_tuski_wd";
                rank="LIEUTENANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_m1a1aim_tuski_wd";
                rank="SERGEANT";
                position[]={-20,-30,3};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_m1a1aim_tuski_wd";
                rank="SERGEANT";
                position[]={20,-30,3};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_m1a1aim_tuski_wd";
                rank="CORPORAL";
                position[]={40,-60,3};
            };
        };
        class m1a1aimtusk1_platoon_AA
        {
            name="M1A1AIM (TUSK I) Platoon (Combined)";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_armor.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1a1aim_tuski_wd";
                rank="LIEUTENANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M6_wd";
                rank="SERGEANT";
                position[]={-20,-30,3};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_m1a1aim_tuski_wd";
                rank="SERGEANT";
                position[]={20,-30,3};
            };
            class Unit3
            {
                side=1;
                vehicle="RHS_M6_wd";
                rank="CORPORAL";
                position[]={40,-60,3};
            };
        };
        class m1a1aimtusk1_section
        {
            name="M1A1AIM (TUSK I) Section";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_armor.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1a1aim_tuski_wd";
                rank="LIEUTENANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_m1a1aim_tuski_wd";
                rank="SERGEANT";
                position[]={-20,-30,2};
            };
        };
        class m1a2sep_platoon
        {
            name="M1A2SEPv1 Platoon";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_armor.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1a2sep1wd_usarmy";
                rank="LIEUTENANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_m1a2sep1wd_usarmy";
                rank="SERGEANT";
                position[]={-20,-30,3};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_m1a2sep1wd_usarmy";
                rank="SERGEANT";
                position[]={20,-30,3};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_m1a2sep1wd_usarmy";
                rank="CORPORAL";
                position[]={40,-60,3};
            };
        };
        class m1a2sep_platoon_AA
        {
            name="M1A2SEPv1 Platoon (Combined)";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_armor.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1a2sep1wd_usarmy";
                rank="LIEUTENANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M6_wd";
                rank="SERGEANT";
                position[]={-20,-30,3};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_m1a2sep1wd_usarmy";
                rank="SERGEANT";
                position[]={20,-30,3};
            };
            class Unit3
            {
                side=1;
                vehicle="RHS_M6_wd";
                rank="CORPORAL";
                position[]={40,-60,3};
            };
        };
        class m1a2sep_section
        {
            name="M1A2SEPv1 Section";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_armor.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1a2sep1wd_usarmy";
                rank="LIEUTENANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_m1a2sep1wd_usarmy";
                rank="SERGEANT";
                position[]={-20,-30,2};
            };
        };
        class m1a2septusk1_platoon
        {
            name="M1A2SEPv1 (TUSK I) Platoon";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_armor.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1a2sep1tuskiwd_usarmy";
                rank="LIEUTENANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_m1a2sep1tuskiwd_usarmy";
                rank="SERGEANT";
                position[]={-20,-30,3};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_m1a2sep1tuskiwd_usarmy";
                rank="SERGEANT";
                position[]={20,-30,3};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_m1a2sep1tuskiwd_usarmy";
                rank="CORPORAL";
                position[]={40,-60,3};
            };
        };
        class m1a2septusk1_platoon_AA
        {
            name="M1A2SEPv1 (TUSK I) Platoon (Combined)";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_armor.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1a2sep1tuskiwd_usarmy";
                rank="LIEUTENANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M6_wd";
                rank="SERGEANT";
                position[]={-20,-30,3};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_m1a2sep1tuskiwd_usarmy";
                rank="SERGEANT";
                position[]={20,-30,3};
            };
            class Unit3
            {
                side=1;
                vehicle="RHS_M6_wd";
                rank="CORPORAL";
                position[]={40,-60,3};
            };
        };
        class m1a2septusk1_section
        {
            name="M1A2SEPv1 (TUSK I) Section";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_armor.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1a2sep1tuskiwd_usarmy";
                rank="LIEUTENANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_m1a2sep1tuskiwd_usarmy";
                rank="SERGEANT";
                position[]={-20,-30,2};
            };
        };
        class m1a2septusk2_platoon
        {
            name="M1A2SEPv1 (TUSK II) Platoon";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_armor.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1a2sep1tuskiiwd_usarmy";
                rank="LIEUTENANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_m1a2sep1tuskiiwd_usarmy";
                rank="SERGEANT";
                position[]={-20,-30,3};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_m1a2sep1tuskiiwd_usarmy";
                rank="SERGEANT";
                position[]={20,-30,3};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_m1a2sep1tuskiiwd_usarmy";
                rank="CORPORAL";
                position[]={40,-60,3};
            };
        };
        class m1a2septusk2_platoon_AA
        {
            name="M1A2SEPv1 (TUSK II) Platoon (Combined)";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_armor.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1a2sep1tuskiiwd_usarmy";
                rank="LIEUTENANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="RHS_M6_wd";
                rank="SERGEANT";
                position[]={-20,-30,3};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_m1a2sep1tuskiiwd_usarmy";
                rank="SERGEANT";
                position[]={20,-30,3};
            };
            class Unit3
            {
                side=1;
                vehicle="RHS_M6_wd";
                rank="CORPORAL";
                position[]={40,-60,3};
            };
        };
        class m1a2septusk2_section
        {
            name="M1A2SEPv1 (TUSK II) Section";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_armor.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m1a2sep1tuskiiwd_usarmy";
                rank="LIEUTENANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_m1a2sep1tuskiiwd_usarmy";
                rank="SERGEANT";
                position[]={-20,-30,2};
            };
        };
    };
    class artillery
    {
        name="Artillery";
        class paladin_platoon
        {
            name="Artillery M109 Platoon";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_art.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m109_usarmy";
                rank="LIEUTENANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_m109_usarmy";
                rank="SERGEANT";
                position[]={-20,-30,3};
            };
            class Unit2
            {
                side=1;
                vehicle="rhsusf_m109_usarmy";
                rank="SERGEANT";
                position[]={20,-30,3};
            };
            class Unit3
            {
                side=1;
                vehicle="rhsusf_m109_usarmy";
                rank="CORPORAL";
                position[]={40,-60,3};
            };
        };
        class paladin_section
        {
            name="Artillery M109 Section";
            side=1;
            faction="jib_usarmy_wd";
            icon="\A3\ui_f\data\map\markers\nato\b_art.paa";
            class Unit0
            {
                side=1;
                vehicle="rhsusf_m109_usarmy";
                rank="LIEUTENANT";
                position[]={0,0,0};
            };
            class Unit1
            {
                side=1;
                vehicle="rhsusf_m109_usarmy";
                rank="SERGEANT";
                position[]={-20,-30,3};
            };
        };
    };
};
