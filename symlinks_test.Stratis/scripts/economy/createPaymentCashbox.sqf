params [
    "_buttonObject",            // Button to press
    "_moneyBox",                // Box where player puts the money
    "_countryCode",            // For checking debts
    "_currencyCode",           // Currency type used
    "_soundsConfig",           // Format: [soundAction, soundSuccess, soundFailure]
	["_handleJournalingPlayer", {params ["_steamId", "_instigatorName", "_countryCode", "_operationType", "_amount", "_playersNote"];}],
	["_sendPayment", {params ["_playerName", "_operationType", "_amount", "_playersNote"]}]
];

// Store config on the server
if (isServer) then {
    _buttonObject setVariable ["moneyBox", _moneyBox, true];
    _buttonObject setVariable ["countryCode", _countryCode, true];
    _buttonObject setVariable ["currencyCode", _currencyCode, true];
	_buttonObject setVariable ["handleJournalingPlayer", _handleJournalingPlayer, true];
	_buttonObject setVariable ["sendPayment", _sendPayment, true];

    _soundsMap = createHashMap;
    _soundsMap set ["action", _soundsConfig select 0];
    _soundsMap set ["success", _soundsConfig select 1];
    _soundsMap set ["failure", _soundsConfig select 2];
    _buttonObject setVariable ["soundsMap", _soundsMap, true];
} else {
	waitUntil {sleep 1; not (isNull (_buttonObject getVariable ["moneyBox", objNull]))};
};

// Function for handling the payment
fnc_handleCashboxPayment = {
    params ["_buttonObject"];

    private _moneyBox = _buttonObject getVariable ["moneyBox", objNull];
    private _countryCode = _buttonObject getVariable ["countryCode", ""];
    private _currencyCode = _buttonObject getVariable ["currencyCode", ""];
    private _soundsMap = _buttonObject getVariable ["soundsMap", createHashMap];
	private _handleJournalingPlayer = _buttonObject getVariable ["handleJournalingPlayer", {}];
	private _sendPayment = _buttonObject getVariable ["sendPayment", {}];

    [_buttonObject, _buttonObject, "action", 3] call fnc_playStoreSound;

    private _debt = 0;
    {
        if (_x select 0 == _countryCode) exitWith {
            _debt = _x select 1;
        };
    } forEach (player getVariable ["rp_debts", []]);

    if (_debt <= 0) exitWith {
        sleep 1;
        hint format [localize "STR_payment_no_debt", localize format ["STR_country%1", _countryCode]];
        [_buttonObject, _buttonObject, "failure", 3] call fnc_playStoreSound;
    };

    private _moneyInBox = [_moneyBox, _currencyCode] call fnc_getMoneyAmountInContainer;
    if (_moneyInBox == 0) exitWith {
        sleep 1;
        hint (localize "STR_payment_no_money");
        [_buttonObject, _buttonObject, "failure", 3] call fnc_playStoreSound;
    };

    private _paidAmount = _moneyInBox;
    private _change = 0;

    if (_paidAmount > _debt) then {
        _change = _paidAmount - _debt;
        _paidAmount = _debt;
    };

    // Subtract money
    [_moneyBox, _currencyCode, _paidAmount] call fnc_takeMoneyFromContainer;

    // Update player debt
	[
		player getVariable "DMP_SteamID",
		name player,
		_countryCode,
		"DebtPayment",
		-1 * _paidAmount,
		localize "STR_transactions_automatedSystem"
	] call _handleJournalingPlayer;
	
	[name player, "DebtPayment", _paidAmount, localize "STR_transactions_automatedSystem"] call _sendPayment;

    sleep 1;

	[player] call fn_updateCivilianInfo;
    private _currencyName = localize format ["STR_%1", _currencyCode];
    private _message = format [
		localize "STR_payment_success",
		_paidAmount,
		_currencyName,
		localize format ["STR_country%1", _countryCode],
		_debt - _paidAmount
	];

    if (_change > 0) then {
        _message = _message + "\n\n" + format[localize "STR_payment_change", _change, _currencyName];
    };

    [_buttonObject, _buttonObject, "success", 3] call fnc_playStoreSound;
    hint _message;
};

// Attach ACE interaction
if (hasInterface) then {
    private _interact = {
        [_this select 0] spawn {
            params ["_target"];
            [_target] spawn fnc_handleCashboxPayment;
        };
    };
	private _actionName = format [localize "STR_pay_debt", localize format ["STR_country%1", _countryCode]];
    private _action = ["PayDebtCashbox", _actionName, "", _interact, {true}] call ace_interact_menu_fnc_createAction;
    [_buttonObject, 0, [], _action] call ace_interact_menu_fnc_addActionToObject;
};