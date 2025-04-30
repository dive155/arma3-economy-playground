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
	_leftover > 0
};

fnc_checkFactoryWorkConditions = {
	params["_payConfig", "_fatigueKey"];
	
	_fatigueIncrease = _fatigueKey call fnc_getWorldVariable;
	_canPay = 	if (_leftover > 0) then { true } else {
		hint(localize "STR_factory_no_money");
		false
	};
	_canPay and ([player, _fatigueIncrease] call fnc_checkIfNotTooFatigued)
};

fnc_handleConverterWorkCompleted = {
	params["_payConfig", "_fatigueKey"];
	
	_fatigueIncrease = _fatigueKey call fnc_getWorldVariable;
	
	_moneyToTake = _payConfig select 1;
	
	[
		"factoryMoney",
		name player,
		"PaymentForWork",
		-1 * _moneyToTake
	] call fnc_handleAutomatedAccountTransaction;
	
	[player, _fatigueIncrease] call fnc_increasePlayerFatigue;
};

fnc_sellProducedFactoryGoods = {
	_income = "factoryGoodsSellPrice" call fnc_getWorldVariable;
	_tax = "factoryGoodsTax" call fnc_getWorldVariable;
	_productionCost = 
		("payHay" call fnc_getWorldVariable)
		+ ("payOre" call fnc_getWorldVariable)
		+ ("payFactory" call fnc_getWorldVariable);
	
	_profit = _income - _productionCost;
	
	_tax = _tax * _profit;
	_final = _income - _tax;
	
	_commission = "factoryBossCommission" call fnc_getWorldVariable;
	[factory_commission_box, currencyCodePdrLeu, _commission] call fnc_putMoneyIntoContainer;
	
	_final = _final - _commission;
	
	[
		"factoryMoney",
		name player,
		"SaleOfProducts",
		_final
	] call fnc_handleAutomatedAccountTransaction;
	
	[
		"cityMoney",
		name player,
		"FactoryTax",
		_tax
	] call fnc_handleAutomatedAccountTransaction;
};