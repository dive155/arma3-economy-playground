params [
	"_buttonObject", 				
	"_moneyBox",
	"_currencyCode1",
	"_currencyCode2",
	"_soundsConfig",
	["_getExchangeRate", {1}], 			// How much of currency 1 to pay to get 1 currency2
	["_getSpread", {0}]					// How much spread on buying/selling currency2 (in Units)
];


if (isServer) then {
	_buttonObject setVariable ["moneyBox", _moneyBox, true];
	_buttonObject setVariable ["currencyCode1", _currencyCode1, true];
	_buttonObject setVariable ["currencyCode2", _currencyCode2, true];
	_buttonObject setVariable ["getExchangeRate", _getExchangeRate, true];
	_buttonObject setVariable ["getSpread", _getSpread, true];
	
	_soundsMap = createHashMap;
	_soundsMap set ["success", _soundsConfig select 0];
	_soundsMap set ["failure", _soundsConfig select 1];
	_buttonObject setVariable ["soundsMap", _soundsMap, true];
} else {
	waitUntil {sleep 1; not (isNull (_buttonObject getVariable ["moneyBox", objNull]))};
};

fnc_handleMoneyExchangeRequested = {
	params["_buttonObject", "_buyingSecondCurrency"];
	
	_moneyBox = _buttonObject getVariable ["moneyBox", objNull];
	_currencyCode1 = _buttonObject getVariable ["currencyCode1", objNull];
	_currencyCode2 = _buttonObject getVariable ["currencyCode2", objNull];
	_exchangeRate = call (_buttonObject getVariable ["getExchangeRate", objNull]);
	_spread = call (_buttonObject getVariable ["getSpread", objNull]);
	_soundsMap = _buttonObject getVariable ["soundsMap", objNull];
	
	if (_buyingSecondCurrency) then {
		_exchangeRate = _exchangeRate + _spread;
	} else {
		_exchangeRate = _exchangeRate - _spread;
		_exchangeRate = 1.0 / _exchangeRate;
	};
	
	_moneyToTakeCurrency = if (_buyingSecondCurrency) then { _currencyCode1 } else { _currencyCode2 };
	_moneyToGiveCurrency = if (_buyingSecondCurrency) then { _currencyCode2 } else { _currencyCode1 };
	
	_amountInTheBoxFirstCurrency = [_moneyBox, _moneyToTakeCurrency] call fnc_getMoneyAmountInContainer;
	_amountToGiveSecondCurrency = floor (_amountInTheBoxFirstCurrency / _exchangeRate);
	_change = _amountInTheBoxFirstCurrency - (_amountToGiveSecondCurrency * _exchangeRate);
	_amountToTakeFirstCurrency = _amountInTheBoxFirstCurrency - _change;
	
	[_moneyBox, _moneyToTakeCurrency, _amountToTakeFirstCurrency] call fnc_takeMoneyFromContainer;
	[_moneyBox, _moneyToGiveCurrency, _amountToGiveSecondCurrency] call fnc_putMoneyIntoContainer;
	
	// Cosmetics
	if (_amountToGiveSecondCurrency >= 1) then {
		[_buttonObject, _moneyBox, "success", 3] call fnc_playStoreSound;
	} else {
		[_buttonObject, _buttonObject, "failure", 3] call fnc_playStoreSound;
		hint (localize "STR_moneyExchangeNoMoney");
	};
	
	if (_exchangeRate < 1) then { _exchangeRate = 1.0 / _exchangeRate; };
	
	hint format[localize "STR_moneyExchangeReport",
		_amountToTakeFirstCurrency,
		localize ("STR_" + _moneyToTakeCurrency),
		_amountToGiveSecondCurrency,
		localize ("STR_" + _moneyToGiveCurrency),
		_exchangeRate,
		_change
	];
};

if (hasInterface) then {
	_processExchangeFirstCurrencyRequest = {
		[_target, true] spawn fnc_handleMoneyExchangeRequested;
	};
	
	_processExchangeSecondCurrencyRequest = {
		[_target, false] spawn fnc_handleMoneyExchangeRequested;
	};
	
	_formatLoc = localize "STR_buyThing";
	_secondCurrencyLocalized = format[_formatLoc, localize ("STR_" + _currencyCode2)];
	_exchangeFirstAction = ["ExchangeFirstCurrency", _secondCurrencyLocalized, "", _processExchangeFirstCurrencyRequest, {true}] call ace_interact_menu_fnc_createAction;
	[_buttonObject, 0, ["ACE_MainActions"], _exchangeFirstAction] call ace_interact_menu_fnc_addActionToObject;
	
	_fistCurrencyLocalized = format[_formatLoc, localize ("STR_" + _currencyCode1)];
	_exchangeSecondAction = ["ExchangeSecondCurrency", _fistCurrencyLocalized, "", _processExchangeSecondCurrencyRequest, {true}] call ace_interact_menu_fnc_createAction;
	[_buttonObject, 0, ["ACE_MainActions"], _exchangeSecondAction] call ace_interact_menu_fnc_addActionToObject;
};