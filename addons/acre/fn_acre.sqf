if (!isServer) exitWith {};
jib_acre_global = {
    params ["_preset_old", "_preset_new", "_names"];
    [
        [_preset_old, _preset_new, _names], {
            params ["_preset_old", "_preset_new", "_names"];
            [
                ["ACRE_PRC152", "description"],
                ["ACRE_PRC148", "label"],
                ["ACRE_PRC117F", "name"]
            ] apply {
                _x params ["_radio", "_field"];
                [
                    _radio, _preset_old, _preset_new
                ] call acre_api_fnc_copyPreset;
                for "_i" from 0 to count _names - 1 do {
                    private _name = _names # _i;
                    [
                        _radio, _preset_new, _i + 1, _field, _name
                    ] call acre_api_fnc_setPresetChannelField;
                };
                [_radio, _preset_new] call acre_api_fnc_setPreset;
            };
        }
    ] remoteExec ["spawn", 0, true];
};
// [
//     "default", "jib_preset",
//     ["PLTNET 1", "PLTNET 2", "PLTNET 3", "COY", "CAS", "FIRES"]
// ] call jib_acre_global;

jib_acre_setUnitLoadout = {
    params ["_unit", "_loadout"];
    if (isNil "acre_api_fnc_filterUnitLoadout") then {
        _unit setUnitLoadout _loadout;
    } else {
        _unit setUnitLoadout ([_loadout] call acre_api_fnc_filterUnitLoadout);
    };
};
