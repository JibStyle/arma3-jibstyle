if (!isServer) exitWith {};

jib_service_teleport = {
    params ["_units", "_other"];
    if (!isServer) then {throw "Not server!"};
    _units apply {
        private _pos = getPos _other;
        _x setVehiclePosition [_pos, [], 0, "NONE"];
    };
};

jib_service_rearmSave = {
    params ["_units"];
    if (!isServer) then {throw "Not server!"};
    _units apply {_x setVariable ["jib_service_loadout", getUnitLoadout _x]};
    addMissionEventHandler ["EntityRespawned" ,{
        params ["_unit", "_corpse"];
        private _loadout =
            _corpse getVariable ["jib_service_loadout", getUnitLoadout _unit];
        _unit setVariable ["jib_service_loadout", _loadout];
        _unit setUnitLoadout [_loadout, true];
    }];
};

jib_service_rearmLoad = {
    params ["_units"];
    if (!isServer) then {throw "Not server!"};
    _units apply {
        private _loadout = _x getVariable ["jib_service_loadout", false];
        if (typeName _loadout == "BOOL") then {
            _x setUnitLoadout typeOf _x;
        } else {
            _x setUnitLoadout [_loadout, true];
        };
    };
};

jib_service_heal = {
    params ["_unit"];
    if (!isServer) then {throw "Not server!"};
    if (isNil "ace_medical_treatment_fnc_fullHeal") then {
        _unit setDamage 0;
    } else {
        [_unit, _unit] remoteExec [
            "ace_medical_treatment_fnc_fullHeal", _unit
        ];
    };
};

jib_service_vehicle = {
    params ["_vehicle"];
    _vehicle setVehicleAmmo 1;
    _vehicle setFuel 1;
    _vehicle setDamage 0;
    private _commander = effectiveCommander _vehicle;
    private _oldCrew = crew _vehicle;
    _oldCrew apply {
        if (alive _x) then {
            [_x] remoteExec ["jib_service_heal", 2];
            [[_x]] remoteExec ["jib_service_rearmLoad", 2];
        } else {
            _vehicle deleteVehicleCrew _x;
        };
    };
    createVehicleCrew _vehicle;
    private _newCrew = crew _vehicle - _oldCrew;
    _newCrew join _commander;
};
publicVariable "jib_service_vehicle";

jib_service_top = {
    params ["_leader", "_selected"];
    if (!isServer) then {throw "Not server!"};
    private _group = group _leader;
    if (count _selected == 0) then {_selected = [_leader]};
    private _rest = units _group - _selected;
    private _i = count units _group;
    private _base = 100;
    units _group apply {
        _x joinAsSilent [_group, _base + _i];
        _i = _i + 1;
    };
    _i = 0;
    _selected apply {
        _x joinAsSilent [_group, _i];
        _i = _i + 1;
    };
    _rest apply {
        _x joinAsSilent [_group, _i];
        _i = _i + 1;
    };
    [_group, _leader] remoteExec ["selectLeader", groupOwner _group];
};

jib_service_bottom = {
    params ["_leader", "_selected"];
    if (!isServer) then {throw "Not server!"};
    private _group = group _leader;
    if (count _selected == 0) then {_selected = [_leader]};
    private _rest = units _group - _selected;
    private _i = count units _group;
    private _base = 100;
    units _group apply {
        _x joinAsSilent [_group, _base + _i];
        _i = _i + 1;
    };
    _i = 0;
    _rest apply {
        _x joinAsSilent [_group, _i];
        _i = _i + 1;
    };
    _selected apply {
        _x joinAsSilent [_group, _i];
        _i = _i + 1;
    };
    [_group, _leader] remoteExec ["selectLeader", groupOwner _group];
};

jib_service_spawnUnit = {
    params ["_leader", "_type", "_position"];
    private _unit =
        group _leader createUnit [_type, _position, [], 0, "NONE"];
    doStop _unit;
};
publicVariable "jib_service_spawnUnit";

jib_service_spawnVehicle = {
    params ["_leader", "_type", "_position"];
    private _vehicle = _type createVehicle _position;
    _vehicle setVariable ["jib_service_disposable", true, true];
    createVehicleCrew _vehicle;
    crew _vehicle join _leader;
    doStop effectiveCommander _vehicle;
};
publicVariable "jib_service_spawnVehicle";

jib_service_despawn = {
    params ["_leader", "_selected"];
    _selected select {
        isPlayer _x == false
    } apply {
        if (vehicle _x == _x) then {
            deleteVehicle _x;
        } else {
            private _vehicle = vehicle _x;
            _vehicle deleteVehicleCrew _x;
            if (
                _vehicle getVariable [
                    "jib_service_disposable", false
                ] && count crew _vehicle == 0
            ) then {
                deleteVehicle _vehicle;
            };
        };
    };
};
publicVariable "jib_service_despawn";
