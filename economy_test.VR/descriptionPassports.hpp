#include "node_modules\grad-passport\grad_passport.hpp"

#include "cau\userinputmenus\systems\_macros.inc"
#include "cau\userinputmenus\systems\_defines.inc"

#include "cau\userinputmenus\controls.cpp"
#include "cau\userinputmenus\systems\displayColorPicker.cpp"
#include "cau\userinputmenus\systems\displayGuiMessage.cpp"
#include "cau\userinputmenus\systems\displayListbox.cpp"
#include "cau\userinputmenus\systems\displayListboxMulti.cpp"
#include "cau\userinputmenus\systems\displayProgressBar.cpp"
#include "cau\userinputmenus\systems\displaySlider.cpp"
#include "cau\userinputmenus\systems\displayText.cpp"
#include "cau\userinputmenus\systems\displayTextMulti.cpp"

class passportPDR: grad_passport_defaultPassport {
    class ControlsBackground: ControlsBackground {
        class BGPic: BGPic {
            text = "node_modules\grad-passport\data\passport_pdr.paa";
        };
    };
	
	class Controls {
        class LastNameTitle: GVAR(RscText) {
            x = GRAD_PASSPORT_DEFAULT_LEFTCOLUMN_X;
            y = GRAD_PASSPORT_DEFAULT_LINETITLE_Y(0);
            w = (0.1000 * X_SCALE);
            h = GRAD_PASSPORT_LINE_H;

            text = "ФАМИЛИЯ";
            sizeEx = GRAD_PASSPORT_DEFAULT_TITLETEXTSIZE;

            colorText[] = {0,0,0,1};
        };
        class LastName: GVAR(RscText) {
            idc = GRAD_IDC_LASTNAME;

            x = GRAD_PASSPORT_DEFAULT_LEFTCOLUMN_X + GRAD_PASSPORT_DEFAULT_INDENT_X;
            y = GRAD_PASSPORT_DEFAULT_LINE_Y(0);
            w = GRAD_PASSPORT_CONTENT_W;
            h = GRAD_PASSPORT_LINE_H;

            colorText[] = {0,0,0,1};
        };
        class FirstNameTitle: GVAR(RscText) {
            x = GRAD_PASSPORT_DEFAULT_LEFTCOLUMN_X;
            y = GRAD_PASSPORT_DEFAULT_LINETITLE_Y(1);
            w = (0.1000 * X_SCALE);
            h = GRAD_PASSPORT_LINE_H;

            text = "ИМЯ";
            sizeEx = GRAD_PASSPORT_DEFAULT_TITLETEXTSIZE;

            colorText[] = {0,0,0,1};
        };
        class FirstName: GVAR(RscText) {
            idc = GRAD_IDC_FIRSTNAME;

            x = GRAD_PASSPORT_DEFAULT_LEFTCOLUMN_X + GRAD_PASSPORT_DEFAULT_INDENT_X;
            y = GRAD_PASSPORT_DEFAULT_LINE_Y(1);
            w = GRAD_PASSPORT_CONTENT_W;
            h = GRAD_PASSPORT_LINE_H;

            colorText[] = {0,0,0,1};
        };
        class DateOfBirthTitle: GVAR(RscText) {
            x = GRAD_PASSPORT_DEFAULT_LEFTCOLUMN_X;
            y = GRAD_PASSPORT_DEFAULT_LINETITLE_Y(2);
            w = (0.1000 * X_SCALE);
            h = GRAD_PASSPORT_LINE_H;

            text = "ДАТА РОЖДЕНИЯ";
            sizeEx = GRAD_PASSPORT_DEFAULT_TITLETEXTSIZE;

            colorText[] = {0,0,0,1};
        };
        class DateOfBirth: GVAR(RscText) {
            idc = GRAD_IDC_DATEOFBIRTH;

            x = GRAD_PASSPORT_DEFAULT_LEFTCOLUMN_X + GRAD_PASSPORT_DEFAULT_INDENT_X;
            y = GRAD_PASSPORT_DEFAULT_LINE_Y(2);
            w = GRAD_PASSPORT_CONTENT_W;
            h = GRAD_PASSPORT_LINE_H;

            colorText[] = {0,0,0,1};
        };
        class PlaceOfBirthTitle: GVAR(RscText) {
            x = GRAD_PASSPORT_DEFAULT_LEFTCOLUMN_X;
            y = GRAD_PASSPORT_DEFAULT_LINETITLE_Y(3);
            w = (0.1000 * X_SCALE);
            h = GRAD_PASSPORT_LINE_H;

            text = "МЕСТО РОЖДЕНИЯ";
            sizeEx = GRAD_PASSPORT_DEFAULT_TITLETEXTSIZE;

            colorText[] = {0,0,0,1};
        };
        class PlaceOfBirth: GVAR(RscText) {
            idc = GRAD_IDC_PLACEOFBIRTH;

            x = GRAD_PASSPORT_DEFAULT_LEFTCOLUMN_X + GRAD_PASSPORT_DEFAULT_INDENT_X;
            y = GRAD_PASSPORT_DEFAULT_LINE_Y(3);
            w = GRAD_PASSPORT_CONTENT_W;
            h = GRAD_PASSPORT_LINE_H;

            colorText[] = {0,0,0,1};
        };
        class ExpiresTitle: GVAR(RscText) {
            x = GRAD_PASSPORT_DEFAULT_LEFTCOLUMN_X;
            y = GRAD_PASSPORT_DEFAULT_LINETITLE_Y(4);
            w = (0.1000 * X_SCALE);
            h = GRAD_PASSPORT_LINE_H;

            text = "ДЕЙСТВУЕТ ДО";
            sizeEx = GRAD_PASSPORT_DEFAULT_TITLETEXTSIZE;

            colorText[] = {0,0,0,1};
        };
        class Expires: GVAR(RscText) {
            idc = GRAD_IDC_EXPIRES;

            x = GRAD_PASSPORT_DEFAULT_LEFTCOLUMN_X + GRAD_PASSPORT_DEFAULT_INDENT_X;
            y = GRAD_PASSPORT_DEFAULT_LINE_Y(4);
            w = GRAD_PASSPORT_CONTENT_W;
            h = GRAD_PASSPORT_LINE_H;

            colorText[] = {0,0,0,1};
        };
        class Serial: GVAR(RscText) {
            idc = GRAD_IDC_SERIAL;

            x = GRAD_PASSPORT_DEFAULT_LEFTCOLUMN_X;
            y = GRAD_PASSPORT_DEFAULT_LINE_Y(5);
            w = GRAD_PASSPORT_CONTENT_W;
            h = GRAD_PASSPORT_LINE_H;

            font = "EtelkaMonospacePro";
            sizeEx = 0.03 * TEXT_SCALE;
            colorText[] = {0,0,0,1};
        };
		class Visas: GVAR(RscCustomText) {
            idc = GRAD_IDC_MISC1;

            x = GRAD_PASSPORT_DEFAULT_RIGHTCOLUMN_X + GRAD_PASSPORT_DEFAULT_INDENT_X;
            y = GRAD_PASSPORT_DEFAULT_LINE_Y(-2.2);
            w = GRAD_PASSPORT_CONTENT_W;
            h = GRAD_PASSPORT_DEFAULT_H;
			
			size = 0.6 * TEXT_SCALE;
			
			font = "EtelkaMonospacePro";
            colorText[] = {0,0,0,1};
        };
		class Notes: GVAR(RscCustomText) {
            idc = GRAD_IDC_MISC2;

            x = GRAD_PASSPORT_DEFAULT_RIGHTCOLUMN_X + GRAD_PASSPORT_DEFAULT_INDENT_X;
            y = GRAD_PASSPORT_DEFAULT_LINE_Y(1);
            w = GRAD_PASSPORT_CONTENT_W;
            h = GRAD_PASSPORT_DEFAULT_H;
			size = 0.6 * TEXT_SCALE;
			font = "EtelkaMonospacePro";
            colorText[] = {0,0,0,1};
        };
    };
};

class passportMoldova: passportPDR {
    class ControlsBackground: ControlsBackground {
        class BGPic: BGPic {
            text = "node_modules\grad-passport\data\passport_moldova.paa";
        };
    };
};