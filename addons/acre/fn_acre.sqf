jib_acre_global = {
    [[], {
        [
            ["ACRE_PRC148", "default", "jib_preset"],
            ["ACRE_PRC152", "default", "jib_preset"],
            ["ACRE_PRC117F", "default", "jib_preset"]
        ] apply {_x call acre_api_fnc_copyPreset};
        [
            ["ACRE_PRC152", "jib_preset", 1, "description", "PLTNET 1"],
            ["ACRE_PRC152", "jib_preset", 2, "description", "PLTNET 2"],
            ["ACRE_PRC152", "jib_preset", 3, "description", "PLTNET 3"],
            ["ACRE_PRC152", "jib_preset", 4, "description", "COY"],
            ["ACRE_PRC152", "jib_preset", 5, "description", "CAS"],
            ["ACRE_PRC152", "jib_preset", 6, "description", "FIRES"],
            ["ACRE_PRC148", "jib_preset", 1, "label", "PLTNET 1"],
            ["ACRE_PRC148", "jib_preset", 2, "label", "PLTNET 2"],
            ["ACRE_PRC148", "jib_preset", 3, "label", "PLTNET 3"],
            ["ACRE_PRC148", "jib_preset", 4, "label", "COY"],
            ["ACRE_PRC148", "jib_preset", 5, "label", "CAS"],
            ["ACRE_PRC148", "jib_preset", 6, "label", "FIRES"],
            ["ACRE_PRC117F", "jib_preset", 1, "name", "PLTNET 1"],
            ["ACRE_PRC117F", "jib_preset", 2, "name", "PLTNET 2"],
            ["ACRE_PRC117F", "jib_preset", 3, "name", "PLTNET 3"],
            ["ACRE_PRC117F", "jib_preset", 4, "name", "COY"],
            ["ACRE_PRC117F", "jib_preset", 5, "name", "CAS"],
            ["ACRE_PRC117F", "jib_preset", 6, "name", "FIRES"]
        ] apply {_x call acre_api_fnc_setPresetChannelField};
        [
            ["ACRE_PRC152", "jib_preset"],
            ["ACRE_PRC148", "jib_preset"],
            ["ACRE_PRC117F", "jib_preset"]
        ] apply {_x call acre_api_fnc_setPreset};
    }] remoteExec ["spawn", 0, true];
};
[] call jib_acre_global;
