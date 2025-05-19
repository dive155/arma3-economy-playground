DIVE_Dances = [
	[dancer_0, "Acts_Dance_01"],
	[dancer_1, "kka3_dubstepdance"],
	[dancer_2, "kka3_nightclubdance"],
	[dancer_3, "kka3_hiphopdance"],
	[dancer_4, "Acts_Dance_02"]
];

DIVE_DanceHandles = [];

{
	_dancer = _x select 0;
	if (local _dancer) then { 
		_dancer setVariable ["initialPosition", getPosWorld _dancer];
	};
	
} forEach DIVE_Dances;

fn_startDancingLocal = {
	params ["_dancer", "_dance"];
	
	
	_handle = [_dancer, _dance] spawn {
		params ["_dancer", "_dance"];
		
		_dance = toLower _dance;
		while { [_dancer] call ace_common_fnc_isAwake } do {
			if not ((animationState _dancer) isEqualTo _dance) then { [_dancer, _dance] remoteExec ["switchMove"]; };
		
			_targetPos = _dancer getVariable "initialPosition";
			_currentPos = getPosWorld _dancer;
			
			if ((_targetPos vectorDistance _currentPos) > 1) then {
				_pos = [_targetPos, _currentPos, 0.95] call BIS_fnc_lerpVector;
				_dancer setPosWorld _targetPos;
			};
			sleep 0.3;
		};
	};
	
	DIVE_DanceHandles pushBack _handle; 
};

fn_startDancingServer = {
	{
		_dancer = _x select 0;
		_dance = _x select 1;
		
		[_dancer, _dance] remoteExec ["fn_startDancingLocal", _dancer];
		
	} forEach DIVE_Dances;
};

fn_stopDancingLocal = {
	params ["_dancer"];
	if ([_dancer] call ace_common_fnc_isAwake) then { [_dancer, ""] remoteExec ["switchMove"] };
	
	{
		terminate _x;
	}
	foreach DIVE_DanceHandles;
	DIVE_DanceHandles = [];
};

fn_stopDancingServer = {
	{
		_dancer = _x select 0;
		
		[_dancer] remoteExec ["fn_stopDancingLocal", _dancer];
		
	} forEach DIVE_Dances;
};