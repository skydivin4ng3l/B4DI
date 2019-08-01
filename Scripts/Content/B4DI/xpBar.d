//Constants
const int oCNpc__OpenScreen_Status = 7592320; // 0x73D980 // HookLen: 7

//////

prototype B4DI_MyXpBar(Bar) {
	x = Print_Screen[PS_X] / 2;
	y = Print_Screen[PS_Y] -20;
	barTop = 6;
	barLeft = 12;
	width = 256;
	height = 32;
	backTex = "Bar_Back.tga";
	barTex = "Bar_XP.tga";
	value = 100;
	valueMax = 100;
};

//////

instance B4DI_XpBar(B4DI_MyXpBar){
	x = 10+128;
	y = 20+16;
};




func void B4DI_xpBar_init() {
	// call in init_Gobal
	//FF_ApplyOnce(B4DI_xpBar_update);
	HookDaedalusFuncS("B_GivePlayerXP", "B4DI_xpBar_update");
	//MEM_Game.pause_screen as a TODO condition
	//FMODE_NONE as not in combat TODO Remember for Healthbar
	HookEngine(oCNpc__OpenScreen_Status, 7 , "B4DI_xpBar_show");
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
		XpBar = Bar_Create(B4DI_XpBar);
		//var int text_ptr; text_ptr = Print_Ext(100,100, "New Bar Created", FONT_Screen, RGBA(255,0,0,200),1000);
	//};

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

func void B4DI_XpBar_View_ResizePercent(var int hndl, var int x_percentage, var int y_percentage ) { 
	// Get the basic Settings for scaling from the original
	Print_GetScreenSize();
    var int ptr; ptr = create(B4DI_XpBar);
    var bar bu; bu = MEM_PtrToInst(ptr);

    var int buhh; var int buwh;
    var int ah; var int aw;
    buhh = bu.height / 2;
    buwh = bu.width / 2;
    if(buhh*2 < bu.height) {ah = 1;} else {ah = 0;};
    if(buwh*2 < bu.width) {aw = 1;} else {aw = 0;};

	//------------------
	if(!Hlp_IsValidHandle(hndl)) { return; };
	var _bar b; b = get(hndl);
	var zCView v0_ptr; var zCView v1_ptr;
	//v0_ptr = View_Get(b.v0);
	
	//var int s0;s0=SB_New();
	//SB_Use(s0);
	//SB("V0: ");	SBi(v0_ptr.vsizex); SB(" , "); SBi(v0_ptr.vsizey); SB(" ");
	
	//View_ResizePxl(b.v0, roundf(mulf(mkf(v0_ptr.psizex), percentageF)), roundf(mulf(mkf(v0_ptr.psizey), percentageF)) );

	v1_ptr = View_Get(b.v1);
	//SB("V1: ");	SBi(v1_ptr.psizex); SB(" , "); SBi(v1_ptr.psizey); SB(" ");

	var int sizex_pre; sizex_pre = Print_ToVirtual(b.val,PS_X);
	var int sizey_pre; sizey_pre = Print_ToVirtual((buhh-bu.barTop)*2+ah+1,PS_Y);
	//var int barValueV; barValueV = ((b.value * 1000) / b.valMax)* b.barW) / 1000); //same as Bar_SetValue->BarSetPromille

	//scale on all axis
	//View_Resize(b.v1, sizex_pre * percentage /100, sizey_pre * percentage / 100 );
	//scale just on y axis
	View_Resize(b.v1, sizex_pre * x_percentage / 100 , sizey_pre * y_percentage / 100 );
	//(v1_ptr.psizex - sizex_pre) / 2
	var int posDifY; posDifY = (v1_ptr.vsizey - sizey_pre)/2;
	if (posDifY>0){
		posDifY *= -1;
	};
	var int posDifX; posDifX = (v1_ptr.vsizex - sizex_pre)/2;
	if (posDifX>0){
		posDifX *= -1;
	};
	
	var int compenstedTargetX; 
	compenstedTargetX = Print_ToVirtual(bu.x - buwh + bu.barLeft + aw, PS_X ) + posDifX;

	var int compenstedTargetY; 
	compenstedTargetY = Print_ToVirtual(bu.y - buhh + bu.barTop + ah +1, PS_Y) + posDifY;
	//x -= v.vsizex>>1;
	//y -= v.vsizey>>1;
	//x -= v.vposx;
	//y -= v.vposy;
	//View_MoveTo(b.v1, v1_ptr.vposx, compenstedTargetY ); //<--- worked
	View_MoveTo(b.v1, compenstedTargetX, compenstedTargetY );

	//Print_Ext(300,300, SB_ToString(), FONT_Screen, RGBA(255,0,0,200),100);
	//SB_Destroy();

	free(ptr, B4DI_XpBar);

};

func void B4DI_Bar_View_ResizePercentageY(var int hndl, var int y_percentage){
	B4DI_XpBar_View_ResizePercent(hndl, 100, y_percentage);
};

func void B4DI_Bar_View_ResizePercentageX(var int hndl, var int x_percentage){
	B4DI_XpBar_View_ResizePercent(hndl, x_percentage,100 );
};

func void B4DI_Bar_View_ResizePercentageXY(var int hndl, var int xy_percentage){
	B4DI_XpBar_View_ResizePercent(hndl, xy_percentage, xy_percentage );
};

func void B4DI_Bar_fadeOut(var int bar) {
	var int a8_XpBar; a8_XpBar = Anim8_NewExt(255, Bar_SetAlpha, bar, false);
	Anim8_RemoveIfEmpty(a8_XpBar, true);
	Anim8_RemoveDataIfEmpty(a8_XpBar, true);
	
	Anim8 (a8_XpBar, 255,  5000, A8_Wait);
	Anim8q(a8_XpBar,   0, 2000, A8_SlowEnd);

};

func void B4DI_Bar_pulse(var int bar) {
	var int a8_XpBar_pulse; a8_XpBar_pulse = Anim8_NewExt(100 , B4DI_Bar_View_ResizePercentageXY, bar, false); //height input
	Anim8_RemoveIfEmpty(a8_XpBar_pulse, true);
	Anim8_RemoveDataIfEmpty(a8_XpBar_pulse, false);
	
	Anim8 (a8_XpBar_pulse, 100,  100, A8_Wait);
	Anim8q(a8_XpBar_pulse, 150, 200, A8_SlowEnd);
	Anim8q(a8_XpBar_pulse, 100, 100, A8_SlowStart);

};

func void B4DI_xpBar_show(){
	var int XpBar; XpBar = B4DI_xpBar_create();
	B4DI_Bar_fadeOut(XpBar);
	Bar_Show(XpBar);
	//B4DI_Bar_pulse(XpBar);
	
};

func void B4DI_xpBar_update() {
	ContinueCall();
	var int XpBar; XpBar = B4DI_xpBar_create();
	B4DI_Bar_fadeOut(XpBar);
	B4DI_Bar_pulse(XpBar);
};

