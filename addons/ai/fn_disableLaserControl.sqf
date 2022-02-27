// Disable AI laser control
params ["_group"];
if (not isServer) throw {"Not server!"};
if (isNull _group) throw {"Null group!"};

// Signal daemon to exit
#define LASER_CONTROL_VARIABLE "jib_ai_laserControlEnabled"
_group setVariable [LASER_CONTROL_VARIABLE, false, owner leader _group];
true;
