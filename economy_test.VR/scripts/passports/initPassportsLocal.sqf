call compile preprocessFileLineNumbers "scripts\passports\passportHelpers.sqf";
call compile preprocessFileLineNumbers "scripts\passports\compilePassportNotes.sqf";

0 spawn {
	waitUntil { not isNull player };

	execVM "scripts\passports\initVisaGivers.sqf";
	execVM "scripts\passports\initPassportEditing.sqf";
	execVM "scripts\passports\initDebtEditing.sqf";
	
	sleep 10;
	[player] call fn_updateCivilianInfo;
	[player] call fn_updateVisaInfo;
};