// Thanks to the glorious Larrow, it is based on his solution
// https://forums.bohemia.net/forums/topic/226662-sqf-arma-3-how-to-get-backpack-contents-out-of-backpacks-stored-inside-a-vehicle/?do=findComment&comment=3387750

fnc_db_getCargoData = {
	params[ "_crate" ];
	
	// Uniforms, vest and backpacks as containers
	_containers = everyContainer _crate; 
	
	// Every item that is not a container type
	_itemsData = itemCargo _crate select{ 
		_item = _x; 
		_containers findIf{ _x select 0 == _item } isEqualTo -1 
	};
	
	_cargoData = [ 
		_itemsData call BIS_fnc_consolidateArray,
		magazinesAmmoCargo _crate call BIS_fnc_consolidateArray,
		weaponsItemsCargo _crate call BIS_fnc_consolidateArray
	];
	
	_containersData = [];
	{
		_x params[ "_containerType", "_container" ];
		
		_containersData pushBack [ 
			_containerType,
			[
				itemCargo _container call BIS_fnc_consolidateArray,
				magazinesAmmoCargo _container call BIS_fnc_consolidateArray,
				weaponsItemsCargo _container call BIS_fnc_consolidateArray
			]
		];
	}forEach _containers;
	
	[ _cargoData, _containersData ];
};

fnc_db_loadCargoFromData = {
	params["_crate", "_data"];
	
	clearItemCargoGlobal _crate;
	clearMagazineCargoGlobal _crate;
	clearWeaponCargoGlobal _crate;
	clearBackpackCargoGlobal _crate;
	
	_cargoData = _data select 0;
	_containersData = _data select 1;
		
	{
		[ _forEachIndex, _x,  _crate ] call fnc_db_addContainerContents;
	}forEach _cargoData;
	
	{
		_x params[ "_containerType", "_containerContents" ];
		
		if ( _containerType call BIS_fnc_itemType select 1 == "backpack" ) then {
			 _crate addBackpackCargoGlobal[ _containerType, 1 ];
		}else{
			 _crate addItemCargoGlobal[ _containerType, 1 ];
		};
		everyContainer  _crate select ( count everyContainer  _crate - 1 ) params[ "_type", "_container" ];
		
		clearItemCargoGlobal _container;
		clearMagazineCargoGlobal _container;
		clearWeaponCargoGlobal _container;
		clearBackpackCargoGlobal _container;
		
		{
			[ _forEachIndex, _x, _container ] call fnc_db_addContainerContents;
		}forEach _containerContents;		
	}forEach _containersData;
};

fnc_db_addContainerContents = {
	params[ "_index", "_contents", "_container" ];
		
	{
		_x params[ "_info", "_count" ];
		
		switch ( _index ) do {
			//Items
			case 0 : {
				_container addItemCargoGlobal[ _info, _count ];
			};
			//Magazines
			case 1 : {
				_info params[ "_magazineType", "_ammoCount" ];
				
				_container addMagazineAmmoCargo[ _magazineType, _count, _ammoCount ];
			};
			//Weapons
			case 2 : {
				_container addWeaponWithAttachmentsCargoGlobal[ _info, _count ];
			};
		};
	}forEach _contents;
};