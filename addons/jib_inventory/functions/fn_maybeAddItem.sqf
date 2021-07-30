// Add item to unit if not already in inventory
params [
    "_unit",         // Unit to add item to
    "_item",         // Item classname to add
    ["_quantity", 1] // Quantity to add
];
while {
    {_x == _item} count (items _unit) < _quantity
} do {
    _unit addItem _item;
};
