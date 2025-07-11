fatigueVarName = "rp_fatigue_current";
fatigueCapacityVarName = "rp_fatigue_capacity";
energizedVarName = "rp_energized";

fnc_getFatigueCapacityEnergized = {
	params ["_player"];
	private _cap = _player getVariable [fatigueCapacityVarName, 4];
	private _energized = [_player] call fnc_getPlayerEnergized;
	_cap + _energized
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
	if (_potentialFatigue <= [_player] call fnc_getFatigueCapacityEnergized) then { true } else{
		hint(localize "STR_fatigue_cant_work");
		false
	}
};

fnc_increasePlayerFatigue = {
	params ["_player", "_fatigueIncrement"];
	_fatigue = ([_player] call fnc_getPlayerFatigue) + _fatigueIncrement;
	[_player, _fatigue] call fnc_setPlayerFatigue;
};

fnc_getPlayerEnergized = {
	params ["_player"];
	
	private _value = _player getVariable [energizedVarName, 0];
	
	if !(_value isEqualType 0) then {
		_value = 0;
		_player setVariable [energizedVarName, _value, true];
	};
	
	_value
};

fnc_setPlayerEnergized = {
	params ["_player", "_value"];
	
	_player setVariable [energizedVarName, _value, true];
};