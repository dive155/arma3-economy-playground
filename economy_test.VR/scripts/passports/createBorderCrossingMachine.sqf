params [
	"_buttonObject",
	"_fromCountry",
	"_toCountry",
	["_getExtraCheckupChance", {0.25}],
	["_extraCondition", {true}],
	["_onSuccess", {}],
	["_onFailure", {}]
];

if (isServer) then {
	_buttonObject setVariable ["fromCountry", _fromCountry, true];
	_buttonObject setVariable ["toCountry", _toCountry, true];
	_buttonObject setVariable ["getExtraCheckupChance", _getExtraCheckupChance, true];
	_buttonObject setVariable ["extraCondition", _extraCondition, true];
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
		private _onSuccess = _target getVariable ["onSuccess", {}];
		private _onFailure = _target getVariable ["onFailure", {}];

		if !(call _condition) exitWith {};

		if (player getVariable ["rp_crossingPending", false]) exitWith {
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
		
		_confirmText = _confirmText splitString "λ";
		_confirmText = _confirmText joinString (toString [10]);
		
		private _confirmed = [
			_confirmText,
			localize "STR_border_confirm_title",
			localize "STR_border_confirm_ok",
			localize "STR_border_confirm_cancel"
		] call BIS_fnc_guiMessage;

		if (!_confirmed) exitWith {};

		private _checkChance = call _extraCheckChance;
		private _roll = random 1;

		if (_roll > _checkChance) then {
			player setVariable ["rp_crossingPending", true, true];

			private _grantedMsg = format [
				localize "STR_border_approved",
				localize ("STR_country" + _from),
				localize ("STR_country" + _to)
			];
			hint _grantedMsg;

			[player, _from, false] call fn_addBorderCrossingLocal;
			[player, _to, true] call fn_addBorderCrossingLocal;

			call _onSuccess;
		} else {
			player setVariable ["rp_checkupPending", true, true];
			hint localize "STR_border_selected_for_check";
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

[_buttonObject, 0, [], _action] call ace_interact_menu_fnc_addActionToObject;
