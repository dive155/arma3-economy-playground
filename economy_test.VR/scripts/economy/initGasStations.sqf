_gasStationSoundsConfig = [
	"a3\missions_f_beta\data\sounds\firing_drills\target_pop-down_large.wss",
	"pdrstuff\sounds\machine_success_money.ogg",
	"pdrstuff\sounds\machine_error.ogg"
];

[
	gas_station_button,
	gas_station_money_box,
	gas_station_pump,
	_gasStationSoundsConfig
]execVM "scripts\economy\createGasStation.sqf";