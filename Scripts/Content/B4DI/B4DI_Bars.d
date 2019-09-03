//////
/// TODO move all changes in LeGo Classes here or at least seperate additions from vanilla LeGo

prototype B4DI_MyXpBar(Bar) {
	x = Print_Screen[PS_X] / 2;
	y = Print_Screen[PS_Y] -20;
	barTop = 3; // 6 Texture 4 good
	barLeft = 8; // 11/12 Texture 
	width = 192; // 256 texture
	height = 24; // 32 texture
	backTex = "Bar_Back.tga";
	barTex = "Bar_XP.tga";
	middleTex = "Bar_TempMax.tga";
	value = 100;
	valueMax = 100;
};

//////

instance B4DI_XpBar(B4DI_MyXpBar){
	//x = 10+128;
	//y = 20+16;
};

instance B4DI_HpBar(GothicBar){
	x = 128+90; //128 virtual should be margin left
	y = Print_Screen[PS_Y] -100;
	barTop = 2;		// 2 is almost too small
	barTex = "Bar_Health.tga";
};

//global vars
var int lastHeroHP;
var int lastHeroMaxHP;
var int dynScalingFactor; //float
////original Bars
instance MEM_oBar_Hp(oCViewStatusBar);
var int MEM_dBar_HP_handle;
instance MEM_dBar_HP(_bar);

//#################################################################
//
//  General Functions
//
//#################################################################
//========================================
// [intern] Helper Scales depenting on Resolution
//========================================
var int B4DI_BarScale[6];
func void B4DI_InitBarScale(){
    Print_GetScreenSize();
    B4DI_BarScale[0]= B4DI_BarScale_off;
    //TODO replace Auto const with Resolution based Scale
    //B4DI_BarScale[1]= B4DI_BarScale_auto;
    // auto scale inspired by systempack.ini
    B4DI_BarScale[1]= roundf( mulf( mkf(100) ,fracf( Print_Screen[PS_Y] ,512 ) ) );
    B4DI_BarScale[2]= B4DI_BarScale_50;
    B4DI_BarScale[3]= B4DI_BarScale_100;
    B4DI_BarScale[4]= B4DI_BarScale_150;
    B4DI_BarScale[5]= B4DI_BarScale_200;

    B4DI_debugSpy("B4DI_AutoScaleFactor: ", IntToString(roundf(mulf( 100 ,fracf( Print_Screen[PS_Y], 512) ) ) ) );
    B4DI_debugSpy("B4DI_AutoScaleFactorArray: ", toStringf(B4DI_BarScale[1]));
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

    var int dynScalingFactor; dynScalingFactor = fracf( scalingFactor, 100 );
    MEM_Info( ConcatStrings( "dynScalingFactor = ", toStringf(dynScalingFactor) ) );

    return dynScalingFactor;
};

//========================================
// [Intern] Resizes bars according of Menu value (gothic.ini)
//========================================
func void B4DI_Bar_dynamicMenuBasedScale(var int bar_hndl){
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    var _bar b; b = get(bar_hndl);
    
    var zCView vBack; vBack = View_Get(b.v0);
    var zCView vBar; vBar = View_Get(b.v1);

    var int dynScalingFactor; dynScalingFactor = B4DI_Bars_getDynamicScaleOptionValuef();

    Bar_ResizeCenteredPercentFromInitial(bar_hndl, dynScalingFactor);
    //TODO Implement different customizeable alignments, maybe per set margin within the Resize process

    // Keep Left aligned
    //compensate scaling difference of left and top offset
    //should not be needed for centered//View_MoveTo(b.v1, vBar.vposx- barLeftOffset , vBar.vposy-barTopOffset);

    ////---debug print
    
    var int s0;s0=SB_New();
    SB_Use(s0);
    SB("scaleFactor: "); SBi(roundf(dynScalingFactor));SB("  ");
    SB("dynScalingFactor: "); SB(toStringf(dynScalingFactor)); SB(" / ");
    SB("BACK: ");   SBi(vBack.psizex); SB(" , "); SBi(vBack.psizey); SB(" ");
    SB("BAR: ");   SBi(vBar.psizex); SB(" , "); SBi(vBar.psizey); SB(" ");
    SB("barW: "); SBi( Print_ToPixel( b.barW, PS_X ) );
    Print_ExtPxl(50,Print_Screen[PS_Y] / 2, SB_ToString(), FONT_Screen, RGBA(255,0,0,200),2500);
    SB_Destroy();
};

//========================================
// [Intern] Resizes actual bar according to percentage reltaive to center
//
//========================================
func void B4DI_Bar_SetBarSizeCenteredPercent(var int hndl, var int x_percentage, var int y_percentage ) { 
	Print_GetScreenSize();
	//------------------
	if(!Hlp_IsValidHandle(hndl)) { return; };
	var _bar b; b = get(hndl);
	var zCView v0_ptr; var zCView v1_ptr;
	
	/// Debug
	var int s0;s0=SB_New();
	SB_Use(s0);
	/// ^^

	v1_ptr = View_Get(b.v1);
	//save the size before the resize
	var int sizex_pre; sizex_pre = Print_ToVirtual(b.val,PS_X);	
	var int sizey_pre; sizey_pre = roundf( mulf( mkf(b.initialDynamicVSizes[IDS_VBAR_Y]), dynScalingFactor ) ) ; // Dynamic Test +1 is missing, but needed?

	//scale on all axis
	View_ResizeCentered(b.v1, sizex_pre * x_percentage / 100 , sizey_pre * y_percentage / 100 ); 
		
	//Debug
	B4DI_debugSpy("Bar PositionX",IntToString(v1_ptr.vposx));
	B4DI_debugSpy("Bar PositionY",IntToString(v1_ptr.vposy));
	B4DI_debugSpy("Bar SizeX",IntToString(v1_ptr.vsizex));
    B4DI_debugSpy("Bar SizeY",IntToString(v1_ptr.vsizey));
    
	SB("V1: ");	SBi(v1_ptr.psizex); SB(" , "); SBi(v1_ptr.psizey); SB(" ");
	var int DebugText; DebugText = Print_Ext(1,1, SB_ToString(), FONT_Screen, RGBA(255,0,0,200),100);
	var zCViewText DebugTextObject; DebugTextObject = Print_GetText(DebugText);
	DebugTextObject.posy = Print_ToVirtual( Print_Screen[PS_Y]/2 , PS_X);  
	SB_Destroy(); 
};

func void B4DI_Bar_SetBarSizeCenteredPercentY(var int hndl, var int y_percentage){
	B4DI_Bar_SetBarSizeCenteredPercent(hndl, 100, y_percentage);
};

func void B4DI_Bar_SetBarSizeCenteredPercentX(var int hndl, var int x_percentage){
	B4DI_Bar_SetBarSizeCenteredPercent(hndl, x_percentage,100 );
};

func void B4DI_Bar_SetBarSizeCenteredPercentXY(var int hndl, var int xy_percentage){
	B4DI_Bar_SetBarSizeCenteredPercent(hndl, xy_percentage, xy_percentage );
};

func void B4DI_Bar_fadeOut(var int bar_hndl, var int deleteBar) {
	var _bar bar_inst; bar_inst = get(bar_hndl);
	bar_inst.anim8FadeOut = Anim8_NewExt(255, Bar_SetAlpha, bar_hndl, false);
	Anim8_RemoveIfEmpty(bar_inst.anim8FadeOut, true);
	if (deleteBar) {
		Anim8_RemoveDataIfEmpty(bar_inst.anim8FadeOut, true);
	} else {
		Anim8_RemoveDataIfEmpty(bar_inst.anim8FadeOut, false);
	};
	
	Anim8(bar_inst.anim8FadeOut, 255,  5000, A8_Wait);
	Anim8q(bar_inst.anim8FadeOut,   0, 2000, A8_SlowEnd);

};

func void B4DI_Bar_pulse(var int bar) {
	var int a8_XpBar_pulse; a8_XpBar_pulse = Anim8_NewExt(100 , B4DI_Bar_SetBarSizeCenteredPercentXY, bar, false); //height input
	Anim8_RemoveIfEmpty(a8_XpBar_pulse, true);
	Anim8_RemoveDataIfEmpty(a8_XpBar_pulse, false);
	
	Anim8 (a8_XpBar_pulse, 100,  100, A8_Wait);
	Anim8q(a8_XpBar_pulse, 150, 200, A8_SlowEnd);
	Anim8q(a8_XpBar_pulse, 100, 100, A8_SlowStart);

};

func void B4DI_Bar_hide( var int bar_hndl){
	if(!Hlp_IsValidHandle(bar_hndl)) {
		MEM_Info("B4DI_Bar_hide failed");
		return;
	};
	var _bar bar_inst; bar_inst = get(bar_hndl);
	bar_inst.isFadedOut = 1;
	B4DI_Bar_fadeOut(bar_hndl, false);
	MEM_Info("B4DI_Bar_hide successful");

};

func void B4DI_Bar_show( var int bar_hndl){
	if(!Hlp_IsValidHandle(bar_hndl)) {
		MEM_Info("B4DI_Bar_show failed");
		return;
	};
	var _bar bar_inst; bar_inst = get(bar_hndl);
	if(Hlp_IsValidHandle(bar_inst.anim8FadeOut) ){
		Anim8_Delete(bar_inst.anim8FadeOut);
	};
	bar_inst.isFadedOut = 0;
	Bar_SetAlpha(bar_hndl, 255);
	Bar_Show(bar_hndl);
	MEM_Info("B4DI_Bar_show successful");
};

func void B4DI_originalBar_hide( var int obar_ptr){
	var oCViewStatusBar bar_inst; bar_inst = MEM_PtrToInst(obar_ptr);
	bar_inst.zCView_alpha = 0; //backView
	ViewPtr_SetAlpha(bar_inst.range_bar, 0); //middleView
	ViewPtr_SetAlpha(bar_inst.value_bar, 0);	//barView
};


//#################################################################
//
//  HP Bar
//
//#################################################################

func void B4DI_HpBar_calcHp() {
	//var oCViewStatusBar bar_hp; bar_hp = MEM_PtrToInst (MEM_GAME.hpBar);
	Bar_SetMax(MEM_dBar_HP_handle, hero.attribute[ATR_HITPOINTS_MAX]);
	Bar_SetValue(MEM_dBar_HP_handle, hero.attribute[ATR_HITPOINTS]);
	MEM_Info("B4DI_HpBar_calcHp");
};


/*func void B4DI_oHpBar_hide(){
	MEM_oBar_Hp.zCView_alpha = 0; //backView
	ViewPtr_SetAlpha(MEM_oBar_Hp.range_bar, 0); //middleView
	ViewPtr_SetAlpha(MEM_oBar_Hp.value_bar, 0);	//barView
};*/

// returns the difference between 
func int B4DI_heroHp_changed(){
	var int heroHpDifference; heroHpDifference = hero.attribute[ATR_HITPOINTS]-lastHeroHP;
	if (heroHpDifference) {
		lastHeroHP = hero.attribute[ATR_HITPOINTS];
		//B4DI_debugSpy( "B4DI_heroHp_changed: ", IntToString(heroHpDifference) );
		return heroHpDifference;
	} else {
		return false;
	};
};

/*func void B4DI_hpBar_hide(){
	MEM_dBar_Hp.isFadedOut = 1;
	B4DI_Bar_fadeOut(MEM_dBar_HP_handle, false);
	MEM_Info("B4DI_hpBar_hide");

};

func void B4DI_hpBar_show(){
	if(Hlp_IsValidHandle(MEM_dBar_Hp.anim8FadeOut) ){
		Anim8_Delete(MEM_dBar_Hp.anim8FadeOut);
	};
	MEM_dBar_Hp.isFadedOut = 0;
	Bar_SetAlpha(MEM_dBar_HP_handle, 255);
	Bar_Show(MEM_dBar_HP_handle);
	if(!Hlp_IsValidHandle(MEM_dBar_HP_handle)) {
		MEM_Info("HANDLE BROCKEN FIX MEEEEEEEEEEEE");
	};
	MEM_Info("B4DI_hpBar_show");
};*/

func void B4DI_hpBar_update(){
	var int heroHpChanged; heroHpChanged = B4DI_heroHp_changed();
	if(heroHpChanged){
		B4DI_HpBar_calcHp();
	};
	if ( (!Npc_IsInFightMode( hero, FMODE_NONE ) || heroHpChanged ) & MEM_dBar_Hp.isFadedOut ) {
		//B4DI_hpBar_show();
		B4DI_Bar_show(MEM_dBar_HP_handle);
	} else if(Npc_IsInFightMode(hero, FMODE_NONE) & !MEM_dBar_Hp.isFadedOut) {
		//B4DI_hpBar_hide();	
		B4DI_Bar_hide(MEM_dBar_HP_handle);
	};
	MEM_Info("B4DI_hpBar_update");

};

func void B4DI_hpBar_InitAlways(){
	//original bars
	MEM_oBar_Hp = MEM_PtrToInst (MEM_GAME.hpBar); //original
	//B4DI_oHpBar_hide();
	//new version
	B4DI_originalBar_hide(MEM_GAME.hpBar);
	// new dBars dynamic
	if(!Hlp_IsValidHandle(MEM_dBar_HP_handle)){
		MEM_dBar_HP_handle = Bar_CreateCenterDynamic(B4DI_HpBar);
		B4DI_Bar_dynamicMenuBasedScale(MEM_dBar_HP_handle);
	};
	MEM_dBar_Hp = get(MEM_dBar_HP_handle);
	B4DI_HpBar_calcHp();
	Bar_SetAlpha(MEM_dBar_HP_handle, 0);
	MEM_dBar_Hp.isFadedOut = 1;

	lastHeroHP = hero.attribute[ATR_HITPOINTS];
	lastHeroMaxHP = hero.attribute[ATR_HITPOINTS_MAX];
	//TODO: Update on option change of Barsize
	//TODO: implement customizable Positions Left Right Top bottom,...
	Bar_MoveLeftUpperTo(MEM_dBar_HP_handle, MEM_oBar_Hp.zCView_vposx, MEM_oBar_Hp.zCView_vposy );

	FF_ApplyOnceExtGT(B4DI_hpBar_update,0,-1);

	MEM_Info("B4DI_hpBar_InitAlways");
};

func void B4DI_hpBar_InitOnce(){

	MEM_Info("B4DI_hpBar_InitOnce");
};

//#################################################################
//
//  XP Bar
//
//#################################################################

func void B4DI_XpBar_calcXp(var int XpBar){
	// ------ XP Setup ------
	var int level_last; var int exp_lastLvlUp;

	level_last = hero.level-1;
	if (level_last<0){
		level_last =0;
		exp_lastLvlUp=0;
	}
	else{
		exp_lastLvlUp = (500*((level_last+2)/2)*(level_last+1));
		//var int exp_next = (500*((hero.level+2)/2)*(hero.level+1));
	};

	//var int exp_neededFromThisLvlToNext = exp_next - exp_lastLvlUp;
	Bar_SetMax(XpBar, hero.exp_next- exp_lastLvlUp);
	Bar_SetValue(XpBar, hero.exp - exp_lastLvlUp);
};

func int B4DI_xpBar_create(){
	////preventing overlapping animations but I fear that the frameFunction still continoue
	//if(Hlp_IsValidHandle(a8_XpBar)) {
	//	if (!Anim8_Empty(a8_XpBar)){
	//		Anim8_Delete(a8_XpBar);
	//		Bar_Delete(XpBar);
	//	};
	//};
	var int XpBar;
	//if(!Hlp_IsValidHandle(XpBar)) {
		XpBar = Bar_CreateCenterDynamic(B4DI_XpBar);
		B4DI_Bar_dynamicMenuBasedScale(XpBar);
		//var int text_ptr; text_ptr = Print_Ext(100,100, "New Bar Created", FONT_Screen, RGBA(255,0,0,200),1000);
	//};

	B4DI_XpBar_calcXp(XpBar);

	////---debug print
	//var _bar b; b = get(XpBar);
	//var zCView v0_ptr; var zCView v1_ptr;
	//v0_ptr = View_Get(b.v0);
	
	//var int s0;s0=SB_New();
	//SB_Use(s0);
	//SB("V0: ");	SBi(v0_ptr.psizex); SB(" , "); SBi(v0_ptr.psizey); SB(" ");
	//v1_ptr = View_Get(b.v1);
	//SB("V1: ");	SBi(v1_ptr.psizex); SB(" , "); SBi(v1_ptr.psizey); SB(" ");
	//Print_Ext(500,500, SB_ToString(), FONT_Screen, RGBA(255,0,0,200),5000);
	//SB_Destroy();

	return XpBar;
};

func void B4DI_xpBar_show(){
	var int XpBar; XpBar = B4DI_xpBar_create();
	B4DI_Bar_fadeOut(XpBar, true);
	//B4DI_hpBar_show();
	//Bar_Show(XpBar);
	//B4DI_Bar_pulse(XpBar);
	
};


func void B4DI_xpBar_update() {
	ContinueCall();
	var int XpBar; XpBar = B4DI_xpBar_create();
	B4DI_Bar_pulse(XpBar);
	B4DI_Bar_fadeOut(XpBar, true);
};

//#################################################################
//
//  Apply changed Settings to all Bars
//
//#################################################################
func void B4DI_Bars_applySettings() {
	B4DI_InitBarScale(); // for resolution dependant scaling
	dynScalingFactor = B4DI_Bars_getDynamicScaleOptionValuef();

	B4DI_Bar_dynamicMenuBasedScale(MEM_dBar_HP_handle);
	B4DI_HpBar_calcHp();

	MEM_Info("B4DI_Bars_applySettings");
};

//#################################################################
//
//  Initinalisation Function Hooks
//
//#################################################################

// called in B4DI_InitOnce
func void B4DI_Bars_InitOnce() {
	//init globals
	MEM_InitGlobalInst ();
	//FMODE_NONE as not in combat 
	B4DI_hpBar_InitOnce();
	HookDaedalusFuncS("B_GivePlayerXP", "B4DI_xpBar_update"); 						// B4DI_xpBar_update()
	//MEM_Game.pause_screen as a TODO condition
	HookEngine(cGameManager__ApplySomeSettings_rtn, 6, "B4DI_Bars_applySettings");  // B4DI_Bars_applySettings()
	HookEngine(oCNpc__OpenScreen_Status, 7 , "B4DI_xpBar_show"); 					// B4DI_xpBar_show()

	MEM_Info("B4DI Bars ininitialised");
};

func void B4DI_Bars_InitAlways() {
	B4DI_hpBar_InitAlways();
};
