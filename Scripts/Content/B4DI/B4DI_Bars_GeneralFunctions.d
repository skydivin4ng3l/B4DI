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






