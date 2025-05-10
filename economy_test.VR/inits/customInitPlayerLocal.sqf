0 execVM "scripts\passports\initPassportsLocal.sqf";
0 execVM "hud\hudControl.sqf";
0 execVM "hud\fuelConsumptionIndicator.sqf";
0 execVM "hud\initPagedJournalDialog.sqf";
0 execVM "hud\initRpDialog2.sqf";

player addEventHandler ["GetInMan", {
	params ["_unit", "_role", "_vehicle", "_turret"];
	
	private _coef = [_vehicle] call fnc_getEconomyFuelConsumption;
	
	if (_coef == -1) exitWith {
		hint (localize "STR_NonPlayableVehicle");
		0 spawn {
			sleep 0.5;
			moveOut player;
		};
	};
	
	systemChat ("fuelConsumptionCoefficient " + str(_coef));
	//_vehicle setFuelConsumptionCoef _coef;
	[_vehicle, _coef] remoteExec ["setFuelConsumptionCoef", _vehicle];
}];

0 spawn {
	sleep 10;
	systemChat "updating lights";
	{
		private _country = _x;
		private _lightsOn = [_country] call fnc_areLightsOn;
		[_country, _lightsOn] call fnc_updateLightsLocal;
	} forEach ["PDR", "Moldova"];
};