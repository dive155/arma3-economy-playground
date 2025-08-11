if (isServer) then {
	[
		refill_hay,
		"DIVE_Haystack",
		5,
		10
	] execVM "scripts\helpers\createRefillField.sqf";
	
	[
		refill_ore,
		"DIVE_OreRock",
		5,
		10
	] execVM "scripts\helpers\createRefillField.sqf";
};