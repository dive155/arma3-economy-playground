daysSinceLastMealVarName = "rp_daysSinceLastMeal";

fnc_getDaysSinceLastMeal = {
	_days = player getVariable [daysSinceLastMealVarName, 0];
	_days
};

fnc_incrementDaysSinceLastMeal = {
	_days = player getVariable [daysSinceLastMealVarName, 0];
	_days = _days + 1;
	player setVariable [daysSinceLastMealVarName, _days];
	_days
};