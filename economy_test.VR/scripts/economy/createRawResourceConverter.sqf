params [
	"_buttonObject", 				// Button to press
	"_rawResourceSource",           // Where to place raw items
	"_outputItemBox",               // Where to put processed items
	"_outputMoneyBox",              // Where to put money
	"_rawResourceClassname",        // Classname of the raw resource to be processed
	"_outputItemClassname",         // Classname of the item to be outputed
	"_outputMoneyAmount"            // How much money to pay
];

_scriptHandle = execVM "scripts\economy\banknoteConversion.sqf";
waitUntil { scriptDone _scriptHandle };

// Do conversion on the SERVER
fnc_convertRawResourceServer = {
	params ["_buttonObject", "_submittedObject"];
	deleteVehicle _submittedObject;
	
	// Give processed resource
	_outputItemBox = _buttonObject getVariable ["outputItemBox", objNull];
	_outputItemClassname = _buttonObject getVariable ["outputItemClassname", ""];
	_outputItemBox addBackpackCargoGlobal [_outputItemClassname, 1];
	
	// Give money
	_outputMoneyBox = _buttonObject getVariable ["outputMoneyBox", objNull];
	_outputMoneyAmount = _buttonObject getVariable ["outputMoneyAmount", 0];
	[_outputMoneyBox, _outputMoneyAmount] call fnc_putMoneyIntoContainer;
};

if (isServer) then {
	// Save converter settings to the master object (button) on the SERVER
	_buttonObject setVariable ["rawResourceSource", _rawResourceSource, true];
	_buttonObject setVariable ["outputItemBox", _outputItemBox, true];
	_buttonObject setVariable ["outputMoneyBox", _outputMoneyBox, true];
	_buttonObject setVariable ["rawResourceClassname", _rawResourceClassname, true];
	_buttonObject setVariable ["outputItemClassname", _outputItemClassname, true];
	_buttonObject setVariable ["outputMoneyAmount", _outputMoneyAmount, true];
};

fnc_checkItemsInTrigger = {
	params ["_buttonObject"];
	_trigger = _buttonObject getVariable ["rawResourceSource", objNull];
	_rawResourceClassname = _buttonObject getVariable ["rawResourceClassname", ""];
	_matches = entities [[_rawResourceClassname],[]] inAreaArray _trigger;
	_matches
};

fnc_checkBackpacksInBox = {
	params ["_buttonObject"];
};

// CLIENT part
if (hasInterface) then {
	//Action to pass to ace actions
	
	
	_processRawResource = {
		// Using spawn to get to scheduled environment
		_this select 0 spawn {
			params ["_target"];
		
			playSound3D ["a3\missions_f_beta\data\sounds\firing_drills\target_pop-down_large.wss", _target, false, getPosASL _target, 4];
			sleep 1.6;
			
			// Resources check on CLIENT
			_matches = _target call fnc_checkItemsInTrigger;
			
			if (count _matches < 1) then {
				hint ("no matches");
				playSound3D ["pdrstuff\sounds\machine_error.ogg", _target, false, getPosASL _target, 3];
			} else {
				[_target, _matches select 0] remoteExec ["fnc_convertRawResourceServer" , 2];
				
				hint ("success");
				playSound3D ["pdrstuff\sounds\machine_success.ogg", _target, false, getPosASL _target, 3];
				sleep 0.8;
				_outputMoneyBox = _target getVariable ["outputMoneyBox", objNull];
				playSound3D ["pdrstuff\sounds\machine_success_money.ogg", _outputMoneyBox, false, getPosASL _outputMoneyBox, 0.8];
				
			};
		};
	};
	
	_processRawResourceAction = ["ProcessRawResource", "Обработать ресурс", "", _processRawResource, {true}] call ace_interact_menu_fnc_createAction;
	[_buttonObject, 0, [], _processRawResourceAction] call ace_interact_menu_fnc_addActionToObject;
};