private _readBookAction = [
	"Play_Durak", 
	(localize "STR_play_durak"), 
	"\pdrstuff\data\ui\ico_cards.paa", 
	{
		private _nearPlayers = allPlayers select { 
			_x distance player <= 7 
		};
		
		if (count _nearPlayers > 1) then {
			[_nearPlayers] remoteExecCall ["DB_fnc_createGame", 2];
		} else {
			hint localize "STR_durak_error";
		};
	}, 
	{"ico_cards" in items player}
] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "ACE_Equipment"], _readBookAction] call ace_interact_menu_fnc_addActionToObject;