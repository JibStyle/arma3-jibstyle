// Spawn AI and join player group
params [
    "_classname", // AI class to spawn
    "_rank"       // AI rank
];
_unit = group player createUnit [_classname, player, [], 0, "NONE"];
_unit setUnitRank _rank;
// [_unit, "ItemMicroDAGR"] call jib_inventory_fnc_maybeAddItem;
if (_unit isKindOf "B_Soldier_A_F") then {
    [_unit] call jib_inventory_fnc_setupUnitAmmoBearer;
};
