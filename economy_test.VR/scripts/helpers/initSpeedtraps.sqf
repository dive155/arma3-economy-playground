fnc_handleSpeedtrapActivation = {
	params ["_activators", "_speedLimit", "_radarId"];
	
	if not (["speedTrapsEnabled"] call fnc_getWorldVariable) exitWith {};
	
	_drivers = [];
	_speedViolators = [];
	{
		// Check if the object is a vehicle
		if ( _x isKindOf "LandVehicle") then {
			_driver = driver _x;
			if (!isNull _driver && isPlayer _driver) then {
				_drivers pushBackUnique _driver;
			};
		};
	} forEach _activators;
	
	{
		_vehicle = vehicle _x;
		_currentSpeed = speed _vehicle;
		if (_currentSpeed > _speedLimit) then {
			_speedViolators pushBack [ _x, _currentSpeed, _speedLimit, _radarId];
		};
	} forEach _drivers; // Loop through all collected drivers
	
	{
		_x call fnc_handleSpeedViolator;
	} forEach _speedViolators;
};

fnc_handleSpeedViolator = {
	params ["_unit", "_currentSpeed", "_speedLimit", "_radarId"];
	
	private _lowSpeedingThreshold = 10;
	private _highSpeedingThreshold = 30;
	private _fine = 0;
	
	if (_currentSpeed > (_speedLimit + _highSpeedingThreshold) ) then {
		_fine = ["speedingFineHigh"] call fnc_getWorldVariable;
	} else {
		if (_currentSpeed > (_speedLimit + _lowSpeedingThreshold) ) then {
			_fine = ["speedingFineLow"] call fnc_getWorldVariable;
		};
	};
	
	private _steamId = _unit getVariable ["DMP_SteamID", ""];
	if (_fine == 0 or _steamId isEqualTo "") exitWith {};
	
	[_currentSpeed, _speedLimit, _fine, "pdrLeu"] remoteExec ["fnc_showSpeedingMessage", _unit];
	
	[
		_steamId,
		format ["[Speeding Radar #%1]", _radarId],
		"PDR",
		"FineTraffic",
		_fine,
		format["%1km/h, limit %2km/h", _currentSpeed toFixed 0, _speedLimit]
	] call fnc_handlePlayerDebtTransaction;
};

fnc_showSpeedingMessage = {
    params ["_currentSpeed", "_speedLimit", "_fineAmount", "_currencyCode"];

    // Localized string key (to be defined in stringtable.xml)
    _localizedText = format [
        localize "STR_speeding_ticket_message",
        _currentSpeed toFixed 0,
        _speedLimit,
        _fineAmount,
        localize ("STR_" + _currencyCode)
    ];

    [_localizedText, -1, -0.3, 12, 0, 0, 789] spawn BIS_fnc_dynamicText;
	
	// TODO temp sound
	playSound "DIVE_Machine_Success_Money";
};
