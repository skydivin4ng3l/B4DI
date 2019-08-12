// *********************************************************************
// game options menu
// *********************************************************************

INSTANCE MENU_GAME_OPT_B4DI(C_MENU_DEF) 
{
	backpic			= MENU_BACK_PIC;
	
	items[0]		= "MENUITEM_B4DI_HEADLINE";
				
	items[1]		= "MENUITEM_B4DI_SCALE";
	items[2]		= "MENUITEM_B4DI_SCALE_CHOICE";
	
				
	items[3]		= "MENUITEM_OPT_B4DI_BACK";
	
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
	posx		=	1000;	posy		=	MENU_START_Y + MENU_SOUND_DY*0;
	dimx		=	4000;	dimy		=	750;
	// Aktionen
	onSelAction[0]	= SEL_ACTION_UNDEF;
	// Weitere Eigenschaften
	flags			= flags | IT_EFFECTS_NEXT;
};

instance MENUITEM_B4DI_SCALE_CHOICE(C_MENU_ITEM_DEF)
{
	backPic		=	MENU_CHOICE_BACK_PIC;
	type		=	MENU_ITEM_CHOICEBOX;		
	text[0]		= 	"off|auto|50%|100%|150%";
	fontName	=   MENU_FONT_SMALL;
	// Position und Dimension	
	posx		= 5000;		posy		=	MENU_START_Y + MENU_SOUND_DY*0 + MENU_CHOICE_YPLUS;
	dimx = MENU_SLIDER_DX;	dimy 		= 	MENU_CHOICE_DY;
	// Aktionen
	onChgSetOption						= "B4DI_barScale";
	onChgSetOptionSection 				= "B4DI";
	// Weitere Eigenschaften
	flags		= flags & ~IT_SELECTABLE;	
	flags		= flags  | IT_TXT_CENTER;
};

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
