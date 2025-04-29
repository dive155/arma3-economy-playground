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
	
	[_steamIdPlayerPairs] call fnc_handleDailyInterest;
	sleep 2;
	[_steamIdPlayerPairs] call fnc_handleDailyTaxes;
	sleep 2;
	
	call DMP_fnc_saveAll;
	[_steamIdPlayerPairs] call fnc_handleCivilianInfo;
 	[_newDay] remoteExec ["fnc_showNextDayMessage"];
};

fnc_handleFatigue = {
	params ["_knownSteamIds"];
	{
		[_x, "rp_fatigue_current", 0, true] call DMP_fnc_setPlayerVariableSteamId;
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

fnc_handleDailyInterest = {
	params ["_steamIdPlayerPairs"];
	{	
		_x params ["_steamId", "_player"];
		_x  spawn {
			params ["_steamId", "_player"];

			private _debts = [_steamId, "rp_debts", []] call DMP_fnc_getPlayerVariableSteamId;
			{
				_x params ["_countryCode", "_currentDebt"];
				
				private _interestVarName = "interestRate_" + _countryCode;
				private _interestRate = [_interestVarName] call fnc_getWorldVariable;
				
	
				private _interest = round (_currentDebt * _interestRate);
				_interest = _interest max 0;
						
				[
					_steamId,
					"[Automatic]",
					_countryCode,
					"DailyInterest",
					_interest,
					localize "STR_transactions_automatedSystem"
				] spawn fnc_handlePlayerDebtTransaction;
				
				sleep 1;
			} forEach _debts;
		};
	} forEach _steamIdPlayerPairs;
};

fnc_handleDailyTaxes = {
	params ["_steamIdPlayerPairs"];
	{
		_x params ["_steamId", "_player"];
		
		([_steamId, ["grad_passport_passportRsc", "rp_dailybills"]] call DMP_fnc_getManyPlayerVariablesSteamId)
		params ["_passportRsc", "_dailyBills"];
		
		// TODO - can't pay bills to multiple countries
		private _countryCode = [_passportRsc] call fnc_getCitizenship;
		
		[
			_steamId,
			"[Automatic]",
			_countryCode,
			"DailyBills",
			_dailyBills,
			localize "STR_transactions_automatedSystem"
		] spawn fnc_handlePlayerDebtTransaction;
	} forEach _steamIdPlayerPairs;
};

fnc_handleCivilianInfo = {
	params ["_steamIdPlayerPairs"];
	{
		_x params ["_steamId", "_player"];			
		if not (isNull _player) then {
			[_player] call fn_updateCivilianInfo; 
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