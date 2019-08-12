/* Initialization */

const string B4DI_VERSION            = "Beyond 4rt Dynamic Interface v0.0.1";
const int    B4DI_LEGO_FLAGS         = LeGo_HookEngine       // For initializing all hooks
                                    | LeGo_FrameFunctions   // For projectile gravity
                                    | LeGo_ConsoleCommands  // For console commands and debugging
                                    | LeGo_Anim8
                                    | LeGo_Bars
                                    | LeGo_Gamestate
                                    | LeGo_Buffs
                                    | LeGo_PrintS;          // To be safe (in case it is used in critical hit event)

var   int    B4DI_Flags;                                     // Flags for initialization of B4DI
const int    B4DI_BARS             = 1<<0;                 	// xpBars.d 

const int    B4DI_ALL                = (1<<2) - 1;           // Initialize all features

const int    B4DI_INITIALIZED        = 0;                    // Indicator whether B4DI was initialized

/// Hooks

const int oCNpc__OpenScreen_Status = 7592320; // 0x73D980 // HookLen: 7


///// TODO Currently in LeGo userconst \\\\\

//const int B4DI_BarScale_off = 100; // will not be used?
//const int B4DI_BarScale_auto = 100; // will not be used?
//const int B4DI_BarScale_50 = 50; // 50 %
//const int B4DI_BarScale_100 = 100; // 100%
//const int B4DI_BarScale_150 = 150; // 150%

///// TODO Currently in LeGo userconst ^^^^^^
