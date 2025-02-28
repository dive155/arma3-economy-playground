params [
	"_buttonObject", 				// Button to press
	"_inputMoneyBox",
	"_gasPump",
	"_soundsConfig",                // Format: [soundAction, soundSuccess, soundFailure]
	
	["_getStartingFuelInPump", { 0 }],
	["_getFuelInStorage", {99999}],
	["_getPrice", {[currencyCodePdrLeu, 100]}],
	["_onFuelSentToPump", { params ["_litersSent"]}]
];
	
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
	
	_gasPump setVariable ["ace_refuel_capacity", 1000, true];
	_gasPump setVariable ["ace_refuel_currentfuelcargo", call _getStartingFuelInPump, true];
};

fnc_handleFuelPaymentRequested = {
	params ["_buttonObject"];
	
	_inputMoneyBox = _buttonObject getVariable ["inputMoneyBox", objNull];
	
	_priceConfig = call (_buttonObject getVariable ["getPrice", {}]);
	_currencyCode = _priceConfig select 0;
	_pricePerLiter = _priceConfig select 1;
	
	_moneyInBox = [_inputMoneyBox, _currencyCode] call fnc_getMoneyAmountInContainer;
	_desiredLiters = _moneyInBox / _pricePerLiter;
	
	hint format["There are %1 leu in the box, enough for %2 liters", _moneyInBox, _desiredLiters];
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