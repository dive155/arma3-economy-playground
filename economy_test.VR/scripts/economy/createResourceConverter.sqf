params [
	"_buttonObject", 				// Button to press
	"_rawResources",                // Format: [[_rawResource1Source, _rawResource1Classname],[...]]
									// _rawResource1Source - Where raw items are checked for. Could be a trigger or a container.
									// _rawResource1Classname - Classname of the raw resource to be processed
	"_outputItemBox",               // Where to put processed items
	"_outputMoneyBox",              // Where to put money
	"_outputItemClassname",         // Classname of the item to be outputed
	"_outputMoneyCurrency",         // Which currency to pay in
	"_outputMoneyAmount",           // How much money to pay
	"_soundsConfig",                // Format: [soundAction, soundSuccess, soundFailure, soundMoney]
	"_localizationConfig",			// Format: [keyAction, keySuccess, keyFailure]
	
	// Callbacks
	["_extraCondition", { params["_buttonObject"]; true }],      // Extra condition is in place in case player should not be able to use the thing
	["_onSuccess", { params["_buttonObject"]; }]				 // Executed when the converter has been used successfully
];

if (isServer) then {
	// Save converter settings to the master object (button) on the SERVER
	_buttonObject setVariable ["rawResources", _rawResources, true];
	_buttonObject setVariable ["outputItemBox", _outputItemBox, true];
	_buttonObject setVariable ["outputItemClassname", _outputItemClassname, true];
	_buttonObject setVariable ["outputMoneyCurrency", _outputMoneyCurrency, true];
	_buttonObject setVariable ["outputMoneyAmount", _outputMoneyAmount, true];
	_buttonObject setVariable ["localizationConfig", _localizationConfig, true];
	_buttonObject setVariable ["extraCondition", _extraCondition, true];
	_buttonObject setVariable ["onSuccess", _onSuccess, true];
	
	_soundsMap = createHashMap;
	_soundsMap set ["action", _soundsConfig select 0];
	_soundsMap set ["success", _soundsConfig select 1];
	_soundsMap set ["failure", _soundsConfig select 2];
	_soundsMap set ["money", _soundsConfig select 3];
	_buttonObject setVariable ["soundsMap", _soundsMap, true];
	
	if (not isNil "_outputMoneyBox") then {
		_buttonObject setVariable ["outputMoneyBox", _outputMoneyBox, true];
	};
};

fnc_checkItemsInTrigger = {
	params ["_rawResourceSource", "_rawResourceClassname"];
	_trigger = _rawResourceSource;
	_matches = entities [[_rawResourceClassname],[]] inAreaArray _trigger;
	_matches
};

fnc_checkBackpacksInBox = {
	params ["_rawResourceSource", "_rawResourceClassname"];
	
	_cargo = getBackpackCargo _rawResourceSource;
	_cargo = _cargo select 0;
	
	_matches = [];
	if ((_cargo find _rawResourceClassname) != -1) then {
		_matches pushBack _rawResourceClassname;
	};
	_matches
};

// Play sound based on a sound key from _soundsConfig
fnc_playConverterSound = {
	params ["_buttonObject", "_source", "_soundKey", "_volume"];
	
	_sounds = _buttonObject getVariable ["soundsMap", createHashMap];
	_soundName = _sounds get _soundKey;
	
	playSound3D [_soundName, _source, false, getPosASL _source, _volume];
};


// Do conversion on the CLIENT
fnc_convertRawResource = {
	params ["_buttonObject", "_submittedObject", "_rawResourceSource"];
	
	if (_rawResourceSource isKindOf "EmptyDetector") then {
		// If source is a trigger we need to remove the object inside the trigger
		deleteVehicle _submittedObject;
	} else {
		// If source is a box we need to remove a backpack inside the box
		_rawResourceSource addBackpackCargoGlobal [_submittedObject, -1];
	};
	
	// Check where and what to give
	_outputItemBox = _buttonObject getVariable ["outputItemBox", objNull];
	_outputItemClassname = _buttonObject getVariable ["outputItemClassname", ""];
	
	// Check if we're giving a backpack or an item
	if (isClass (configFile >> "CfgVehicles" >> _outputItemClassname)) then {
		_outputItemBox addBackpackCargoGlobal [_outputItemClassname, 1];
	} else {
		_outputItemBox addItemCargoGlobal [_outputItemClassname, 1];
	};
	
	// Give money
	_outputMoneyBox = _buttonObject getVariable ["outputMoneyBox", objNull];
	if (not isNil "_outputMoneyBox") then {
		_outputMoneyCurrency = _buttonObject getVariable ["outputMoneyCurrency", currencyCodePdrLeu];
		_outputMoneyAmount = _buttonObject getVariable ["outputMoneyAmount", 0];
		[_outputMoneyBox, _outputMoneyCurrency, _outputMoneyAmount] call fnc_putMoneyIntoContainer;
		
		[_buttonObject, _outputMoneyBox] spawn {
			params ["_buttonObject", "_outputMoneyBox"];
			sleep 2.4;			
			[_buttonObject, _outputMoneyBox, "money", 0.8] call fnc_playConverterSound;
		}
	};
};

// CLIENT init part
if (hasInterface) then {
	//Action to pass to ace actions
	_processRawResource = {
		// Using spawn to get to scheduled environment
		_this select 0 spawn {
			params ["_target"];
			
			// Extra condition is in place in case player should not be able to use the thing, maybe too tired, doesn't have perms etc.
			_extraCondition = _target getVariable ["extraCondition", {true}];
			if not (_target call _extraCondition) exitWith {};
			
			[_target, _target, "action", 4] call fnc_playConverterSound;
			
			// Checking whether we have resource to convert
			_matches = [];
			// TODO multiple resources
			_rawResources = (_target getVariable ["rawResources", []]) select 0;
			_rawResourceSource = _rawResources select 0;
			_rawResourceClassname = _rawResources select 1;
			
			if (_rawResourceSource isKindOf "EmptyDetector") then {
				_matches = [_rawResourceSource, _rawResourceClassname] call fnc_checkItemsInTrigger;
			} else {
				_matches = [_rawResourceSource, _rawResourceClassname] call fnc_checkBackpacksInBox;
			};
			_hasResourceToConvert = count _matches > 0;
			
			// Logic happens instantaneously to prevent exploits
			if (_hasResourceToConvert) then {

				[_target, _matches select 0, _rawResourceSource] call fnc_convertRawResource;
				_onSuccess = _target getVariable ["onSuccess", {}];
				_target spawn _onSuccess;
			};
			
			sleep 1.6;
			
			// Cosmetics happen with a bit of a delay
			_localizationConfig = _target getVariable["localizationConfig", []];
			if (_hasResourceToConvert) then {
				hint localize (_localizationConfig select 1);
				[_target, _target, "success", 3] call fnc_playConverterSound;
			} else {
				hint localize (_localizationConfig select 2);
				[_target, _target, "failure", 3] call fnc_playConverterSound;
			};
		};
	};
	
	_localizationConfig = _buttonObject getVariable["localizationConfig", []];
	_processRawResourceAction = ["ProcessRawResource", localize (_localizationConfig select 0), "", _processRawResource, {true}] call ace_interact_menu_fnc_createAction;
	[_buttonObject, 0, [], _processRawResourceAction] call ace_interact_menu_fnc_addActionToObject;
};