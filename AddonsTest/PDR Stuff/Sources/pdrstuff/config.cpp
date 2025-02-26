class CfgPatches
{
	class Pdr_Stuff
	{
		name = "PDR Stuff";
		author = "Dive";
		
		units[]=
		{
			"b_dive_grain_bag",
			"b_dive_ore_bag",
			"DIVE_Haystack",
			"DIVE_OreRock"
		};
		weapons[]={};
		requiredVersion=0.1;
		requiredAddons[]=
		{
			"A3_Weapons_F",
			"A3_Weapons_F_Ammoboxes",
			"ace_common"
		};
	};
};
class CfgVehicles
{
	class B_Carryall_cbr;
	class b_dive_grain_bag: B_Carryall_cbr
	{
		author="Dive";
		scope=2;
		displayName=$STR_backpack_grain;
		picture="\pdrstuff\data\UI\ico_backpack_grain.paa";
		maximumLoad = 0; 
		mass = 400;
		hiddenSelectionsTextures[]=
		{
			"pdrstuff\data\backpack_grain.paa"
		};
	};
	
	class b_dive_ore_bag: B_Carryall_cbr
	{
		author="Dive";
		scope=2;
		displayName=$STR_backpack_ore;
		picture="\pdrstuff\data\UI\ico_backpack_ore.paa";
		maximumLoad = 0; 
		mass = 400;
		hiddenSelectionsTextures[]=
		{
			"pdrstuff\data\backpack_ore.paa"
		};
	};
	
	class ACE_Box_Misc;
    class DIVE_Haystack: ACE_Box_Misc {
        author = "Dive";
        displayName = $STR_haystack;
		model = "\a3\structures_f_enoch\industrial\agriculture\haybale_01_f.p3d";
        transportMaxWeapons = 0;
        transportMaxMagazines = 0;
        transportMaxItems = 0;
        maximumload = 0;

        class TransportWeapons {};
        class TransportMagazines {};
        class TransportItems {};
        class TransportBackpacks {};
    };
	
	class DIVE_OreRock: ACE_Box_Misc {
        author = "Dive";
        displayName = $STR_ore;
		model = "\a3\rocks_f_exp\lavastones\lavastone_small_f.p3d";
        transportMaxWeapons = 0;
        transportMaxMagazines = 0;
        transportMaxItems = 0;
        maximumload = 0;

        class TransportWeapons {};
        class TransportMagazines {};
        class TransportItems {};
        class TransportBackpacks {};
    };
};
