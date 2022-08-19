// Select player and transfer curator ownership
params ["_oldUnit", "_newUnit"];
if (not isServer) then {throw "Not server!"};
if (not isPlayer _oldUnit) then {throw "Old unit not a player!"};
if (not alive _newUnit) then {throw "New unit not alive!"};

// Get curator logic
private _curator = getAssignedCuratorLogic _oldUnit;

// Trigger client
[[_newUnit, _curator], {
    params ["_newUnit", "_curator"];

    // Select player
    selectPlayer _newUnit;

    // Un-force curator and transfer curator ownership
    [false, false] call BIS_fnc_forceCuratorInterface;
    [[player, _curator], {
        params ["_player", "_logic"];
        unassignCurator _logic;
        waitUntil { isNull (getAssignedCuratorUnit _logic) };
        _player assignCurator _logic;
    }] remoteExec ["spawn", 2];

    // Update MARTA
    if (count hcAllGroups player > 0) then {
        setGroupIconsVisible [true, false];
    } else {
        setGroupIconsVisible [false, false];
    };

    // Add ALiVE combat support actions
    if (!isNil "NEO_radioLogic") then {
        {
            player addAction _x
        } foreach (
            NEO_radioLogic getVariable "NEO_radioPlayerActionArray"
        );
    };

    // Call additional event handlers
    jib_selectPlayer_handlers apply {
        [] call _x;
    };
}] remoteExec ["spawn", _oldUnit];

true;
