call compile preprocessFileLineNumbers "scripts\passports\compilePassportNotes.sqf";

getDateText = {
	_curDate = date;
	_ddMMyyyy = format ["%2.%1",
		(if (_curDate select 1 < 10) then { "0" } else { "" }) + str (_curDate select 1),
		(if (_curDate select 2 < 10) then { "0" } else { "" }) + str (_curDate select 2)
	];
	_ddMMyyyy
};

getTimeText = {
	_timeText = [dayTime, "HH:MM"] call BIS_fnc_timeToString;
	_timeText = " (" + _timeText + ")";
	_timeText
};

notifyPassportChanged = {
	params ["_receiver"];
	hint "Внёс изменения в паспорт игрока";
	["В ваш паспорт внесены изменения"] remoteExec ["hint", _receiver];
};

cacheTarget = {
	params ["_toCache"];
	player setVariable ["cachedTarget", _toCache, true];
};

loadCachedTarget = {
	_cachedTarget = player getVariable ["cachedTarget", objNull];
	_cachedTarget
};