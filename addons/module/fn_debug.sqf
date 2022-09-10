params ["_logic", "_units", "_isActivated"];
if (!_isActivated) exitWith {};

private _foo = _logic getVariable ["jib_modules_debugFoo", objNull];
jib_modules_debugFoo = _foo;
