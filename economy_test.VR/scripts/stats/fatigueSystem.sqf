fatigueVarName = "rp_fatigue";

fnc_getPlayerFatigue = {
	player getVariable [fatigueVarName, 0.0];
};

fnc_setPlayerFatigue = {
	params ["_fatigue"];
	player setVariable [fatigueVarName, _fatigue, true];
};

converterFatigueIncrement = 0.125;

fnc_checkIfNotTooFatigued = {
	params ["_fatigueIncrement"];
	
	_potentialFatigue = (call fnc_getPlayerFatigue) + _fatigueIncrement;
	if (_potentialFatigue <= 1) then { true } else {
		hint(localize "STR_fatigue_cant_work");
		false
	}
};

fnc_increasePlayerFatigue = {
	params ["_fatigueIncrement"];
	_fatigue = (call fnc_getPlayerFatigue) + _fatigueIncrement;
	_fatigue call fnc_setPlayerFatigue;
};