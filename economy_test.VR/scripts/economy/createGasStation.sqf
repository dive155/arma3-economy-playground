params [
	"_buttonObject", 				// Button to press
	"_inputMoneyBox",
	"_gasPump",
	"_soundsConfig",                // Format: [soundAction, soundSuccess, soundFailure]
	
	["_getPrice", {[currencyCodePdrLeu, 100]}],
	["_getFuelInStorage", {99999}],
	["_onFuelSentToPump", { params ["_litersSent"]}]
];
	
if (isServer) then {
	// Save gas pump settings to the master object (button) on the SERVER
	_buttonObject setVariable ["inputMoneyBox", _inputMoneyBox, true];
	_buttonObject setVariable ["gasPump", _gasPump, true];
	_buttonObject setVariable ["getPrice", _getPrice, true];
	_buttonObject setVariable ["getFuelInStorage", _getFuelInStorage, true];
	_buttonObject setVariable ["onFuelSentToPump", _onFuelSentToPump, true];
	
	_soundsMap = createHashMap;
	_soundsMap set ["action", _soundsConfig select 0];
	_soundsMap set ["success", _soundsConfig select 1];
	_soundsMap set ["failure", _soundsConfig select 2];
	_buttonObject setVariable ["soundsMap", _soundsMap, true];
};