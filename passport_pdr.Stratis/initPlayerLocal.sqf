waitUntil { not isNull player };

execVM "scripts\passports\initVisaGivers.sqf";
execVM "scripts\passports\initPassportEditing.sqf";
execVM "scripts\passports\initDebtEditing.sqf"