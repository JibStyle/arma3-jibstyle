// Make unit a commander.
params ["_leader"];
if (not isServer) then {throw "Not server!"};
if (not alive _leader) then {throw "Leader not alive!"};

// Throw if already HC
{
    if (_x isKindOf "HighCommand") then {throw "Already HC"};
} forEach synchronizedObjects _leader;

// Maybe create logic group
if (isNil "jib_hc_group") then {
    jib_hc_group = createGroup sideLogic;
};

// Create logics
private _hc = jib_hc_group createUnit [
    "HighCommand", [0, 0, 0], [], 0, "NONE"
];
private _hcSub = jib_hc_group createUnit [
    "HighCommandSubordinate", [0, 0, 0], [], 0, "NONE"
];
_hc synchronizeObjectsAdd [_leader, _hcSub];

// Enable MARTA immediately
[[], {
    setGroupIconsVisible [true, false];
}] remoteExec ["spawn", _leader];

true;
