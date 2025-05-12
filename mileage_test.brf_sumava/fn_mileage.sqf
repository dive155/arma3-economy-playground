/*
ADV_fnc_mileage:

Shows a hint about current driven distance.

Possible call - has to be executed on each client locally:
0 execVM "fn_mileage.sqf"
*/

if (!hasInterface) exitWith {};

ADV_var_mileageActions = 1;

//mileage counter function:
ADV_fn_mileage = {
	ADV_var_mileage = 1;
	ADV_reach = 0;
	
	_oldPos = position player; 
	
	while {ADV_var_mileage == 1} do {
		_traveledDistance = _oldPos distance position player; 
		ADV_reach = ADV_reach + _traveledDistance;
		_oldPos = position player; 
		
		sleep 1;
		if (ADV_reach < 1000) then {
			hintSilent format ["Distance: %1 m",(round ADV_reach)];
		};
		if (ADV_reach > 1000) then {
			hintSilent format ["Distance: %1 km", ( (round ADV_reach)/1000 )];
		};
	};
};

//mileage action loop:
while {true} do {
	waitUntil {sleep 1; ADV_var_mileageActions == 1};
	//activation action:
	ADV_action_enableMileage = player addAction [("<t color=""#33FFFF"">" + ("Enable Odometer") + "</t>"), {
		//spawns mileage counter function:
		ADV_handle_mileage = [] spawn ADV_fn_mileage;
		//action for resetting the mileage counter:
		ADV_action_reachZero = player addAction [
			("<t color=""#33FFFF"">" + ("Reset Odometer") + "</t>"),
			{
				ADV_reach = 0;
			},nil,3,false,true
		];
		//action for disabling the mileage counter and readding the activation action:
		ADV_action_disableMileage = player addAction [
			("<t color=""#33FFFF"">" + ("Disable Odometer") + "</t>"),
			{
				//exits the ADV_fn_mileage loop:
				ADV_var_mileage = 0;
				//removes the remaining actions:
				{(_this select 1) removeAction _x} forEach [ADV_action_reachZero,(_this select 2)];
				//and readds the activation action:
				ADV_var_mileageActions = 1;
			},nil,3,false,true
		];
		//removes the enable action:
		(_this select 1) removeAction (_this select 2);
	},nil,3,false,true];
	//wait until ADV_action_disableMileage is activated:
	waitUntil {sleep 1; ADV_var_mileageActions == 0;};
};

true;