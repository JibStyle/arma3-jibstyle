// Add group to HC commander.
params ["_commander", "_group"];
if (not isServer) then {throw "Not server!"};
if (isNull _commander) then {throw "Commander not alive!"};
if (isNull _group) then {throw "Null group!"};

// Add group to HC
if (hcLeader _group != _commander) then {
    hcLeader _group hcRemoveGroup _group;
    private _t = time + 1;
    waitUntil { isNull hcLeader _group || time > _t };
    _commander hcSetGroup [_group];
    _t = time + 1;
    waitUntil { hcLeader _group == _commander || time > _t};
};
true;
