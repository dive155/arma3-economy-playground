_cashboxSounds = [
    "a3\missions_f_beta\data\sounds\firing_drills\target_pop-down_large.wss",
    "pdrstuff\sounds\machine_success_money.ogg",
    "pdrstuff\sounds\machine_error.ogg"
];

[
    payment_button_pdr,
    payment_box_pdr,
    "PDR",
    "pdrLeu",
    _cashboxSounds,
	{  	
		//private _steamId = player getVariable "DMP_SteamID";
		//private _record = [_this] call fnc_composeAccountRecord;
		//["debt_" + _steamId + "_PDR", _record] remoteExec ["DMP_fnc_addToJournal", 2];
		_this call fnc_handlePlayerDebtTransactionSteamId;
	},
	{
		 private _args = ["cityMoney"] + _this;
		_args call fnc_handleAutomatedAccountTransaction;
 	}
] execVM "scripts\economy\createPaymentCashbox.sqf";

[
    payment_button_moldova,
    payment_box_moldova,
    "Moldova",
    "moldovaLeu",
    _cashboxSounds,
	{  	
		// private _steamId = player getVariable "DMP_SteamID";
		// private _record = [_this] call fnc_composeAccountRecord;
		// ["debt_" + _steamId + "_Moldova", _record] remoteExec ["DMP_fnc_addToJournal", 2];
		_this call fnc_handlePlayerDebtTransactionSteamId;
	}
] execVM "scripts\economy\createPaymentCashbox.sqf";