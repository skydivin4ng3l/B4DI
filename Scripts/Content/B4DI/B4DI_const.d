/* Initialization */

const string B4DI_VERSION            = "Beyond 4rt Dynamic Interface v0.0.5";
const int    B4DI_LEGO_FLAGS         = LeGo_HookEngine       // For initializing all hooks
                                    | LeGo_FrameFunctions   // For projectile gravity
                                    | LeGo_ConsoleCommands  // For console commands and debugging
                                    | LeGo_Anim8
                                    | LeGo_Bars
                                    | LeGo_Gamestate
                                    | LeGo_Buffs
                                    | LeGo_Cursor
                                    /*| LeGo_Render*/
                                    | LeGo_Buttons
                                    | LeGo_PrintS;          // To be safe (in case it is used in critical hit event)

var   int    B4DI_Flags;                                     // Flags for initialization of B4DI
const int    B4DI_BARS             = 1<<0;                 	// xpBars.d 

const int    B4DI_ALL                = (1<<2) - 1;           // Initialize all features

const int    B4DI_INITIALIZED				= 0;                    // Indicator whether B4DI was initialized
const int 	 B4DI_BARS_FEATURES_INITIALISED		= 0;
const int 	 B4DI_BARS_INITIALIZED_ALWAYS	= 0;

//========================================
// _barPreview Options
//========================================

const int B4DI_BARPREVIEW_HAS_OWN_LABEL = 0;

const string B4DI_LABEL_FONT = "Font_old_10_white.tga";

//========================================
// interpretations of ini Setting
//========================================
const int B4DI_BarScale_off		= 100; // will not be used?
const int B4DI_BarScale_auto	= 100; // will not be used?
const int B4DI_BarScale_50		= 50; // 50 %
const int B4DI_BarScale_100		= 100; // 100%
const int B4DI_BarScale_150		= 150; // 150%
const int B4DI_BarScale_200		= 200; // 200%

//========================================
// FocusBar Options
//========================================
const int B4DI_FOCUSBAR_SHOW_ATT_FRIENDLY 	= 1;
const int B4DI_FOCUSBAR_SHOW_ATT_NEUTRAL 	= 1;
const int B4DI_FOCUSBAR_SHOW_ATT_ANGRY 		= 1;
const int B4DI_FOCUSBAR_SHOW_ATT_HOSTILE 	= 1;

const int B4DI_FOCUSBAR_SHOW_LABLE			= 1;



//========================================
// eBar CONST DONOT CHANGE
//========================================

const int B4DI_eBAR_INTITIAL_REFRESH 	= 0;
const int B4DI_eBAR_NO_REPLACEMENT 		= 0;

const int B4DI_eBar_ALPHA_SLIDER_RANGE_MIN = 0;
const int B4DI_eBar_ALPHA_SLIDER_RANGE = 255;
const int B4DI_MENU_SLIDER_ALPHA_STEPS = 8; //copy of Menu_Defines.d

const int B4DI_eBar_FADEIN_MAX = 255;
const int B4DI_eBar_FADEOUT_MIN = 0;

//========================================
// Margin (benutzt in AlignmentManager)
//========================================

const int B4DI_ALIGNMENT_MARGIN_USE_DEFAULT				= -1;
const int B4DI_ALIGNMENT_MARGIN_DEFAULT_VALUE			= 64;

const int B4DI_ALIGNMENT_SLOT_MARGIN_TOP				= 0;
const int B4DI_ALIGNMENT_SLOT_MARGIN_BOTTOM				= 1;
const int B4DI_ALIGNMENT_SLOT_MARGIN_LEFT				= 2;
const int B4DI_ALIGNMENT_SLOT_MARGIN_RIGHT				= 3;
const int B4DI_ALIGNMENT_SLOT_MARGIN_Y_BETWEENOBJECTS	= 4;

const int B4DI_ALIGNMENT_SLOT_MARGIN_ARRAY_SIZE			= 5;

//========================================
// Sizelimits (benutzt in AlignmentManager)
//========================================

const int B4DI_ALIGNMENT_SLOT_OBJECTSIZE_NO_LIMIT  	= -1;

const int B4DI_NUM_OF_AXIS = 2;

//========================================
// Aligment Slot Index to Lists (benutzt in AlignmentManager) This should mirror the Anchors of Bars
//========================================
const int B4DI_ALIGNMENT_USE_ANCHOR			= -1; //usable to add Object to suitable Slot based on its anchorpoint

const int B4DI_ALIGNMENT_LEFT_TOP			= 0; //Default
const int B4DI_ALIGNMENT_LEFT_BOTTOM		= 1;
const int B4DI_ALIGNMENT_RIGHT_TOP			= 2;
const int B4DI_ALIGNMENT_RIGHT_BOTTOM		= 3;
const int B4DI_ALIGNMENT_CENTER				= 4;
const int B4DI_ALIGNMENT_CENTER_TOP			= 5;
const int B4DI_ALIGNMENT_CENTER_BOTTOM		= 6;
const int B4DI_ALIGNMENT_CENTER_LEFT		= 7;
const int B4DI_ALIGNMENT_CENTER_RIGHT		= 8;

const int B4DI_ALIGNMENT_SLOT_ARRAY_SIZE	= 9;


//========================================
// Animation Modes
//========================================

const int B4DI_PULSE_SIZE_CENTERED_XY 	= 0;
const int B4DI_PULSE_SIZE_CENTERED_X  	= 1;
const int B4DI_PULSE_SIZE_CENTERED_Y 	= 2;

//========================================
// Hooks
//========================================
const int oCNpc__OpenScreen_Status 				= 7592320;		// 0x73D980 // HookLen: 7
const int cGameManager__ApplySomeSettings_rtn 	= 4362866; 		// 0x429272 // HookLen: 6
// Kooked by Quickslots of lego wich is not implemented?
//const int oCNpc__OpenInventory 				= 7742032;		// 0x762250	// HookLen: 6
//const int oCNpc__CloseInventory 				= 7742480;		// 0x762410	// HookLen: 9
const int oCNpcInventory__Close					= 7389936;		// 0x70C2F0 //
const int oCNpcInventory__Open					= 7388944; // 0x0070BF10 // HookLen: 7

const int oCNpc__OpenSpellBook					= 7596432;		//0x73E990 // HookLen: 10
const int oCNpc__CloseSpellBook					= 7596512;		//0x73E9E0 // HookLen: 6
//const int oCNpc__EV_DrawWeapon                  = 7654416; 	//0x74CC10 Hook: Shields HookLen: 6
//const int oCNpc__EV_DrawWeapon1                 = 7656160; 	//0x74D2E0 Hook: Shields HookLen: 5
const int oCNpc__EV_DrawWeapon2                 = 7656832; 		//0x0074D580 // HookLen: 6
const int oCNpc__EV_ChooseWeapon                = 7661952; 		//0x0074E980 // HookLen: 6

//const int oCNpc__EV_RemoveWeapon                = 7658272; //0x74DB20 Hook: Shields // HookLen: 7
//const int oCNpc__EV_RemoveWeapon1               = 7660720; //0x74E4B0 Hook: Shields // HookLen: 7
const int oCNpc__EV_RemoveWeapon2				= 7661104; //0x74E630 // HookLen: 6

//const int CGameManager__HandleCancelKey    		= 4368128; //0x0042A700	// HookLen:	7 // not idea
//const int zCMenuItemInput__HasBeenCanceled		= 5107168; //0x004DEDE0	// HookLen: 6 // no idea
const int oCItemContainer__Close				= 7376688; //0x00708F30	// HookLen:	7 //seems also be used by AI_Removed NPC
const int oCMobContainer__Close					= 7497280; //0x00726640	// HookLen:	6
//virtual void __thiscall oCMobContainer::Open(oCNpc *)  	0x00726500	0	6
const int oCNpc__CloseDeadNpc					= 7744320; //0x00762B40	// HookLen:	5
//void __thiscall oCNpc::OpenDeadNpc(void)     	0x00762970	0	6

//oCItem * __fastcall oCViewDialogInventory::GetSelectedItem(void)   	0x00689110	0	6
const int oCViewDialogInventory__GetSelectedItem = 6852880;   	//0x00689110	// HookLen:	6
//virtual oCItem * __thiscall oCItemContainer::GetSelectedItem(void)   	0x007092C0	0	5
const int oCItemContainer__GetSelectedItem		 = 7377600;   	//0x007092C0	// HookLen:	5
//oCItem * __thiscall oCNpcInventory::GetItem(int)       	0x0070C450	0	6
const int oCNpcInventory__GetItem				 = 7390288;       	//0x0070C450	// HookLen:	6

//oCItem * __thiscall oCNpc::GetFromInv(int int) 	0x00749180	0	10
const int oCNpc__GetFromInv						= 7639424; 	//0x00749180	// HookLen:	10

//virtual void __thiscall oCNpc::SetWeaponMode(int)     	0x00739940	0	5
const int oCNpc__SetWeaponMode					= 7575872;     	//0x00739940	// HookLen:	5
const int oCNpc__SetWeaponMode_custom_branch1	= 7575981;     	//0x007399AD	// HookLen:	5 //sheath all weapons directly and indirectly
const int oCNpc__SetWeaponMode_custom_branch2	= 7576043;     	//0x007399EB	// HookLen:	5 //draw magic
const int oCNpc__SetWeaponMode_custom_branch3	= 7576106;     	//0x00739A2A	// HookLen:	5 //broken hook or uncommon case

const int oCNpc__SetWeaponMode_Ninja			= 7575921;				//0x739971 //HookLen: 6


//virtual void __thiscall oCNpc::SetWeaponMode2(int)    	0x00738E80	0	6
const int oCNpc__SetWeaponMode2					= 7573120;    	//0x00738E80	// HookLen:	6
//void __thiscall oCNpc::SetWeaponMode2(zSTRING const &)  	0x00738C60	0	7
const int oCNpc__SetWeaponMode2__zSTRING		= 7572576;  	//0x00738C60	// HookLen:	7

//void __thiscall oCNpc::OnDamage_Hit(oCNpc::oSDamageDescriptor &)    	0x00666610	0	7
const int oCNpc__OnDamage_Hit    				= 6710800;				//0x00666610	// HookLen:	7
//void __thiscall oCNpc::OnDamage_Hit custom (oCNpc::oSDamageDescriptor &)    	0x66CAC7 	0	5
const int oCNpc__OnDamage_Hit_custom			= 6736583;				//0x66CAC7	// HookLen:	5
//void __thiscall oCNpc::OnDamage_Hit custom (oCNpc::oSDamageDescriptor &)    	066CF25  	0	6
const int oCNpc__OnDamage_Hit_return			= 6737701;				//0x066CF25 	// HookLen:	6

//int __thiscall oCNpc::UseItem(oCItem *) 	0x0073BC10	0	7

const int oCGame__UpdatePlayerStatus                = 7093113; //0x6C3B79 //HookLen: 8 Hook: Focusnames

const int oCGame__UpdatePlayerStatus_focusbar = 7091981; //0x6C370D //HookLen: 6
const int oCGame__UpdatePlayerStatus_manaBar =7091233; //0x006C3421 //HookLen: 6
//0x6C3B79 //HookLen: 8 //Ninja Focus Names
const int oCGame__UpdatePlayerStatus_return = 7093239;//0x006C3BF7 // HookLen: 7

//Dialog
const int oCNpc__ActivateDialogCam = 7700784; //0x00758130 // HookLen: 6
const int oCNpc__DeactivateDialogCam = 7701344;	//0x00758360 // HookLen: 6

//Spell
const int oCNpc__ReadySpell = 6816480; //0x006802E0 // HookLen: 7
const int oCNpc__UnreadySpell = 6816896; // 0x00680480 // HookLen: 7

//const int oCSpell__Cast = ;	//
const int oCSpell__Cast_return = 4740356;	//0x00485504 // HookLen: 7



