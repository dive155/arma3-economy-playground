class RscText {
    access = 0;
    type = 0;
    idc = -1;
    style = 0;
    linespacing = 1;
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,1};
    text = "";
    fixedWidth = 0;
    shadow = 1;
    font = "EtelkaMonospaceProBold";
    sizeEx = 0.03;
};

class RscTitles {
    class CustomHUD {
        idd = -1;
        duration = 1e+1000;
        onLoad = "uiNamespace setVariable ['CustomHUD_Display', _this select 0]";
        fadein = 0;
        fadeout = 0;
        movingEnable = 0;

        class controls {
            class HUD_Background: RscText {
                idc = 1000;
                x = safeZoneX + safeZoneW - 0.7;
                y = safeZoneY + 0.05;
                w = 0.25;
                h = 0.1;
                colorBackground[] = {0, 0, 0, 0.5};
            };

            class HUD_Line1: RscText {
                idc = 1001;
                style = 0;
                sizeEx = 0.03;
                text = "Line 1";
                x = safeZoneX + safeZoneW - 0.69;
                y = safeZoneY + 0.06;
                w = 0.23;
                h = 0.025;
                colorText[] = {1, 1, 1, 1};
            };

            class HUD_Line2: RscText {
                idc = 1002;
                style = 0;
                sizeEx = 0.025;
                text = "Line 2";
                x = safeZoneX + safeZoneW - 0.69;
                y = safeZoneY + 0.085;
                w = 0.23;
                h = 0.025;
                colorText[] = {1, 1, 1, 1};
            };

            class HUD_Line3: RscText {
                idc = 1003;
                style = 0;
                sizeEx = 0.025;
                text = "Line 3";
                x = safeZoneX + safeZoneW - 0.69;
                y = safeZoneY + 0.11;
                w = 0.23;
                h = 0.025;
                colorText[] = {1, 1, 1, 1};
            };
        };
    };
};
