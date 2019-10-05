//#################################################################
//
//  HP Bar
//
//#################################################################
//TODO Rework
func void B4DI_HpBar_Refresh(var int animated_value_diff) {
	B4DI_eBar_RefreshAnimated(MEM_eBar_HP_handle, ATR_HITPOINTS, ATR_HITPOINTS_MAX, animated_value_diff);
	//B4DI_eBar_Refresh(MEM_eBar_HP_handle, ATR_HITPOINTS, ATR_HITPOINTS_MAX);
};

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

func void B4DI_hpBar_InitAlways(){
	//original bars
	MEM_oBar_Hp = MEM_PtrToInst (MEM_GAME.hpBar); //original
	B4DI_originalBar_hide(MEM_GAME.hpBar);
	// new dBars dynamic
	if( !Hlp_IsValidHandle(MEM_eBar_HP_handle) ){
		MEM_Info("B4DI_hpBar_InitAlways: Creating an HP Bar Handle");

		MEM_eBar_HP_handle = B4DI_eBar_Create(B4DI_HpBar);
		B4DI_eBar_SetNpcRef(MEM_eBar_HP_handle, MEM_InstToPtr(hero));
	};
	MEM_eBar_Hp = get(MEM_eBar_HP_handle);
	B4DI_HpBar_Refresh(B4DI_eBAR_INTITIAL_REFRESH);

	lastHeroHP = hero.attribute[ATR_HITPOINTS];
	lastHeroMaxHP = hero.attribute[ATR_HITPOINTS_MAX];
	//TODO: Update on option change of Barsize
	//TODO: implement customizable Positions Left Right Top bottom,...
	//TODO: implement a Screen margin
	Bar_MoveLeftUpperToValidScreenSpace(MEM_eBar_HP.bar, MEM_oBar_Hp.zCView_vposx, MEM_oBar_Hp.zCView_vposy );

	MEM_Info("B4DI_hpBar_InitAlways");
};

func void B4DI_hpBar_InitOnce(){

	MEM_Info("B4DI_hpBar_InitOnce");
};

