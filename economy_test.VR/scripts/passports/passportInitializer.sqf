if (isNil "fnc_setPassportVariablesBulk") then { call compile preprocessFileLineNumbers "scripts\passports\passportHelpers.sqf";}; 

fnc_initializeDefaultPassport = {
	private _unit = _this select 0;
	private _alreadySet = _unit getVariable ["PDR_passportInitialized", false];
	
	if not _alreadySet then {
		[  
		_unit,  
		[  	
			["grad_passport_passportRsc", "passport" + (_this select 1)],
			["grad_passport_firstName", _this select 2],  
			["grad_passport_lastName", _this select 3],  
			["grad_passport_placeOfBirth", _this select 4],  
			["grad_passport_dateOfBirth", _this select 5],  
			["grad_passport_expires", _this select 6],  
			["grad_passport_serial", _this select 7],
			
			
			["rp_debts", [["Moldova", 0], ["PDR", 0]]],
			["rp_govtjob", ""],  
			["rp_govtsalary", 0],  
			["rp_dailybills", if ((_this select 1) isEqualTo "Pdr") then {300} else {9} ],
			["rp_registeredvehicles", []],  
			["rp_passportnotes", []],
			["rp_registrationaddress", ""],  
			["rp_ownedproperties", []],
			["rp_permissions", []], 
			["rp_fatigue_current", 0], 
			["rp_fatigue_capacity", 4], 
			["rp_daysSinceLastMeal", 0]
		]] call fnc_setPassportVariablesBulk;
		
		_unit setVariable ["PDR_passportInitialized", true];
	};
};



// [  
 // this,  
 // [  
  // ["grad_passport_passportRsc", "passportMoldova"],  
  // ["grad_passport_firstName", "Джоменик"],  
  // ["grad_passport_lastName", "Балан"],  
  // ["grad_passport_placeOfBirth", "г. Фуящерск, Молдова"],  
  // ["grad_passport_dateOfBirth", "1990-03-16"],  
  // ["grad_passport_expires", "2030-03-16"],  
  // ["grad_passport_serial", "MD-412399"],  
 
  // ["rp_govtjob", "Резервист"],  
  // ["rp_govtsalary", 6],  
  // ["rp_dailybills", 20],  
  // ["rp_debts", [["Moldova", 3], ["PDR", 120]]],  
  // ["rp_registrationaddress", "Ул. Сталина д. 16, Молдовосталь"],  
  // ["rp_ownedproperties", ["Ул. Сталина д. 16, Молдовосталь", "Ул. Ленина д.13, Механострой"]],  
  // ["rp_registeredvehicles", ["MLD-1356", "TRANSIT-5234(22.06)"]],  
  // ["rp_passportnotes", ["Герой Труда.","Алкоголик."]], 
 
  // ["rp_permissions", ["cooking", "accountFull_factoryMoney", "accountFull_cityMoney", "debtEditing_PDR", "debtEditing_Moldova", "passportEditingPdr", "passportEditingMoldova","visaGiving_PDR", "visaGiving_Moldova", "sellingIndustrialGoods"]], 
  // ["rp_fatigue_current", 0], 
  // ["rp_fatigue_capacity", 4], 
  // ["rp_daysSinceLastMeal", 1] 
   
// ]] call fnc_setPassportVariablesBulk;