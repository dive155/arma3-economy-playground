params [
	"_buttonObject", 				// Button to press
	"_inputMoneyBox",
	"_gasPump",
	"_soundsConfig",                // Format: [soundAction, soundSuccess, soundFailure]
	
	["_getFuelInStorage", {99999}],
	["_getPrice", {[currencyCodePdrLeu, 100]}],
	["_onFuelSentToPump", { params ["_litersSent", "_moneyCurrency", "_moneyAmount"];}]
];

gas_station_pump_capacity = 1000;

if (isServer) then {
	// Save gas pump settings to the master object (button) on the SERVER
	_buttonObject setVariable ["inputMoneyBox", _inputMoneyBox, true];
	_buttonObject setVariable ["gasPump", _gasPump, true];
	_buttonObject setVariable ["getFuelInStorage", _getFuelInStorage, true];
	_buttonObject setVariable ["getPrice", _getPrice, true];
	_buttonObject setVariable ["onFuelSentToPump", _onFuelSentToPump, true];
	
	_soundsMap = createHashMap;
	_soundsMap set ["action", _soundsConfig select 0];
	_soundsMap set ["success", _soundsConfig select 1];
	_soundsMap set ["failure", _soundsConfig select 2];
	_buttonObject setVariable ["soundsMap", _soundsMap, true];
	
	_gasPump setVariable ["ace_refuel_capacity", gas_station_pump_capacity, true];
};

fnc_handleFuelPaymentRequested = {
	params ["_buttonObject"];
	
	_inputMoneyBox = _buttonObject getVariable ["inputMoneyBox", objNull];
	_gasPump = _buttonObject getVariable ["gasPump", objNull];
	_fuelInPump = _gasPump getVariable ["ace_refuel_currentfuelcargo", 0];
	
	[_target, _target, "action", 3] call fnc_playStoreSound;
	
	_priceConfig = call (_buttonObject getVariable ["getPrice", {}]);
	_currencyCode = _priceConfig select 0;
	_pricePerLiter = _priceConfig select 1;
	
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
	
	// Checking if we can fit this much fuel into the fuel pump
	if (_fuelInPump + _desiredLiters > gas_station_pump_capacity) then {
		_desiredLiters = gas_station_pump_capacity - _fuelInPump;
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


if (hasInterface) then {
	_processFuelPaymentRequest = {
		_this select 0 spawn {
			params ["_target"];
			
			[_target] call fnc_handleFuelPaymentRequested;
		};
	};
	
	_payForFuelAction = ["ProcessRawResource", localize "STR_pay_for_fuel", "", _processFuelPaymentRequest, {true}] call ace_interact_menu_fnc_createAction;
	[_buttonObject, 0, [], _payForFuelAction] call ace_interact_menu_fnc_addActionToObject;
};