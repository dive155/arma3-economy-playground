daysSinceLastMealVarName = "rp_daysSinceLastMeal";

fnc_getDaysSinceLastMeal = {
	params ["_player"];
	_days = _player getVariable [daysSinceLastMealVarName, 0];
	[_player] call fnc_updateBuff;
	_days
};

fnc_incrementDaysSinceLastMeal = {
	params ["_player"];
	_days = _player getVariable [daysSinceLastMealVarName, 0];
	_days = _days + 1;
	_player setVariable [daysSinceLastMealVarName, _days, true];
	[_player] call fnc_updateBuff;
	_days
};

fnc_satiateHunger = {
	params ["_player"];
	_player setVariable [daysSinceLastMealVarName, 0, true];
	[_player] call fnc_updateBuff;
	hint (localize "STR_HungerSatiated");
};

fnc_energizePlayer = {
	params ["_player"];
	[_player, 1] call fnc_setPlayerEnergized;
	hint (localize "STR_EnergizedWork");
};

fnc_updateBuff = {
	params ["_player"];
	private _days = _player getVariable [daysSinceLastMealVarName, 0];
	
	private _buff = switch (_days) do {
		case 0: { 2 };       // Well-fed → +2
		case 1: { 0 };       // Neutral
		case 2: { -4 };      // Hungry → -4
		default { -8 };      // 3+ days → -8
	};
	
	private _wellFed = [_player] call fnc_getPlayerWellFed;
	_buff = _buff + _wellFed;

	_player setVariable ["DSDR_buff", _buff, true];
};

fnc_getPlayerWellFed = {
	params ["_player"];
	
	private _value = _player getVariable ["rp_well_fed", 0];
	
	if !(_value isEqualType 0) then {
		_value = 0;
		_player setVariable ["rp_well_fed", _value, true];
	};
	
	_value
};

fnc_setPlayerWellFed = {
	params ["_player", "_value"];
	_player setVariable ["rp_well_fed", _value, true];
	[_player] call fnc_updateBuff;
	hint (localize "STR_WellFed");
};

["KSS_usedItem", {
	private _foodType = _this select 0;
	if ((_foodType isEqualTo "pdr_lunch_full") or (_foodType isEqualTo "pdr_onion_soup")) then {
		[player] call fnc_satiateHunger;
	};
	
	if (_foodType isEqualTo "pdr_whoyarilo" or _foodType isEqualTo "pdr_jaguar") then {
		[player] call fnc_energizePlayer;
	};
	
	if ((_foodType isEqualTo "pdr_caviar") or (_foodType isEqualTo "pdr_cake")) then {
		[player, 1] call fnc_setPlayerWellFed;
	};
	
	//systemChat ("AA used " + str(_this select 0))
}] call CBA_fnc_addEventHandler;