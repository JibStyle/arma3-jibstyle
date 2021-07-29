// Init client or server during mission start
if (hasInterface) then {
    call jib_misc_fnc_client_restrictScoretable;
    call jib_misc_fnc_setupViewDistance;
} else {
    call jib_misc_fnc_setupViewDistance;
};
