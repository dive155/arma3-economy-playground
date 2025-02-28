fatigueVarName = "rp_fatigue";

fnc_getPlayerFatigue = {
	player getVariable [fatigueVarName, 0.0];
};

fnc_setPlayerFatigue = {
	params ["_fatigue"];
	player setVariable [fatigueVarName, _fatigue, true];
};

converterFatigueIncrement = 0.125;

fnc_checkIfCanWorkOnConverter = {
	params ["_converterButton"];
	
	_potentialFatigue = (call fnc_getPlayerFatigue) + converterFatigueIncrement;
	if (_potentialFatigue <= 1) then { true } else {
		hint(localize "STR_fatigue_cant_work");
		false
	}
};

fnc_onWorkCompletedOnConverter = {
	params ["_converterButton"];
	_fatigue = (call fnc_getPlayerFatigue) + converterFatigueIncrement;
	_fatigue call fnc_setPlayerFatigue;
};