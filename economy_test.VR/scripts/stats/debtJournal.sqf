fnc_showOwnDebtHistory = {
	params ["_countryCode"];
	private _steamId = (player getVariable "DMP_SteamID");
	[_steamId, _countryCode] call fnc_showPlayerDebtHistory;
};

fnc_showPlayerDebtHistory = {
	params["_steamId", "_countryCode"];
		
	(["DMP_fnc_getManyPlayerVariablesSteamId", [_steamId, ["grad_passport_firstName", "grad_passport_lastName"], ""]] call DMP_fnc_requestServerResult)
	params ["_playerName", "_playerLastName"];
	
	private _header = "<t align='center'><t size='1.5'>" + (localize "STR_transactions_title") + "<br/><t color='#caf5c4'> " + format [localize "STR_account_debt", _playerLastName, _playerName, localize ("STR_country" + _countryCode)] + "</t></t></t><br/><br/>";
	
	["debt_" + _steamId + "_" + _countryCode, _header] call fnc_requestAndShowJournal;
};

_checkOwnDebtAction = [
	"CheckOwnDebtPDR", 
	(localize "STR_check_debt_action") + " (" + (localize "STR_countryPDR") +")", 
	"", 
	{
		["PDR"] spawn fnc_showOwnDebtHistory;
	}, 
	{true}
] call ace_interact_menu_fnc_createAction;
	
[player, 1, ["ACE_SelfActions", "RpSelfRoot"], _checkOwnDebtAction] call ace_interact_menu_fnc_addActionToObject;

_checkOwnDebtAction = [
	"CheckOwnDebtMoldova", 
	(localize "STR_check_debt_action") + "(" + (localize "STR_countryMoldova") +")", 
	"", 
	{
		["Moldova"] spawn fnc_showOwnDebtHistory;
	}, 
	{true}
] call ace_interact_menu_fnc_createAction;
	
[player, 1, ["ACE_SelfActions", "RpSelfRoot"], _checkOwnDebtAction] call ace_interact_menu_fnc_addActionToObject;