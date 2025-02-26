params [
	"_buttonObject", 				// Button to press
	"_inputTrigger",                // Where to place raw items
	"_outputItemBox",           // Where to put processed items
	"_outputMoneyBox",              // Where to put money
	"_rawResourceClassname",        // Classname of the raw resource to be processed
	"_outputItemClassname",         // Classname of the item to be outputed
	"_outputMoneyAmount"            // How much money to pay
];


if (isServer) then {
	// Initialize conversion method on the SERVER for all future conversions to use
	if (isNil "DIVE_RawResourceConverterInitialized") then {
		DIVE_RawResourceConverterInitialized = true;
		
		// Do conversion on the SERVER
		fnc_convertRawResourceServer = {
			params ["_buttonObject", "_submittedObject"];
			deleteVehicle _submittedObject;
			
			_outputItemBox = _buttonObject getVariable ["outputItemBox", objNull];
			_outputItemClassname = _buttonObject getVariable ["outputItemClassname", ""];
			_outputItemBox addBackpackCargoGlobal [_outputItemClassname, 1];
		};
	};
	
	// Save converter settings to the master object (button) on the SERVER
	_buttonObject setVariable ["inputTrigger", _inputTrigger, true];
	_buttonObject setVariable ["outputItemBox", _outputItemBox, true];
	_buttonObject setVariable ["outputMoneyBox", _outputMoneyBox, true];
	_buttonObject setVariable ["rawResourceClassname", _rawResourceClassname, true];
	_buttonObject setVariable ["outputItemClassname", _outputItemClassname, true];
	_buttonObject setVariable ["outputMoneyAmount", _outputMoneyAmount, true];
};

if (hasInterface) then {
	_processRawResource = {
		_trigger = _target getVariable ["inputTrigger", objNull];
		_rawResourceClassname = _target getVariable ["rawResourceClassname", ""];
		
		_matches = entities [[_rawResourceClassname],[]] inAreaArray _trigger;
		if (count _matches < 1) then {
			hint ("no matches");
		} else {
			hint ("success");
			
			[_target, _matches select 0] remoteExec ["fnc_convertRawResourceServer" , 2];
		};
	};
	
	_processRawResourceAction = ["ProcessRawResource", "Обработать ресурс", "", _processRawResource, {true}] call ace_interact_menu_fnc_createAction;
	[_buttonObject, 0, ["ACE_MainActions"], _processRawResourceAction] call ace_interact_menu_fnc_addActionToObject;
};