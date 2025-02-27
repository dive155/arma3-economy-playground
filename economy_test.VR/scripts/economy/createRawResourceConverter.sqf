params [
	"_buttonObject", 				// Button to press
	"_rawResourceSource",           // Where raw items are checked for. Could be a trigger or a container.
	"_outputItemBox",               // Where to put processed items
	"_outputMoneyBox",              // Where to put money
	"_rawResourceClassname",        // Classname of the raw resource to be processed
	"_outputItemClassname",         // Classname of the item to be outputed
	"_outputMoneyAmount",           // How much money to pay
	"_soundsConfig",                // Format: [soundAction, soundSuccess, soundFailure, soundMoney]
	"_localizationConfig"			// Format: [keyAction, keySuccess, keyFailure]
];

_scriptHandle = execVM "scripts\economy\banknoteConversion.sqf";
waitUntil { scriptDone _scriptHandle };

if (isServer) then {
	// Save converter settings to the master object (button) on the SERVER
	_buttonObject setVariable ["rawResourceSource", _rawResourceSource, true];
	_buttonObject setVariable ["outputItemBox", _outputItemBox, true];
	_buttonObject setVariable ["rawResourceClassname", _rawResourceClassname, true];
	_buttonObject setVariable ["outputItemClassname", _outputItemClassname, true];
	_buttonObject setVariable ["outputMoneyAmount", _outputMoneyAmount, true];
	_buttonObject setVariable ["localizationConfig", _localizationConfig, true];
	
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
		_outputMoneyAmount = _buttonObject getVariable ["outputMoneyAmount", 0];
		[_outputMoneyBox, _outputMoneyAmount] call fnc_putMoneyIntoContainer;
		
		sleep 0.8;			
		[_buttonObject, _outputMoneyBox, "money", 0.8] call fnc_playConverterSound;
	};
};

// CLIENT init part
if (hasInterface) then {
	//Action to pass to ace actions
	_processRawResource = {
		// Using spawn to get to scheduled environment
		_this select 0 spawn {
			params ["_target"];
			
			[_target, _target, "action", 4] call fnc_playConverterSound;
			_localizationConfig = _target getVariable["localizationConfig", []];
			
			sleep 1.6;
			
			// Checking whether we have resource to convert
			_matches = [];
			_rawResourceSource = _target getVariable ["rawResourceSource", objNull];
			_rawResourceClassname = _target getVariable ["rawResourceClassname", ""];
			if (_rawResourceSource isKindOf "EmptyDetector") then {
				_matches = [_rawResourceSource, _rawResourceClassname] call fnc_checkItemsInTrigger;
			} else {
				_matches = [_rawResourceSource, _rawResourceClassname] call fnc_checkBackpacksInBox;
			};
			
			if (count _matches > 0) then {
				hint localize (_localizationConfig select 1);
				[_target, _target, "success", 3] call fnc_playConverterSound;
				[_target, _matches select 0, _rawResourceSource] call fnc_convertRawResource;
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