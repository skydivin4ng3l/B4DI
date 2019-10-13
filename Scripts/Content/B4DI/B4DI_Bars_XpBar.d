//#################################################################
//
//  XP Bar
//
//#################################################################
func void B4DI_XpBar_calcXp(){
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
	var int exp_neededForNextLevelUp; exp_neededForNextLevelUp = hero.exp_next- exp_lastLvlUp;
	var int exp_gotSinceLastLevelUp; exp_gotSinceLastLevelUp = hero.exp - exp_lastLvlUp;
	//Bar_SetMax(XpBar, hero.exp_next- exp_lastLvlUp);
	//Bar_SetValue(XpBar, hero.exp - exp_lastLvlUp);
	B4DI_eBar_SetValuesBasic(MEM_eBar_XP_handle, exp_gotSinceLastLevelUp, exp_neededForNextLevelUp);
	B4DI_eBar_RefreshLabel(MEM_eBar_XP_handle);
};

func void B4DI_xpBar_show(){

	B4DI_XpBar_calcXp();
	B4DI_eBar_show(MEM_eBar_XP_handle);
	B4DI_eBar_hideFaded(MEM_eBar_XP_handle);
	
};

func void B4DI_xpBar_update(var int add_xp) {
	PassArgumentI(add_xp);
	ContinueCall();

	B4DI_XpBar_calcXp();
	B4DI_eBar_show(MEM_eBar_XP_handle);

	B4DI_eBar_pulse_size(MEM_eBar_XP_handle, B4DI_Bar_SetBarSizeCenteredPercentXY);
	B4DI_eBar_hideFaded(MEM_eBar_XP_handle);
};

func void B4DI_xpBar_InitAlways(){
	if(!Hlp_IsValidHandle(MEM_eBar_XP_handle)){
		MEM_Info("B4DI_xpBar_InitAlways: Creating an XP Bar Handle");
		MEM_eBar_XP_handle = B4DI_eBar_CreateCustomXY(B4DI_XpBar, MEM_oBar_Focus.zCView_vposx, MEM_oBar_Hp.zCView_vposy, B4DI_ALIGNMENT_USE_ANCHOR);
	};
	MEM_eBar_XP = get(MEM_eBar_XP_handle);
	B4DI_XpBar_calcXp();

	//TODO: Update on option change of Barsize
	//TODO: implement customizable Positions Left Right Top bottom,...
	//TODO: implement a Screen margin
	//Bar_MoveLeftUpperToValidScreenSpace(MEM_eBar_XP.bar, MEM_oBar_Focus.zCView_vposx, MEM_oBar_Hp.zCView_vposy );

	MEM_Info("B4DI_xpBar_InitAlways");
};

func void B4DI_xpBar_InitOnce(){
	HookDaedalusFuncS("B_GivePlayerXP", "B4DI_xpBar_update"); 						// B4DI_xpBar_update(var int add_xp)

	MEM_Info("B4DI_xpBar_InitOnce");

};
