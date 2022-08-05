// Add guard waypoint to group
params ["_group"];
if (not isServer) then {throw "Not server!"};
if (isNull _group) then {throw "No entity selected!"};

private _wp = count waypoints _group;
_group addWaypoint [getPos leader _group, 0]; // WP uses AGLS
[_group, _wp] setWaypointType "GUARD";
