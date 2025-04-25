fnc_composeAccountRecord = {
	params ["_accountID", "_operationRecord"];
	_operationRecord params ["_playerName", "_operationType", "_amount", "_playersNote"];
	
	private _date = date;
	_date params ["_year", "_month", "_day", "_hours", "_minutes"];

	// Construct formatted string
	private _dateString = format ["%1.%2.%3 %4:%5", _day, _month, _year, _hours, _minutes];
	
	private _result = format ["%1,%2,%3,%4,%5", _dateString, _playerName, _operationType, _amount, _playersNote];
	_result
};

[
	account_button_cityMoney,
	account_box_cityMoney,
	"cityMoney",
	currencyCodePdrLeu,
	{ ["cityMoney", 100] call fnc_getWorldVariable },
	{ ["cityMoney", _this select 0] call fnc_setWorldVariable },
	{ [player, "accountFull_cityMoney", true] call fnc_checkHasPermission },
	{  
		private _record = ["cityMoney", _this] call fnc_composeAccountRecord;
		["accountJournal_cityMoney", _record] remoteExec ["DMP_fnc_addToJournal", 2];
	}
] execVM "scripts\economy\createAccountCashbox.sqf";

[
	account_button_factoryMoney,
	account_box_factoryMoney,
	"factoryMoney",
	currencyCodePdrLeu,
	{ ["factoryMoney", 100] call fnc_getWorldVariable },
	{ ["factoryMoney", _this select 0] call fnc_setWorldVariable },
	{ [player, "accountFull_factoryMoney", true] call fnc_checkHasPermission },
	{  
		private _record = ["factoryMoney", _this] call fnc_composeAccountRecord;
		["accountJournal_factoryMoney", _record] remoteExec ["DMP_fnc_addToJournal", 2];
	}
] execVM "scripts\economy\createAccountCashbox.sqf";