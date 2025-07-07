params [
	"_buttonObject", 				// Button to press
	"_rawResources",                // Format: [[_rawResource1Source, _rawResource1Classname],[...]]
									// _rawResource1Source - Where raw items are checked for. Could be a trigger or a container.
									// _rawResource1Classname - Classname of the raw resource to be processed
	"_outputItemBox",               // Where to put processed items
	"_outputMoneyBox",              // Where to put money
	"_outputItemConfig",            // Items to be outputed, Format [_classname, _amount]
	"_soundsConfig",                // Format: [soundAction, soundSuccess, soundFailure, soundMoney]
	"_localizationConfig",			// Format: [keyAction, keySuccess, keyFailure]
	
	// Callbacks
	["_getPayConfig", {["", 0]}],                                          // Which currency to pay in and how much
	["_extraCondition", { params["_buttonObject", "_payConfig"]; true }],  // Extra condition is in place in case player should not be able to use the thing
	["_onSuccess", { params["_buttonObject", "_payConfig"]; }]            // Executed when the converter has been used successfully
];

if (isServer) then {
	// Save converter settings to the master object (button) on the SERVER
	_buttonObject setVariable ["rawResources", _rawResources, true];
	_buttonObject setVariable ["outputItemBox", _outputItemBox, true];
	_buttonObject setVariable ["outputItemConfig", _outputItemConfig, true];
	_buttonObject setVariable ["localizationConfig", _localizationConfig, true];
	_buttonObject setVariable ["getPayConfig", _getPayConfig, true];
	_buttonObject setVariable ["extraCondition", _extraCondition, true];
	_buttonObject setVariable ["onSuccess", _onSuccess, true];
	
	_soundsMap = createHashMap;
	_soundsMap set ["action", _soundsConfig select 0];
	_soundsMap set ["success", _soundsConfig select 1];
	_soundsMap set ["failure", _soundsConfig select 2];
	_soundsMap set ["money", _soundsConfig select 3];
	_buttonObject setVariable ["soundsMap", _soundsMap, true];
	
	if (not isNull _outputMoneyBox) then {
		_buttonObject setVariable ["outputMoneyBox", _outputMoneyBox, true];
	};
} else {
	waitUntil {
		sleep 1; 
		count (_buttonObject getVariable ["rawResources", []]) > 0
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

// Do conversion on the CLIENT
fnc_removeRawResouce = {
	params ["_buttonObject", "_submittedObject", "_rawResourceSource"];
	
	if (_rawResourceSource isKindOf "EmptyDetector") then {
		// If source is a trigger we need to remove the object inside the trigger
		deleteVehicle _submittedObject;
	} else {
		// If source is a box we need to remove a backpack inside the box
		_rawResourceSource addBackpackCargoGlobal [_submittedObject, -1];
	};
};

// Do conversion on the CLIENT
fnc_giveConversionOutput = {
	params ["_buttonObject"];
	
	// Give Item
	_outputItemBox = _buttonObject getVariable ["outputItemBox", objNull];
	if (not isNull _outputItemBox) then {
		// Check where and what to give
		_outputItemConfig = _buttonObject getVariable ["outputItemConfig", ""];
		_outputItemConfig params ["_outputItemClassname", "_outputItemAmount"];
		
		// Check if we're giving a backpack or an item
		if (isClass (configFile >> "CfgVehicles" >> _outputItemClassname)) then {
			_outputItemBox addBackpackCargoGlobal [_outputItemClassname, _outputItemAmount];
		} else {
			_outputItemBox addItemCargoGlobal [_outputItemClassname, _outputItemAmount];
		};
	};
	
	// Give money
	_outputMoneyBox = _buttonObject getVariable ["outputMoneyBox", objNull];
	if (not isNull _outputMoneyBox) then {
		_payConfig = call (_buttonObject getVariable "getPayConfig");
		[_outputMoneyBox, _payConfig select 0, _payConfig select 1] call fnc_putMoneyIntoContainer;
		
		[_buttonObject, _outputMoneyBox] spawn {
			params ["_buttonObject", "_outputMoneyBox"];
			sleep 2.4;			
			[_buttonObject, _outputMoneyBox, "money", 0.8] call fnc_playStoreSound;
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
			
			// Getting vars
			//_rawResources = (_target getVariable ["rawResources", []]) select 0;
			_rawResources = _target getVariable ["rawResources", []];
			_localizationConfig = _target getVariable["localizationConfig", []];
			_onSuccess = _target getVariable ["onSuccess", {}];
			_payConfig = call (_target getVariable "getPayConfig");
			_extraCondition = _target getVariable ["extraCondition", {true}];
			
			// Extra condition is in place in case player should not be able to use the thing, maybe too tired, doesn't have perms etc.
			if not ([_target, _payConfig] call _extraCondition) exitWith {};

			// Checking if player has provided all the needed resources
			_hasResourceToConvert = true;
			_allMatches = [];
			{
				_rawResourceSource = _x select 0;
				_rawResourceClassname = _x select 1;
				_matches = [];
				
				if (_rawResourceSource isKindOf "EmptyDetector") then {
					_matches = [_rawResourceSource, _rawResourceClassname] call fnc_checkItemsInTrigger;
				} else {
					_matches = [_rawResourceSource, _rawResourceClassname] call fnc_checkBackpacksInBox;
				};
				
				// Conversion happens only if EVERY type of resource has at least 1 item present
				if (count _matches == 0) exitWith {
					_hasResourceToConvert = false;
				};
				
				_allMatches pushBack [_matches select 0, _rawResourceSource];
			} forEach _rawResources;
			
			if (_hasResourceToConvert) then {
				{
					_match = _x select 0;
					_rawResourceSource = _x select 1;

					// Only 1 item of each type is consumed
					[_target, _match, _rawResourceSource] call fnc_removeRawResouce;
				} forEach _allMatches;

				// Give conversion result
				[_target] call fnc_giveConversionOutput;

				// Trigger success callback
				[_target, _payConfig] spawn _onSuccess;

				[_target, _target, "action", 4] call fnc_playStoreSound;
				sleep 1.6;

				// Show localized success message
				private _locKey = _localizationConfig select 1;
				if (!(_locKey isEqualTo "")) then {
					hint localize _locKey;
				};

				// Success sound effect
				[_target, _target, "success", 3] call fnc_playStoreSound;

			} else {
				[_target, _target, "action", 4] call fnc_playStoreSound;
				sleep 1.6;

				// Show localized failure message
				hint localize (_localizationConfig select 2);

				// Failure sound effect
				[_target, _target, "failure", 3] call fnc_playStoreSound;
			};
		};
	};
	
	_localizationConfig = _buttonObject getVariable["localizationConfig", []];
	_processRawResourceAction = ["ProcessRawResource", localize (_localizationConfig select 0), "", _processRawResource, {true}] call ace_interact_menu_fnc_createAction;
	[_buttonObject, 0, [], _processRawResourceAction] call ace_interact_menu_fnc_addActionToObject;
};