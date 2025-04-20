fatigueVarName = "rp_fatigue_current";
fatigueCapacityVarName = "rp_fatigue_capacity";

fnc_getFatigueCapacity = {
	params ["_player"];
	_player getVariable [fatigueCapacityVarName, 4];
};

fnc_setFatigueCapacity = {
	params ["_player", "_fatigueCapacity"];
	_player setVariable [fatigueCapacityVarName, _fatigueCapacity, true];
};

fnc_getPlayerFatigue = {
	params ["_player"];
	_player getVariable [fatigueVarName, 0.0];
};

fnc_setPlayerFatigue = {
	params ["_player", "_fatigue"];
	_player setVariable [fatigueVarName, _fatigue, true];
};

fnc_checkIfNotTooFatigued = {
	params ["_player", "_fatigueIncrement"];
	
	_potentialFatigue = (call fnc_getPlayerFatigue) + _fatigueIncrement;
	if (_potentialFatigue <= [_player] call fnc_getFatigueCapacity) then { true } else{
		hint(localize "STR_fatigue_cant_work");
		false
	}
};

fnc_increasePlayerFatigue = {
	params ["_player", "_fatigueIncrement"];
	_fatigue = ([_player] call fnc_getPlayerFatigue) + _fatigueIncrement;
	[_player, _fatigue] call fnc_setPlayerFatigue;
};