// Default Respawn Inventories
{ [_x, true] call BIS_fnc_moduleRespawnInventory } forEach allCurators;
[west, ["B_Protagonist_VR_F"]] call BIS_fnc_setRespawnInventory;
[east, ["O_Protagonist_VR_F"]] call BIS_fnc_setRespawnInventory;
[independent, ["I_Protagonist_VR_F"]] call BIS_fnc_setRespawnInventory;
[civilian, ["C_Protagonist_VR_F"]] call BIS_fnc_setRespawnInventory;

// Handle Zeus Respawn
addMissionEventHandler ["EntityRespawned", {
    params ["_newEntity", "_oldEntity"];
    // systemChat format [
    //     "EntityRespawned new: %1, old: %2",
    //     _newEntity,
    //     _oldEntity
    // ];
    private _curator = getAssignedCuratorLogic _oldEntity;
    if (isNull _curator) exitWith {};
    unassignCurator _curator;
    waitUntil { isNull (getAssignedCuratorUnit _curator) };
    _newEntity assignCurator _curator;
}];

// Side relations
west setFriend [independent, 0];
independent setFriend [west, 0];
east setFriend [independent, 0];
independent setFriend [east, 0];
