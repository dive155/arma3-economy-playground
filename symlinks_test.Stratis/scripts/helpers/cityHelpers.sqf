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

fnc_getCityMoney = {
	["cityMoney"] call fnc_getWorldVariable;
};

fnc_getCiviliansInfoServer = {
	params["_countryCode"];
	
	private _steamIds = call DMP_fnc_getAllPersistentSteamIds;
	private _result = [];
	{
		private _data = [_x, ["grad_passport_passportRsc","grad_passport_firstName", "grad_passport_lastName", "rp_govtjob", "rp_govtsalary", "rp_dailybills", "rp_debts"]]call DMP_fnc_getManyPlayerVariablesSteamId;
		
		_data params ["_passport", "_name", "_surname", "_job", "_salary", "_bills", "_debts"];
		
		_online = not (isNull ([_x] call DMP_fnc_lookupPlayerOnlineSteamId));
		_data pushBack _online;
		
		private _playerCountryCode = [_passport] call fnc_getCitizenship;
		
		if (_playerCountryCode isEqualTo _countryCode) then {
			private _debt = 0;
			{
				if (_x select 0 isEqualTo _countryCode) then {
					_debt = _x select 1;
				};
			} forEach _debts;
			
			_data set [6, _debt];
			_result pushBack _data;
		};
		
	} forEach _steamIds;
	_result
};
