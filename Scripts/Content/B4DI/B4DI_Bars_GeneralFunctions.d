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
// B4DI_ArrayCreateExactSize
// 			MEM_ArrayCreate with Exact size and handle
//========================================
const int sizeOf_Int = 4;
func int B4DI_ArrayCreateExactSize( var int countToAlloc, var int bytesOfType ) {
	var int array_hndl;	array_hndl =  new(zCArray@);
    var zCArray array_inst; array_inst = get(array_hndl);
    array_inst.numInArray = countToAlloc;
    array_inst.numAlloc = countToAlloc;
    array_inst.array = MEM_Alloc(bytesOfType * countToAlloc);

    return array_hndl;
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

func int B4DI_Bars_getbarShowLabelOptionValue(){
	B4DI_barShowLabel = STR_ToInt(MEM_GetGothOpt("B4DI", "B4DI_barShowLabel"));
	B4DI_Info1("B4DI_Bars_getbarShowLabelOptionValue: ", B4DI_barShowLabel );
	return B4DI_barShowLabel;
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
		return roundf( MEM_GetGothOptSliderf( sectionname, optionname, actualValueRange ) );
};

func int B4DI_GetGothOptSlider( var string sectionname, var string optionname, var int actualValueRange, var int actualValueRangeMin, var int actualValueDefault ) {
    var int OptionValue; OptionValue = MEM_GetGothOptSlider( sectionname, optionname, actualValueRange );

    B4DI_Info1( cs3("B4DI_GetGothOptSlider: ", optionname, "= ") , OptionValue );

    if( !(actualValueRangeMin <= OptionValue && OptionValue <= actualValueRange) ) {
    	
    	OptionValue = actualValueDefault;
    	MEM_SetGothOpt( sectionname, optionname, toStringf( fracf( actualValueRange, actualValueDefault ) ) );
    };

    return OptionValue;
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

//========================================
// [hacky] Set LabelTop used in multiple dependening files
//
//========================================
func void B4DI_eBars_SetLabelTop(var int eBar_hndl) {
    var _extendedBar eBar; eBar = get(eBar_hndl);
    var _bar bar; bar = get(eBar.bar);
    var zCView vLabel; vLabel = View_Get(bar.vLabel);

    View_Top(bar.vLabel);
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






