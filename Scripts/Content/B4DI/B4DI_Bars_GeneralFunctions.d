//#################################################################
//
//  General Functions
//
//#################################################################

//TODO Depricated -> migrate XP-Bar
//func void B4DI_Bar_fadeOut(var int bar_hndl, var int deleteBar) {
//	var _bar bar_inst; bar_inst = get(bar_hndl);
//	bar_inst.anim8FadeOut = Anim8_NewExt(255, Bar_SetAlpha, bar_hndl, false);
//	Anim8_RemoveIfEmpty(bar_inst.anim8FadeOut, true);
//	if (deleteBar) {
//		Anim8_RemoveDataIfEmpty(bar_inst.anim8FadeOut, true);
//	} else {
//		Anim8_RemoveDataIfEmpty(bar_inst.anim8FadeOut, false);
//	};
	
//	Anim8(bar_inst.anim8FadeOut, 255,  5000, A8_Wait);
//	Anim8q(bar_inst.anim8FadeOut,   0, 2000, A8_SlowEnd);

//};
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

//for now only integer exponents
func int powf(var int basef, var int exponent ) {
	if( lef(basef,FLOATNULL) && gef(basef,FLOATNULL)  && exponent == 0) {
		MEM_Warn("pow: basef can not be ZERO when exponent is also ZERO");
		return FLOATNULL;
	};
	if(exponent == 0) {return FLOATEINS;};
	var int result; result = basef;
	var int power; power = 1;
	while(power < abs(exponent));
		result = mulf(result,basef);
		power += 1;
	end;
	if(exponent < 0) {
		result = divf( FLOATEINS, result );
	};

	return result;

};

func int pow(var int base, var int exponent) {
	return roundf(powf(mkf(base), exponent));
};

func int STR_ToIntf( var string intFString ) {
	//B4DI_Info1("STR_ToIntf: SplitCount: ", STR_SplitCount(intFString, decimalPoint) );
	var int resultf;
	var int preDecimalf;
	if( STR_Len(intFString) > 1 && STR_IndexOf(intFString, decimalPoint) >= 1 ) {
		//var string preDecimalS; preDecimalS = STR_Split(intFString, decimalPoint, 0);
		//B4DI_debugSpy("STR_ToIntf: WITH preDecimalS ", preDecimalS );

		preDecimalf = mkf( STR_ToInt( STR_Split( intFString, decimalPoint, 0 ) ) );
		//B4DI_debugSpy("STR_ToIntf: WITH preDecimalf ", toStringf(preDecimalf) );


		var string decimalS; decimalS = STR_Split(intFString, decimalPoint, 1);
		//B4DI_debugSpy("STR_ToIntf: WITH decimalS ", decimalS );

		var int decimalLenght; decimalLenght = STR_Len(decimalS);
		//B4DI_Info1("STR_ToIntf: decimalLenght= ", decimalLenght);

		var int decimalf; decimalf = fracf( STR_ToInt(decimalS), pow( 10, decimalLenght ) );
		//B4DI_debugSpy("STR_ToIntf: WITH decimalf ", toStringf(decimalf) );

		resultf = addf(preDecimalf, decimalf);		
		//B4DI_debugSpy("STR_ToIntf: WITH decimalPoint ", toStringf(resultf) );
	} else {
		preDecimalf = mkf( STR_ToInt( STR_Split( intFString, decimalPoint, 0 ) ) );
		resultf = preDecimalf;
		//B4DI_debugSpy("STR_ToIntf: no decimalPoint ", toStringf(resultf) );
	};

	return resultf;

};

//func float STR_ToFloat( var string floatString ) {
//	var float result; result = castFromIntf(STR_ToIntf(floatString));

//	return result;

//};

func int MEM_GetGothOptSliderf(var string sectionname, var string optionname, var int actualValueRange ) {
	//B4DI_debugSpy("MEM_GetGothOptSliderf: optionString", MEM_GetGothOpt(sectionname, optionname) );
	var int optionValuef; optionValuef = STR_ToIntf( MEM_GetGothOpt(sectionname, optionname) );
	//B4DI_debugSpy("MEM_GetGothOptSliderf: optionValuef", toStringf(optionValuef) );
	var int resultf; resultf = mulf( mkf(actualValueRange), optionValuef);
	//B4DI_debugSpy("MEM_GetGothOptSliderf: resultf", toStringf(resultf) );
	
	return resultf;
};

func int MEM_GetGothOptSlider(var string sectionname, var string optionname, var int actualValueRange ) {
		return roundf( MEM_GetGothOptSliderf( sectionname, optionname, actualValueRange, sliderSteps ) );
};

//========================================
// [Intern] Get FadeOut Min Value of Menu value (gothic.ini) asFloat
//
//========================================
func int B4DI_Bars_getFadeOutMinOptionValuef(){
	var int fadeOutMinOption; fadeOutMinOption = MEM_GetGothOptSlider( "B4DI", "B4DI_barFadeOutMin", B4DI_eBar_ALPHA_SLIDER_RANGE, B4DI_MENU_SLIDER_ALPHA_STEPS );

    B4DI_Info1( "Bar fadeOutMinOption = ", fadeOutMinOption );
    B4DI_barFadeOutMin = fadeOutMinOption;

    return fadeOutMinOption;
};

//========================================
// [Intern] Get FadeIn Max Value of Menu value (gothic.ini) asFloat
//
//========================================
func int B4DI_Bars_getFadeInMaxOptionValuef(){
    var int fadeInMaxOption; fadeInMaxOption = MEM_GetGothOptSlider( "B4DI", "B4DI_barFadeInMax", B4DI_eBar_ALPHA_SLIDER_RANGE, B4DI_MENU_SLIDER_ALPHA_STEPS );

    B4DI_Info1( "Bar fadeInMaxOption = ", fadeInMaxOption );

    if( B4DI_barFadeOutMin > fadeInMaxOption ) {
    	fadeInMaxOption = B4DI_barFadeOutMin;
    	B4DI_barFadeInMax = fadeInMaxOption;
    	fadeInMaxOption = divf( fracf( B4DI_eBar_ALPHA_SLIDER_RANGE, fadeInMaxOption ), B4DI_MENU_SLIDER_ALPHA_STEPS );
    	MEM_SetGothOpt("B4DI", "B4DI_barFadeInMax", toStringf(fadeInMaxOption) );
    };

    B4DI_barFadeInMax = fadeInMaxOption;

    return fadeInMaxOption;
};

//========================================
// [Intern] Fill the instance oHero(oCNpc);
//
//========================================
func void B4DI_heroInstance_InitAlways() {
	var int oCNpc_hero_ptr; oCNpc_hero_ptr = MEM_InstToPtr(oHero);
	if(!Hlp_Is_oCNpc( oCNpc_hero_ptr ) ) {
		var int hero_ptr; hero_ptr = MEM_InstToPtr(hero);
	  	oHero = MEM_PtrToInst(hero_ptr);
	};
	
};

func void B4DI_Bar_pulse_size(var int bar_hndl, var func pulseFunc) {
	var int a8_Bar_pulse; a8_Bar_pulse = Anim8_NewExt(100 , pulseFunc, bar_hndl, false); //height input
	Anim8_RemoveIfEmpty(a8_Bar_pulse, true);
	Anim8_RemoveDataIfEmpty(a8_Bar_pulse, true);
	
	Anim8 (a8_Bar_pulse, 100,  100, A8_Wait);
	Anim8q(a8_Bar_pulse, 150, 200, A8_SlowEnd);
	Anim8q(a8_Bar_pulse, 100, 100, A8_SlowStart);

};

func void B4DI_originalBar_hide( var int obar_ptr){
	var oCViewStatusBar bar_inst; bar_inst = MEM_PtrToInst(obar_ptr);
	bar_inst.zCView_alpha = 0; //backView
	ViewPtr_SetAlpha(bar_inst.range_bar, 0); //middleView
	ViewPtr_SetAlpha(bar_inst.value_bar, 0);	//barView
};






