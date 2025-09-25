_gasStationSoundsConfig = [
	"a3\missions_f_beta\data\sounds\firing_drills\target_pop-down_large.wss",
	"pdrstuff\sounds\machine_success_money.ogg",
	"pdrstuff\sounds\machine_error.ogg"
];

fnc_handleFuelSentToPump = {
	params ["_litersSent", "_moneyCurrency", "_moneyAmount"];
	
	["fuelInStorage", -1 * _litersSent] call fnc_increaseWorldVariable;
	
	// Commented out while using fuel tickets
	[
		"cityMoney",
		name player,
		"FuelTrade",
		//_moneyAmount
		0
	] call fnc_handleAutomatedAccountTransaction;
};

[
	gas_station_terminal,
	gas_station_terminal,
	gas_station_pump,
	_gasStationSoundsConfig,
	{ 
		private _isOpen = ["gasStationOpen"] call fnc_getWorldVariable;
		if not _isOpen then { hint localize "STR_gasStationClosed" };
		_isOpen
	},
	{"fuelInStorage" call fnc_getWorldVariable},
	//{[currencyCodePdrLeu, "fuelPrice_PDR" call fnc_getWorldVariable]},
	{[currencyCodeFuelTickets, 1]},
	fnc_handleFuelSentToPump
]execVM "scripts\economy\createGasStation.sqf";

[
	gas_station_terminal_moldova,
	gas_station_terminal_moldova,
	gas_station_pump_moldova,
	_gasStationSoundsConfig,
	{ 
		private _isOpen = ["gasStationOpenMoldova"] call fnc_getWorldVariable;
		if not _isOpen then { hint localize "STR_gasStationClosedMoldova" };
		_isOpen
	},
	{"fuelInStorageMoldova" call fnc_getWorldVariable},
	{[currencyCodeMoldovaLeu, "fuelPrice_Moldova" call fnc_getWorldVariable]},
	{
		params ["_litersSent", "_moneyCurrency", "_moneyAmount"];
		["fuelInStorageMoldova", -1 * _litersSent] call fnc_increaseWorldVariable;
	}
]execVM "scripts\economy\createGasStation.sqf";