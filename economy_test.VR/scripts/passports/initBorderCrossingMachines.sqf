[
	crossing_button_pdr,
	"PDR",
	"Moldova",
	{ 
		["autoBorderChance"] call fnc_getWorldVariable 
	},
	{
		private _debt = [player, "PDR"] call fnc_getPlayerDebt;
		
		private _passport = player getVariable ["grad_passport_passportRsc", ""];
		private _citizenship = [_passport] call fnc_getCitizenship;
		private _hasVisa = [player, "Moldova"] call fnc_checkHasVisa;
		_hasVisa = _hasVisa or (_citizenship isEqualTo "Moldova");
		
		_canGoWithThisPassport = true;
		if ((_citizenship isEqualTo "PDR") and (not (["autoBorderForPDRans"] call fnc_getWorldVariable))) then {
			_canGoWithThisPassport = false;
		};
		
		(_debt <= 500) and _hasVisa and _canGoWithThisPassport
	},
	{
		["autoBorderEnabled"] call fnc_getWorldVariable
	}
]execVM "scripts\passports\createBorderCrossingMachine.sqf";

[
	crossing_button_moldova,
	"Moldova",
	"PDR",
	{ 
		["autoBorderChance"] call fnc_getWorldVariable 
	},
	{
		private _debt = [player, "Moldova"] call fnc_getPlayerDebt;
		
		private _passport = player getVariable ["grad_passport_passportRsc", ""];
		private _citizenship = [_passport] call fnc_getCitizenship;
		private _hasVisa = [player, "PDR"] call fnc_checkHasVisa;
		_hasVisa = _hasVisa or (_citizenship isEqualTo "PDR");
		
		_canGoWithThisPassport = true;
		if ((_citizenship isEqualTo "Moldova") and (not (["autoBorderForMoldovans"] call fnc_getWorldVariable))) then {
			_canGoWithThisPassport = false;
		};
		
		(_debt <= 40) and _hasVisa and _canGoWithThisPassport
	},
	{
		["autoBorderEnabled"] call fnc_getWorldVariable
	}
]execVM "scripts\passports\createBorderCrossingMachine.sqf";

fnc_handlePlayerIsCrossingBorder = {
	params ["_player"];
	
	private _pendingCrossing = _player getVariable ["rp_crossingPending", []];
	if (count _pendingCrossing > 0) then {
		_pendingCrossing params ["_from", "_to", "_completed"];
		if !(_completed) then {
			_player setVariable ["rp_crossingPending", [_from, _to, true], true];
			[_player, _pendingCrossing] spawn {
				params ["_player", "_pendingCrossing"];
				_pendingCrossing params ["_from", "_to", "_completed"];
				
				[_player, _from, false] remoteExec ["fn_addBorderCrossingLocal", _player];
				sleep 1;
				
				[_player, _to, true] remoteExec ["fn_addBorderCrossingLocal", _player];
				sleep 0.5;
				
				["STR_border_completed"] remoteExec ["fn_hintLocalized", _player];
			};
		};
	};
	
	if (_player getVariable ["rp_checkupPending", false]) then {
		_player setVariable ["rp_checkupPending", false, true];
	};
};

fnc_handlePlayerAbandonedBorder = {
	params ["_player"];
	
	private _pendingCrossing = _player getVariable ["rp_crossingPending", []];
	if (count _pendingCrossing > 0) then {
		_pendingCrossing params ["_from", "_to", "_completed"];
		_player setVariable ["rp_crossingPending", [], true];
		
		if (not _completed) then {
			["STR_border_abandoned"] remoteExec ["fn_hintLocalized", _player];
		};
	};
};

if (isServer) then {
	[
		{
			{
				if (_x inArea border_reset_trigger) then {
					[_x] call fnc_handlePlayerIsCrossingBorder;
				};
			} forEach allPlayers;
		}, 
		1, 
	[]] call CBA_fnc_addPerFrameHandler;
	
	[
		{
			{
				if not (_x inArea border_zone_trigger) then {
					[_x] call fnc_handlePlayerAbandonedBorder;
				};
			} forEach allPlayers;
		}, 
		3.1234, 
	[]] call CBA_fnc_addPerFrameHandler;
};

