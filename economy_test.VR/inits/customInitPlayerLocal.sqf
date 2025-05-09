0 execVM "scripts\passports\initPassportsLocal.sqf";
0 execVM "hud\hudControl.sqf";
0 execVM "hud\fuelConsumptionIndicator.sqf";
0 execVM "hud\initPagedJournalDialog.sqf";
0 execVM "hud\initRpDialog2.sqf";


0 spawn {
	sleep 10;
	
	{
		private _country = _x;
		private _lightsOn = [_country] call fnc_areLightsOn;
		[_country, _lightsOn] call fnc_updateLightsLocal;
	} forEach ["PDR", "Moldova"];
};