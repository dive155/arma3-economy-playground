params ["_vehicle"];

// Settings
targetSpeed = 60;
consCoef = 10;
testDistance = 500;


fuelCapacity =  getNumber (configFile >> "CfgVehicles" >> typeOf _vehicle >> "ace_refuel_fuelCapacity");

if (fuelCapacity < 0.1) exitWith { hint "Bad vehicle, no ace_refuel_fuelCapacity, needs modding" };

player moveInDriver _vehicle;
sleep 1;

_vehicle engineOn true;

sleep 1;
//_vehicle setVelocityModelSpace [0, 12, 0];
_pos = getPosATL _vehicle;
_vehicle setPosATL [_pos select 0, _pos select 1, (_pos select 2) + 1.5];

_boostVel = 35;

vehicle player setVelocityModelSpace [0, _boostVel, 0];
sleep 0.2;
vehicle player setVelocityModelSpace [0, _boostVel, 0];
sleep 0.2;
vehicle player setVelocityModelSpace [0, _boostVel, 0];

waitUntil { speed vehicle player < targetSpeed };

true call ace_vehicles_fnc_toggleSpeedControl;

sleep 3;

waitUntil { abs (targetSpeed - speed vehicle player) < 1 };

sleep 2;

waitUntil { abs (targetSpeed - speed vehicle player) < 1 };

sleep 2;

hint "Let's go!";

_vehicle setFuelConsumptionCoef consCoef;
startingFuel = fuel _vehicle;

startPos = getPosATL _vehicle;
currentDistance = 0.1;

while { (testDistance - currentDistance) > 0 } do {
	currentDistance = startPos vectorDistance (getPosATL vehicle player);
	currentDistance = currentDistance + 0.1;
	_currentFuel = fuel vehicle player;
	_fuelConsumed = startingFuel - _currentFuel;
	_fuelConsumedLiters = fuelCapacity * _fuelConsumed;
	_ratePerKM = (1000 / currentDistance) * _fuelConsumedLiters;
	
	_msg = format ["ConsumptionCoef:%1\nDistance: %2/%3\nConsumed Liters:%4\nLiters per km: %5\nFuel capacity: %6\nClassname: %7",
		consCoef, currentDistance, testDistance, _fuelConsumedLiters, _ratePerKM, fuelCapacity, typeOf vehicle player];
	
	hintSilent _msg;
	copyToClipboard _msg;
		
	sleep 0.5;
};

_vehicle setFuelConsumptionCoef 1;
true call ace_vehicles_fnc_toggleSpeedControl;