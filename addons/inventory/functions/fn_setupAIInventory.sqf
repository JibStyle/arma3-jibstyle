// Setup AI inventory custom items
params ["_unit"]; // AI unit

// _log = format [
//     "jib_inventory unit: %1, leader: %2, local: %3, player: %4",
//     _unit, leader _unit, local _unit, isPlayer _unit
// ];
// diag_log _log;
// systemChat _log;

if (
    not local _unit
	|| isPlayer _unit
	|| {side _unit != west}
) exitWith {};
if (
    _unit isKindOf "B_Soldier_SL_F"
	|| {_unit isKindOf "B_Soldier_TL_F"}
) then {
    [_unit, "ItemAndroid"] call jib_inventory_fnc_maybeAddItem;
} else {
    [_unit, "ItemMicroDAGR"] call jib_inventory_fnc_maybeAddItem;
};
