fnc_onPdrFuelSent = {
	params ["_litersSent", "_moneyCurrency", "_moneyAmount"];
	
	_currentFuelInStorage = "fuelInStorage" call fnc_getWorldVariable;
	["fuelInStorage", (_currentFuelInStorage - _litersSent) max 0]  call fnc_setWorldVariable;
};

_gasStationSoundsConfig = [
	"a3\missions_f_beta\data\sounds\firing_drills\target_pop-down_large.wss",
	"pdrstuff\sounds\machine_success_money.ogg",
	"pdrstuff\sounds\machine_error.ogg"
];

fnc_handleFuelSentToPump = {
	params ["_litersSent", "_moneyCurrency", "_moneyAmount"];
};

[
	gas_station_button,
	gas_station_money_box,
	gas_station_pump,
	_gasStationSoundsConfig,
	{0},
	{"fuelInStorage" call fnc_getWorldVariable},
	{[currencyCodePdrLeu, 100]},
	fnc_onPdrFuelSent
]execVM "scripts\economy\createGasStation.sqf";