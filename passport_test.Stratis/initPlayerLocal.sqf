waitUntil { not isNull player };

if (player getVariable ["visa_giver", false]) then {
	_changeData = {
		_text = _target getVariable ["grad_passport_misc1", ""];
		_text = _text + "<br/>1";
		_target setVariable ["grad_passport_misc1",_text, true];
	};

	_action = ["Give Visa", "Give Visa", "", _changeData, {true}] call ace_interact_menu_fnc_createAction;
	["CAManBase", 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;
};