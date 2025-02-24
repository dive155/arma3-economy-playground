class CfgPatches
{
	class Pdr_Stuff
	{
		name = "PDR Stuff";
		author = "Dive";
		
		units[]=
		{
			"b_dive_grain_bag",
		};
		weapons[]={};
		requiredVersion=0.1;
		requiredAddons[]=
		{
			"A3_Weapons_F",
			"A3_Weapons_F_Ammoboxes"
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
};
