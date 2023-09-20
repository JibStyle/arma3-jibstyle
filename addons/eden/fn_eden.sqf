// TODO: Make into traditional SQF function. Preinit doesn't work for Eden.

// New standard loadout
jib_eden_loadout_standard = {
    params ["_unit"];

    // Define helpers
    private _add_fn = {
        params ["_quantity", "_item"];
        for "_i" from 0 to _quantity - 1 do (
            switch true do
            {
                case (_unit canAddItemToUniform [_item, _quantity]): {
                    {_unit addItemToUniform _item}
                };
                case (_unit canAddItemToVest [_item, _quantity]): {
                    {_unit addItemToVest _item}
                };
                case (_unit canAddItemToBackpack [_item, _quantity]): {
                    {_unit addItemToBackpack _item}
                };
                default {{_unit addItem _item}};
            }
        );
    };
    private _add_uniform_fn = {
        params ["_quantity", "_item"];
        for "_i" from 0 to _quantity - 1 do {_unit addItemToUniform _item};
    };
    private _add_vest_fn = {
        params ["_quantity", "_item"];
        for "_i" from 0 to _quantity - 1 do {_unit addItemToVest _item};
    };
    private _add_backpack_fn = {
        params ["_quantity", "_item"];
        for "_i" from 0 to _quantity - 1 do {_unit addItemToBackpack _item};
    };

    // Ensure base primary weapon
    private _primaryWeaponBase = getText (
        configFile >> "CfgWeapons" >> primaryWeapon _unit >> "baseWeapon"
    );
    private _primaryWeaponMagazine = primaryWeaponMagazine _unit;
    private _primaryWeaponItems = primaryWeaponItems _unit;
    if (_primaryWeaponBase != primaryWeapon _unit) then {
        _unit addWeapon _primaryWeaponBase;
        _primaryWeaponMagazine + _primaryWeaponItems apply {
            _unit addPrimaryWeaponItem _x
        };
    };

    // Ensure base secondary weapon
    private _secondaryWeaponBase = getText (
        configFile >> "CfgWeapons" >> secondaryWeapon _unit >> "baseWeapon"
    );
    private _secondaryWeaponMagazine = secondaryWeaponMagazine _unit;
    private _secondaryWeaponItems = secondaryWeaponItems _unit;
    if (_secondaryWeaponBase != secondaryWeapon _unit) then {
        _unit addWeapon _secondaryWeaponBase;
        _secondaryWeaponMagazine + _secondaryWeaponItems apply {
            _unit addSecondaryWeaponItem _x
        };
    };

    // Ensure base handgun weapon
    private _handgunWeaponBase = getText (
        configFile >> "CfgWeapons" >> handgunWeapon _unit >> "baseWeapon"
    );
    private _handgunMagazine = handgunMagazine _unit;
    private _handgunItems = handgunItems _unit;
    if (_handgunWeaponBase != handgunWeapon _unit) then {
        _unit addWeapon _handgunWeaponBase;
        _handgunMagazine + _handgunItems apply {
            _unit addHandgunItem _x
        };
    };

    // Ensure base backpack
    if (
        !isNull (
            configFile >> "CfgVehicles" >> backpack _unit
                >> "TransportItems"
        )
            || !isNull (
                configFile >> "CfgVehicles" >> backpack _unit
                    >> "TransportMagazines"
            )
    ) then {
        private _backpack = configName inheritsFrom (
            configFile >> "CfgVehicles" >> backpack _unit
        );
        removeBackpack _unit;
        _unit addBackpack _backpack;
    };

    // Standard linked items
    private _old_hmd = hmd _unit;
    removeAllAssignedItems _unit; // map,compass,watch,radio,GPS,NVG,bino
    _unit linkItem "ItemCompass";
    _unit linkItem "ItemMap";
    _unit linkItem "ItemWatch";

    // NVG
    private _hmd_map = [
        [["NVGoggles"], "ACE_NVG_Wide"],
        [["NVGoggles_OPFOR"], "ACE_NVG_Wide_Black"],
        [["NVGoggles_INDEP"], "ACE_NVG_Wide_Green"],
        [["NVGoggles_tna_F"], "ACE_NVG_Wide_Green"]
    ];
    _hmd_map apply {
        _x params ["_froms", "_to"];
        if (_old_hmd in _froms) exitWith {_unit linkItem _to};
    };
    if (hmd _unit == "") then {_unit linkItem _old_hmd};

    // Standard container items
    removeAllItemsWithMagazines _unit;
    [
        [1, "ACE_EarPlugs"],
        [1, "ACE_Flashlight_XL50"],
        [2, "ACE_packingBandage"],
        [2, "ACE_fieldDressing"],
        [1, "ACE_morphine"],
        [1, "ACE_tourniquet"],
        [1, "SmokeShell"],
        [1, "HandGrenade"],
        [2, "Chemlight_green"],
        [4, "ACE_CableTie"]
    ] apply {_x call _add_fn};
    [
        [1, "ACRE_PRC343"],
        [1, "ItemAndroid"]
    ] apply {_x call _add_vest_fn};

    // Special trait container items
    if (_unit getUnitTrait "Medic") then {
        [
            [20, "ACE_packingBandage"],
            [20, "ACE_fieldDressing"],
            [5, "ACE_epinephrine"],
            [5, "ACE_morphine"],
            [5, "ACE_splint"],
            [5, "ACE_tourniquet"],
            [5, "ACE_salineIV_500"],
            [5, "ACE_adenosine"]
        ] apply {_x call _add_backpack_fn};
    };
    if (_unit getUnitTrait "Engineer") then {
        [
            [1, "ToolKit"],
            [1, "ACE_EntrenchingTool"],
            [1, "ACE_wirecutter"]
        ] apply {_x call _add_backpack_fn};
    };
    if (_unit getUnitTrait "ExplosiveSpecialist") then {
        [
            [1, "MineDetector"],
            [1, "ACE_DefusalKit"],
            [1, "ACE_Clacker"],
            [6, "DemoCharge_Remote_Mag"]
        ] apply {_x call _add_backpack_fn};
    };
    if (_unit getUnitTrait "UavHacker") then {
        _unit linkItem (
            switch (side _unit) do
            {
                case west: {"B_UavTerminal"};
                case east: {"O_UavTerminal"};
                case independent: {"I_UavTerminal"};
                default {"C_UavTerminal"};
            }
        );
    };
    if (
        !isNull (
            configFile >> "CfgWeapons" >> primaryWeaponItems _unit # 2
                >> "ACE_ScopeAdjust_Vertical"
        )
    ) then {
        [1, "ACE_RangeCard"] call _add_vest_fn;
    };
    if (leader _unit == _unit) then {
        _unit addWeapon "ACE_Vector";
        [1, "ACE_microDAGR"] call _add_vest_fn;
    };

    // Add magazines until full
    _handgunMagazine apply {[2, _x] call _add_vest_fn};
    _primaryWeaponMagazine apply {[2, _x] call _add_vest_fn}; // min 2 each
    _primaryWeaponMagazine apply {[20, _x] call _add_vest_fn}; // max
    _secondaryWeaponMagazine apply {[2, _x] call _add_backpack_fn};
    _secondaryWeaponMagazine apply {[20, _x] call _add_backpack_fn};
};
