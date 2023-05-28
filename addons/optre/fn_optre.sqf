if (!isServer) exitWith {};

jib_optre_pelican_load = {
    params ["_pelican", "_cargo"];
    if (!isServer) exitWith {};

    private _loaded = false;
    switch true do
    {
        case (
            _cargo isKindOf "OPTRE_M808B_base"
                || _cargo isKindOf "OPTRE_M808B2"
                || _cargo isKindOf "OPTRE_M808BM_Base"
                || _cargo isKindOf "OPTRE_M808B_Arty_Base"
        ) : {
	    _cargo attachTo [_pelican,[0,-7.2, -0.37105]];
	    _cargo setDir 180;
	    _loaded = true;
        };

        case (
            _cargo isKindOf "OPTRE_M808S"
                || _cargo isKindOf "OPTRE_M808L"
        ) :
	{
	    _cargo attachTo [_pelican,[0,-7.2, -2.7805]];
	    _cargo setDir 180;
	    _loaded = true;
	};

        case (
            _cargo isKindOf "OPTRE_M12A1_LRV"
                || _cargo isKindOf "OPTRE_M12_LRV"
                || _cargo isKindOf "OPTRE_M12G1_LRV"
                || _cargo isKindOf "OPTRE_M12R_AA"
                || _cargo isKindOf "OPTRE_M813_TT"
                || _cargo isKindOf "OPTRE_M12_FAV_APC"
        ) : {
	    _cargo attachTo [_pelican,[0,-5,0.25]];
	    _loaded = true;
        };

        case (
            _cargo isKindOf "OPTRE_M12_FAV"
                || _cargo isKindOf "OPTRE_M914_RV"
        ) : {
	    _cargo attachTo [_pelican,[0,-4.25,0.70]];
	    _loaded = true;
        };

        case (_cargo isKindOf "OPTRE_M413_base") : {
	    _cargo attachTo [_pelican,[0,-3.6,0.30]];
	    _loaded = true;
        };

        case (_cargo isKindOf "OPTRE_M494") : {
	    _cargo attachTo [_pelican,[0,-5,-0.75]];
	    _loaded = true;
        };

        case (
            _cargo isKindOf "optre_catfish_unarmed_f"
                || _cargo isKindOf "optre_catfish_mg_f"
        ) : {
	    _cargo attachTo [_pelican,[0,-4.8,-0.1]];
	    _loaded = true;
        };
    };

    if (_loaded) then {
        _pelican setVariable ["jib_optre__pelican_cargo", _cargo, true];
    };

    _loaded;
};

jib_optre_pelican_unload = {
    params ["_pelican"];
    if (!isServer) exitWith {};
    private _cargo =
        _pelican getVariable ["jib_optre__pelican_cargo", objNull];

    _pelican allowDamage false;
    detach _cargo;
    private _v = velocity _pelican;
    _cargo setVelocity [_v # 0, _v # 1, ((_v # 2) - 2)];
    _cargo allowDamage false;

    [_pelican, _cargo] spawn {
        params ["_pelican", "_cargo"];
        sleep 1.0;
        _cargo allowDamage true;
        _pelican allowDamage true;
        _pelican setVariable ["jib_optre__pelican_cargo", objNull, true];
    };
};

jib_optre_drake_hev_setup = {
    params ["_drake", "_console", "_pods"];
    if (!isServer) exitWith {};
    if (count _pods != 6) then {throw "Must be 6 pods"};
    _console setVariable ["OPTRE_PodsLaunchIn", -1, true];
    _console setVariable ["OPTRE_PodsLinkedToConsole", _pods];
    [
        _console, [
            "OPEN CONTROL MENU", OPTRE_Fnc_Menu, ["UNSC_HEV", "UNSC_DATABASE"]
        ]
    ] remoteExecCall ["addAction", 0, true];
    private _attachPoints =
        ["pod1pos", "pod2pos", "pod3pos", "pod4pos", "pod5pos", "pod6pos"];
    for "_i" from 0 to 5 do {
        private _pod = _pods # _i;
        _pod setVariable ["OPTRE_PlayerControled", true, true];
        _pod animate ["main_door_rotation", 1];
        _pod animate ["left_door_rotation", 1];
        _pod animate ["right_door_rotation", 1];
        _pod attachTo [
            _drake getVariable ["OPTRE_DrakeParts", []] select 2,
            [0, 0.17, 1.05],
            _attachPoints # _i
        ];
    };
};

jib_optre__freefallSetup = {
    jib_optre_freefallHeight = 100;
    removeMissionEventHandler [
        "EachFrame",
        missionNamespace getVariable ["jib_optre__freefallEachFrame", -1]
    ];
    missionNamespace setVariable [
        "jib_optre__freefallEachFrame",
        addMissionEventHandler [
            "EachFrame",
            {
                if (vehicle player != player) exitWith {};
                private _lastPlayer = missionNamespace getVariable [
                    "jib_optre__freefallLastPlayer", objNull
                ];
                if (player != _lastPlayer) then {
                    _lastPlayer setUnitFreefallHeight -1;
                    player setUnitFreefallHeight (
                        [jib_optre_freefallHeight, 1e10] select (
                            getPos player select 2 < jib_optre_freefallHeight
                        )
                    );
                    jib_optre__freefallLastPlayer = player;
                };
                getUnitFreefallInfo player params [
                    "_falling", "_animating", "_freefallHeight"
                ];
                if (_falling) then {
                    if (
                        !(_animating) && {
                            getPos player select 2 > jib_optre_freefallHeight
                        }
                    ) then {
                        player setUnitFreefallHeight jib_optre_freefallHeight;
                    };
                } else {
                    if (_freefallHeight < 1e9) then {
                        player setUnitFreefallHeight 1e10;
                    };
                };
            }
        ]
    ];
};
publicVariable "jib_optre__freefallSetup";
[] remoteExecCall ["jib_optre__freefallSetup", 0, true];
