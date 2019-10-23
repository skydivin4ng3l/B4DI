/***********************************\
        B4DI Option Getters
\***********************************/

//all functions reading B4DI_ dedicaded ini options
func void B4DI_OptionGetters_InitOnce() {

     MEM_Info("Initializing entries in Gothic.ini.");

    if (!MEM_GothOptExists("B4DI", "B4DI_barScale")) {
        // Add INI-entry, if not set
        MEM_SetGothOpt("B4DI", "B4DI_barScale", "1");
    };

    if (!MEM_GothOptExists("B4DI", "B4DI_barShowLabel")) {
        // Add INI-entry, if not set
        MEM_SetGothOpt("B4DI", "B4DI_barShowLabel", "0");
    };

    if (!MEM_GothOptExists("B4DI", "B4DI_barFadeOutMin")) {
        // Add INI-entry, if not set
        MEM_SetGothOpt("B4DI", "B4DI_barFadeOutMin", "0.0");
    };

    if (!MEM_GothOptExists("B4DI", "B4DI_barFadeInMax")) {
        // Add INI-entry, if not set
        MEM_SetGothOpt("B4DI", "B4DI_barFadeInMax", "1.0");
    };

    //TODO Think about always disable on startup
    if (!MEM_GothOptExists("B4DI", "B4DI_enableEditUIMode")) {
        MEM_SetGothOpt("B4DI", "B4DI_enableEditUIMode", "0");
    };
};

//========================================
// [intern] Helper Scales depenting on Resolution
//========================================
var int B4DI_BarScale[6];
func void B4DI_InitBarScale(){
    Print_GetScreenSize();
    B4DI_BarScale[0]= B4DI_BarScale_off;
    // auto scale inspired by systempack.ini
    B4DI_BarScale[1]= roundf( mulf( mkf(100) ,fracf( Print_Screen[PS_Y] ,512 ) ) );
    B4DI_BarScale[2]= B4DI_BarScale_50;
    B4DI_BarScale[3]= B4DI_BarScale_100;
    B4DI_BarScale[4]= B4DI_BarScale_150;
    B4DI_BarScale[5]= B4DI_BarScale_200;
};

//========================================
// [Intern] Get Dynamic Scale according of Menu value (gothic.ini) asFloat
//
//========================================
func int B4DI_Bars_getDynamicScaleOptionValuef(){
    B4DI_InitBarScale();
    var int scaleOption; scaleOption = STR_ToInt(MEM_GetGothOpt("B4DI", "B4DI_barScale"));
    var int scalingFactor; //scalingFactor = B4DI_BarScale_auto; //Default
    MEM_Info( ConcatStrings( "Bar scaleOption = ", IntToString( scaleOption ) ) );
    if(!scaleOption) {
        MEM_Error("Bar Scale Option not set using Default Auto instead!");
        scalingFactor = MEM_ReadStatArr(B4DI_BarScale,1);
        MEM_Info( ConcatStrings( "Bar Scalingfactor = ", IntToString(scalingFactor) ) );
    } else{
        scalingFactor = MEM_ReadStatArr(B4DI_BarScale,scaleOption);
        MEM_Info( ConcatStrings( "Bar Scalingfactor = ", IntToString(scalingFactor) ) );
    };

    var int percScalingFactor; percScalingFactor = fracf( scalingFactor, 100 );
    MEM_Info( ConcatStrings( "percScalingFactor = ", toStringf(percScalingFactor) ) );

    return percScalingFactor;
};

//========================================
// [Intern] Get EditUIMode Option 1=ON, 0=OFF 
//          ON will provoke a separate "GameState"
//========================================
func int B4DI_getEnableEditUIModeOptionValue() {
    B4DI_enableEditUIMode = STR_ToInt(MEM_GetGothOpt("B4DI", "B4DI_enableEditUIMode"));
    B4DI_Info1("B4DI_getEnableEditUIModeOptionValue: ", B4DI_enableEditUIMode );
    return B4DI_enableEditUIMode;
};

//========================================
// [Intern] Get Label Option 1=ON, 0=OFF, unless inventory / XP-Bar
//
//========================================
func int B4DI_Bars_getbarShowLabelOptionValue(){
    B4DI_barShowLabel = STR_ToInt(MEM_GetGothOpt("B4DI", "B4DI_barShowLabel"));
    B4DI_Info1("B4DI_Bars_getbarShowLabelOptionValue: ", B4DI_barShowLabel );
    return B4DI_barShowLabel;
};


//========================================
// [Intern] Get FadeOut Min Value of Menu value (gothic.ini) 
//
//========================================
func int B4DI_Bars_getFadeOutMinOptionValue(){
	var int fadeOutMinOption; fadeOutMinOption = B4DI_GetGothOptSlider( "B4DI", "B4DI_barFadeOutMin", B4DI_eBar_ALPHA_SLIDER_RANGE, B4DI_eBar_ALPHA_SLIDER_RANGE_MIN, B4DI_eBar_FADEOUT_MIN);

    //B4DI_Info1( "Bar fadeOutMinOption = ", fadeOutMinOption );
    B4DI_barFadeOutMin = fadeOutMinOption;

    return fadeOutMinOption;
};

//========================================
// [Intern] Get FadeIn Max Value of Menu value (gothic.ini)
//
//========================================
func int B4DI_Bars_getFadeInMaxOptionValuef(){
    //var int fadeInMaxOption; fadeInMaxOption = MEM_GetGothOptSlider( "B4DI", "B4DI_barFadeInMax", B4DI_eBar_ALPHA_SLIDER_RANGE );
    var int fadeInMaxOption; fadeInMaxOption = B4DI_GetGothOptSlider( "B4DI", "B4DI_barFadeInMax", B4DI_eBar_ALPHA_SLIDER_RANGE, B4DI_eBar_ALPHA_SLIDER_RANGE_MIN, B4DI_eBar_FADEIN_MAX);

    B4DI_Info1( "Bar fadeInMaxOption = ", fadeInMaxOption );

    //if( B4DI_eBar_ALPHA_SLIDER_RANGE_MIN <= fadeInMaxOption && fadeInMaxOption <= B4DI_eBar_ALPHA_SLIDER_RANGE ) {
    	if ( fadeInMaxOption < B4DI_barFadeOutMin ) {
    		fadeInMaxOption = B4DI_barFadeOutMin;
    		MEM_SetGothOpt("B4DI", "B4DI_barFadeInMax", MEM_GetGothOpt("B4DI", "B4DI_barFadeOutMin") );
    	};
    //} else {
    //	fadeInMaxOption = B4DI_eBar_ALPHA_SLIDER_RANGE;
    //	MEM_SetGothOpt("B4DI", "B4DI_barFadeInMax", toStringf(B4DI_eBar_FADEIN_MAX_INI_DEFAULT) );
    //};

    B4DI_barFadeInMax = fadeInMaxOption;

    return fadeInMaxOption;
};

