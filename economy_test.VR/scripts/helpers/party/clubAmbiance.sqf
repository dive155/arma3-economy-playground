DIVE_AllLights_Local = [];

fn_createLightLocal = {
	params ["_color", "_position"];
	
	private _className = format ["Reflector_Cone_01_narrow_%1_F", _color];
	private _light = createVehicleLocal [_className, _position];
	_light setPosATL _position;
	DIVE_AllLights_Local pushBack _light;
	
	_light
};

fn_createSpinningLightLocal = {
	params ["_color", "_position", "_rotSpeed", "_pitchSpeed"];
	
	private _light = [_color, _position] call fn_createLightLocal;
	
	private _handle = [_light, _rotSpeed, _pitchSpeed] spawn {
		params ["_light", "_rotSpeed", "_pitchSpeed"];
		while { true} do {
			private _pitch = -1 * abs( cos (time * _pitchSpeed) * 50 ) - 10;
			
			private _vecs = [[[0,1,0],[0,0,1]], 0, _pitch, 0] call BIS_fnc_transformVectorDirAndUp;
			private _newDir = _vecs select 0;
			private _newUp = _vecs select 1;
			
			_vecs = [[_newDir,_newUp], time * _rotSpeed, 0, 0] call BIS_fnc_transformVectorDirAndUp;
			_light setVectorDirAndUp [_vecs select 0, _vecs select 1];
			sleep 0.001;
		};
	};
	
	_light setVariable ["SpinHandle", _handle, false];
};

fn_createBlinkerLocal = {
	params ["_color", "_position", "_rotation", "_timeShown", "_timeHidden", "_timeOffset"];
	
	private _light = [_color, _position] call fn_createLightLocal;
	
	[_light, _rotation] call BIS_fnc_setObjectRotation;
	
	private _handle = [_light, _timeShown, _timeHidden, _timeOffset] spawn {
		params ["_light", "_timeShown", "_timeHidden", "_timeOffset"];
		
		private _nextFlip = time + _timeHidden + _timeOffset;
		private _isHidden = true;
		
		while { true} do {
			if (time < _nextFlip) then { continue };
			
			_isHidden = not _isHidden;
			_light hideObject _isHidden;
			
			if (_isHidden) then {
				_nextFlip = time + _timeHidden;
			} else {
				_nextFlip = time + _timeShown;
			};
			
			sleep 0.001;
		};
	};
	
	_light setVariable ["SpinHandle", _handle, false];
};

fn_createDanceFloorLightsLocal = {
	["green", getPosATL clublight_0, 300, 224] spawn fn_createSpinningLightLocal;
	["red", getPosATL clublight_1, 210, 261] spawn fn_createSpinningLightLocal;
	["blue", getPosATL clublight_2, 253, 245] spawn fn_createSpinningLightLocal;
	
	// For rotation order is Yaw, Pitch, Roll
	["orange", getPosATL clublight_3, [70,-45,0], 0.1, 0.4, 0] spawn fn_createBlinkerLocal;
	["red", getPosATL clublight_4, [-45,-30,0], 0.2, 0.3, 0.25] spawn fn_createBlinkerLocal;
	
	["green", getPosATL clublight_5, 300, 224] spawn fn_createSpinningLightLocal;
	["red", getPosATL clublight_6, 210, 261] spawn fn_createSpinningLightLocal;
	["blue", getPosATL clublight_7, 253, 245] spawn fn_createSpinningLightLocal;
	
	// For rotation order is Yaw, Pitch, Roll
	["orange", getPosATL clublight_8, [70,-45,0], 0.1, 0.4, 0] spawn fn_createBlinkerLocal;
	["red", getPosATL clublight_9, [-45,-30,0], 0.2, 0.3, 0.25] spawn fn_createBlinkerLocal;
};

fn_destroyDanceFloorLightsLocal = {
	{
		_handle = _x getVariable "SpinHandle";
		terminate _handle;
		
		deleteVehicle _x;
	} forEach DIVE_AllLights_Local;
	DIVE_AllLights_Local = [];
};

DIVE_Music_Handle = [];
DIVE_Music_Id = 0;

fn_startMusicServer = {
	missionNamespace setVariable ["DIVE_partyMusicEnabled", true, true];
	DIVE_Music_Handle = 0 spawn {
		while { true } do {
			// TODO replace with new song
			//DIVE_Music_Id = playSound3D [getMissionPath "scripts\helpers\party\pdr_dnb.ogg", partySpeaker, true, getPosASL partySpeaker, 5, 1, 150];
			//sleep 22.647;
			//DIVE_Music_Id = playSound3D ["pdrstuff\music\pdr_grozy.ogg", partySpeaker, false, getPosASL partySpeaker, 5, 1, 150];
			//waitUntil { sleep 0.5; soundParams DIVE_Music_Id isEqualTo [] };			
		};
	};
};

fn_stopMusicServer = {
	//stopSound DIVE_Music_Id;
	missionNamespace setVariable ["DIVE_partyMusicEnabled", false, true];
	//terminate DIVE_Music_Handle;
};