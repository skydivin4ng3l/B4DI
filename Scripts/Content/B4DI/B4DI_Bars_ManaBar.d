//#################################################################
//
//  Mana Bar
//
//#################################################################
func int B4DI_heroMana_changed(){
	var int heroManaDifference; heroManaDifference = hero.attribute[ATR_MANA]-lastHeroMANA;
	if (heroManaDifference) {
		lastHeroMANA = hero.attribute[ATR_MANA];
		B4DI_debugSpy( "B4DI_heroMana_changed: ", IntToString(heroManaDifference) );
		return heroManaDifference;
	} else {
		return false;
	};
};

func void B4DI_manaBar_Refresh(var int animated_value_diff){
	B4DI_eBar_RefreshAnimated(MEM_eBar_MANA_handle, ATR_MANA, ATR_MANA_MAX, animated_value_diff);
};

func void B4DI_manaBar_InitAlways(){
	//original bars
	MEM_oBar_Mana = MEM_PtrToInst (MEM_GAME.manaBar); //original
	B4DI_originalBar_hide(MEM_GAME.manaBar);
	// new dBars dynamic
	if(!Hlp_IsValidHandle(MEM_eBar_MANA_handle)){
		MEM_Info("B4DI_manaBar_InitAlways: Creating an MAMA Bar Handle");
		MEM_eBar_MANA_handle = B4DI_eBar_CreateAsReplacement(B4DI_ManaBar, MEM_GAME.manaBar);
	};
	B4DI_eBar_SetNpcRef(MEM_eBar_MANA_handle, MEM_InstToPtr(hero));
	MEM_eBar_MANA = get(MEM_eBar_MANA_handle);
	//B4DI_eBar_Bar_SetTitleString( MEM_eBar_MANA_handle, B4DI_GetMenuItemText("MENU_ITEM_ATTRIBUTE_3_TITLE",0) );
	B4DI_manaBar_Refresh(B4DI_eBAR_INTITIAL_REFRESH);

	lastHeroMANA = hero.attribute[ATR_MANA];
	lastHeroMaxMANA = hero.attribute[ATR_MANA_MAX];
	//TODO: Update on option change of Barsize
	//TODO: implement customizable Positions Left Right Top bottom,...
	//TODO: implement a Screen margin
	//Bar_MoveLeftUpperToValidScreenSpace(MEM_eBar_MANA.bar, MEM_oBar_Mana.zCView_vposx, MEM_oBar_Mana.zCView_vposy );


	MEM_Info("B4DI_manaBar_InitAlways");
};

func void B4DI_manaBar_InitOnce(){
	HookDaedalusFuncS("Spell_ProcessMana", "B4DI_manaBar_hooking_Spell_ProcessMana" ); //B4DI_manaBar_hooking_Spell_ProcessMana( var int manaInvested)
	HookDaedalusFuncS("Spell_ProcessMana_Release", "B4DI_manaBar_hooking_Spell_ProcessMana_Release"); //B4DI_manaBar_hooking_Spell_ProcessMana_Release( var int manaInvested)
	MEM_Info("B4DI_manaBar_InitOnce");
};

