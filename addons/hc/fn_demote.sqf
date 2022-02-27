// Remove all subordinate groups from commander.
params ["_leader"];
if (not isServer) then {throw "Not server!"};
if (isNull _leader) then {throw "Null leader!"};

// Remove all groups
hcRemoveAllGroups _leader;

// Disable MARTA
[[], {
    setGroupIconsVisible [false, false];
}] remoteExec ["spawn", _leader];

true;
