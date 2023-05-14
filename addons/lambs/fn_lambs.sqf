if (!isServer) exitWith {};

jib_lambs_group_disable = {
    params ["_group"];
    [_group, {
        params ["_group"];
        _group setVariable ["lambs_danger_disableGroupAI", true];
        units _group apply {_x setVariable ["lambs_danger_disableAI", true]};
    }] remoteExec ["spawn", leader _group];
};

jib_lambs_group_enable = {
    params ["_group"];
    [_group, {
        params ["_group"];
        _group setVariable ["lambs_danger_disableGroupAI", false];
        units _group apply {_x setVariable ["lambs_danger_disableAI", false]};
    }] remoteExec ["spawn", leader _group];
};

jib_lambs_group_debug = {
    params ["_group"];
    [
        !(_group getVariable ["lambs_danger_disableGroupAI", false]),
        units _group apply {
            !(_x getVariable ["lambs_danger_disableAI", false])
        }
    ];
};
