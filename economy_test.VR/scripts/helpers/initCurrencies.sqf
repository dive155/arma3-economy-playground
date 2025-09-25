_scriptHandle = execVM "scripts\economy\banknoteConversion.sqf";
waitUntil { scriptDone _scriptHandle };

currencyCodePdrLeu = "pdrLeu";
[
	currencyCodePdrLeu, 
	[["pdr_1000_leu", 1000], 
	["pdr_500_leu", 500], 
	["pdr_100_leu", 100], 
	["pdr_50_leu", 50], 
	["pdr_10_leu", 10], 
	["pdr_5_leu", 5], 
	["pdr_1_leu", 1]]
] call fnc_createCurrencyDefinition;

currencyCodeMoldovaLeu = "moldovaLeu";
[
	currencyCodeMoldovaLeu,
	[["moldova_100_leu", 100], 
	["moldova_50_leu", 50], 
	["moldova_10_leu", 10], 
	["moldova_5_leu", 5], 
	["moldova_1_leu", 1]]
] call fnc_createCurrencyDefinition;

currencyCodeFuelTickets = "fuelTickets";
[
	currencyCodeFuelTickets, 
	[["pdr_fuel_50", 50], 
	["pdr_fuel_10", 10], 
	["pdr_fuel_5", 5], 
	["pdr_fuel_1", 1]]
] call fnc_createCurrencyDefinition;