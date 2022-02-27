// Activate addons
private _addons = [];
private _cfgPatches = configfile >> "cfgpatches";
for "_i" from 0 to (count _cfgPatches - 1) do {
    _class = _cfgPatches select _i;
    if (isclass _class) then {
        _addons set [count _addons,configname _class];
    };
};
// _addons call bis_fnc_activateaddons;
// removeallcuratoraddons jib_zeus_curator;
// jib_zeus_curator addcuratoraddons _addons;
activateAddons _addons;
