fnc_checkIfCityCanPay = {
	params ["_payConfig"];
	_toPay = _payConfig select 1;
	_cityMoney = "cityMoney" call fnc_getWorldVariable;
	_leftover = _cityMoney - _toPay;
	
	if (_leftover > 0) then { true } else {
		hint(localize "STR_city_no_money");
		false
	};
};

fnc_addMoneyToCity = {
	params["_moneyToAdd"];
	
	["cityMoney", _moneyToAdd] call fnc_increaseWorldVariable
};