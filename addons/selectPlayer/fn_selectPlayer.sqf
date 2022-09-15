if (!isServer) exitWith {};

// Select player event handlers.
//
// Handlers passed _oldUnit and _newUnit, and run on client machine of
// player who was selected.
jib_selectPlayer_handlers = [];

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_selectPlayer_moduleValidate = {};

// Tell client to select player.
jib_selectPlayer_server = {
    params ["_oldUnit", "_newUnit"];
    if (not isServer) then {throw "Not server!"};
    if (not isPlayer _oldUnit) then {throw "Old unit not a player!"};
    if (not alive _newUnit) then {throw "New unit not alive!"};

    // Trigger client
    [
        _oldUnit,
        _newUnit
    ] remoteExec ["jib_selectPlayer_client", _oldUnit];
};

// PRIVATE

// Client code for select player.
jib_selectPlayer_client = {
    params ["_oldUnit", "_newUnit"];
    if (not isPlayer _oldUnit) then {throw "Old unit not a player!"};
    if (not alive _newUnit) then {throw "New unit not alive!"};

    // Select
    selectPlayer _newUnit;

    // Call handlers
    jib_selectPlayer_handlers apply {[_oldUnit, _newUnit] call _x;};
};

jib_selectPlayer_selectedFrom = objNull;

jib_selectPlayer_moduleFrom = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            jib_selectPlayer_selectedFrom = effectiveCommander _attached;
        },
        [],
        "local"
    ] call jib_selectPlayer_moduleValidate;
};

jib_selectPlayer_moduleTo = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_oldUnit"];
            jib_selectPlayer_selectedFrom = objNull;
            [
                _oldUnit,
                effectiveCommander _attached
            ] call jib_selectPlayer_server;
        },
        [jib_selectPlayer_selectedFrom]
    ] call jib_selectPlayer_moduleValidate;
};

jib_selectPlayer_moduleSelf = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            _args params ["_player"];
            [_player, _attached] call jib_selectPlayer_server;
        },
        [player]
    ] call jib_selectPlayer_moduleValidate;
};

// Publish variables and functions
publicVariable "jib_selectPlayer_moduleValidate";
publicVariable "jib_selectPlayer_selectedFrom";
publicVariable "jib_selectPlayer_moduleFrom";
publicVariable "jib_selectPlayer_moduleTo";
publicVariable "jib_selectPlayer_moduleSelf";
publicVariable "jib_selectPlayer_handlers";
publicVariable "jib_selectPlayer_client";
