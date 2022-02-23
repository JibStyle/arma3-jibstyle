private ["_foo", "_bar", "_curatorUnit"];
params [
    ["_logic", objNull, [objNull]],
    ["_units", [], [[]]], // CfgVehicles.Module_F.AttributesBase.Units
    ["_isActivated", true, [true]]
];
if (_isActivated) then {
    _foo = _logic getVariable ["Foo", -1];
    _bar = _logic getVariable ["Bar", ""];
    _curatorUnit = _logic getvariable [
        "bis_fnc_curatorAttachObject_object",
        objnull
    ];

    my_modules_00_args = _this;
    systemChat format [
        "Foo: %1, bar: %2, curatorUnit: %3 units: %4, pos: %5, args: %6",
        _foo,
        _bar,
        _curatorUnit,
        _units,
        getPosASL _logic,
        _this
    ];
};
true;
