params [["_extraCodndition", {true}]];
DIVE_offroad_extraCondition = _extraCodndition;

fnc_initOffroadHandling = {
	// Global state variables
	DIVE_lastOnRoadStatus = true;
	DIVE_departurePoint = [0,0,0];
	DIVE_departureTime = -1;
	DIVE_offroadCheckDelay = 0.2;
	DIVE_offroadPFH = [{
		if !(vehicle player isKindOf "Car" && driver vehicle player == player) exitWith {
			//systemChat (str(diag_tickTime) + " not driving");
		};
		
		private _veh = vehicle player;
		if not (call DIVE_offroad_extraCondition) exitWith {_veh setCruiseControl [9999, false];};
		
		private _posWorld = getPosWorld _veh;
	
		// First check: isOnRoad
		private _isOnRoad = isOnRoad _veh;
	
		// Second check: surface type
		if (!_isOnRoad) then {
			private _surfaceName = surfaceType _posWorld;
	
			if ((_surfaceName select [0, 1]) == "#") then {
				_surfaceName = _surfaceName select [1];
			};
	
			private _surfaceCfg = configFile >> "CfgSurfaces" >> _surfaceName;
			private _soundHit = getText (_surfaceCfg >> "soundHit");
	
			if (_soundHit isEqualTo "concrete" || {_soundHit isEqualTo "building"}) then {
				_isOnRoad = true;
			};
		};
	
		// Third check: object underneath
		if (!_isOnRoad) then {
			private _below = lineIntersectsSurfaces [
				AGLToASL _posWorld,
				AGLToASL [_posWorld select 0, _posWorld select 1, (_posWorld select 2) - 3],
				_veh,
				objNull,
				true,
				1,
				"GEOM",
				"NONE"
			];
	
			// If there's any object detected under the car, consider paved
			if (count _below > 0) then {
				private _hitObject = _below select 0 select 2;
				if (!isNull _hitObject) then {
					_isOnRoad = true;
				};
			};
			
			private _startPos = getPosASL _veh;
			private _endPos = _startPos vectorAdd [0, 0, -10];
			
			// Optional: adjust flags to only hit static geometry
			private _flags = 4 + 2; // CF_ONLY_STATIC (4) + CF_NEAREST_CONTACT (2)
			
			private _intersections = lineIntersectsObjs [
				_startPos,
				_endPos,
				_veh,
				objNull,
				true,
				_flags
			];
			
			{
				private _obj = _x;
				if (!isNull _obj) then {
					private _className = toLower typeOf _obj;
					if (!(_className find "rail" > -1)) then {
						_isOnRoad = true;
					};
				};
			} forEach _intersections;
		};
	
		// Now process offroad logic
		if (_isOnRoad) then {
			//systemChat (str(diag_tickTime) + " on road");
			DIVE_lastOnRoadStatus = true;
			DIVE_departurePoint = getPosASL _veh;
			DIVE_departureTime = diag_tickTime;
			_veh setCruiseControl [9999, false];
		} else {
			if (DIVE_lastOnRoadStatus) then {
				DIVE_lastOnRoadStatus = false;
				DIVE_departurePoint = getPosASL _veh;
				DIVE_departureTime = diag_tickTime;
				hint (localize "STR_dive_offroad_warning_1");
			} else {
				private _curPos = getPosASL _veh;
				private _dist = _curPos distance DIVE_departurePoint;
				private _timeOff = diag_tickTime - DIVE_departureTime;
				private _speed = abs(speed _veh);
	
				//systemChat (str(diag_tickTime) + " potentially offroad");
	
				if (_dist > 3 && _speed > 1) then {
					if (_dist > 5 || _timeOff > 1) then {
						//systemChat (str(diag_tickTime) + " fully offroad");
						private _speedLimit = DIVE_offroadSpeedLimit;
						
						private _texPos = (time * 0.03) % 1;
						private _noise = 0.7 * (1337 random [_texPos, 0]); // Bumpy ride!
						_speedLimit = _speedLimit - (_speedLimit * _noise);
						//systemChat ("limit " + str(_speedLimit));
						
						_veh setCruiseControl [_speedLimit, false];
						
						if (speed _veh < -3) then {
							_veh setVelocityModelSpace [0, -(_speedLimit*0.4)/3.6, 0];
						};
						
						[_veh] call fnc_offroadDamageCar;
						
						// Trigger offroad mode logic here
						//DIVE_departureTime = diag_tickTime + 9999;
					};
				};
			};
		};
	}, 0.2, []] call CBA_fnc_addPerFrameHandler;
};

DIVE_offroadSpeedLimit = 4;

// Global cache
DIVE_carsWheelHitpoints = createHashMap;

fnc_offroadDamageCar = {
	params ["_vehicle"];

	private _className = typeOf _vehicle;

	// Configuration — easily editable
	private _mul = DIVE_offroadCheckDelay * (DIVE_offroadSpeedLimit / 3.6);
	private _wheelDamageChance     = 0.05 * _mul;
	private _fuelDamageChance      = 0.02 * _mul;
	private _engineDamageChance    = 0.01 * _mul;

	private _wheelDamageIncrement  = 1;
	private _fuelDamageIncrement   = 0.5;
	private _engineDamageIncrement = 0.5;

	// Check cache
	if (!(_className in DIVE_carsWheelHitpoints)) then {
		private _hitPointsData = getAllHitPointsDamage _vehicle;
		if (_hitPointsData isEqualTo []) exitWith {};

		private _hitPointNames = _hitPointsData select 0;

		// Extract wheel hitpoints
		private _wheelHitPoints = _hitPointNames select {
			toLower _x find "wheel" > -1
		};

		// Fuel tank
		private _fuel = (_hitPointNames select {
			toLower _x find "fuel" > -1
		}) param [0, ""];

		// Engine
		private _engine = (_hitPointNames select {
			toLower _x find "engine" > -1
		}) param [0, ""];

		// Store in cache
		DIVE_carsWheelHitpoints set [_className, [_wheelHitPoints, _fuel, _engine]];
	};

	// Retrieve from cache
	private _cached = DIVE_carsWheelHitpoints get _className;
	if (isNil "_cached") exitWith {};

	private _wheels = _cached select 0;
	private _fuel   = _cached select 1;
	private _engine = _cached select 2;

	private _rand = random 1;

	if (_rand < _wheelDamageChance && count _wheels > 0) then {
		private _wheel = selectRandom _wheels;
		private _current = _vehicle getHitPointDamage _wheel;
		
		if (_current < 1) then {
			_vehicle setHitPointDamage [_wheel, _current + _wheelDamageIncrement];
			
			if (_current + _wheelDamageIncrement >= 1) then {
				[_veh, "offroad_tire.ogg"] call fnc_offroadPlayCarSound;
				hint (localize "STR_dive_offroad_warning_2");
			};
		};
	} else {
		if (_rand < (_wheelDamageChance + _fuelDamageChance) && _fuel != "") then {
			private _current = _vehicle getHitPointDamage _fuel;
			
			if (_current < 1) then {
				_vehicle setHitPointDamage [_fuel, _current + _fuelDamageIncrement];
				[_veh, "offroad_fuel.ogg"] call fnc_offroadPlayCarSound;
				hint (localize "STR_dive_offroad_warning_3");
			};
		} else {
			if (_rand < (_wheelDamageChance + _fuelDamageChance + _engineDamageChance) && _engine != "") then {
				private _current = _vehicle getHitPointDamage _engine;
				
				if (_current < 1) then {
					_vehicle setHitPointDamage [_engine, _current + _engineDamageIncrement];
					
					hint (localize "STR_dive_offroad_warning_4");
					if (_current + _engineDamageIncrement >= 1) then {
						[_veh, "offroad_engine.ogg"] call fnc_offroadPlayCarSound;
					};
				};
			};
		};
	};
};

fnc_offroadPlayCarSound = {
	params ["_veh", "_soundName"];
	playSound3D [
		"pdrstuff\sounds\" + _soundName,
		_veh,
		false,
		getPosASL _veh,
		5
	];
};
call fnc_initOffroadHandling;