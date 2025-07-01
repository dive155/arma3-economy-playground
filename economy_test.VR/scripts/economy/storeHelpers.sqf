fnc_playStoreSound = {
	params ["_buttonObject", "_source", "_soundKey", "_volume"];
	
	_sounds = _buttonObject getVariable ["soundsMap", createHashMap];
	_soundName = _sounds get _soundKey;
	
	playSound3D [_soundName, _source, false, getPosASL _source, _volume, 1, 30];
};