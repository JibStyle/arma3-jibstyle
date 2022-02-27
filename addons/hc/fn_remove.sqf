// Remove group from HC.
params ["_group"];
if (not isServer) then {throw "Not server!"};
if (isNull _group) then {throw "Null group!"};
hcLeader _group hcRemoveGroup _group;
true;
