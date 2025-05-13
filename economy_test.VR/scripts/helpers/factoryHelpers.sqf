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
	params["_payConfig", "_fatigueKey", "_facilityOpenKey", "_moneyBox"];
	_facilityOpen = _facilityOpenKey call fnc_getWorldVariable;
	if not _facilityOpen exitWith {
		hint(localize "STR_factory_closed");
		false
	};
	
	private _moneyInBox = [_moneyBox, _payConfig select 0] call fnc_getMoneyAmountInContainer;
	if (_moneyInBox > 0) exitWith {
		hint(localize "STR_factory_take_money");
		false
	};
	
	_fatigueIncrease = _fatigueKey call fnc_getWorldVariable;
	_canPay = 	if ([_payConfig] call fnc_checkIfFactoryCanPay) then { true } else {
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
	private [
		"_income", "_taxRate", "_tax", "_final", "_commissionRate",
		"_commission", "_netIncome"
	];

    private _payHay           = ["payHay"] call fnc_getWorldVariable;
    private _payOre           = ["payOre"] call fnc_getWorldVariable;
    private _payFactory       = ["payFactory"] call fnc_getWorldVariable;
    private _goodsSellPrice   = ["factoryGoodsSellPrice"] call fnc_getWorldVariable;
    private _taxRate          = ["factoryGoodsTax"] call fnc_getWorldVariable;
    private _bossCut          = ["factoryBossCommission"] call fnc_getWorldVariable;

	private _prodCostTotal = _payHay + _payOre + _payFactory;
	private _cityTax = floor (_goodsSellPrice * _taxRate);
    private _postExpensesRevenue = _goodsSellPrice - _cityTax - _prodCostTotal;
    private _directorCommission = floor (_postExpensesRevenue * _bossCut);
    private _factoryBalance = floor (_goodsSellPrice - _cityTax - _directorCommission - _prodCostTotal);

	[factory_commission_box, currencyCodePdrLeu, _directorCommission] call fnc_putMoneyIntoContainer;

	[
		"factoryMoney",
		name player,
		"SaleOfProducts",
		_factoryBalance
	] call fnc_handleAutomatedAccountTransaction;

	[
		"cityMoney",
		name player,
		"FactoryTax",
		_cityTax
	] call fnc_handleAutomatedAccountTransaction;

	hint format [
		localize "STR_factory_sale_summary",
		_goodsSellPrice,
		_cityTax,
		round (_taxRate * 100),
		_directorCommission,
		round (_bossCut * 100),
		_factoryBalance
	];
};

fnc_checkHowManyBackpacksInBox = {
    params ["_box", "_backpackClass"];
    
    if (isNull _box) exitWith {0};
    
    private _count = 0;
    private _allItems = backpackCargo _box;

    {
        if (_x == _backpackClass) then {
            _count = _count + 1;
        };
    } forEach _allItems;

    _count
};