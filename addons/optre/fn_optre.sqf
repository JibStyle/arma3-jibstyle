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
