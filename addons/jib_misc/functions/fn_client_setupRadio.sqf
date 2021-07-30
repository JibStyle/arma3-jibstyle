// initPlayerLocal.sqf: call jib_misc_fnc_setupRadio;
//systemChat "Setting up radio...";
[{call TFAR_fnc_haveSWRadio}, {
    _channel = player getVariable ["jib_misc_radioChannel", 0];
    _channelAlt = player getVariable ["jib_misc_radioChannelAlt", -1];
    _stereo = if (_channelAlt == -1) then {0} else {1};
    _stereoAlt = if (_channelAlt == -1) then {0} else {2};

    _settings = (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwSettings;
    _settings set [0, _channel];
    _settings set [3, _stereo];
    _settings set [5, _channelAlt];
    _settings set [6, _stereoAlt];
    [(call TFAR_fnc_activeSwRadio), _settings] call TFAR_fnc_setSwSettings;
    systemChat "Radio setup succeeded.";
}, [], 10, {systemChat "Error setting up radio.";}] call CBA_fnc_waitUntilAndExecute;
