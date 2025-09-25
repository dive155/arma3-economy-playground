params [
	"_buttonObject", 				// Button to press
	"_inputMoneyBox",
	"_gasPump",
	"_soundsConfig",                // Format: [soundAction, soundSuccess, soundFailure]
	["_extraCondition", {true}],
	["_getFuelInStorage", {99999}],
	["_getPrice", {[currencyCodePdrLeu, 100]}],
	["_onFuelSentToPump", { params ["_litersSent", "_moneyCurrency", "_moneyAmount"];}]
];

gas_station_pump_capacity = 1000;

if (isServer) then {
	// Save gas pump settings to the master object (button) on the SERVER
	_buttonObject setVariable ["inputMoneyBox", _inputMoneyBox, true];
	_buttonObject setVariable ["gasPump", _gasPump, true];
	_buttonObject setVariable ["extraCondition", _extraCondition, true];
	_buttonObject setVariable ["getFuelInStorage", _getFuelInStorage, true];
	_buttonObject setVariable ["getPrice", _getPrice, true];
	_buttonObject setVariable ["onFuelSentToPump", _onFuelSentToPump, true];
	
	_soundsMap = createHashMap;
	_soundsMap set ["action", _soundsConfig select 0];
	_soundsMap set ["success", _soundsConfig select 1];
	_soundsMap set ["failure", _soundsConfig select 2];
	_buttonObject setVariable ["soundsMap", _soundsMap, true];
	
	[_gasPump, 0] call ace_refuel_fnc_setfuel;
	_gasPump setVariable ["ace_refuel_capacity", gas_station_pump_capacity, true];
} else {
	waitUntil {sleep 1; not (isNull (_buttonObject getVariable ["inputMoneyBox", objNull]))};
};

fnc_handleFuelPaymentRequested = {
	params ["_buttonObject", ["_onlyShowPrices", false]];
	
	_inputMoneyBox = _buttonObject getVariable ["inputMoneyBox", objNull];
	_gasPump = _buttonObject getVariable ["gasPump", objNull];
	_fuelInPump = _gasPump getVariable ["ace_refuel_currentfuelcargo", 0];
	
	_extraCondition = _buttonObject getVariable ["extraCondition", objNull];
	if not (call _extraCondition) exitWith {};
	
	_nozzle = _gasPump getVariable ["ace_refuel_ownednozzle", objNull];
	if (not isNull _nozzle) exitWith {
		sleep 1;
		hint(localize "STR_gasStationReturnNozzle");
		[_buttonObject, _buttonObject, "failure", 3] call fnc_playStoreSound;
	};
	
	_priceConfig = call (_buttonObject getVariable ["getPrice", {}]);
	_currencyCode = _priceConfig select 0;
	_pricePerLiter = _priceConfig select 1;
	
	if (_onlyShowPrices) exitWith {
		private _currencyText = localize ("STR_" + _currencyCode);
		hint format[localize "STR_gas_station_prices", _pricePerLiter, _currencyText];
	};
	
	[_target, _target, "action", 3] call fnc_playStoreSound;
	
	_moneyInTheBox = [_inputMoneyBox, _currencyCode] call fnc_getMoneyAmountInContainer;
	if (_moneyInTheBox == 0) exitWith { 
		sleep 1;
		hint(localize "STR_fuel_payment_no_money");
		[_buttonObject, _buttonObject, "failure", 3] call fnc_playStoreSound;
	};
	
	_moneyForPayment = _moneyInTheBox;
	_desiredLiters = _moneyForPayment / _pricePerLiter;
	
	//hint format["There are %1 leu in the box, enough for %2 liters", _moneyForPayment, _desiredLiters];
	_fuelInStorage = _buttonObject call (_buttonObject getVariable ["getFuelInStorage", {0}]);
	
	// Checking if enough fuel is stored in the underground storage
	if (_desiredLiters > _fuelInStorage) then {
		_desiredLiters = _fuelInStorage;
	};
	
	//Checking if we can fit this much fuel into the fuel pump
	if (_fuelInPump + _desiredLiters > gas_station_pump_capacity) then {
		_desiredLiters = gas_station_pump_capacity - _fuelInPump;
	};
	
	private _minimumOrderLiters = 1;
	if (_desiredLiters < _minimumOrderLiters) exitWith {
		sleep 1;
		hint(localize "STR_fuel_payment_too_small");
		[_buttonObject, _buttonObject, "failure", 3] call fnc_playStoreSound;
	};
	
	_moneyForPayment = _desiredLiters * _pricePerLiter;
	[_inputMoneyBox, _currencyCode, _moneyForPayment] call fnc_takeMoneyFromContainer;
	
	_finalFuelInPump = _fuelInPump + _desiredLiters;
	_gasPump setVariable ["ace_refuel_currentfuelcargo", _finalFuelInPump, true];
	
	_onFuelSentToPump = _buttonObject getVariable ["onFuelSentToPump", {}];
	[_desiredLiters, _currencyCode, _moneyForPayment] call _onFuelSentToPump;
	
	// Cosmetics
	_currencyTranslation = localize ("STR_" + _currencyCode);
	_message = format [(localize "STR_fuel_payment_description"), _moneyForPayment, _currencyTranslation, _desiredLiters];
	
	_change = _moneyInTheBox - _moneyForPayment;
	if (_change > 0) then {
		_message = _message + "\n\n" + format[localize "STR_fuel_payment_change", _change, _currencyTranslation];
	};
	
	sleep 1;
	[_buttonObject, _buttonObject, "success", 3] call fnc_playStoreSound;
	hint(_message);
};

// A workaround for multiple vehicles refueling until this is merged
// https://github.com/acemod/ACE3/issues/10904
if (local _gasPump) then {
	[_gasPump] spawn {
		params ["_gasPump"];

		private _prevFuel = [_gasPump] call ace_refuel_fnc_getfuel;
		private _nozzleInUse = false;
		private _refueling = false;
		private _cachedFuel = -1;

		while {true} do {
			sleep 1;

			private _nozzle = _gasPump getVariable ["ace_refuel_ownednozzle", objNull];
			private _currentFuel = [_gasPump] call ace_refuel_fnc_getfuel;
			//systemChat "tick";
			
			// Nozzle has been taken
			if (!isNull _nozzle && !_nozzleInUse) then {
				_nozzleInUse = true;
				_refueling = false;
				// Do not reset _cachedFuel here — it's used to track lock state now
				//systemChat "nozzle taken";
			};

			// Nozzle in use and fuel has changed → refueling started
			if (_nozzleInUse && !_refueling && _currentFuel < _prevFuel) then {
				_refueling = true;
				//systemChat "refueling detected";
			};

			// If nozzle is in use, refueling started, but fuel is not decreasing anymore
			// AND the pump is not already locked (_cachedFuel == -1)
			if (_nozzleInUse && _refueling && _currentFuel >= _prevFuel && _cachedFuel == -1) then {
				// Lock pump
				_cachedFuel = _currentFuel;
				[_gasPump, 0] call ace_refuel_fnc_setfuel;
				_gasPump setVariable ["DIVE_fuelCargoCached", _cachedFuel, true];
				_refueling = false;
				//systemChat "locking pump caching " + str(_cachedFuel);
			};

			// Nozzle returned
			if (isNull _nozzle && _nozzleInUse) then {
				_nozzleInUse = false;

				// Restore cached fuel only if it was cached (i.e. pump was locked)
				_cachedFuel = _gasPump getVariable ["DIVE_fuelCargoCached", -1];
				//systemChat "restoring cached amount " + str(_cachedFuel);
				if (_cachedFuel > -1) then {
					[_gasPump, _cachedFuel] call ace_refuel_fnc_setfuel;
					_gasPump setVariable ["DIVE_fuelCargoCached", -1, true];
					_cachedFuel = -1;
				};
			};

			_prevFuel = _currentFuel;
		};
	};
};

if (hasInterface) then {
	_showFuelPrice = {
		_this select 0 spawn {
			params ["_target"];
			
			[_target, true] call fnc_handleFuelPaymentRequested;
		};
	};
	
	_showFuelPriceAction = ["ShowFuelPrices", localize "STR_check_fuel_prices", "", _showFuelPrice, {true}] call ace_interact_menu_fnc_createAction;
	[_buttonObject, 0, ["ACE_MainActions"], _showFuelPriceAction] call ace_interact_menu_fnc_addActionToObject;
	
	_processFuelPaymentRequest = {
		_this select 0 spawn {
			params ["_target"];
			
			[_target] call fnc_handleFuelPaymentRequested;
		};
	};
	
	_payForFuelAction = ["PayForFuel", localize "STR_pay_for_fuel", "", _processFuelPaymentRequest, {true}] call ace_interact_menu_fnc_createAction;
	[_buttonObject, 0, ["ACE_MainActions"], _payForFuelAction] call ace_interact_menu_fnc_addActionToObject;
};