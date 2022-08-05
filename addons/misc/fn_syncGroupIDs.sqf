// Push group IDs from current machine to all
allGroups apply {
    private _id = groupId _x;
    _x setGroupIdGlobal [_id];
};
