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

addTextToVisas = {
	params ["_receiver", "_addText"];
	
	_text = _receiver getVariable ["grad_passport_misc1", ""];
	_text = _text + "<br/>" + _addText;
	_receiver setVariable ["grad_passport_misc1",_text, true];
};

cacheTarget = {
	params ["_toCache"];
	player setVariable ["cachedTarget", _toCache, true];
};

loadCachedTarget = {
	_cachedTarget = player getVariable ["cachedTarget", objNull];
	_cachedTarget
};

if (player getVariable ["visa_giver", false]) then {

	_issueVisa = {
		_message = (call getDateText) + " <t shadow='2'>Виза</t> выдана в Молдову";
		[_target, _message] call addTextToVisas;
	};
	
	_registerEntry = {
		_message = (call getDateText) + (call getTimeText) + " <t shadow='2'>Впущен</t> в Молдову";
		[_target, _message] call addTextToVisas;
	};
	
	_registerExit = {
		_message = (call getDateText) + (call getTimeText) + " <t shadow='2'>Выпущен</t> из Молдовы";
		[_target, _message] call addTextToVisas;
	};
	
	_addCustom = {
		[_target] call cacheTarget;
		[
			[false,""],
			"Добавить текст к визам",
			{
				if _confirmed then {
					_cachedTarget = call loadCachedTarget;
					[_cachedTarget, _text] call addTextToVisas;
				};
			},
			"Send",
			""  // reverts to default
		] call CAU_UserInputMenus_fnc_text;
	};

	_root = ["VisaRoot","Visa","",{nil},{true}] call ace_interact_menu_fnc_createAction;
	["CAManBase", 0, ["ACE_MainActions"], _root, true] call ace_interact_menu_fnc_addActionToClass;
	
	_issueVisaAction = ["Issue Visa", "Issue Visa (Moldova)", "", _issueVisa, {true}] call ace_interact_menu_fnc_createAction;
	["CAManBase", 0, ["ACE_MainActions", "VisaRoot"], _issueVisaAction, true] call ace_interact_menu_fnc_addActionToClass;
	
	_registerExitAction = ["Allow Exit", "Allow Exit (Moldova)", "", _registerExit, {true}] call ace_interact_menu_fnc_createAction;
	["CAManBase", 0, ["ACE_MainActions", "VisaRoot"], _registerExitAction, true] call ace_interact_menu_fnc_addActionToClass;
	
	_registerEntryAction = ["Allow Entry", "Allow Entry (Moldova)", "", _registerEntry, {true}] call ace_interact_menu_fnc_createAction;
	["CAManBase", 0, ["ACE_MainActions", "VisaRoot"], _registerEntryAction, true] call ace_interact_menu_fnc_addActionToClass;
	
	_addCustomAction = ["Add Custom", "Add Custom", "", _addCustom, {true}] call ace_interact_menu_fnc_createAction;
	["CAManBase", 0, ["ACE_MainActions", "VisaRoot"], _addCustomAction, true] call ace_interact_menu_fnc_addActionToClass;
};