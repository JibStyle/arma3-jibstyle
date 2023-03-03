// Integrate addon dependencies
if (!isServer) exitWith {};

jib_handler_missionStart = [
    jib_transport_handlerMissionStart,
    jib_zeus_handlerMissionStart,
    jib_draw_missionStart
];
jib_handler_missionEntityRespawned = [
    jib_transport_handlerMissionEntityRespawned,
    jib_zeus_handlerMissionEntityRespawned
];
jib_handler_missionTeamSwitch = [
    jib_hc_handlerMissionTeamSwitch,
    jib_transport_handlerMissionTeamSwitch,
    jib_zeus_handlerMissionTeamSwitch
];
jib_handler_missionOnUserAdminStateChanged = [
    jib_zeus_handlerMissionOnUserAdminStateChanged
];
jib_selectPlayer_handlers = [
    jib_transport_selectPlayerHandler,
    jib_zeus_selectPlayerHandler,
    {
        // Add ALiVE combat support actions
        if (!isNil "NEO_radioLogic") then {
            {
                player addAction _x
            } foreach (
                NEO_radioLogic getVariable "NEO_radioPlayerActionArray"
            );
        };
    }
];
publicVariable "jib_selectPlayer_handlers";

jib_ai_moduleValidate = jib_module_validate;
jib_ai_drawAdd = jib_draw_add;
jib_ai_drawRemove = jib_draw_remove;
jib_alive_moduleValidate = jib_module_validate;
jib_debug_moduleValidate = jib_module_validate;
jib_draw_moduleValidate = jib_module_validate;
jib_hc_moduleValidate = jib_module_validate;
jib_misc_moduleValidate = jib_module_validate;
jib_objective_moduleValidate = jib_module_validate;
jib_random_moduleValidate = jib_module_validate;
jib_replacement_moduleValidate = jib_module_validate;
jib_selectPlayer_moduleValidate = jib_module_validate;
jib_support_moduleValidate = jib_module_validate;
jib_sync_moduleValidate = jib_module_validate;
jib_teleport_moduleValidate = jib_module_validate;
jib_wp_moduleValidate = jib_module_validate;
jib_wp_paraEffectDropzone = jib_para_effectDropzone;
jib_wp_paraEffectEgress = jib_para_effectEgress;
jib_wp_paraEffectIngress = jib_para_effectIngress;
jib_wp_paraUnload = jib_para_unload;
jib_zeus_moduleValidate = jib_module_validate;
jib_zeus_log = jib_log;
publicVariable "jib_ai_moduleValidate";
publicVariable "jib_ai_drawAdd";
publicVariable "jib_ai_drawRemove";
publicVariable "jib_alive_moduleValidate";
publicVariable "jib_debug_moduleValidate";
publicVariable "jib_draw_moduleValidate";
publicVariable "jib_hc_moduleValidate";
publicVariable "jib_misc_moduleValidate";
publicVariable "jib_objective_moduleValidate";
publicVariable "jib_random_moduleValidate";
publicVariable "jib_replacement_moduleValidate";
publicVariable "jib_selectPlayer_moduleValidate";
publicVariable "jib_support_moduleValidate";
publicVariable "jib_sync_moduleValidate";
publicVariable "jib_teleport_moduleValidate";
publicVariable "jib_wp_moduleValidate";
publicVariable "jib_wp_paraEffectDropzone";
publicVariable "jib_wp_paraEffectEgress";
publicVariable "jib_wp_paraEffectIngress";
publicVariable "jib_wp_paraUnload";
publicVariable "jib_zeus_log";
publicVariable "jib_zeus_moduleValidate";

jib_logistics_activate_crate = jib_emitter_crate;
jib_logistics_activate_unit = {
    _this spawn {
        params ["_emitter", "_player"];
        private _unit = [_emitter] call jib_emitter_single select 3 select 0;
        [[_unit, _player], {
            params ["_unit", "_player"];
            [_unit] join group _player;
            waitUntil {alive _unit && group _unit == group _player};
            doStop _unit;
        }] remoteExec ["spawn", _player];
    };
};
jib_logistics_activate_vehicle = jib_emitter_single;
jib_logistics_menu_unit = jib_menu_unit;
jib_logistics_menu_create = jib_menu_create;
jib_logistics_menu_action = jib_menu_action;
jib_menu_alive = jib_alive_menu;
jib_group_serialize_soldier = jib_cereal_serialize_soldier;
publicVariable "jib_group_serialize_soldier";
jib_group_deserialize_soldiers = jib_cereal_deserialize_soldiers;
publicVariable "jib_group_deserialize_soldiers";
jib_group_action = jib_menu_action;
jib_group_menu_dynamic = jib_menu_dynamic;
publicVariable "jib_group_menu_dynamic";
jib_emitter_deserialize_batch = jib_cereal_deserialize_batch;
jib_emitter_deserialize_crate = jib_cereal_deserialize_crate;
jib_emitter_deserialize_waypoint = jib_cereal_deserialize_waypoint;
jib_emitter_serialize_batch = jib_cereal_serialize_batch;
jib_emitter_serialize_crate = jib_cereal_serialize_crate;
jib_emitter_serialize_waypoint = jib_cereal_serialize_waypoint_manual;

// Run the mission start handlers
[] call jib_handler_integrationDone;
