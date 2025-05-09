fnc_createTram = {
	PDR_tram = [tram_loco] call ATRAIN_fnc_createTrain; 
	for "_i" from 0 to 4 do 
	{ 
		[PDR_tram, "ATS_Trains_A3_Passenger"] call ATRAIN_fnc_attachTrainCar; 
	}; 
	PDR_tram setVariable ["ATRAIN_Remote_Cruise_Control_Enabled", true, true]; 
	PDR_tram setVariable ["ATRAIN_Local_Velocity", 0]; 
	PDR_tram setVariable ["ATRAIN_Remote_Velocity", 0, true]; 
	
	missionNamespace setVariable ["PDR_tram_enabled", false, true];
	PDR_tram_velocityChangeHandle = objNull;
	
};

fnc_startTram = {
	missionNamespace setVariable ["PDR_tram_enabled", true, true];
	[10] spawn fnc_changeTramSpeed;
	PDR_tram_velocityChangeHandle = 0 spawn fnc_tramTravelLoop;
};

fnc_stopTram = {
	missionNamespace setVariable ["PDR_tram_enabled", false, true];
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
			PDR_tram_velocityChangeHandle = [0] spawn fnc_changeTramSpeed;
			["stop"] remoteExec ["hint"];
			sleep 15;
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

sleep 5;
call fnc_createTram;