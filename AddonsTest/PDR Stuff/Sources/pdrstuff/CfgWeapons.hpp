class cfgWeapons
{	
	class ItemCore;
	class InventoryItem_Base_F;
	class pdr_money_base: ItemCore
	{
		scope=1;
		access=3;
		displayName="-";
		detectRange=-1;
		simulation="ItemMineDetector";
		useAsBinocular=0;
		type=4096;
		picture="";
		descriptionShort="";
		class ItemInfo: InventoryItem_Base_F
		{
			mass=1;
		};
	};

	// -------Moldova money---------
	class moldova_1_leu: pdr_money_base
	{
		scope=2;
		displayName=$STR_moldova_1_ley;
		picture="\pdrstuff\data\money\moldova_1_leu";
		class ItemInfo: ItemInfo
		{
			mass=0;
		};
	};
	
	class moldova_5_leu: pdr_money_base
	{
		scope=2;
		displayName=$STR_moldova_5_ley;
		picture="\pdrstuff\data\money\moldova_5_leu";
		class ItemInfo: ItemInfo
		{
			mass=0;
		};
	};
	
	class moldova_10_leu: pdr_money_base
	{
		scope=2;
		displayName=$STR_moldova_10_ley;
		picture="\pdrstuff\data\money\moldova_10_leu";
		class ItemInfo: ItemInfo
		{
			mass=0;
		};
	};
	
	class moldova_50_leu: pdr_money_base
	{
		scope=2;
		displayName=$STR_moldova_50_ley;
		picture="\pdrstuff\data\money\moldova_50_leu";
		class ItemInfo: ItemInfo
		{
			mass=0;
		};
	};
	
	class moldova_100_leu: pdr_money_base
	{
		scope=2;
		displayName=$STR_moldova_100_ley;
		picture="\pdrstuff\data\money\moldova_100_leu";
		class ItemInfo: ItemInfo
		{
			mass=0;
		};
	};
	
	//----------PDR money--------
	class pdr_1_leu: pdr_money_base
	{
		scope=2;
		displayName=$STR_pdr_1_ley;
		picture="\pdrstuff\data\money\pdr_1_leu";
		class ItemInfo: ItemInfo
		{
			mass=0;
		};
	};
	
	class pdr_5_leu: pdr_money_base
	{
		scope=2;
		displayName=$STR_pdr_5_ley;
		picture="\pdrstuff\data\money\pdr_5_leu";
		class ItemInfo: ItemInfo
		{
			mass=0;
		};
	};
	
	class pdr_10_leu: pdr_money_base
	{
		scope=2;
		displayName=$STR_pdr_10_ley;
		picture="\pdrstuff\data\money\pdr_10_leu";
		class ItemInfo: ItemInfo
		{
			mass=0;
		};
	};
	
	class pdr_50_leu: pdr_money_base
	{
		scope=2;
		displayName=$STR_pdr_50_ley;
		picture="\pdrstuff\data\money\pdr_50_leu";
		class ItemInfo: ItemInfo
		{
			mass=0;
		};
	};
	
	class pdr_100_leu: pdr_money_base
	{
		scope=2;
		displayName=$STR_pdr_100_ley;
		picture="\pdrstuff\data\money\pdr_100_leu";
		class ItemInfo: ItemInfo
		{
			mass=0;
		};
	};
	
	class pdr_500_leu: pdr_money_base
	{
		scope=2;
		displayName=$STR_pdr_500_ley;
		picture="\pdrstuff\data\money\pdr_500_leu";
		class ItemInfo: ItemInfo
		{
			mass=0;
		};
	};
	
	class pdr_1000_leu: pdr_money_base
	{
		scope=2;
		displayName=$STR_pdr_1000_ley;
		picture="\pdrstuff\data\money\pdr_1000_leu";
		class ItemInfo: ItemInfo
		{
			mass=0;
		};
	};
	
	class food_itemcore : ItemCore {
		type = 4096;
		detectRange = -1;
		simulation = "ItemMineDetector";
		scope = 0;
		author = "Dive";
	};

	class pdr_lunch_full : food_itemcore
	{
		scope = 2;
		displayName = $STR_pdr_lunch;
		descriptionShort = "";
		picture = "\pdrstuff\data\pdr_lunch";
		class ItemInfo: InventoryItem_Base_F {
			mass = 25;
		};
		class KSS
		{
			delay = 30;
			type = "both";
			add = "90";
		};
	};
};