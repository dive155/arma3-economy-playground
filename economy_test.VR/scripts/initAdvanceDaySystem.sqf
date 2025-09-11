fnc_advanceDayServer = {
	params ["_chargeInterest", "_chargeTaxes", "_offlinePlayersWork", "_markServicesUnpaid", "_chargeNpcPayment"];
	[0, 0] call fnc_showLoadingMessageLocal;

	private _currentDay = ["rpDay"] call fnc_getWorldVariable;
	private _newDay = _currentDay + 1;
	["rpDay", _newDay] call fnc_setWorldVariable;
	
	private _knownSteamIds = call DMP_fnc_getAllPersistentSteamIds;
	private _steamIdPlayerPairs = _knownSteamIds apply {
		[_x, [_x] call DMP_fnc_lookupPlayerOnlineSteamId]
	};
	
	[_knownSteamIds] call fnc_handleFatigue;
	[_steamIdPlayerPairs] call fnc_handleHunger;
	
	if (_chargeInterest) then {
		[_steamIdPlayerPairs] call fnc_handleDailyInterest;
		sleep 1;
	};
	
	[1, 0] call fnc_showLoadingMessageLocal;
	if (_chargeTaxes) then {
		[_steamIdPlayerPairs] call fnc_handleDailyTaxes;
		sleep 1;
	};
	
	[2, 0] call fnc_showLoadingMessageLocal;
	if (_offlinePlayersWork) then {
		[_steamIdPlayerPairs] call fnc_handleOfflinePlayers;
		sleep 1;
	};
	
	[_steamIdPlayerPairs] call fnc_handleCivilianInfo;
	
	[3, 0] call fnc_showLoadingMessageLocal;
	if (_markServicesUnpaid) then {
		call fnc_handleCityServices;
		sleep 1;
	};
	
	[3, 0.5] call fnc_showLoadingMessageLocal;
	
	if (_chargeNpcPayment) then {
		call fnc_handleNpcPayments;
		sleep 1;
	};
	
	call DMP_fnc_saveAll;
 	[_newDay] remoteExec ["fnc_showNextDayMessage"];
};

fnc_handleFatigue = {
	params ["_knownSteamIds"];
	{
		[_x, "rp_fatigue_current", 0, true] call DMP_fnc_setPlayerVariableSteamId;
		[_x, "rp_energized", 0, true] call DMP_fnc_setPlayerVariableSteamId;
		[_x, "rp_well_fed", 0, true] call DMP_fnc_setPlayerVariableSteamId;
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
	
	private _totalPlayers = count _steamIdPlayerPairs;
	private _progress = 0;
	
	{	
		_x params ["_steamId", "_player"];
		_x  spawn {
			params ["_steamId", "_player"];

			private _debts = [_steamId, "rp_debts", []] call DMP_fnc_getPlayerVariableSteamId;
			{
				_x params ["_countryCode", "_currentDebt"];
				
				private _interestVarName = "interestRate_" + _countryCode;
				private _interestRate = [_interestVarName] call fnc_getWorldVariable;
				
	
				private _interest = ceil (_currentDebt * _interestRate);
				_interest = _interest max 0;
				
				if (_interest > 0) then {
					[
						_steamId,
						"[Automatic]",
						_countryCode,
						"DailyInterest",
						_interest,
						localize "STR_transactions_automatedSystem"
					] spawn fnc_handlePlayerDebtTransaction;	
				};
				sleep 0.3;
			} forEach _debts;
		};
		
		_progress = _forEachIndex / _totalPlayers;
		[0, _progress] call fnc_showLoadingMessageLocal;
		
		sleep 0.5;
	} forEach _steamIdPlayerPairs;
};

fnc_handleDailyTaxes = {
	params ["_steamIdPlayerPairs"];
	
	private _totalPlayers = count _steamIdPlayerPairs;
	private _progress = 0;
	
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
		sleep 0.2;
		
		_progress = _forEachIndex / _totalPlayers;
		[1, _progress] call fnc_showLoadingMessageLocal;
	} forEach _steamIdPlayerPairs;
};

fnc_handleCityServices = {
	_decreaseVar = {
		params ["_varName"];
		private _value = [_varName] call fnc_getWorldVariable;
		_value = (_value - 1) max 0;
		[_varName, _value] call fnc_setWorldVariable;
	};
	
	["services_paidTram"] call _decreaseVar;
	["services_paidStreetlights"] call _decreaseVar;
	["services_paidSpeedtraps"] call _decreaseVar;
	
	sleep 0.2;
	
	private _lightsPaid = ["services_paidStreetlights"] call fnc_getWorldVariable;
	if (_lightsPaid == 0) then {
		["PDR", false] remoteExec ["fnc_setLightsServer", 2];
	};
	
	private _speedPaid = ["services_paidSpeedtraps"] call fnc_getWorldVariable;
	if (_speedPaid == 0) then {
		["speedTrapsEnabled", false] call fnc_setWorldVariable;
	};
};

fnc_handleNpcPayments = {
	private _factoryPayment = "factoryNpcPayment" call fnc_getWorldVariable;
	
	if (_factoryPayment > 0) then {
		if ([["", _factoryPayment]] call fnc_checkIfFactoryCanPay) then {
			[
				"factoryMoney",
				"NPC",
				"PaymentForNpcs",
				-1 * _factoryPayment
			] call fnc_handleAutomatedAccountTransactionServer;
			
			_factoryPayment = round (_factoryPayment * 0.2);
			[
				"cityMoney",
				"NPC",
				"TaxFromNpcs",
				_factoryPayment
			] call fnc_handleAutomatedAccountTransactionServer;
		};
	};
	
	sleep 0.2;
	private _cityPayment = "cityNpcPayment" call fnc_getWorldVariable;
	
	if (_cityPayment > 0) then {
		if ([["", _cityPayment]] call fnc_checkIfCityCanPay) then {
			[
				"cityMoney",
				"NPC",
				"PaymentForNpcs",
				-1 * _cityPayment
			] call fnc_handleAutomatedAccountTransactionServer;
		};
	};
};

// Scenario for offline players
// Can't work in PDR: Just adding taxes, skip player
// Can work in PDR:
// 1. Works once in Hay and Ore
// 2. Pays price of hay for a lunch
// If PDR citizen
// 3. Pays remaining towards debt
// If Moldovan citizen
// 3a. Converts money accounting for rate and spread
// 4. Pays remaining towards debt

fnc_handleOfflinePlayers = {
	params ["_steamIdPlayerPairs"];
	
	private _totalPlayers = count _steamIdPlayerPairs;
	private _progress = 0;
	
	{
		_x params ["_steamId", "_player"];
				
		if not (isNull _player) then { continue };
		
		([_steamId, 
			["grad_passport_passportRsc", "grad_passport_firstName", "grad_passport_lastName", "rp_visas", "rp_debts", "rp_fatigue_capacity"],
			["", "", "", [], []]
		] call DMP_fnc_getManyPlayerVariablesSteamId)
		params ["_passportRsc", "_firstName", "_lastName", "_visas", "_debts", "_fatigueCapacity"];
		
		private _countryCode = [_passportRsc] call fnc_getCitizenship;
		private _hasRightToWork = false;
		if (_countryCode == "PDR") then {
			_hasRightToWork = true;
		} else {
			if (typeName _visas == "ARRAY") then {
				_hasRightToWork = ({ _x select 0 == "PDR" && { _x select 1 } } count _visas) > 0;
			};
		};
		
		if (_fatigueCapacity < 2) then {
			_hasRightToWork = false;
		};
		
		// Dude can't work in PDR :(
		if not _hasRightToWork then { continue };
		
		// Works at Farm, processes 1 Hay
		// Works at Quarry, processes 1 Ore
		private _totalEarned = 0;
		private _payForHay = "payHay" call fnc_getWorldVariable;
		private _payForOre = "payOre" call fnc_getWorldVariable;
		private _payForBoth = _payForHay + _payForOre;
		
		// Check if stimulator exists in hay_stimulator_box
		_cargo = getItemCargo hay_stimulator_box;
		_hasStimulator = ("pdr_harvest_stimulator" in (_cargo select 0));

		if (
			(["farmOpen"] call fnc_getWorldVariable) and
			(["quarryOpen"] call fnc_getWorldVariable) and
			_hasStimulator
		) then {
			if ([["", _payForBoth]] call fnc_checkIfFactoryCanPay) then {
				[
					"factoryMoney",
					_firstName + " " + _lastName,
					"PaymentForWorkOffline",
					-1 * _payForBoth
				] call fnc_handleAutomatedAccountTransactionServer;

				// Remove one stimulator
				hay_stimulator_box addItemCargoGlobal ["pdr_harvest_stimulator", -1];

				_totalEarned = _payForBoth;
				hay_output_box addBackpackCargoGlobal ["b_dive_grain_bag_worse", 1];
				ore_output_box addBackpackCargoGlobal ["b_dive_ore_bag", 1];
			};
		};
		
		// Eats lunch
		_totalEarned = _totalEarned - ("lunchPrice" call fnc_getWorldVariable);
		// TODO send money to the cook?
		
		if (_totalEarned > 0) then {
			// A moldovan needs to exchange money first
			if (_countryCode == "Moldova") then {
				private _rate = "exchangeRate" call fnc_getWorldVariable;
				_rate = _rate + ("exchangeSpread" call fnc_getWorldVariable);
				_totalEarned = floor (_totalEarned / _rate);
			};
			
			// Limit amount by country's debt
			private _debtAmount = 0;
			{
				if (_x select 0 == _countryCode) exitWith {
					_debtAmount = _x select 1;
				};
			} forEach _debts;

			_totalEarned = _totalEarned min _debtAmount;

			if (_totalEarned <= 0) exitWith {};
			
			// TODO Check if debt will become positive
			[
				_steamId,
				"[Automatic]",
				_countryCode,
				"DebtPaymentOffline",
				-1 * _totalEarned,
				localize "STR_transactions_automatedSystem"
			] call fnc_handlePlayerDebtTransaction;
			
			if (_countryCode == "PDR") then {
				[
					"cityMoney",
					_firstName + " " + _lastName,
					"DebtPaymentOffline",
					_totalEarned
				] call fnc_handleAutomatedAccountTransactionServer;
			} else {
				[
					"moldovaMoney",
					_firstName + " " + _lastName,
					"DebtPaymentOffline",
					_totalEarned
				] call fnc_handleAutomatedAccountTransactionServer;
			};
		};
		sleep 0.5;
		
		_progress = _forEachIndex / _totalPlayers;
		[2, _progress] call fnc_showLoadingMessageLocal;
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

pdr_advanceDayLastUpdate = time;
fnc_showLoadingMessageLocal = {
	params ["_progressStep", "_progressPercent"];
	if ((time - pdr_advanceDayLastUpdate) > 1) then {
		private _totalSteps = 4;
		_progressPercent = round (_progressPercent * 100 / _totalSteps);
		private _progressPerStep = 100 / _totalSteps;
		private _progress = _progressStep * _progressPerStep + _progressPercent;
	
		systemchat str(_progress);
		[_progress] remoteExec ["fnc_showLoadingMessage"];
		pdr_advanceDayLastUpdate = time;
	};
};

fnc_showLoadingMessage = {
	params ["_progressPercent"];
	_text = format [
        "<t size='2' font='EtelkaMonospaceProBold'>%1</t><br/>",
        localize "STR_NewRPDayLoading" + format [" (%1 %%)", _progressPercent]
    ];
	titleText [_text, "PLAIN NOFADE", 30, true, true];
};

fnc_showNextDayMessage = {
    params ["_day"];
    _text = format [
        "<t size='2' font='EtelkaMonospaceProBold'>%1</t><br/>",
        localize "STR_NewRPDayStarting"
    ];
    _text = _text + format [
        "<t size='4' font='EtelkaMonospaceProBold' color='#78ff91'>%1 %2</t><br/>",
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