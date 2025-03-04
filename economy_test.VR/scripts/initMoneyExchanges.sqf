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
	{ 12 },
	{ 1 }
]execVM "scripts\economy\createMoneyExchange.sqf";