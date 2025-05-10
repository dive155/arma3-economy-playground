fnc_createTram = {
	PDR_tram = [tram_loco] call ATRAIN_fnc_createTrain; 
	missionNamespace setVariable ["PDR_tram_enabled", false, true];
	PDR_tram_velocityChangeHandle = objNull;
	PDR_tram setVariable ["ATRAIN_Remote_Cruise_Control_Enabled", true, true]; 
	
	// Collect other cars
	PDR_tram setVariable ["ATRAIN_Local_Velocity", -2]; 
	PDR_tram setVariable ["ATRAIN_Remote_Velocity", -2, true]; 
	
	[{
		PDR_tram setVariable ["ATRAIN_Local_Velocity", 0]; 
		PDR_tram setVariable ["ATRAIN_Remote_Velocity", 0, true];
		PDR_tram setVariable ["ATRAIN_Remote_Cruise_Control_Enabled", false, true]; 
	}, [], 10] call CBA_fnc_waitAndExecute;
};

fnc_startTram = {
	missionNamespace setVariable ["PDR_tram_enabled", true, true];
	PDR_tram setVariable ["ATRAIN_Remote_Cruise_Control_Enabled", true, true];
	PDR_tram_velocityChangeHandle = [10] spawn fnc_changeTramSpeed;
	PDR_tram_travelLoopHandle = 0 spawn fnc_tramTravelLoop;
	[] remoteExec ["fnc_soundHorn"];
};

fnc_stopTram = {
	missionNamespace setVariable ["PDR_tram_enabled", false, true];
	PDR_tram setVariable ["ATRAIN_Remote_Cruise_Control_Enabled", false, true]; 
	terminate PDR_tram_travelLoopHandle;
	terminate PDR_tram_velocityChangeHandle;
	PDR_tram_velocityChangeHandle = [0] spawn fnc_changeTramSpeed;
};

PDR_tram_stations = [tram_station_1, tram_station_2, tram_station_3];

fnc_tramTravelLoop = {
	_wasInStation = false;
	while {missionNamespace getVariable ["PDR_tram_enabled", false]} do {
		private _inStation = false;
		private _front = [PDR_Tram] call ATRAIN_fnc_findFrontCar;
		private _local = _front getVariable ["ATRAIN_Local_Copy", objNull];
		private _pos = getPosATL _local;

		{
			if (_pos inArea _x) then {
				_inStation = true;
			};
		} forEach PDR_tram_stations;
		
		if ((not _wasInStation) and _inStation) then {
			[] remoteExec ["fnc_soundHorn"];
			PDR_tram_velocityChangeHandle = [0] spawn fnc_changeTramSpeed;
			sleep 20;
			[] remoteExec ["fnc_soundHorn"];
			PDR_tram_velocityChangeHandle = [10] spawn fnc_changeTramSpeed;
		};
		
		_wasInStation = _inStation;
		sleep 0.5;
	};
};

fnc_changeTramSpeed = {
	params ["_targetSpeed", ["_acceleration", 0.3]];

	_initSpeed = PDR_tram getVariable ["ATRAIN_Remote_Velocity", 0];
	if (_initSpeed > _targetSpeed) then {
		while {_initSpeed > _targetSpeed} do {
			_initSpeed = _initSpeed - _acceleration;
			_initSpeed = _initSpeed max _targetSpeed;
			PDR_tram setVariable ["ATRAIN_Local_Velocity", _initSpeed]; 
			PDR_tram setVariable ["ATRAIN_Remote_Velocity", _initSpeed, true]; 
			sleep 0.2;
		};
	} else {
		while {_initSpeed < _targetSpeed} do {
			_initSpeed = _initSpeed + _acceleration;
			_initSpeed = _initSpeed min _targetSpeed;
			PDR_tram setVariable ["ATRAIN_Local_Velocity", _initSpeed]; 
			PDR_tram setVariable ["ATRAIN_Remote_Velocity", _initSpeed, true]; 
			sleep 0.2;
		};
	};
};

fnc_soundHorn = {
	private _front = [PDR_Tram] call ATRAIN_fnc_findFrontCar;
	private _local = _front getVariable ["ATRAIN_Local_Copy", objNull];
	_hornDistance = 500;
	_local say3D ["ATSHornStart", _hornDistance, 1];
	sleep 0.99;
	if((floor random 2) > 0) then {
		_local say3D ["ATSHornMiddle1", _hornDistance, 1];
	} else {
		_local say3D ["ATSHornMiddle2", _hornDistance, 1];
	};
	sleep 0.99;
	_local say3D ["ATSHornEnd", _hornDistance, 1];
	sleep 1;
};

sleep 5;
if (isServer) then {
	call fnc_createTram;
};