_gasStationSoundsConfig = [
	"a3\missions_f_beta\data\sounds\firing_drills\target_pop-down_large.wss",
	"pdrstuff\sounds\machine_success_money.ogg",
	"pdrstuff\sounds\machine_error.ogg"
];

fnc_handleFuelSentToPump = {
	params ["_litersSent", "_moneyCurrency", "_moneyAmount"];
	
	["fuelInStorage", -1 * _litersSent] call fnc_increaseWorldVariable;
	
	[
		"cityMoney",
		name player,
		"FuelTrade",
		_moneyAmount
	] call fnc_handleAutomatedAccountTransaction;
};

[
	gas_station_button,
	gas_station_money_box,
	gas_station_pump,
	_gasStationSoundsConfig,
	{ 
		private _isOpen = ["gasStationOpen"] call fnc_getWorldVariable;
		if not _isOpen then { hint localize "STR_gasStationClosed" };
		_isOpen
	},
	{"fuelInStorage" call fnc_getWorldVariable},
	{[currencyCodePdrLeu, "fuelPrice_PDR" call fnc_getWorldVariable]},
	fnc_handleFuelSentToPump
]execVM "scripts\economy\createGasStation.sqf";