// Init client during mission start
if (!hasInterface) exitWith {};
addMissionEventHandler [
    "PreloadFinished",
    {
        call jib_main_fnc_onPlayerRespawn;
    }
];
player addEventHandler [
    "Respawn",
    {
        // params ["_entity", "_corpse"];
        call jib_main_fnc_onPlayerRespawn;
    }
];
