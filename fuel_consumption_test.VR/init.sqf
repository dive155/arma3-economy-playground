sleep 2;

private _trigger = t1; // Replace 'myTrigger' with the actual trigger variable name
private _vehicles = vehicles select { _x inArea _trigger };

if (count _vehicles > 0) then {
    [_vehicles select 0] execVM "testFuelConsumption.sqf"
} else {
	hint "No vehicles found";
};

