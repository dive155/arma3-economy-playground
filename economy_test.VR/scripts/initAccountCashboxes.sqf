[
	account_button_cityMoney,
	account_box_cityMoney,
	"cityMoney",
	currencyCodePdrLeu,
	{ ["cityMoney", 100] call fnc_getWorldVariable },
	{ ["cityMoney", _this select 0] call fnc_setWorldVariable },
	{ [player, "accountFull_cityMoney", true] call fnc_checkHasPermission },
	{  
		private _record = [_this] call fnc_composeAccountRecord;
		["accountJournal_cityMoney", _record] remoteExec ["DMP_fnc_addToJournal", 2];
	},
	{
		[player, "accountFull_cityMoney"] call fnc_checkHasPermission or {
			[player, "accountRead_cityMoney", true] call fnc_checkHasPermission
		}
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
		private _record = [_this] call fnc_composeAccountRecord;
		["accountJournal_factoryMoney", _record] remoteExec ["DMP_fnc_addToJournal", 2];
	},
	{
		[player, "accountFull_factoryMoney"] call fnc_checkHasPermission or {
			[player, "accountRead_factoryMoney", true] call fnc_checkHasPermission
		}
	}
] execVM "scripts\economy\createAccountCashbox.sqf";