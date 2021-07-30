class CfgGroups {
    class WEST {
	class JIB_BLU_F {
	    name = "JIB NATO";
	    class SpecOps {
		name = "Special Forces";
		class JIB_BLU_F_SpecOps_Hooligans {
		    name = "Hooligans";
		    side = 1;
		    faction = "JIB_BLU_F";
		    icon = "\A3\ui_f\data\map\markers\nato\b_recon.paa";
		    rarityGroup = 0.5;

		    class Unit0 {
			position[] = {0,0,0};
			rank = "SERGEANT";
			side = 1;
			vehicle = "JIB_B_Wildman_F";
		    };
		    class Unit1 {
			position[] = {5,-5,0};
			rank = "PRIVATE";
			side = 1;
			vehicle = "JIB_B_Wildman_F";
		    };
		    class Unit2 {
			position[] = {-5,-5,0};
			rank = "PRIVATE";
			side = 1;
			vehicle = "JIB_B_Wildman_F";
		    };
		    class Unit3 {
			position[] = {10,-10,0};
			rank = "PRIVATE";
			side = 1;
			vehicle = "JIB_B_Wildman_F";
		    };
		};
	    };
	    class Infantry {name = "Infantry";};
	    class Motorized {name = "Motorized Infantry";};
	    class Motorized_MTP {name = "Motorized Infantry (MTP)";};
	    class Support {name = "Support Infantry";};
	    class Mechanized {name = "Mechanized Infantry";};
	    class Armored {name = "Armor";};
	    class Artillery {name = "Artillery";};
	    class Naval {name = "Naval";};
	    class Air {name = "Air";};
	};
    };
};
