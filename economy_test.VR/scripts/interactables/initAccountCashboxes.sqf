[
	account_atm_cityMoney,
	account_atm_cityMoney,
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
	},
	{
		_str = call fnc_getCityDashboard;
		[_str, 0.01, true] call fnc_showLongTextDialog;
	},
	true,
	"STR_accountOperationsCity",
	10
] execVM "scripts\economy\createAccountCashbox.sqf";

[
	city_dashboard,
	account_atm_cityMoney,
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
	},
	{
		_str = call fnc_getCityDashboard;
		[_str, 0.01, true] call fnc_showLongTextDialog;
	},
	false,
	"STR_operationsCity",
	10
] execVM "scripts\economy\createAccountCashbox.sqf";

[
	account_atm_factoryMoney,
	account_atm_factoryMoney,
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
	},
	{
		private _str = call fnc_getIndustryDashboard;
		[_str, 0.02, true] call fnc_showLongTextDialog;
	},
	true,
	"STR_accountOperationsFactory",
	10
] execVM "scripts\economy\createAccountCashbox.sqf";

[
	factory_dashboard,
	account_atm_factoryMoney,
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
	},
	{
		private _str = call fnc_getIndustryDashboard;
		[_str, 0.02, true] call fnc_showLongTextDialog;
	},
	false,
	"STR_operationsFactory",
	10
] execVM "scripts\economy\createAccountCashbox.sqf";

[
	account_atm_moldovaMoney,
	account_atm_moldovaMoney,
	"moldovaMoney",
	currencyCodeMoldovaLeu,
	{ ["moldovaMoney", 100] call fnc_getWorldVariable },
	{ ["moldovaMoney", _this select 0] call fnc_setWorldVariable },
	{ [player, "accountFull_moldovaMoney", true] call fnc_checkHasPermission },
	{  
		private _record = [_this] call fnc_composeAccountRecord;
		["accountJournal_moldovaMoney", _record] remoteExec ["DMP_fnc_addToJournal", 2];
	},
	{
		[player, "accountFull_moldovaMoney"] call fnc_checkHasPermission or {
			[player, "accountRead_moldovaMoney", true] call fnc_checkHasPermission
		}
	},
	{
		private _str = call fnc_getMoldovaDashboard;
		[_str, 0.02, true] call fnc_showLongTextDialog;
	},
	true,
	"STR_accountOperationsMoldova",
	0
] execVM "scripts\economy\createAccountCashbox.sqf";