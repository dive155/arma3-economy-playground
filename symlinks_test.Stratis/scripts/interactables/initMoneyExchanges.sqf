_exchangeSoundsConfig = [
	"pdrstuff\sounds\machine_success_money.ogg",
	"pdrstuff\sounds\machine_error.ogg"
];

[
	exchange_button,
	exchange_box,
	currencyCodePdrLeu,
	currencyCodeMoldovaLeu,
	_exchangeSoundsConfig,
	{ ["exchangeRate"] call fnc_getWorldVariable },
	{ ["exchangeSpread"] call fnc_getWorldVariable },
	{["inflationCoef_PDR"] call fnc_getWorldVariable},
	{["inflationCoef_Moldova"] call fnc_getWorldVariable}
]execVM "scripts\economy\createMoneyExchange.sqf";