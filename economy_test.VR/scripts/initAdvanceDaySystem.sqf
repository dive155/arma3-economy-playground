fnc_advanceDayServer = {
	private _currentDay = ["rpDay"] call fnc_getWorldVariable;
	private _newDay = _currentDay + 1;
	["rpDay", _newDay] call fnc_setWorldVariable;
	
	private _knownSteamIds = call DMP_fnc_getAllPersistentSteamIds;
	private _steamIdPlayerPairs = _knownSteamIds apply {
		[_x, [_x] call DMP_fnc_lookupPlayerOnlineSteamId]
	};
	
	[_knownSteamIds] call fnc_handleFatigue;
	[_steamIdPlayerPairs] call fnc_handleHunger;
	
	sleep 3;
	call DMP_fnc_saveAll;
 	[_newDay] remoteExec ["fnc_showNextDayMessage"];
};

fnc_handleFatigue = {
	params ["_knownSteamIds"];
	{
		[_x, "rp_fatigue_current", 0, true] call DMP_fnc_setPlayerVariableSteamId
	} forEach _knownSteamIds;
};

fnc_handleHunger = {
	params ["_steamIdPlayerPairs"];
	{
		_x params ["_steamId", "_player"];
		
		if not isNull _player then {
			[_player] call fnc_incrementDaysSinceLastMeal;
		};
	} forEach _steamIdPlayerPairs;
};

fnc_showNextDayMessage = {
    params ["_day"];
    _text = format [
        "<t size='2' font='EtelkaMonospaceProBold'>%1</t><br/>",
        localize "STR_NewRPDayStarting"
    ];
    _text = _text + format [
        "<t size='4' font='EtelkaMonospaceProBold' color='#ffd330'>%1 %2</t><br/>",
        localize "STR_rpDay", _day
    ];
    _text = _text + format [
        "<t size='1.2' font='EtelkaMonospaceProBold'>%1<br/>%2<br/>%3<br/></t>",
        localize "STR_WorkFatigueReset",
        localize "STR_HungerIncreased",
        localize "STR_DailyBillsAdded"
    ];
    
    titleText [_text, "PLAIN NOFADE", 1, true, true];
    playSound "DSDR_Success";
    sleep 15;
    titleFadeOut 1;
};