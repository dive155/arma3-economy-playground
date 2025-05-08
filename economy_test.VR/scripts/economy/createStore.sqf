params [
    "_buttonObject",
    "_moneyBox",
    "_itemBox",
    "_objectArea",
    "_currencyCode",
    "_storeItemsConfig",
    "_soundsConfig"
];

if (isServer) then {
    _buttonObject setVariable ["store_moneyBox", _moneyBox, true];
    _buttonObject setVariable ["store_itemBox", _itemBox, true];
    _buttonObject setVariable ["store_objectArea", _objectArea, true];
    _buttonObject setVariable ["store_currencyCode", _currencyCode, true];
    _buttonObject setVariable ["store_config", _storeItemsConfig, true];

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

        private _itemList = [];

        {
            private _categoryItems = _x;
            {
                private _class = _x select 0;
                private _price = _x select 1;

                private _cfg = configFile >> "CfgWeapons" >> _class;
                if (!isClass _cfg) then { _cfg = configFile >> "CfgMagazines" >> _class };
                if (!isClass _cfg) then { _cfg = configFile >> "CfgVehicles" >> _class };
                if (!isClass _cfg) then { continue };

                private _name = getText (_cfg >> "displayName");
                private _icon = getText (_cfg >> "picture");

                _itemList pushBack [
                    [_name],
                    [format ["%1", _price]],
                    [_icon],
                    [],
                    _name,
                    _class,
                    _price
                ];
            } forEach _categoryItems;
        } forEach _storeConfig;

        [
            [
                _itemList,
                0,
                false
            ],
            localize "STR_store_select_item",
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
					
					private _class = _data;
					private _price = _value;

					private _hasMoney = [_moneyBox, _currency] call fnc_getMoneyAmountInContainer;
					
					systemChat str([_moneyBox, _currency]);
					
					if (_hasMoney < _price) exitWith {
						hint localize "STR_store_not_enough_money";
						[_target, _target, "failure", 3] call fnc_playStoreSound;
					};
					
					[_moneyBox, _currency, _price] call fnc_takeMoneyFromContainer;

					private _cfg = configFile >> "CfgVehicles" >> _class;
					if (isClass _cfg) then {
						private _pos = getPosATL _objectArea;
						_pos set [2, (_pos select 2) + 0.5];
						createVehicle [_class, _pos, [], 0, "NONE"];
					} else {
						private _itemCfg = configFile >> "CfgWeapons" >> _class;
						if (isClass _itemCfg) then {
							_itemBox addWeaponCargoGlobal [_class, 1];
						} else {
							_itemCfg = configFile >> "CfgMagazines" >> _class;
							if (isClass _itemCfg) then {
								_itemBox addMagazineCargoGlobal [_class, 1];
							} else {
								_itemCfg = configFile >> "CfgGlasses" >> _class;
								if (isClass _itemCfg) then {
									_itemBox addItemCargoGlobal [_class, 1];
								} else {
									_itemBox addItemCargoGlobal [_class, 1]; // fallback
								};
							};
						};
					};

					private _message = format [
						(localize "STR_store_purchase_success"),
						_price,
						(localize ("STR_" + _currency)),
						_class
					];
					hint _message;
					[_target, _target, "success", 3] call fnc_playStoreSound;
				},
				[_target]
			],
            localize "STR_store_confirm",
            localize "STR_store_cancel"
        ] call CAU_UserInputMenus_fnc_listBox;
    };

    private _storeAction = ["BuyFromStore", localize "STR_store_interact_buy", "", _buyFromStoreAction, {true}] call ace_interact_menu_fnc_createAction;
    [_buttonObject, 0, [], _storeAction] call ace_interact_menu_fnc_addActionToObject;
};
