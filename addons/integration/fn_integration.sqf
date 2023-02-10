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
jib_menu_alive_opcom_disable = jib_alive_opcomDisable;
jib_menu_alive_opcom_enable = jib_alive_opcomEnable;
jib_menu_alive_profile_disable = jib_alive_profileDisable;
jib_menu_alive_profile_enable = jib_alive_profileEnable;
jib_menu_alive_register_disable = jib_alive_registerDisable;
jib_menu_alive_register_enable = jib_alive_registerEnable;
jib_menu_handler_main_menu = jib_handler_isMainMenu;
jib_menu_service_group_bottom = jib_service_group_bottom;
jib_menu_service_group_top = jib_service_group_top;
jib_menu_service_group_delete = jib_service_group_delete;
jib_menu_zeus_admin = jib_zeus_admin;
publicVariable "jib_menu_alive_opcom_disable";
publicVariable "jib_menu_alive_opcom_enable";
publicVariable "jib_menu_alive_profile_disable";
publicVariable "jib_menu_alive_profile_enable";
publicVariable "jib_menu_alive_register_disable";
publicVariable "jib_menu_alive_register_enable";
publicVariable "jib_menu_service_group_bottom";
publicVariable "jib_menu_service_group_top";

// Run the mission start handlers
[] call jib_handler_integrationDone;
