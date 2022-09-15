// Transport Functions
if (!isServer) exitWith { "Not server!" };

// Server
jib_transport_handlerMissionStart = {
    params ["_oldUnit", "_newUnit"];
    [] remoteExec ["jib_transport_addAction", 0, true];
};

// Server
jib_transport_handlerMissionEntityRespawned = {
    params ["_oldUnit", "_newUnit"];
    [] remoteExec ["jib_transport_addAction", _newUnit, true];
};

// Server
jib_transport_handlerMissionTeamSwitch = {
    params ["_oldUnit", "_newUnit"];
    [] remoteExec ["jib_transport_addAction", _newUnit, true];
};

// Client
jib_transport_selectPlayerHandler = {
    [] call jib_transport_addAction;
};

// Add action to player.
jib_transport_addAction = {
    player addAction["<img image='\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa' /> HC Transport",{showCommandingMenu "#USER:HC_Transport"},[],1,true,false,"", "hcShownBar && _target == _this" ];
};

// *********************************
// High Command Transport
// LightWeight AddOn v.0.01
// *********************************
// Author: Henrik Hansen
// If you are using my functions in a realease please leave a thank
// you note in the credits
// *********************************
// Special Thanks To:
// - Killzone_Kid for the KK_fnc_commonTurrets function
// - Jester814 for inspiring tutorials / videos
// *********************************
// AddOn created mainly to correct high command transport tasks like
// (but not limited to):
// - hc group will not board vehicles that has been assigned to other
//   hc groups (even though cargo space is avalable)
// - hc group will not board even empty vehicles in which the player
//   has been in the driverseat
// - Feedback tracker: http://feedback.arma3.com/view.php?id=12934
// *********************************
// Usage:
// - Go to high command control (Left CTRL + SPACE)
// - Select high command groups (F1 - F12)
// - Press 6 on keyboard to bring up AddOn Command Menu
// *********************************

HC_Transport_SCToggleVar = true;

HC_Transport = [
    ["HC Transport",true],
    ["Transport Load"      ,[2],"",-5,[["expression","[hcSelected player] call HC_Trans_Load"]],"1","1"],
    ["Transport Unload"    ,[3],"",-5,[["expression","[hcSelected player] call HC_Trans_Unload"]],"1","1"],
    ["Crew Enter"          ,[4],"",-5,[["expression","[hcSelected player] call HC_Trans_CrewEnter"]],"1","1"],
    ["Crew Exit"           ,[5],"",-5,[["expression","[hcSelected player] call HC_Trans_CrewExit"]],"1","1"],
    ["Engine On"           ,[6],"",-5,[["expression","[hcSelected player,true] call HC_Trans_Engine"]],"1","1"],
    ["Engine Off"          ,[7],"",-5,[["expression","[hcSelected player,false] call HC_Trans_Engine"]],"1","1"],
    ["Helo Land/Hover"       	 ,[8],"",-5,[["expression","[hcSelected player,true] call HC_Trans_HeloLand"]],"1","1"],
    ["Toggle SideChat"     ,[9],"",-5,[["expression","[] call HC_Transport_SCToggle"]],"1","1"]
];

//HC_Custom_0 = HC_Transport;

HC_Trans_Load = {
    private ["_hcgroups","_onfootgrps","_vehiclegrps","_cargoseats","_cargounits","_name"];
    _hcgroups = _this select 0;
    if( count _hcgroups < 1 ) exitWith {hint 'Select a minimum of 1 HC group to transport'};

    _onfootgrps = [];
    _vehiclegrps = [];
    {
	if( vehicle (leader _x) == (leader _x) ) then {
	    _onfootgrps set [count _onfootgrps ,_x];
	} else {
	    _vehiclegrps set [count _vehiclegrps ,_x];
	};
    } forEach _hcgroups;

    if( count _vehiclegrps < 1 ) then {
	if( vehicle player == player ) exitWith {hint 'In the selected HC groups, at least 1 HC group (or yourself) must be in a vehicle to provide transport'};
	_vehiclegrps = [group player];
    };

    if( count _vehiclegrps > 1 ) exitWith {hint 'In the selected HC groups, only 1 HC group must be in a vehicle to provide transport'};
    if( count _onfootgrps < 1 )  exitWith {hint 'In the selected HC groups, at least 1 HC group must be on foot'};

    _vehicle = (vehicle (leader (_vehiclegrps select 0)));
    _cargoseats = getNumber (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "transportSoldier");
    {
	_cargounits = 0;
	{
	    if( "Cargo" in (assignedVehicleRole _x) ) then {_cargounits=_cargounits+1};
	} forEach (crew _vehicle);

	if( count (units _x) <= _cargoseats - _cargounits ) then {
	    {unassignVehicle _x;_x assignAsCargo _vehicle;} forEach (units _x);
	    (units _x) orderGetIn true;
	    deleteWaypoint [_x, all];
	    _wp = _x addWaypoint [getPos _vehicle, 0];
	    _wp setWaypointType "GETIN";
	    if( HC_Transport_SCToggleVar ) then {_wp setWaypointStatements ["true", "_name = getText (configFile >> 'CfgVehicles' >> (typeOf (vehicle this)) >> 'displayName');this sideChat format['We have now mounted a %1',_name]"]};
	    _x setCurrentWaypoint _wp;
	}
	else {
	    if( HC_Transport_SCToggleVar ) then {_name = getText (configFile >> 'CfgVehicles' >> (typeOf _vehicle) >> 'displayName');(leader _x) sideChat format['We cannot mount the %1 because there is not enough room for us',_name]};
	};
    } forEach _onfootgrps;
};


HC_Trans_Unload = {
    private ["_hcgroups","_vehicle","_wp"];
    _hcgroups = _this select 0;
    if( count _hcgroups < 1 ) exitWith {hint 'Select at least 1 HC transport group to unload'};
    {
	_vehicle = vehicle (leader _x);
	if( _vehicle != leader _x ) then {
	    if( _x != group (driver _vehicle) ) then {
		//{unassignVehicle _x} forEach (units _x);
		_x leaveVehicle _vehicle;
		deleteWaypoint [_x, all];
		_wp = _x addWaypoint [getPos _vehicle, 0];
		_wp setWaypointType "GETOUT";
		if( HC_Transport_SCToggleVar ) then {[_x,_vehicle] call HC_Trans_UnloadMonitor};
		_x setCurrentWaypoint _wp;
	    };
	};
    } forEach _hcgroups;
};


HC_Trans_CrewEnter = {
    private ["_hcgroups","_list","_wp","_grp"];
    _hcgroups = _this select 0;
    {
	if( count _hcgroups < 1 || vehicle (leader _x) != leader _x ) exitWith {hint 'Select at least 1 HC group on foot to take control of nearest vehicle'};
	if( count _hcgroups > 1 ) exitWith {hint 'Select only 1 HC group on foot to take control of nearest vehicle'};
	{unassignVehicle _x} forEach (units _x);
	deleteWaypoint [_x, all];
	_list = nearestObjects [leader _x, ["LandVehicle","Air"], 100];
	_grp=_x;
	{
	    if ( ([_grp,_x] call HC_Trans_AssignCrew) ) exitWith {
		(units _grp) orderGetIn true;
		_wp = _grp addWaypoint [getPos _x, 0];
		_wp setWaypointType "GETIN";
		if( HC_Transport_SCToggleVar ) then {_wp setWaypointStatements ["true", "[thislist] call HC_Trans_CrewEnterCheck"]};
		_grp setCurrentWaypoint _wp;
	    };
	} forEach _list;
    } forEach _hcgroups;
};


HC_Trans_CrewExit = {
    private ["_hcgroups","_vehicle","_wp"];
    _hcgroups = _this select 0;
    if( count _hcgroups < 1 ) exitWith {hint 'Select at least 1 HC group in a vehicle that is to exit that vehicle'};
    {
	_vehicle = vehicle (leader _x);
	if( _vehicle != leader _x && (group (driver _vehicle)) == _x ) then {
	    _x leaveVehicle _vehicle;
	    deleteWaypoint [_x, all];
	    _wp = _x addWaypoint [getPos _vehicle, 0];
	    _wp setWaypointType "GETOUT";
	    if( HC_Transport_SCToggleVar ) then {[_x,_vehicle] call HC_Trans_UnloadMonitor};
	    _x setCurrentWaypoint _wp;
	};
    } forEach _hcgroups;
};


HC_Trans_HeloLand = {
    private ["_hcgroups","_vehicle","_engineoff"];
    _hcgroups = _this select 0;
    _engineon = _this select 1;
    if( count _hcgroups < 1 ) exitWith {hint 'Select at least 1 HC group in a Helicopter that is to land'};
    {
	_vehicle = vehicle (leader _x);
	if( _vehicle != leader _x && (group (driver _vehicle)) == _x && _vehicle isKindOf "Helicopter" ) then {
	    if( _engineon ) then { _vehicle land "GET IN" }
	    else { _vehicle land "LAND" };
	};
    } forEach _hcgroups;
};


HC_Trans_Engine = {
    private ["_hcgroups","_vehicle","_engineon"];
    _hcgroups = _this select 0;
    _engineon = _this select 1;
    if( count _hcgroups < 1 ) exitWith {hint 'Select at least 1 HC group in a vehicle that is to shut the engine off'};
    {
	_vehicle = vehicle (leader _x);

	if( !_engineon && _vehicle isKindOf "Helicopter" ) then {
	    [[_x],false] call HC_Trans_HeloLand;
	}
 	else {
	    if( _vehicle != leader _x && (group (driver _vehicle)) == _x ) then {
		_vehicle engineOn _engineon;
	    };
	};
    } forEach _hcgroups;
};


HC_Trans_UnloadMonitor = {
    _this spawn {
	private ["_group","_vehicle","_dismounted","_name"];
	_group = _this select 0;
	_vehicle = _this select 1;
	_dismounted = false;
	while { !_dismounted } do {
	    sleep 0.5;
	    _dismounted = true;
	    {
		if( vehicle _x != _x ) exitWith {_vehicle=vehicle _x;_dismounted=false};
	    } forEach units _group;
	};//while
	_name = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
	(leader _group) sideChat format["We have now unmounted the %1",_name];
    };//spawn
};


HC_Trans_CrewEnterCheck = {
    private ["_units","_grp","_leader","_vehicle","_name"];
    _units = _this select 0;
    _grp = group (_units select 0);
    _leader = leader _grp;
    _vehicle = vehicle _leader;
    if( _vehicle == _leader ) exitWith { _leader sideChat "We could not take control of any near vehicles"};
    _name = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
    if(  group (driver _vehicle) == _grp ) exitWith {_leader sideChat format["We have now mounted and taken control of a %1",_name]};
};


//thank you to Killzone_Kid for this function
KK_fnc_commonTurrets = {
    private ["_arr","_trts"];
    _arr = [];
    _trts = configFile / "CfgVehicles" / typeOf _this / "Turrets";
    for "_i" from 0 to count _trts - 1 do {
	_arr set [count _arr, [_i]];
	for "_j" from 0 to count (
	    _trts / configName (_trts select _i) / "Turrets"
	) - 1 do {
	    _arr set [count _arr, [_i, _j]];
	};
    };
    _arr
};


//[_grp,_vehicle,_slots] call HC_Trans_AssignCrew;
HC_Trans_AssignCrew = {
    private ["_grp","_vehicle","_slots","_idx","_units","_rolearray","_unit","_tmp"];
    _grp 	 = _this select 0;
    _vehicle = _this select 1;

    //we dont want static weapons
    if( (getNumber (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "hasDriver")) == 0 ) exitWith {false};

    //vehicle must not already have a crew assigned
    _units = 0;
    {
	_unit = _x;
	_units = _units + ({_x in (assignedVehicleRole _unit)} count ["Driver","Turret"]);
    } forEach (crew _vehicle);
    if( _units > 0 ) exitWith {false};

    //check if the group can fit in the vehicle with the leader as driver
    _slots 	 = _vehicle call KK_fnc_commonTurrets;//+ 1 driverseat (not turret)
    _units = getNumber (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "transportSoldier");
    if( count (units _grp) + count (crew _vehicle) > (count _slots) + 1 + _units ) exitWith {false};

    //all ok, now we assign the positions
    _units   = units _grp;
    _units   = _units - [leader _grp];
    (leader _grp) assignAsDriver _vehicle;
    _idx=0;
    while {_idx < count _slots && count _units > 0} do {
	_tmp = _units select 0;
	_tmp assignAsTurret [_vehicle, (_slots select _idx)];
	_units   = _units - [_tmp];
	_idx = _idx + 1;
    };
    {_x assignAsCargo _vehicle} forEach _units;
    true
};

HC_Transport_SCToggle = {
    if( HC_Transport_SCToggleVar ) then {
	HC_Transport_SCToggleVar = false;
	hint "HC Transport SideChat Disabled";
    }
    else {
	HC_Transport_SCToggleVar = true;
	hint "HC Transport SideChat Enabled";
    };
};

publicVariable "jib_transport_addAction";
publicVariable "HC_Transport_SCToggleVar";
publicVariable "HC_Transport";
publicVariable "HC_Trans_Load";
publicVariable "HC_Trans_Unload";
publicVariable "HC_Trans_CrewEnter";
publicVariable "HC_Trans_CrewExit";
publicVariable "HC_Trans_HeloLand";
publicVariable "HC_Trans_Engine";
publicVariable "HC_Trans_UnloadMonitor";
publicVariable "HC_Trans_CrewEnterCheck";
publicVariable "HC_Trans_AssignCrew";
publicVariable "HC_Transport_SCToggle";
