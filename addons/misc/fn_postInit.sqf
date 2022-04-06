// Server
if (!isServer) exitWith {};

// Sync group IDs
allGroups apply {
    private _id = groupId _x;
    _x setGroupIdGlobal [_id];
};
