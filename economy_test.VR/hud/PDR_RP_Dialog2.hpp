#include "CustomControlClasses.h"
class PDR_RP_Dialog2
{
	idd = 8346;
	
	class ControlsBackground
	{
		class RpBackground
		{
			type = 0;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.34375;
			y = safeZoneY + safeZoneH * 0.225;
			w = safeZoneW * 0.3125;
			h = safeZoneH * 0.55;
			style = 0;
			text = "";
			colorBackground[] = {0,0.061,0.2151,0.8852};
			colorText[] = {0.2549,0.7725,0.1961,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
		
	};
	class Controls
	{
		class HeaderControl
		{
			type = 0;
			idc = 0;
			x = safeZoneX + safeZoneW * 0.44375;
			y = safeZoneY + safeZoneH * 0.225;
			w = safeZoneW * 0.1125;
			h = safeZoneH * 0.075;
			style = 2;
			text = "PDR RP";
			colorBackground[] = {1,1,1,0};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.5);
			
		};
		class MainInfoText
		{
			type = 13;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.36875;
			y = safeZoneY + safeZoneH * 0.3;
			w = safeZoneW * 0.1375;
			h = safeZoneH * 0.125;
			style = 0;
			text = "Current Day: 5<br/>Days Since Last Meal: 1<br/>Work Fatigue: 2/4<br/>Citizenship: Moldova";
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2);
			colorBackground[] = {1,1,1,0};
			tooltipColorText[] = {1,1,1,1};
			class Attributes
			{
				
			};
			
		};
		class OpenPassportButton
		{
			type = 1;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.54375;
			y = safeZoneY + safeZoneH * 0.375;
			w = safeZoneW * 0.0875;
			h = safeZoneH * 0.025;
			style = 0;
			text = "Open Passport";
			borderSize = 0;
			colorBackground[] = {0,0,0,1};
			colorBackgroundActive[] = {1,0,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorFocused[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			offsetPressedX = 0.01;
			offsetPressedY = 0.01;
			offsetX = 0.01;
			offsetY = 0.01;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
			
		};
		class PermissionsInfoText
		{
			type = 13;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.36875;
			y = safeZoneY + safeZoneH * 0.65;
			w = safeZoneW * 0.1375;
			h = safeZoneH * 0.1;
			style = 0;
			text = "Debt to PDR: 234<br/><br/>Debt to Moldova: 12";
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2);
			colorBackground[] = {1,1,1,0};
			tooltipColorText[] = {1,1,1,1};
			class Attributes
			{
				
			};
			
		};
		class PermissionsInfoText_copy1
		{
			type = 13;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.36875;
			y = safeZoneY + safeZoneH * 0.425;
			w = safeZoneW * 0.2625;
			h = safeZoneH * 0.175;
			style = 0;
			text = "Special Permissions:";
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2);
			colorBackground[] = {1,1,1,0};
			tooltipColorText[] = {1,1,1,1};
			class Attributes
			{
				
			};
			
		};
		class DebtHistory1
		{
			type = 1;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.54375;
			y = safeZoneY + safeZoneH * 0.7;
			w = safeZoneW * 0.0875;
			h = safeZoneH * 0.025;
			style = 0;
			text = "Debt History";
			borderSize = 0;
			colorBackground[] = {0,0,0,1};
			colorBackgroundActive[] = {1,0,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorFocused[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			offsetPressedX = 0.01;
			offsetPressedY = 0.01;
			offsetX = 0.01;
			offsetY = 0.01;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
			
		};
		class DebtHistory2
		{
			type = 1;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.54375;
			y = safeZoneY + safeZoneH * 0.65;
			w = safeZoneW * 0.0875;
			h = safeZoneH * 0.025;
			style = 0;
			text = "Debt History";
			borderSize = 0;
			colorBackground[] = {0,0,0,1};
			colorBackgroundActive[] = {1,0,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorFocused[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			offsetPressedX = 0.01;
			offsetPressedY = 0.01;
			offsetX = 0.01;
			offsetY = 0.01;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
			
		};
		
	};
	
};
