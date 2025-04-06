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
	_player setVariable [daysSinceLastMealVarName, _days];
	_days
};