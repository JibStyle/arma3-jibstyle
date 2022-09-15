// Activate all addons loaded in game.
//
// By default, only items referenced by a mission are activated. For
// example, modules in thie addon would not be loaded.
jib_zeus_activateAddons = {
    private _addons = [];
    private _cfgPatches = configfile >> "cfgpatches";
    for "_i" from 0 to (count _cfgPatches - 1) do {
        _class = _cfgPatches select _i;
        if (isclass _class) then {
            _addons set [count _addons, configname _class];
        };
    };
    activateAddons _addons;
};

// NOTE: Function must be called synchronously.
//
// This special function is called synchronously on all machines with
// mod installed, because activateAddons only works during the preInit
// phase.
[] call jib_zeus_activateAddons;
