// Add action to restore loadout
params ["_object"]; // Object to assign action to
_object addAction [
    "Heal and rearm", // title
    {
	// params ["_target", "_caller", "_actionId", "_arguments"];
	call jib_inventory_fnc_client_loadoutRestore;
	[player, player] call ace_medical_treatment_fnc_fullHeal;
    },		// code
    nil,	// arguments
    10, 	// priority
    true,	// showWindow
    true,	// hideOnUse
    "",		// shortcut
    "true",	// condition
    5,		// radius
    false,	// unconscious
    "",		// selection
    ""		// memoryPoint
];
