_cashboxSounds = [
    "a3\missions_f_beta\data\sounds\firing_drills\target_pop-down_large.wss",
    "pdrstuff\sounds\machine_success_money.ogg",
    "pdrstuff\sounds\machine_error.ogg"
];

[
    payment_atm_pdr,
    payment_atm_pdr,
    "PDR",
    "pdrLeu",
    _cashboxSounds,
	{  	
		_this call fnc_handlePlayerDebtTransaction;
	},
	{
		 private _args = ["cityMoney"] + _this;
		_args call fnc_handleAutomatedAccountTransaction;
 	},
	50
] execVM "scripts\economy\createPaymentCashbox.sqf";

[
    payment_atm_moldova,
    payment_atm_moldova,
    "Moldova",
    "moldovaLeu",
    _cashboxSounds,
	{  	
		_this call fnc_handlePlayerDebtTransaction;
	},
	{
		 private _args = ["moldovaMoney"] + _this;
		_args call fnc_handleAutomatedAccountTransaction;
 	},
	5
] execVM "scripts\economy\createPaymentCashbox.sqf";