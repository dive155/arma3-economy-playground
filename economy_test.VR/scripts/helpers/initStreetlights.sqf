PDR_allLampClasses = [
	"Land_LampIndustrial_02_F", 
	"Land_LampStreet_02_F",
	"Land_LampShabby_F",
	"Land_LampDecor_F",
	"Land_Camping_Light_F",
	"Land_LampIndustrial_01_F",
	"Land_Ind_Vysypka",
	"Land_Ind_Expedice_2",
	"Land_Ind_Mlyn_03",
	"Land_GuardTower_02_on"
];

PDR_lightTriggers_PDR = [
	streetlights_t_1,
	streetlights_t_2
];

PDR_lightTriggers_Moldova = [
	streetlights_moldova_t_1,
	streetlights_moldova_t_2
];

fnc_setLightsServer = {
	params["_countryCode", "_enable"];
	
	private _varName = "PDR_lightsOnGlobal_" + _countryCode;
	_isOn = missionNamespace getVariable [_varName, true];
	
	if (_isOn != _enable) then {
		missionNamespace setVariable [_varName, _enable, true];
		[_countryCode, _enable] remoteExec ["fnc_updateLightsLocal"];
	};
};

fnc_areLightsOn = {
	params["_countryCode"];
	private _varName = "PDR_lightsOnGlobal_" + _countryCode;
	_isOn = missionNamespace getVariable [_varName, true];
	_isOn
};

fnc_updateLightsLocal = {
	params["_countryCode", "_enable"];
	private _localVarName = "PDR_lightOnLocal_" + _countryCode;
	
	_isOnLocal = missionNamespace getVariable [_localVarName, true];
	if (_isOnLocal != _enable) then {
		missionNamespace setVariable [_localVarName, _enable];
		private _triggers = missionNamespace getVariable ("PDR_lightTriggers_" + _countryCode);
		private _allLights = _triggers apply { [_x, PDR_allLampClasses] call fnc_getObjectsOfTypesInTrigger };
								
		_allLights = _allLights call fnc_mergeObjectArrays;
		
		private _status = if _enable then {"AUTO"} else {"OFF"};
		{
			_x switchLight _status;
		} forEach _allLights;
	};
};

fnc_getObjectsOfTypesInTrigger = {
	params ["_trigger", "_typeArray"];
	private _result = [];

	private _pos = getPosATL _trigger;
	private _area = triggerArea _trigger;
	private _radiusX = _area select 0;
	private _radiusY = _area select 1;

	// Compute diagonal distance to furthest point in the rectangular trigger
	private _diagRadius = sqrt((_radiusX ^ 2) + (_radiusY ^ 2));

	private _nearby = _pos nearObjects _diagRadius;

	{
		if ((typeOf _x) in _typeArray && _x inArea _trigger) then {
			_result pushBack _x;
		};
	} forEach _nearby;

	_result
};

fnc_mergeObjectArrays = {
	private _all = [];

	{
		_all append _x;
	} forEach _this;

	_all arrayIntersect _all
};