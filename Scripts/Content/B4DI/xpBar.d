//Constants
const int oCNpc__OpenScreen_Status = 7592320; // 0x73D980 // HookLen: 7

//////

prototype B4DI_MyXpBar(Bar) {
	x = Print_Screen[PS_X] / 2;
	y = Print_Screen[PS_Y] -20;
	barTop = 3;
	barLeft = 7;
	width = 180;
	height = 20;
	backTex = "Bar_Back.tga";
	barTex = "Bar_XP.tga";
	value = 100;
	valueMax = 100;
};

//////

instance B4DI_XpBar(B4DI_MyXpBar){
	x = 100;
	y = 20;
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
	////preventing overlapping animations but I fear that the frameFunction still continous
	//if(Hlp_IsValidHandle(a8_XpBar)) {
	//	if (!Anim8_Empty(a8_XpBar)){
	//		Anim8_Delete(a8_XpBar);
	//		Bar_Delete(XpBar);
	//	};
	//};
	var int XpBar;
	if(!Hlp_IsValidHandle(XpBar)) {
		XpBar = Bar_Create(B4DI_XpBar);
	};

	// ------ XP Setup ------
	var int level_next; level_next = hero.level+1;
	var int exp_lastLvlUp; exp_lastLvlUp = (500*(level_next/2)*level_next);
	//var int exp_next		= (500*((hero.level+2)/2)*(hero.level+1));

	//var int exp_neededFromThisLvlToNext = exp_next - exp_lastLvlUp;
	Bar_SetMax(XpBar, hero.exp_next);
	Bar_SetValue(XpBar, hero.exp - exp_lastLvlUp);

	return XpBar;
};

func void B4DI_Bar_fadeOut(var int bar) {
	var int a8_XpBar; a8_XpBar = Anim8_NewExt(255, Bar_SetAlpha, bar, false);
	Anim8_RemoveIfEmpty(a8_XpBar, true);
	Anim8_RemoveDataIfEmpty(a8_XpBar, true);
	
	Anim8 (a8_XpBar, 255,  5000, A8_Wait);
	Anim8q(a8_XpBar,   0, 2000, A8_SlowStart);

};

func void B4DI_xpBar_show(){
	var int XpBar; XpBar = B4DI_xpBar_create();
	B4DI_Bar_fadeOut(XpBar);
	Bar_Show(XpBar);
	
};

func void B4DI_xpBar_update() {
	ContinueCall();
	var int XpBar; XpBar = B4DI_xpBar_create();
	B4DI_Bar_fadeOut(XpBar);
};

