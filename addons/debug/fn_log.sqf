// Log debug message to system chat
//
// Params should be same as `format`.
private _message = format _this;
if (hasInterface) then {
    systemChat format ["[JIB LOCAL] %1", _message];
} else {
    [format ["[JIB REMOTE] %1", _message]] remoteExec ["systemChat", 0];
};
