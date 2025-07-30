if (hasInterface) then {
	["pdr_pager_used", {
		systemChat ("receiver is" + str(_this));
		private _receiver = _this select 0;
		private _message = _this select 1;
		
		private _passportRsc = player getVariable ["grad_passport_passportRsc", "Pdr"];
		private _countryCode = [_passportRsc] call fnc_getCitizenship;
		private _steamId = player getVariable ["DMP_SteamID", ""];
		private _messagePrice = 60;
		
		[
			_steamId,
			"[Automatic]",
			_countryCode,
			"Pager",
			_messagePrice,
			localize "STR_transactions_automatedSystem"
		] spawn fnc_handlePlayerDebtTransaction;
		
		0 spawn {
			sleep 1;
			[player] call fn_updateCivilianInfo;
		};
		
		hint (format [localize "STR_PaidForPager", _messagePrice]);
		
		[player, _receiver, _message] remoteExec ["fnc_recordPagerMessageServer", 2];
	}] call CBA_fnc_addEventHandlerArgs;
};

fnc_recordPagerMessageServer = {
	params ["_sender", "_receiver", "_text"];
	
	private _date = date;
	_date params ["_year", "_month", "_day", "_hours", "_minutes"];
		
	private _day = ["rpDay"] call fnc_getWorldVariable;
	private _dateString = format ["Day %1; %2:%3", _day, _hours, _minutes];
	
	_sender = [_sender] call fnc_getPlayerLegalName;
	_receiver = [_receiver] call fnc_getPlayerLegalName;
	
	private _result = format ["%1, %2 to %3 Msg:%4", _dateString, _sender, _receiver, _text];
	["pagerMessages", _result] call DMP_fnc_addToJournal;
};