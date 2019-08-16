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
	x = 135+20;
	y = Print_Screen[PS_Y] -100;
	barTop = 2;		// 2 is almost too small
	barTex = "Bar_Health.tga";
};


///// Hooks

func void B4DI_Bars_init() {
	// call in init_Gobal
	//FF_ApplyOnce(B4DI_xpBar_update);
	HookDaedalusFuncS("B_GivePlayerXP", "B4DI_xpBar_update"); // B4DI_xpBar_update()
	//MEM_Game.pause_screen as a TODO condition
	//FMODE_NONE as not in combat TODO Remember for Healthbar
	HookEngine(oCNpc__OpenScreen_Status, 7 , "B4DI_xpBar_show"); // B4DI_xpBar_show()
};

////// Support

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

func int B4DI_hpBar_create(){
	
	var int hpBar;
	HpBar = Bar_CreateCenterDynamic(B4DI_HpBar);


	return HpBar;
};

func void B4DI_Bar_SetSizeCenteredPercent(var int hndl, var int x_percentage, var int y_percentage ) { 
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
	var int sizey_pre; sizey_pre = b.initialDynamicVSizes[IDS_V1_Y]; // Dynamic Test +1 is missing, but needed?

	//scale on all axis
	View_Resize(b.v1, sizex_pre * x_percentage / 100 , sizey_pre * y_percentage / 100 ); 
	
	//Calc the size difference caused by the resize all in virtual space
	var int posDifY; posDifY = (v1_ptr.vsizey - sizey_pre)/2;
	//positive difference means View is now bigger than before
	//  therefore needs to be moved into the opposite direction
	if (posDifY>0){
		posDifY *= -1;
	};
	var int posDifX; posDifX = (v1_ptr.vsizex - sizex_pre)/2;
	if (posDifX>0){
		posDifX *= -1;
	};
	
	// calculate the original pixel center -> virtualize it -> compensate with axis differance
	var int compenstedTargetX; 
	compenstedTargetX = b.initialVPositions[IP_V1_LEFT] + posDifX;

	var int compenstedTargetY; 
	compenstedTargetY = b.initialVPositions[IP_V1_TOP] + posDifY;

	View_MoveTo(b.v1, compenstedTargetX, compenstedTargetY );
	
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

func void B4DI_Bar_SetSizeCenteredPercentY(var int hndl, var int y_percentage){
	B4DI_Bar_SetSizeCenteredPercent(hndl, 100, y_percentage);
};

func void B4DI_Bar_SetSizeCenteredPercentX(var int hndl, var int x_percentage){
	B4DI_Bar_SetSizeCenteredPercent(hndl, x_percentage,100 );
};

func void B4DI_Bar_SetSizeCenteredPercentXY(var int hndl, var int xy_percentage){
	B4DI_Bar_SetSizeCenteredPercent(hndl, xy_percentage, xy_percentage );
};

func void B4DI_Bar_fadeOut(var int bar) {
	var int a8_XpBar; a8_XpBar = Anim8_NewExt(255, Bar_SetAlpha, bar, false);
	Anim8_RemoveIfEmpty(a8_XpBar, true);
	Anim8_RemoveDataIfEmpty(a8_XpBar, true);
	
	Anim8 (a8_XpBar, 255,  5000, A8_Wait);
	Anim8q(a8_XpBar,   0, 2000, A8_SlowEnd);

};

func void B4DI_Bar_pulse(var int bar) {
	var int a8_XpBar_pulse; a8_XpBar_pulse = Anim8_NewExt(100 , B4DI_Bar_SetSizeCenteredPercentXY, bar, false); //height input
	Anim8_RemoveIfEmpty(a8_XpBar_pulse, true);
	Anim8_RemoveDataIfEmpty(a8_XpBar_pulse, false);
	
	Anim8 (a8_XpBar_pulse, 100,  100, A8_Wait);
	Anim8q(a8_XpBar_pulse, 150, 200, A8_SlowEnd);
	Anim8q(a8_XpBar_pulse, 100, 100, A8_SlowStart);

};

func void B4DI_hpBar_show(){
	var int HpBar; HpBar = B4DI_hpBar_create();
	B4DI_Bar_fadeOut(HpBar);

};

func void B4DI_xpBar_show(){
	var int XpBar; XpBar = B4DI_xpBar_create();
	B4DI_Bar_fadeOut(XpBar);
	B4DI_hpBar_show();
	//Bar_Show(XpBar);
	//B4DI_Bar_pulse(XpBar);
	
};


func void B4DI_xpBar_update() {
	ContinueCall();
	var int XpBar; XpBar = B4DI_xpBar_create();
	B4DI_Bar_fadeOut(XpBar);
	B4DI_Bar_pulse(XpBar);
};

