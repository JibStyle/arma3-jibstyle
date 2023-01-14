if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_debug_moduleValidate = {};

// PRIVATE BELOW HERE

jib_debug_count = {
    private _westGroup = 0;
    private _westMan = 0;
    private _westCar = 0;
    private _westTank = 0;
    private _westAir = 0;
    private _westOther = 0;

    private _independentGroup = 0;
    private _independentMan = 0;
    private _independentCar = 0;
    private _independentTank = 0;
    private _independentAir = 0;
    private _independentOther = 0;

    private _eastGroup = 0;
    private _eastMan = 0;
    private _eastCar = 0;
    private _eastTank = 0;
    private _eastAir = 0;
    private _eastOther = 0;

    private _civilianGroup = 0;
    private _civilianMan = 0;
    private _civilianCar = 0;
    private _civilianTank = 0;
    private _civilianAir = 0;
    private _civilianOther = 0;

    vehicles apply {
        private _type = typeOf _x;
        private _side = side _x;
        switch (_side) do
        {
            case west: {
                switch (true) do
                {
                    case (_type isKindOf "car"): {_westCar = _westCar + 1};
                    case (_type isKindOf "tank"): {_westTank = _westTank + 1};
                    case (_type isKindOf "air"): {_westAir = _westAir + 1};
                    default {_westOther = _westOther + 1};
                };
            };
            case independent: {
                switch (true) do
                {
                    case (_type isKindOf "car"): {_independentCar = _independentCar + 1};
                    case (_type isKindOf "tank"): {_independentTank = _independentTank + 1};
                    case (_type isKindOf "air"): {_independentAir = _independentAir + 1};
                    default {_independentOther = _independentOther + 1};
                };
            };
            case east: {
                switch (true) do
                {
                    case (_type isKindOf "car"): {_eastCar = _eastCar + 1};
                    case (_type isKindOf "tank"): {_eastTank = _eastTank + 1};
                    case (_type isKindOf "air"): {_eastAir = _eastAir + 1};
                    default {_eastOther = _eastOther + 1};
                };
            };
            case civilian: {
                switch (true) do
                {
                    case (_type isKindOf "car"): {_civilianCar = _civilianCar + 1};
                    case (_type isKindOf "tank"): {_civilianTank = _civilianTank + 1};
                    case (_type isKindOf "air"): {_civilianAir = _civilianAir + 1};
                    default {_civilianOther = _civilianOther + 1};
                };
            };
        };
    };

    allUnits apply {
        private _type = typeOf _x;
        private _side = side _x;
        if (_type isKindOf "man") then {
            switch (_side) do
            {
                case west: {_westMan = _westMan + 1};
                case independent: {_independentMan = _independentMan + 1};
                case east: {_eastMan = _eastMan + 1};
                case civilian: {_civilianMan = _civilianMan + 1};
            };
        };
    };

    allGroups apply {
        private _side = side _x;
        switch (_side) do
        {
            case west: {_westGroup = _westGroup + 1};
            case independent: {_independentGroup = _independentGroup + 1};
            case east: {_eastGroup = _eastGroup + 1};
            case civilian: {_civilianGroup = _civilianGroup + 1};
        };
    };

    format [
        "B%1m%2c%3t%4a%5o%6_I%7m%8c%9t%10a%11o%12_O%13m%14c%15t%16a%17o%18_C%19m%20c%21t%22a%23o%24",
        _westGroup,
        _westMan,
        _westCar,
        _westTank,
        _westAir,
        _westOther,
        _independentGroup,
        _independentMan,
        _independentCar,
        _independentTank,
        _independentAir,
        _independentOther,
        _eastGroup,
        _eastMan,
        _eastCar,
        _eastTank,
        _eastAir,
        _eastOther,
        _civilianGroup,
        _civilianMan,
        _civilianCar,
        _civilianTank,
        _civilianAir,
        _civilianOther
    ];
};
publicVariable "jib_debug_count";

jib_debug_moduleCopyPositionASL = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            private _posASL = ATLToASL _posATL;
            jib = _posASL; // Special convenience var
            copyToClipboard str _posASL;
            systemChat format ["%1 copied and set to jib.", _posASL];
        },
        [],
        "local"
    ] call jib_debug_moduleValidate;
};

jib_debug_moduleCopyPositionATL = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            jib = _posATL; // Special convenience var
            copyToClipboard str _posATL;
            systemChat format ["%1 copied and set to jib.", _posATL];
        },
        [],
        "local"
    ] call jib_debug_moduleValidate;
};

jib_debug_moduleSelectEntity = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            jib = _attached; // Special convenience var
            systemChat format ["%1 set to jib.", _attached];
        },
        [],
        "local"
    ] call jib_debug_moduleValidate;
};

publicVariable "jib_debug_moduleValidate";
publicVariable "jib_debug_moduleCopyPositionASL";
publicVariable "jib_debug_moduleCopyPositionATL";
publicVariable "jib_debug_moduleSelectEntity";
