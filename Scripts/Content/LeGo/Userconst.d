/***********************************\
              READ-ONLY
\***********************************/
// Folgende Konstanten dürfen NICHT verändert, nur verwendet werden.

//========================================
// Anim8
//========================================
// Bewegungsformen
const int A8_Constant  = 1;
const int A8_SlowEnd   = 2;
const int A8_SlowStart = 3;
const int A8_Wait      = 4;

//========================================
// Buttons
//========================================
const int BUTTON_ACTIVE = 1;
const int BUTTON_ENTERED = 2;

//========================================
// Aligns (benutzt in View)
//========================================
const int ALIGN_CENTER = 0;
const int ALIGN_LEFT   = 1;
const int ALIGN_RIGHT  = 2;
const int ALIGN_TOP    = 3;
const int ALIGN_BOTTOM = 4;


//========================================
// Anchor (benutzt in View) anchorPoint_mode
//========================================
const int ANCHOR_USE_OBJECTS_ANCHOR	= -1;

const int ANCHOR_LEFT_TOP			= 0; //Default
const int ANCHOR_LEFT_BOTTOM		= 1;
const int ANCHOR_RIGHT_TOP			= 2;
const int ANCHOR_RIGHT_BOTTOM		= 3;
const int ANCHOR_CENTER				= 4;
const int ANCHOR_CENTER_TOP			= 5;
const int ANCHOR_CENTER_BOTTOM		= 6;
const int ANCHOR_CENTER_LEFT		= 7;
const int ANCHOR_CENTER_RIGHT		= 8;

//========================================
// ValidScreenSpace (benutzt in View)
//========================================
const int NON_VALIDSCREENSPACE	= 0;
const int VALIDSCREENSPACE   	= 1;

//========================================
// Size_LIMIT (benutzt in View)
//========================================
const int VIEW_NO_SIZE_LIMIT		= -1;

//========================================
// PercentagedScaling Modes (benutzt in Bars)
//========================================
const int SCALING_ABSOLUTE		= 0;
const int SCALING_RELATIVE  	= 1;

//========================================
// Interface
//========================================
//                        R           G          B          A           R G B
const int COL_Aqua    =             (255<<8) | (255<<0) | (255<<24); //#00FFFF
const int COL_Black   =                                   (255<<24); //#000000
const int COL_Blue    =                        (255<<0) | (255<<24); //#0000FF
const int COL_Fuchsia = (255<<16) |            (255<<0) | (255<<24); //#FF00FF
const int COL_Gray    = (128<<16) | (128<<8) | (128<<0) | (255<<24); //#808080
const int COL_Green   =             (128<<8) |            (255<<24); //#008000
const int COL_Lime    =             (255<<8) |            (255<<24); //#00FF00
const int COL_Maroon  = (128<<16) |                       (255<<24); //#800000
const int COL_Navy    =                        (128<<0) | (255<<24); //#000080
const int COL_Olive   = (128<<16) | (128<<8) |            (255<<24); //#808000
const int COL_Purple  = (128<<16) |            (128<<0) | (255<<24); //#800080
const int COL_Red     = (255<<16) |                       (255<<24); //#FF0000
const int COL_Silver  = (192<<16) | (192<<8) | (192<<0) | (255<<24); //#C0C0C0
const int COL_Teal    =             (128<<8) | (128<<0) | (255<<24); //#008080
const int COL_White   = (255<<16) | (255<<8) | (255<<0) | (255<<24); //#FFFFFF
const int COL_Yellow  = (255<<16) | (255<<8) |            (255<<24); //#FFFF00

const int PS_X = 0;
const int PS_Y = 1;

const int PS_VMax = 8192;

//========================================
// Bars (Extened)
//========================================
//for refresh of current set value/Max
const int BAR_REFRESH_NO_CHANGE = -1;
const int BAR_SIZE_LOCK_X_AXIS = -1;
const int BAR_SIZE_LOCK_Y_AXIS = -1;

//Access for initialDynamicVSize Array
const int IDS_VBACK_X = 0;
const int IDS_VBACK_Y = 1;
const int IDS_VBAR_X = 2;
const int IDS_VBAR_Y = 3;

//Access for initialVPosition Array
const int IP_VBACK_CENTER_X	= 0;
const int IP_VBACK_CENTER_Y	= 1;
const int IP_VBAR_CENTER_X	= 2;
const int IP_VBAR_CENTER_Y	= 3;
const int IP_VBACK_LEFT		= 4;
//const int IP_VBACK_RIGHT	= 5;
const int IP_VBACK_TOP		= 6;
//const int IP_VBACK_BOTTOM	= 7;
const int IP_VBAR_LEFT		= 8;
//const int IP_VBAR_RIGHT		= 9;
const int IP_VBAR_TOP		= 10;
//const int IP_VBAR_BOTTOM	= 11;

//// interpretations of ini Setting
//const int B4DI_BarScale_off		= 100; // will not be used?
//const int B4DI_BarScale_auto	= 100; // will not be used?
//const int B4DI_BarScale_50		= 50; // 50 %
//const int B4DI_BarScale_100		= 100; // 100%
//const int B4DI_BarScale_150		= 150; // 150%
//const int B4DI_BarScale_200		= 200; // 200%


//========================================
// Gamestate
//========================================
const int Gamestate_NewGame     = 0;
const int Gamestate_Loaded      = 1;
const int Gamestate_WorldChange = 2;
const int Gamestate_Saving      = 3;

//========================================
// Cursor
//========================================
const int CUR_LeftClick  = 0;
const int CUR_RightClick = 1;
const int CUR_MidClick   = 2;
const int CUR_WheelUp    = 3;
const int CUR_WheelDown  = 4;


/***********************************\
               MODIFY
\***********************************/
// Folgende Konstanten dienen nicht als Parameter sondern als Vorgaben.
// Sie dürfen frei verändert werden.

//========================================
// Bloodsplats
//========================================
const int BLOODSPLAT_NUM = 15; // Maximale Anzahl auf dem Screen
const int BLOODSPLAT_TEX = 6;  // Maximale Anzahl an Texturen ( "BLOODSPLAT" + texID + ".TGA" )
const int BLOODSPLAT_DAM = 7;  // Schadensmultiplikator bzgl. der Texturgröße ( damage * 2^BLOODSPLAT_DAM )

//========================================
// Cursor
//========================================
const string Cursor_Texture   = "CURSOR.TGA"; // Genutzte Textur, LeGo stellt eine "CURSOR.TGA" bereit

//========================================
// Buffs
//========================================
const int Buffs_DisplayForHero = 1;

//========================================
// Interface
//========================================
const string Print_LineSeperator = "~"; // Sollte man lieber nicht ändern

/* ==== PrintS ==== */
// <<Virtuelle Positionen>>
const int    PF_PrintX      = 200;     // Startposition X
const int    PF_PrintY      = 5000;    // Startposition Y
const int    PF_TextHeight  = 170;     // Abstand zwischen einzelnen Zeilen

// <<Milisekunden>>
const int    PF_FadeInTime  = 300;     // Zeit zum einblenden der Textzeilen
const int    PF_FadeOutTime = 1000;    // Zeit zum ausblenden der Textzeilen
const int    PF_MoveYTime   = 300;     // Zeit zum verschieben einer Zeile
const int    PF_WaitTime    = 3000;    // Zeit die gewartet wird, bis wieder ausgeblendet wird

const string PF_Font        = "FONT_OLD_10_WHITE.TGA"; //Verwendete Schriftart

//========================================
// Talents
//========================================
const int AIV_TALENT = AIV_TALENT_INDEX; // Genutzte AI-Var

//========================================
// Dialoggestures
//========================================
// Die abgespielte Animation kann so beschrieben werden:
//   DIAG_Prefix + AniName + DIAG_Suffix + ((rand() % (Max - (Min - 1))) + Min).ToString("00");
const string DIAG_Prefix = "DG_";
const string DIAG_Suffix = "_";

//========================================
// Buffs
//========================================
const int Buff_FadeOut = 1; // Deactivate fade-out by setting this to 0

