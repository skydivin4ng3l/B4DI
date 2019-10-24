// *********************************************************************
// game options menu
// *********************************************************************

INSTANCE MENU_GAME_OPT_B4DI(C_MENU_DEF) 
{
	backpic			= MENU_BACK_PIC;
	
	items[0]		= "MENUITEM_B4DI_HEADLINE";
				
	items[1]		= "MENUITEM_B4DI_SCALE";
	items[2]		= "MENUITEM_B4DI_SCALE_CHOICE";

	items[3]		= "MENUITEM_B4DI_LABEL";
	items[4]		= "MENUITEM_B4DI_LABEL_CHOICE";

	items[5]		= "MENUITEM_B4DI_BAR_FADEIN_MAX";
	items[6]		= "MENUITEM_B4DI_BAR_FADEIN_MAX_SLIDER";

	items[7]		= "MENUITEM_B4DI_BAR_FADEOUT_MIN";
	items[8]		= "MENUITEM_B4DI_BAR_FADEOUT_MIN_SLIDER";

	items[9]		= "MENUITEM_B4DI_EDITUI";
	items[10]		= "MENUITEM_B4DI_EDITUI_CHOICE";
				
	items[11]		= "MENUITEM_OPT_B4DI_BACK";
	
	flags = flags | MENU_SHOW_INFO;
};


INSTANCE MENUITEM_B4DI_HEADLINE(C_MENU_ITEM_DEF) 
{
	text[0]		=	"Dynamic HUD Settings";
	type		=	MENU_ITEM_TEXT;
	// Position und Dimension	
	posx		=	0;		posy		=	MENU_TITLE_Y;
	dimx		=	8100;
	
	flags		= flags & ~IT_SELECTABLE;
	flags		= flags | IT_TXT_CENTER;	
};


//
// Bar Scale
//

INSTANCE MENUITEM_B4DI_SCALE(C_MENU_ITEM_DEF)
{
	backpic		=	MENU_ITEM_BACK_PIC;
	text[0]		=	"Bar Scale";
	text[1]		= 	"Size of the Bars."; // Kommentar
	// Position und Dimension	
	posx		=	1000;	posy		=	MENU_START_Y + MENU_DY*0;
	dimx		=	4000;	dimy		=	600;
	// Aktionen
	onSelAction[0]	= SEL_ACTION_UNDEF;
	// Weitere Eigenschaften
	flags			= flags | IT_EFFECTS_NEXT;
};

instance MENUITEM_B4DI_SCALE_CHOICE(C_MENU_ITEM_DEF)
{
	backPic		=	MENU_CHOICE_BACK_PIC;
	type		=	MENU_ITEM_CHOICEBOX;		
	text[0]		= 	"off|auto|50%|100%|150% | 200%";
	fontName	=   MENU_FONT_SMALL;
	// Position und Dimension	
	posx		= 5000;		posy		=	MENU_START_Y + MENU_DY*0 + MENU_CHOICE_YPLUS;
	dimx = MENU_CHOICE_DX;	dimy 		= 	MENU_CHOICE_DY;
	// Aktionen
	onChgSetOption						= "B4DI_barScale";
	onChgSetOptionSection 				= "B4DI";
	// Weitere Eigenschaften
	flags		= flags & ~IT_SELECTABLE;	
	flags		= flags  | IT_TXT_CENTER;
};

//
// Bar Label
//

INSTANCE MENUITEM_B4DI_LABEL(C_MENU_ITEM_DEF)
{
	backpic		=	MENU_ITEM_BACK_PIC;
	text[0]		=	"Bar Labels";
	text[1]		= 	"Toggle the Labels of the Bars."; // Kommentar
	// Position und Dimension	
	posx		=	1000;	posy		=	MENU_START_Y + MENU_DY*1;
	dimx		=	4000;	dimy		=	600;
	// Aktionen
	onSelAction[0]	= SEL_ACTION_UNDEF;
	// Weitere Eigenschaften
	flags			= flags | IT_EFFECTS_NEXT;
};

instance MENUITEM_B4DI_LABEL_CHOICE(C_MENU_ITEM_DEF)
{
	backPic		=	MENU_CHOICE_BACK_PIC;
	type		=	MENU_ITEM_CHOICEBOX;		
	text[0]		= 	"off|on";
	fontName	=   MENU_FONT_SMALL;
	// Position und Dimension	
	posx		= 5000;		posy		=	MENU_START_Y + MENU_DY*1 + MENU_CHOICE_YPLUS;
	dimx = MENU_CHOICE_DX;	dimy 		= 	MENU_CHOICE_DY;
	// Aktionen
	onChgSetOption						= "B4DI_barShowLabel";
	onChgSetOptionSection 				= "B4DI";
	// Weitere Eigenschaften
	flags		= flags & ~IT_SELECTABLE;	
	flags		= flags  | IT_TXT_CENTER;
};

//
// Bar FadeIn Max
//

INSTANCE MENUITEM_B4DI_BAR_FADEIN_MAX(C_MENU_ITEM_DEF)
{
	backpic		=	MENU_ITEM_BACK_PIC;
	text[0]		=	"Bar Max. Visibility";
	text[1]		= 	"Always > Min Visibility."; // Kommentar
	// Position und Dimension	
	posx		=	1000;	posy		=	MENU_START_Y + MENU_DY*2;
	dimx		=	4000;	dimy		=	600;
	// Aktionen
	onSelAction[0]	= SEL_ACTION_UNDEF;
	// Weitere Eigenschaften
	flags			= flags | IT_EFFECTS_NEXT;
};

instance MENUITEM_B4DI_BAR_FADEIN_MAX_SLIDER(C_MENU_ITEM_DEF)
{
	backPic		=	MENU_SLIDER_BACK_PIC;
	type		=	MENU_ITEM_SLIDER;		
	fontName	=   MENU_FONT_SMALL;
	// Position und Dimension	
	posx		= 5000;		posy		=	MENU_START_Y + MENU_DY*2 + MENU_SLIDER_YPLUS;
	dimx = MENU_SLIDER_DX;	dimy 		= 	MENU_SLIDER_DY;
	// Aktionen
	onChgSetOption						= "B4DI_barFadeInMax";
	onChgSetOptionSection 				= "B4DI";
	// Weitere Eigenschaften
	userFloat[0]	= 8; //8 Slider-Steps
	userString[0]	= MENU_SLIDER_POS_PIC;

	flags		= flags & ~IT_SELECTABLE;	
};

//
// Bar Fadeout Min
//

INSTANCE MENUITEM_B4DI_BAR_FADEOUT_MIN(C_MENU_ITEM_DEF)
{
	backpic		=	MENU_ITEM_BACK_PIC;
	text[0]		=	"Bar Min. Visibility";
	text[1]		= 	"Minimum Visibility of the Bars."; // Kommentar
	// Position und Dimension	
	posx		=	1000;	posy		=	MENU_START_Y + MENU_DY*3;
	dimx		=	4000;	dimy		=	600;
	// Aktionen
	onSelAction[0]	= SEL_ACTION_UNDEF;
	// Weitere Eigenschaften
	flags			= flags | IT_EFFECTS_NEXT;
};

instance MENUITEM_B4DI_BAR_FADEOUT_MIN_SLIDER(C_MENU_ITEM_DEF)
{
	backPic		=	MENU_SLIDER_BACK_PIC;
	type		=	MENU_ITEM_SLIDER;		
	fontName	=   MENU_FONT_SMALL;
	// Position und Dimension	
	posx		= 5000;		posy		=	MENU_START_Y + MENU_DY*3 + MENU_SLIDER_YPLUS;
	dimx = MENU_SLIDER_DX;	dimy 		= 	MENU_SLIDER_DY;
	// Aktionen
	onChgSetOption						= "B4DI_barFadeOutMin";
	onChgSetOptionSection 				= "B4DI";
	// Weitere Eigenschaften
	userFloat[0]	= 8; //8 Slider-Steps
	userString[0]	= MENU_SLIDER_POS_PIC;

	flags		= flags & ~IT_SELECTABLE;	
};

//
// Bar Label
//

INSTANCE MENUITEM_B4DI_EDITUI(C_MENU_ITEM_DEF)
{
	backpic		=	MENU_ITEM_BACK_PIC;
	text[0]		=	"EditUI Mode";
	text[1]		= 	"Toggles interactive UI Editing."; // Kommentar
	// Position und Dimension	
	posx		=	1000;	posy		=	MENU_START_Y + MENU_DY*4;
	dimx		=	4000;	dimy		=	600;
	// Aktionen
	onSelAction[0]	= SEL_ACTION_UNDEF;
	// Weitere Eigenschaften
	flags			= flags | IT_EFFECTS_NEXT;
};

instance MENUITEM_B4DI_EDITUI_CHOICE(C_MENU_ITEM_DEF)
{
	backPic		=	MENU_CHOICE_BACK_PIC;
	type		=	MENU_ITEM_CHOICEBOX;		
	text[0]		= 	"off|on";
	fontName	=   MENU_FONT_SMALL;
	// Position und Dimension	
	posx		= 5000;		posy		=	MENU_START_Y + MENU_DY*4 + MENU_CHOICE_YPLUS;
	dimx = MENU_CHOICE_DX;	dimy 		= 	MENU_CHOICE_DY;
	// Aktionen
	onChgSetOption						= "B4DI_enableEditUIMode";
	onChgSetOptionSection 				= "B4DI";
	// Weitere Eigenschaften
	flags		= flags & ~IT_SELECTABLE;	
	flags		= flags  | IT_TXT_CENTER;
};

//========================================
// BACK
//========================================

INSTANCE MENUITEM_OPT_B4DI_BACK(C_MENU_ITEM_DEF)
{
	backpic		=	MENU_ITEM_BACK_PIC;
	text[0]		=	"Zurück";
	// Position und Dimension	
	posx		=	1000;		posy		=	MENU_BACK_Y;
	dimx		=	6192;		dimy		=	MENU_SOUND_DY;
	// Aktionen
	onSelAction[0]	= 	SEL_ACTION_BACK;

	flags			= flags | IT_TXT_CENTER;
};
