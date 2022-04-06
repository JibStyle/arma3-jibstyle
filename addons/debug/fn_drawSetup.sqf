// Setup debug drawing
//
// NOTE: Local effect!
if (not hasInterface) exitWith { "No interface!" };
if (not isNil "jib_debug_drawHandle") then {
    [] call jib_debug_fnc_drawTeardown;
};
jib_debug_drawHandle = addMissionEventHandler [
    "Draw3D",
    {
        if (isNil "jib_debug_drawObjects") exitWith { "No list!" };
        {
            private _color = [0,1,0,.5];
            private _offset = 2; // Additional height
            private _shadow = true;
            private _textSize = .05;

            drawIcon3D [
                "",
                _color,
                ASLToAGL getPosASLVisual _x vectorAdd [
                    0,
                    0,
                    boundingBox _x # 1 # 2 + _offset
                ],
                0,
                0,
                0,
                _x getVariable ["jib_debug_drawText", ""],
                _shadow,
                _textSize
            ];
        } forEach jib_debug_drawObjects;
    }
];
