fatigueVarName = "rp_fatigue_current";
fatigueCapacityVarName = "rp_fatigue_capacity";

fnc_getFatigueCapacity = {
	player getVariable [fatigueCapacityVarName, 4];
};

fnc_setFatigueCapacity = {
	params ["_fatigueCapacity"];
	player setVariable [fatigueCapacityVarName, _fatigueCapacity, true];
};

fnc_getPlayerFatigue = {
	player getVariable [fatigueVarName, 0.0];
};

fnc_setPlayerFatigue = {
	params ["_fatigue"];
	player setVariable [fatigueVarName, _fatigue, true];
};

fnc_checkIfNotTooFatigued = {
	params ["_fatigueIncrement"];
	
	_potentialFatigue = (call fnc_getPlayerFatigue) + _fatigueIncrement;
	if (_potentialFatigue <= call fnc_getFatigueCapacity) then { true } else {
		hint(localize "STR_fatigue_cant_work");
		false
	}
};

fnc_increasePlayerFatigue = {
	params ["_fatigueIncrement"];
	_fatigue = (call fnc_getPlayerFatigue) + _fatigueIncrement;
	_fatigue call fnc_setPlayerFatigue;
};