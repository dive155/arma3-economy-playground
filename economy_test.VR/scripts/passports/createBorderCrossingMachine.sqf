params [
	"_buttonObject",
	"_fromCountry",
	"_toCountry",
	["_getExtraCheckupChance", {0.25}],
	["_extraCondition", {true}],
	["_borderOpenCondition", {true}],
	["_onSuccess", {}],
	["_onFailure", {}]
];

if (isServer) then {
	_buttonObject setVariable ["fromCountry", _fromCountry, true];
	_buttonObject setVariable ["toCountry", _toCountry, true];
	_buttonObject setVariable ["getExtraCheckupChance", _getExtraCheckupChance, true];
	_buttonObject setVariable ["extraCondition", _extraCondition, true];
	_buttonObject setVariable ["borderOpenCondition", _borderOpenCondition, true];
	_buttonObject setVariable ["onSuccess", _onSuccess, true];
	_buttonObject setVariable ["onFailure", _onFailure, true];
} else {
	waitUntil {
		sleep 1;
		not ((_buttonObject getVariable ["fromCountry", ""]) isEqualTo "")
	};
};

private _actionCode = {
	_target spawn {
		params["_target"];
		private _from = _target getVariable ["fromCountry", ""];
		private _to = _target getVariable ["toCountry", ""];
		private _extraCheckChance = _target getVariable ["getExtraCheckupChance", {0.25}];
		private _condition = _target getVariable ["extraCondition", {true}];
		private _borderOpenCondition = _target getVariable ["borderOpenCondition", {true}];
		private _onSuccess = _target getVariable ["onSuccess", {}];
		private _onFailure = _target getVariable ["onFailure", {}];

		if !(call _borderOpenCondition) exitWith {
			hint localize "STR_autoborder_closed";
		};
		
		private _pendingCrossing = player getVariable ["rp_crossingPending", []];
		if (count _pendingCrossing > 0) exitWith {
			hint localize "STR_border_already_approved";
		};

		if (player getVariable ["rp_checkupPending", false]) exitWith {
			hint localize "STR_border_manual_check";
		};

		private _confirmText = format [
			localize "STR_border_confirm_text",
			localize ("STR_country" + _from),
			localize ("STR_country" + _to)
		];

		private _chancePercent = round ((call _extraCheckChance) * 100);
		private _confirmText = format [
			localize "STR_border_confirm_text",
			_chancePercent,
			localize ("STR_country" + _from),
			localize ("STR_country" + _to)
		];
		
		_confirmText = parseText _confirmText;
		
		private _confirmed = [
			_confirmText,
			localize "STR_border_confirm_title",
			localize "STR_border_confirm_ok",
			localize "STR_border_confirm_cancel"
		] call BIS_fnc_guiMessage;

		if (!_confirmed) exitWith {};

		private _checkChance = call _extraCheckChance;
		private _roll = random 1;

		if ((_roll > _checkChance) and (call _condition)) then {
			player setVariable ["rp_crossingPending", [_from, _to], true];

			private _grantedMsg = format [
				localize "STR_border_approved",
				localize ("STR_country" + _from),
				localize ("STR_country" + _to)
			];
			[_grantedMsg, -1, -0.3, 8, 0, 0, 789] spawn BIS_fnc_dynamicText;

			call _onSuccess;
		} else {
			player setVariable ["rp_checkupPending", true, true];
			_deniedMessage = localize "STR_border_selected_for_check";
			[_deniedMessage, -1, -0.3, 8, 0, 0, 789] spawn BIS_fnc_dynamicText;
			call _onFailure;
		};
	};
};

private _actionLabel = format [
	"%1: %2 -> %3",
	localize "STR_border_action_label",
	localize ("STR_country" + _fromCountry),
	localize ("STR_country" + _toCountry)
];

private _action = [
	format ["BorderCross_%1_%2", _fromCountry, _toCountry],
	_actionLabel,
	"",
	_actionCode,
	{true}
] call ace_interact_menu_fnc_createAction;

[_buttonObject, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

// Cancel action
private _cancelActionCode = {
	player setVariable ["rp_crossingPending", [], true];
	hint localize "STR_border_request_cancelled";
};

private _cancelActionCondition = {
	private _pending = player getVariable ["rp_crossingPending", []];
	(count _pending) > 0
};

private _cancelAction = [
	"BorderCrossCancel",
	localize "STR_border_cancel_label",
	"",
	_cancelActionCode,
	_cancelActionCondition
] call ace_interact_menu_fnc_createAction;

[_buttonObject, 0, ["ACE_MainActions"], _cancelAction] call ace_interact_menu_fnc_addActionToObject;
