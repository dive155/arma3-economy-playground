// === BASE CLASSES ===
// class RscText {
    // access = 0;
    // type = 0;
    // idc = -1;
    // style = 0;
    // linespacing = 1;
    // colorBackground[] = {0,0,0,0};
    // colorText[] = {1,1,1,1};
    // text = "";
    // fixedWidth = 0;
    // shadow = 1;
    // font = "PuristaMedium";
    // SizeEx = 0.04;
// };

class RscStructuredText {
    access = 0;
    type = 13;
    idc = -1;
    style = 0;
    x = 0;
    y = 0;
    w = 0.1;
    h = 0.035;
    text = "";
    size = 0.04;
    shadow = 1;
    class Attributes {
        font = "PuristaMedium";
        color = "#ffffff";
        align = "left";
        valign = "top";
        shadow = 1;
    };
};

class RscButton {
    access = 0;
    type = 1;
    text = "";
    colorText[] = {1,1,1,1};
    colorDisabled[] = {0.4,0.4,0.4,1};
    colorBackground[] = {0.2,0.2,0.2,1};
    colorBackgroundDisabled[] = {0.95,0.95,0.95,1};
    colorBackgroundActive[] = {0.3,0.3,0.3,1};
    colorFocused[] = {0.3,0.3,0.3,1};
    colorShadow[] = {0,0,0,0.5};
    colorBorder[] = {0,0,0,1};
    soundEnter[] = {"",0.09,1};
    soundPush[] = {"",0.09,1};
    soundClick[] = {"",0.09,1};
    soundEscape[] = {"",0.09,1};
    style = 2;
    shadow = 2;
    font = "PuristaMedium";
    sizeEx = 0.04;
    offsetX = 0.003;
    offsetY = 0.003;
    offsetPressedX = 0.002;
    offsetPressedY = 0.002;
    borderSize = 0;
};

class RscControlsGroup {
    type = 15;
    idc = -1;
    style = 0;
    x = 0;
    y = 0;
    w = 1;
    h = 1;

    shadow = 0;

    class VScrollbar {
        color[] = {1, 1, 1, 1};
        width = 0.021;
        autoScrollEnabled = 0;
    };
    class HScrollbar {
        color[] = {1, 1, 1, 1};
        height = 0.028;
    };

    class Controls {};
};

// === DIALOG ===
class LongTextDialog {
    idd = 13786;
    movingEnable = false;
    enableSimulation = true;

    class controlsBackground {
        class Background: RscText {
            idc = -1;
            x = 0.1;
            y = 0.1;
            w = 0.8;
            h = 0.8;
            colorBackground[] = {0,0,0,0.85};
        };
    };

    class controls {
        class ScrollGroup: RscControlsGroup {
            idc = 2000;
            x = 0.12;
            y = 0.12;
            w = 0.76;
            h = 0.68;

            class controls {
                class TextContent: RscStructuredText {
                    idc = 2001;
                    x = 0;
                    y = 0;
                    w = 0.74;
                    h = 1; // Temporary — dynamically resized
                    text = "";
                    size = 0.04;
                };
            };
        };

        class CloseButton: RscButton {
            idc = 2002;
            text = "$STR_hudClose";
            x = 0.4;
            y = 0.82;
            w = 0.2;
            h = 0.05;
            action = "closeDialog 0;";
        };
    };
};