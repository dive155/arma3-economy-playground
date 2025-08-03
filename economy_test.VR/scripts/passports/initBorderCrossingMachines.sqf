[
	crossing_button_pdr,
	"PDR",
	"Moldova",
	{ 0.5 }
]execVM "scripts\passports\createBorderCrossingMachine.sqf";

[
	crossing_button_moldova,
	"Moldova",
	"PDR",
	{ 0.5 }
]execVM "scripts\passports\createBorderCrossingMachine.sqf";

fnc_resetAutoBorderCrossing = {
	params ["_player"];
	
	private _pendingCrossing = player getVariable ["rp_crossingPending", []];
	_player setVariable ["rp_crossingPending", [], true];
	if (count _pendingCrossing > 0) then {
		[_player, _pendingCrossing] spawn {
			params ["_player", "_pendingCrossing"];
			_pendingCrossing params ["_from", "_to"];
			
			[_player, _from, false] remoteExec ["fn_addBorderCrossingLocal", _player];
			sleep 1;
			
			[_player, _to, true] remoteExec ["fn_addBorderCrossingLocal", _player];
			sleep 0.5;
			
			["STR_border_completed"] remoteExec ["fn_hintLocalized", _player];
		};
	};
	
	if (_player getVariable ["rp_checkupPending", false]) then {
		_player setVariable ["rp_checkupPending", false, true];
	};
	
	systemChat "ResetStatus"
};

if (isServer) then {
	[
		{
			{
				if (_x inArea border_reset_trigger) then {
					[_x] call fnc_resetAutoBorderCrossing;
				};
			} forEach allPlayers;
		}, 
		1, 
	[]] call CBA_fnc_addPerFrameHandler;
};

