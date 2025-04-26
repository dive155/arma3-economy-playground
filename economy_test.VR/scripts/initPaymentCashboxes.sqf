_cashboxSounds = [
    "a3\missions_f_beta\data\sounds\firing_drills\target_pop-down_large.wss",
    "pdrstuff\sounds\machine_success_money.ogg",
    "pdrstuff\sounds\machine_error.ogg"
];

[
    payment_button_pdr,
    payment_box_pdr,
    "PDR",
    "pdrLeu",
    _cashboxSounds,
	{  	
		private _steamId = player getVariable "DMP_SteamID";
		private _record = [_this] call fnc_composeAccountRecord;
		["debt_" + _steamId + "_PDR", _record] remoteExec ["DMP_fnc_addToJournal", 2];
	},
	{
		params ["_playerName", "_operationType", "_amount", "_playersNote"];
		
		private _cityMoney = ["cityMoney"] call fnc_getWorldVariable;
		_cityMoney = _cityMoney + _amount;
		["cityMoney", _cityMoney] call fnc_setWorldVariable;
		
		private _recordData = [
			_playerName,
			_operationType,
			_amount,
			_cityMoney,
			_playersNote
		];
		private _record = [_recordData] call fnc_composeAccountRecord;
		["accountJournal_cityMoney", _record] remoteExec ["DMP_fnc_addToJournal", 2];
 	}
] execVM "scripts\economy\createPaymentCashbox.sqf";

[
    payment_button_moldova,
    payment_box_moldova,
    "Moldova",
    "moldovaLeu",
    _cashboxSounds,
	{  	
		private _steamId = player getVariable "DMP_SteamID";
		private _record = [_this] call fnc_composeAccountRecord;
		["debt_" + _steamId + "_Moldova", _record] remoteExec ["DMP_fnc_addToJournal", 2];
	}
] execVM "scripts\economy\createPaymentCashbox.sqf";