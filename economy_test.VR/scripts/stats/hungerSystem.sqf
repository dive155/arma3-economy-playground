daysSinceLastMealVarName = "rp_daysSinceLastMeal";

fnc_getDaysSinceLastMeal = {
	params ["_player"];
	_days = _player getVariable [daysSinceLastMealVarName, 0];
	_days
};

fnc_incrementDaysSinceLastMeal = {
	params ["_player"];
	_days = _player getVariable [daysSinceLastMealVarName, 0];
	_days = _days + 1;
	_player setVariable [daysSinceLastMealVarName, _days, true];
	_days
};

fnc_satiateHunger = {
	params ["_player"];
	_player setVariable [daysSinceLastMealVarName, 0, true];
};

["KSS_usedItem", {
	private _foodType = _this select 0;
	if (_foodType isEqualTo "pdr_lunch_full") then {
		[player] call fnc_satiateHunger;
	};
	//systemChat ("AA used " + str(_this select 0))
}] call CBA_fnc_addEventHandler;