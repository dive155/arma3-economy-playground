private _readBookAction = [
	"Read_Book_Jokes", 
	(localize "STR_book_jokes"), 
	"\pdrstuff\data\ui\ico_book_jokes.paa", 
	{[format ["<t size='1.5'>%1<br/><br/><t/><t size='1'>%2<t/>", localize "STR_book_jokes", localize "STR_book_jokes_content"], 0.05] call fnc_showLongTextDialog}, 
	{"pdr_book_jokes" in items player}
] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "ACE_Equipment"], _readBookAction] call ace_interact_menu_fnc_addActionToObject;
 
_readBookAction = [
	"Read_Book_Magycais", 
	(localize "STR_book_magycais"), 
	"\pdrstuff\data\ui\ico_book_magycais.paa", 
	{[format ["<t size='1.5'>%1<br/><br/><t/><t size='1'>%2<t/>", localize "STR_book_magycais", localize "STR_book_magycais_content"], 0.05] call fnc_showLongTextDialog},  
	{"pdr_book_magycais" in items player}
] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "ACE_Equipment"], _readBookAction] call ace_interact_menu_fnc_addActionToObject;