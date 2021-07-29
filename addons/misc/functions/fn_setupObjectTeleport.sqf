// Add action to teleport to destination object
params [
    "_object",      // Object to assign action to
    "_destination", // Object to teleport to
    "_title"        // Action title
];
_object addAction [
    _title,         // title
    {
        params ["_target", "_caller", "_actionId", "_arguments"];
        _arguments params ["_destination"];
        player setPos getPos _destination;
    },              // code
    [_destination], // arguments
    10,             // priority
    true,           // showWindow
    true,           // hideOnUse
    "",             // shortcut
    "true",         // condition
    5,              // radius
    false,          // unconscious
    "",             // selection
    ""              // memoryPoint
];
