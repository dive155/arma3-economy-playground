industrialConverterSoundsConfig = [
	"a3\missions_f_beta\data\sounds\firing_drills\target_pop-down_large.wss",
	"pdrstuff\sounds\machine_success.ogg",
	"pdrstuff\sounds\machine_error.ogg",
	"pdrstuff\sounds\machine_success_money.ogg"
];

fnc_checkIfFactoryCanPay = {
	params ["_payConfig"];
	_toPay = _payConfig select 1;
	_factoryMoney = "factoryMoney" call fnc_getWorldVariable;
	_leftover = _factoryMoney - _toPay;
	
	if (_leftover > 0) then { true } else {
		hint(localize "STR_factory_no_money");
		false
	};
};

fnc_takeMoneyFromFactory = {
	params["_moneyToTake"];
	
	_factoryMoney = "factoryMoney" call fnc_getWorldVariable;
	_factoryMoney = _factoryMoney - _moneyToTake;
	["factoryMoney", _factoryMoney] call fnc_setWorldVariable;
};

fnc_checkFactoryWorkConditions = {
	params["_payConfig", "_fatigueKey"];
	
	_fatigueIncrease = _fatigueKey call fnc_getWorldVariable;
	([_payConfig] call fnc_checkIfFactoryCanPay)
		and ([_fatigueIncrease] call fnc_checkIfNotTooFatigued)
};

fnc_handleFactoryWorkCompleted = {
	params["_payConfig", "_fatigueKey"];
	
	_fatigueIncrease = _fatigueKey call fnc_getWorldVariable;
	
	_moneyToTake = _payConfig select 1;
	_moneyToTake call fnc_takeMoneyFromFactory;
	_fatigueIncrease call fnc_increasePlayerFatigue;
};