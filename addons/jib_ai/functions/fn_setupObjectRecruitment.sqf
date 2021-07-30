// Add recruitment actions to object
params [
    "_object",          // Service provider
    ["_variant", "MTP"] // Variant
];

switch (_variant) do
{
    case "MTP": { // Default
        _object addAction [
            "Recruit Full Squad",
            {
	        ["B_soldier_M_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
	        ["B_soldier_AT_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
	        ["B_medic_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
	        ["B_Soldier_TL_F", "CORPORAL"] call jib_ai_fnc_recruitAI;
	        ["B_Soldier_AR_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
	        ["B_soldier_exp_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
	        ["B_Soldier_A_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
            },
            nil, 1.5, false, false, "", "leader player == player",
            5, false, "", ""
        ];
        _object addAction ["Recruit Marksman", {["B_soldier_M_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Missile Specialist (AT)", {["B_soldier_AT_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Combat Life Saver", {["B_medic_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Team Leader", {["B_Soldier_TL_F", "CORPORAL"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Autorifleman", {["B_Soldier_AR_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Explosive Specialist", {["B_soldier_exp_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Ammo Bearer", {["B_Soldier_A_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Pilot", {["B_Pilot_F", "LIEUTENANT"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Helicopter Pilot", {["B_Helipilot_F", "LIEUTENANT"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Helicopter Crew", {["B_helicrew_F", "SERGEANT"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Crewman", {["B_crew_F", "SERGEANT"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
    };

    case "T": { // Pacific
        _object addAction [
            "Recruit Full Squad",
            {
	        ["B_T_soldier_M_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
	        ["B_T_soldier_AT_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
	        ["B_T_medic_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
	        ["B_T_Soldier_TL_F", "CORPORAL"] call jib_ai_fnc_recruitAI;
	        ["B_T_Soldier_AR_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
	        ["B_T_soldier_exp_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
	        ["B_T_Soldier_A_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
            },
            nil, 1.5, false, false, "", "leader player == player",
            5, false, "", ""
        ];
        _object addAction ["Recruit Marksman", {["B_T_soldier_M_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Missile Specialist (AT)", {["B_T_soldier_AT_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Combat Life Saver", {["B_T_medic_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Team Leader", {["B_T_Soldier_TL_F", "CORPORAL"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Autorifleman", {["B_T_Soldier_AR_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Explosive Specialist", {["B_T_soldier_exp_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Ammo Bearer", {["B_T_Soldier_A_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Pilot", {["B_T_Pilot_F", "LIEUTENANT"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Helicopter Pilot", {["B_T_Helipilot_F", "LIEUTENANT"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Helicopter Crew", {["B_T_helicrew_F", "SERGEANT"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Crewman", {["B_T_crew_F", "SERGEANT"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
    };

    case "W": { // Woodland
        _object addAction [
            "Recruit Full Squad",
            {
	        ["B_W_soldier_M_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
	        ["B_W_soldier_AT_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
	        ["B_W_medic_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
	        ["B_W_Soldier_TL_F", "CORPORAL"] call jib_ai_fnc_recruitAI;
	        ["B_W_Soldier_AR_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
	        ["B_W_soldier_exp_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
	        ["B_W_Soldier_A_F", "PRIVATE"] call jib_ai_fnc_recruitAI;
            },
            nil, 1.5, false, false, "", "leader player == player",
            5, false, "", ""
        ];
        _object addAction ["Recruit Marksman", {["B_W_soldier_M_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Missile Specialist (AT)", {["B_W_soldier_AT_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Combat Life Saver", {["B_W_medic_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Team Leader", {["B_W_Soldier_TL_F", "CORPORAL"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Autorifleman", {["B_W_Soldier_AR_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Explosive Specialist", {["B_W_soldier_exp_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Ammo Bearer", {["B_W_Soldier_A_F", "PRIVATE"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Pilot", {["B_Pilot_F", "LIEUTENANT"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Helicopter Pilot", {["B_W_Helipilot_F", "LIEUTENANT"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Helicopter Crew", {["B_W_helicrew_F", "SERGEANT"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
        _object addAction ["Recruit Crewman", {["B_W_crew_F", "SERGEANT"] call jib_ai_fnc_recruitAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
    };
};

_object addAction ["Dismiss AI", {call jib_ai_fnc_dismissAI;}, nil, 1.5, false, false, "", "leader player == player", 5, false, "", ""];
