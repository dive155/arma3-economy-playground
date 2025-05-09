params [
    "_buttonObject",
    "_moneyBox",
    "_itemBox",
    "_objectArea",
    "_currencyCode",
    "_storeItemsConfig",
    "_soundsConfig",
	["_extraCondition", {true}],
	["_taxGetter", {0}],
	["_onItemSold", { params ["itemClass", "_moneyCurrency", "_moneyAmount", "_taxAmount"];}]
];

if (isServer) then {
    _buttonObject setVariable ["store_moneyBox", _moneyBox, true];
    _buttonObject setVariable ["store_itemBox", _itemBox, true];
    _buttonObject setVariable ["store_objectArea", _objectArea, true];
    _buttonObject setVariable ["store_currencyCode", _currencyCode, true];
    _buttonObject setVariable ["store_config", _storeItemsConfig, true];
	_buttonObject setVariable ["extraCondition", _extraCondition, true];
	_buttonObject setVariable ["taxGetter", _taxGetter, true];
	_buttonObject setVariable ["onItemSold", _onItemSold, true];

    _soundsMap = createHashMap;
    _soundsMap set ["action", _soundsConfig select 0];
    _soundsMap set ["success", _soundsConfig select 1];
    _soundsMap set ["failure", _soundsConfig select 2];
    _buttonObject setVariable ["soundsMap", _soundsMap, true];
};

if (hasInterface) then {
    private _buyFromStoreAction = {
        params ["_target"];

        private _storeConfig = _target getVariable ["store_config", []];
        private _moneyBox = _target getVariable ["store_moneyBox", objNull];
        private _itemBox = _target getVariable ["store_itemBox", objNull];
        private _objectArea = _target getVariable ["store_objectArea", objNull];
        private _currency = _target getVariable ["store_currencyCode", "UNKNOWN"];
        private _soundsMap = _target getVariable ["soundsMap", createHashMap];
		private _extraCondition = _target getVariable ["extraCondition", {true}];
		private _taxGetter = _target getVariable ["taxGetter", {0}];
		private _onItemSold = _target getVariable ["onItemSold", {}];
		if not (call _extraCondition) exitWith {};

        private _itemList = [];
		{
			private _class = _x select 0;
			private _price = _x select 1;
			private _cfg = configFile >> "CfgWeapons" >> _class;
			if (!isClass _cfg) then { _cfg = configFile >> "CfgMagazines" >> _class };
			if (!isClass _cfg) then { _cfg = configFile >> "CfgVehicles" >> _class };
			if (!isClass _cfg) then { continue };

			private _name = getText (_cfg >> "displayName");
			private _icon = getText (_cfg >> "picture");

			private _tax = ceil (_price *  (call _taxGetter));
			private _priceText = if (_tax > 0) then { format ["%1 (+%2 %3)", _price, localize "STR_store_tax", _tax] } else {format ["%1", _price]};

			_itemList pushBack [
				[_name],
				[_priceText],
				[_icon],
				[],
				_name,
				_class,
				_price
			];
		} forEach _storeConfig;

        [
            [
                _itemList,
                0,
                false
            ],
            format [localize "STR_store_select_item", localize ("STR_" + _currency)],
            [
				{				
					//params ["_confirmed", "_index", "_data", "_value", "_args"];
					private _target = _this select 0;
				
					if not _confirmed exitWith {};
					
					private _storeConfig = _target getVariable ["store_config", []];
					private _moneyBox = _target getVariable ["store_moneyBox", objNull];
					private _itemBox = _target getVariable ["store_itemBox", objNull];
					private _objectArea = _target getVariable ["store_objectArea", objNull];
					private _currency = _target getVariable ["store_currencyCode", "UNKNOWN"];
					private _soundsMap = _target getVariable ["soundsMap", createHashMap];
					private _extraCondition = _target getVariable ["extraCondition", {true}];
					private _taxGetter = _target getVariable ["taxGetter", {0}];
					private _onItemSold = _target getVariable ["onItemSold", {}];
					
					private _class = _data;
					private _price = _value;
					private _tax = ceil (_price *  (call _taxGetter));
					private _priceWithTax = _price + _tax;
					
					private _hasMoney = [_moneyBox, _currency] call fnc_getMoneyAmountInContainer;
					if (_hasMoney < _priceWithTax) exitWith {
						hint localize "STR_store_not_enough_money";
						[_target, _target, "failure", 3] call fnc_playStoreSound;
					};
					
					[_moneyBox, _currency, _priceWithTax] call fnc_takeMoneyFromContainer;
					[_class, _currency, _price, _tax] call _onItemSold;
					
					_reportSuccess = {
						private _message = format [
							(localize "STR_store_purchase_success"),
							_priceWithTax,
							(localize ("STR_" + _currency)),
							_class
						];
						hint _message;
						[_target, _target, "success", 3] call fnc_playStoreSound;
					};
					
					_cfg = configFile >> "CfgVehicles" >> _class;
					if (isClass _cfg) exitWith {
						// Check if it's a backpack
						if (getNumber (_cfg >> "isBackpack") == 1) exitWith {
							_itemBox addBackpackCargoGlobal [_class, 1];
							call _reportSuccess;
						};

						// It's a placeable object (vehicle-like)
						private _pos = getPosATL _objectArea;
						_pos set [2, (_pos select 2) + 0.5];

						private _obj = createVehicle [_class, _pos, [], 0, "NONE"];
						_obj setPosATL _pos;

						[_obj] spawn {
							sleep 0.5;
							(_this select 0) setDamage 0;
						};
						call _reportSuccess;
					};

					_cfg = configFile >> "CfgWeapons" >> _class;
					if (isClass _cfg) exitWith {
						call _reportSuccess;
						
						private _type = (_class call BIS_fnc_itemType) select 1;
						if (_type isEqualTo "Uniform" or _type isEqualTo "Vest") then {
							_itemBox addItemCargoGlobal [_class, 1];
						} else {
							_itemBox addWeaponCargoGlobal [_class, 1];
						};
					};

					_cfg = configFile >> "CfgMagazines" >> _class;
					if (isClass _cfg) exitWith {
						call _reportSuccess;
						_itemBox addMagazineCargoGlobal [_class, 1];
					};
					
					_cfg = configFile >> "CfgGlasses" >> _class;
					if (isClass _cfg) exitWith {
						call _reportSuccess;
						_itemBox addItemCargoGlobal [_class, 1];
					};
					
					// Fallback
					_itemBox addItemCargoGlobal [_class, 1];
					call _reportSuccess;
				},
				[_target]
			],
            localize "STR_store_confirm",
            localize "STR_store_cancel"
        ] spawn CAU_UserInputMenus_fnc_listBox;
    };

    private _storeAction = ["BuyFromStore", localize "STR_store_interact_buy", "", _buyFromStoreAction, {true}] call ace_interact_menu_fnc_createAction;
    [_buttonObject, 0, [], _storeAction] call ace_interact_menu_fnc_addActionToObject;
};
