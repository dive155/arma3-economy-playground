_gasStationSoundsConfig = [
	"a3\missions_f_beta\data\sounds\firing_drills\target_pop-down_large.wss",
	"pdrstuff\sounds\machine_success_money.ogg",
	"pdrstuff\sounds\machine_error.ogg"
];

fnc_handleFuelSentToPump = {
	params ["_litersSent", "_moneyCurrency", "_moneyAmount"];
	
	["fuelInStorage", -1 * _litersSent] call fnc_increaseWorldVariable;
	["cityMoney", _moneyAmount] call fnc_increaseWorldVariable;
};

[
	gas_station_button,
	gas_station_money_box,
	gas_station_pump,
	_gasStationSoundsConfig,
	{0},
	{"fuelInStorage" call fnc_getWorldVariable},
	{[currencyCodePdrLeu, "fuelPricePDR" call fnc_getWorldVariable]},
	fnc_handleFuelSentToPump
]execVM "scripts\economy\createGasStation.sqf";