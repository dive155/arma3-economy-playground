params["_screenObject", "_textureIndex", "_crate"];

if (isNil "fnc_playMovieInitLocal") then {
	fnc_playMovieInitLocal = {
		params ["_target", "_player", "_args"];
		_args params ["_screen", "_textureIndex", "_crate"];
		
		private _itemCargo = getItemCargo _crate;
		private _items = _itemCargo select 0;

		private _matchedMovie = [];

		{
			private _movieClassname = _x select 0;
			if (_movieClassname in _items) then {
				_matchedMovie = _x;
			};
		} forEach videoPlayerKnownMovies;
		
		if (count _matchedMovie == 0) exitWith {hint (localize "STR_NoMoviesFound")};
		
		missionNamespace setVariable ["isPlayingMovie", true, true];
		[_screen, _textureIndex, _matchedMovie] remoteExec ["fnc_playMovieInitServer", 2];
	};
};

if (isNil "fnc_playMovieInitServer") then {
	fnc_playMovieInitServer = {
		params ["_screen", "_textureIndex", "_movieData"];
		_this remoteExec ["fnc_playMovieOnScreenLocal", 0];
	};
};

if (isNil "fnc_playMovieOnScreenLocal") then {
	fnc_playMovieOnScreenLocal = {
		params ["_screen", "_textureIndex", "_movieData"];
		_movieData params ["_className", "_videoFile", "_sound"];
		_screen setObjectTexture [_textureIndex, _videoFile];
		_src = _screen say3D _sound;
		[_videoFile, [10, 10]] call BIS_fnc_playVideo;
		deleteVehicle _src;
		_screen setObjectTexture[0,""];
		
		if (missionNamespace getVariable "isPlayingMovie") then {
			missionNamespace setVariable ["isPlayingMovie", false, true];
		};
	};
};

if (hasInterface) then {	
	_playMovieAction = ["PlayMovie", "Play Movie", "", fnc_playMovieInitLocal, {
		not (missionNamespace getVariable ["isPlayingMovie", false])
	}, {}, [_screenObject, _textureIndex, _crate]] call ace_interact_menu_fnc_createAction;
	[_screenObject, 0, [], _playMovieAction] call ace_interact_menu_fnc_addActionToObject;
};