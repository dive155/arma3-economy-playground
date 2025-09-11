0 execVM "scripts\passports\initPassportsLocal.sqf";
0 execVM "hud\hudControl.sqf";
0 execVM "hud\fuelConsumptionIndicator.sqf";
0 execVM "hud\initPagedJournalDialog.sqf";
0 execVM "hud\initRpDialog2.sqf";

fnc_handleFuelConsumtpionCoefficient = {
	params ["_unit", "_role", "_vehicle", "_turret"];
	
	private _coef = [_vehicle] call fnc_getEconomyFuelConsumption;
	
	if (_coef == -1) exitWith {
		hint (localize "STR_NonPlayableVehicle");
		0 spawn {
			sleep 0.5;
			moveOut player;
		};
	};
	
	//systemChat ("fuelConsumptionCoefficient " + str(_coef));
	//_vehicle setFuelConsumptionCoef _coef;
	[_vehicle, _coef] remoteExec ["setFuelConsumptionCoef", _vehicle];
};
	

fnc_addMusicPlayerActionIfMissing = {
	params ["_unit", "_role", "_vehicle", "_turret"];

	private _cfgVehicle = configOf _vehicle;
	private _userActions = configProperties [_cfgVehicle >> "UserActions", "isClass _x"];

	private _hasMusicPlayer = false;
	{
		if (configName _x == "music_player") exitWith {
			_hasMusicPlayer = true;
		};
	} forEach _userActions;

	if not _hasMusicPlayer then {
		private _musicPlayerActionId = _vehicle getVariable["DIVE_musicPlayerActionId", -1];
		if (_musicPlayerActionId == -1) then {
			private _actionId =_vehicle addAction [
				 localize "STR_VN_VEHICLE_RADIO_DN",
				 {
				 ["open"] call vn_fnc_music;
				 },
				 nil,
				 1.5,
				 true,
				 false,
				 "",
				 "alive _this && { local _this && { missionnamespace getvariable ['vn_jukebox_enable', true] && { driver _this isEqualTo player } } }",
				 5,
				 false,
				 "",
				 ""
			]; 
			_vehicle setVariable["DIVE_musicPlayerActionId", _actionId];
		};
	};
};

fnc_removeMusicPlayerAction = {
	params ["_unit", "_role", "_vehicle", "_turret", "_isEject"];
	
	private _musicPlayerActionId = _vehicle getVariable["DIVE_musicPlayerActionId", -1];
	if (_musicPlayerActionId != -1) then {
		_vehicle removeAction _musicPlayerActionId;
		_vehicle setVariable["DIVE_musicPlayerActionId", -1]; 
	};
};

player addEventHandler ["GetInMan", {
	params ["_unit", "_role", "_vehicle", "_turret"];
		_this call fnc_handleFuelConsumtpionCoefficient;
		_this call fnc_addMusicPlayerActionIfMissing;
	}];

player addEventHandler ["GetOutMan", {
	params ["_unit", "_role", "_vehicle", "_turret", "_isEject"];
	_this call fnc_removeMusicPlayerAction;
}];

0 spawn {
	sleep 20;
	//systemChat "updating lights";
	{
		private _country = _x;
		private _lightsOn = [_country] call fnc_areLightsOn;
		[_country, _lightsOn] call fnc_updateLightsLocal;
	} forEach ["PDR", "Moldova"];
};

// Jam the AK
player addEventHandler ["Fired", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

	if (_weapon isEqualTo "rhs_weap_akmn") then {
		if (random 1 < 0.4) then {
			[_unit, _weapon] call ace_overheating_fnc_jamWeapon;
			hint localize "STR_jam_ak";
		};
	};
}];


sleep 10;
[player] call fnc_updateBuff;