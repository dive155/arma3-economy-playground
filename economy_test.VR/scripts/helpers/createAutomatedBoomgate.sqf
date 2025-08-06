params [
	"_gate",
	"_trigger",
	"_playerCondition",
	"_executionCondition"
];

private _delay = 0.8 + random 0.4;
[
	{
		(_this select 0) params [
			"_gate",
			"_trigger",
			"_playerCondition",
			"_executionCondition"
		];
	
		if (call _executionCondition) then {
			private _shouldOpen = false;
			{
				if (_x inArea _trigger) then {
					if ([_x] call _playerCondition) then {
						_shouldOpen = true;
					};
				};
			} forEach allPlayers;
			
			private _phase = _gate animationSourcePhase  "Door_1_sound_source";
			
			if (_shouldOpen and (_phase != 1)) then {
				_gate animateSource ['Door_1_sound_source', 1];
			};
			
			private _forcedOpen = _gate getVariable ["forced_open", false];
			if (!_shouldOpen and (_phase != 0) and (not _forcedOpen)) then {
				_gate animateSource ['Door_1_sound_source', 0];
			};
		};
	}, 
	_delay, 
_this] call CBA_fnc_addPerFrameHandler;

