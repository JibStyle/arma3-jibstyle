player setUnitLoadout (
    player getVariable [
	"jib_inventory_savedLoadout",
	getUnitLoadout (
	    configFile >> "EmptyLoadout"
	)
    ]
);
