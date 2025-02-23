waitUntil { not isNull player };

getDateText = {
	_curDate = date;
	_ddMMyyyy = format ["%2.%1",
		(if (_curDate select 1 < 10) then { "0" } else { "" }) + str (_curDate select 1),
		(if (_curDate select 2 < 10) then { "0" } else { "" }) + str (_curDate select 2)
	];
	_ddMMyyyy
};

getTimeText = {
	_timeText = [dayTime, "HH:MM"] call BIS_fnc_timeToString;
	_timeText = " (" + _timeText + ")";
	_timeText
};

if (player getVariable ["visa_giver", false]) then {

	_issueVisa = {
		_message = (call getDateText) + " <t shadow='2'>Виза</t> выдана в Молдову";
	
		_text = _target getVariable ["grad_passport_misc1", ""];
		_text = _text + "<br/>" + _message;
		_target setVariable ["grad_passport_misc1",_text, true];
	};
	
	_registerEntry = {
		_message = (call getDateText) + (call getTimeText) + " <t shadow='2'>Впущен</t> в Молдову";
	
		_text = _target getVariable ["grad_passport_misc1", ""];
		_text = _text + "<br/>" + _message;
		_target setVariable ["grad_passport_misc1",_text, true];
	};
	
	_registerExit = {
		_message = (call getDateText) + (call getTimeText) + " <t shadow='2'>Выпущен</t> из Молдовы";
	
		_text = _target getVariable ["grad_passport_misc1", ""];
		_text = _text + "<br/>" + _message;
		_target setVariable ["grad_passport_misc1",_text, true];
	};

	_root = ["VisaRoot","Visa","",{nil},{true}] call ace_interact_menu_fnc_createAction;
	["CAManBase", 0, ["ACE_MainActions"], _root, true] call ace_interact_menu_fnc_addActionToClass;
	
	_issueVisaAction = ["Issue Visa", "Issue Visa (Moldova)", "", _issueVisa, {true}] call ace_interact_menu_fnc_createAction;
	["CAManBase", 0, ["ACE_MainActions", "VisaRoot"], _issueVisaAction, true] call ace_interact_menu_fnc_addActionToClass;
	
	_registerExitAction = ["Allow Exit", "Allow Exit (Moldova)", "", _registerExit, {true}] call ace_interact_menu_fnc_createAction;
	["CAManBase", 0, ["ACE_MainActions", "VisaRoot"], _registerExitAction, true] call ace_interact_menu_fnc_addActionToClass;
	
	_registerEntryAction = ["Allow Entry", "Allow Entry (Moldova)", "", _registerEntry, {true}] call ace_interact_menu_fnc_createAction;
	["CAManBase", 0, ["ACE_MainActions", "VisaRoot"], _registerEntryAction, true] call ace_interact_menu_fnc_addActionToClass;
	
	
	
	//[C130, 1, ["ACE_SelfActions"], _static] call ace_interact_menu_fnc_addActionToObject;
	//[C130, 1, ["ACE_SelfActions","StaticLine"], _hook] call ace_interact_menu_fnc_addActionToObject;
};