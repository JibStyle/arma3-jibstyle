// Add action to restore loadout
params ["_object"]; // Object to assign action to
_object addAction [
    "Heal and rearm", // title
    {
	// params ["_target", "_caller", "_actionId", "_arguments"];
        player setUnitLoadout typeOf player;
        if (isNil "ace_medical_treatment_fnc_fullHeal") then {
            player setDamage 0;
        } else {
	    [player, player] call ace_medical_treatment_fnc_fullHeal;
        };
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
