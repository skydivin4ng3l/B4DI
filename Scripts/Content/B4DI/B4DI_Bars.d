//////
/// TODO move all changes in LeGo Classes here or at least seperate additions from vanilla LeGo

func void B4DI_heroInstance_InitAlways() {
	var int oCNpc_hero_ptr; oCNpc_hero_ptr = MEM_InstToPtr(oHero);
	if(!Hlp_Is_oCNpc( oCNpc_hero_ptr ) ) {
		var int hero_ptr; hero_ptr = MEM_InstToPtr(hero);
	  	oHero = MEM_PtrToInst(hero_ptr);
	};
	
};
//#################################################################
//
//  Inventory related
//
//#################################################################
//#################################################################
//PreViews
//#################################################################
func void B4DI_Bars_hideItemPreview() {
	//TODO Update
	//View_Close(MEM_preView_HP_handle);

	B4DI_eBar_HidePreview(MEM_eBar_HP_handle);
	B4DI_eBar_HidePreview(MEM_eBar_MANA_handle);
	areItemPreviewsHidden = true;
	B4DI_eBar_RefreshLabel(MEM_eBar_HP_handle);
	B4DI_eBar_RefreshLabel(MEM_eBar_MANA_handle);
	MEM_Info("B4DI_Bars_hideItemPreview");
};


func void B4DI_Bars_showItemPreview() {
	var int index; var STRING type; var int value;

	B4DI_Bars_hideItemPreview(); // hide all previews to prevent old ones to persist if selected remains in valid category // Might not belong here 

	repeat(index, ITM_TEXT_MAX); 
		type = MEM_ReadStatStringArr(selectedInvItem.TEXT,index);
		MEM_Info( cs2("type: ", type) );

		if( STR_Compare(type , NAME_Bonus_HP) == STR_EQUAL ) {
			value = MEM_ReadStatArr(selectedInvItem.COUNT,index);
			MEM_Info("B4DI_Bars_showItemPreview HP");
			B4DI_eBar_ShowPreview(MEM_eBar_HP_handle, value);
		};
		if( STR_Compare(type , NAME_Bonus_HpMax ) == STR_EQUAL ) {
			value = MEM_ReadStatArr(selectedInvItem.COUNT,index);
			MEM_Info("B4DI_Bars_showItemPreview HPMax");
			//TODO preview HPMax
			B4DI_eBar_SetPreviewChangesMaximum(MEM_eBar_HP_handle);
			B4DI_eBar_ShowPreview(MEM_eBar_HP_handle, value);
		};
		if( STR_Compare(type , NAME_Bonus_Mana ) == STR_EQUAL ) {
			value = MEM_ReadStatArr(selectedInvItem.COUNT,index);
			MEM_Info("B4DI_Bars_showItemPreview MANA");
			B4DI_eBar_ShowPreview(MEM_eBar_MANA_handle, value);
		};
		if( STR_Compare(type , NAME_Bonus_ManaMax ) == STR_EQUAL  ) {
			value = MEM_ReadStatArr(selectedInvItem.COUNT,index);
			MEM_Info("B4DI_Bars_showItemPreview MANAMax");
			//TODO preview manaMax
			B4DI_eBar_SetPreviewChangesMaximum(MEM_eBar_MANA_handle);
			B4DI_eBar_ShowPreview(MEM_eBar_MANA_handle, value);
		};
		if( STR_Compare(type , NAME_Mana_needed ) == STR_EQUAL ) {
			value = MEM_ReadStatArr(selectedInvItem.COUNT,index);
			MEM_Info("B4DI_Bars_showItemPreview MANA Needed");
			//TODO preview manaNeeded
		};

	end;
};


//=====Inv_GetSelectedItem=====

func int Inv_GetSelectedItem(){
	var int itm_index; itm_index = oHero.inventory2_oCItemContainer_selectedItem + 2; 		//anscheinend sind die ersten beiden items in der List nie belegt.
	var zCListSort list; list = _^(oHero.inventory2_oCItemContainer_contents);
	if (List_HasLengthS(_@(list), itm_index))
	{	
		var int itm_ptr; itm_ptr = List_GetS(_@(list), itm_index);
		return itm_ptr;
	}
	else
	{
		return 0;
	};	
};


//#################################################################
//
//  HP Bar
//
//#################################################################
//TODO Rework
func void B4DI_HpBar_Refresh() {
	B4DI_eBar_Refresh(MEM_eBar_HP_handle, ATR_HITPOINTS, ATR_HITPOINTS_MAX);
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
	};
	MEM_eBar_Hp = get(MEM_eBar_HP_handle);
	B4DI_HpBar_Refresh();

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

func void B4DI_manaBar_Refresh(){
	B4DI_eBar_Refresh(MEM_eBar_MANA_handle, ATR_MANA, ATR_MANA_MAX);
};

func void B4DI_manaBar_InitAlways(){
	//original bars
	MEM_oBar_Mana = MEM_PtrToInst (MEM_GAME.manaBar); //original
	B4DI_originalBar_hide(MEM_GAME.manaBar);
	// new dBars dynamic
	if(!Hlp_IsValidHandle(MEM_eBar_MANA_handle)){
		MEM_eBar_MANA_handle = B4DI_eBar_Create(B4DI_ManaBar);
	};
	MEM_eBar_MANA = get(MEM_eBar_MANA_handle);
	B4DI_manaBar_Refresh();

	lastHeroMANA = hero.attribute[ATR_MANA];
	lastHeroMaxMANA = hero.attribute[ATR_MANA_MAX];
	//TODO: Update on option change of Barsize
	//TODO: implement customizable Positions Left Right Top bottom,...
	//TODO: implement a Screen margin
	Bar_MoveLeftUpperToValidScreenSpace(MEM_eBar_MANA.bar, MEM_oBar_Mana.zCView_vposx, MEM_oBar_Mana.zCView_vposy );


	MEM_Info("B4DI_manaBar_InitAlways");
};

func void B4DI_manaBar_InitOnce(){
	HookDaedalusFuncS("Spell_ProcessMana", "B4DI_manaBar_hooking_Spell_ProcessMana" ); //B4DI_manaBar_hooking_Spell_ProcessMana( var int manaInvested)
	HookDaedalusFuncS("Spell_ProcessMana_Release", "B4DI_manaBar_hooking_Spell_ProcessMana_Release"); //B4DI_manaBar_hooking_Spell_ProcessMana_Release( var int manaInvested)
	MEM_Info("B4DI_manaBar_InitOnce");
};


//#################################################################
//
//  Update all "normal" Bars
//
//#################################################################

func void B4DI_Bars_update(){
	var int heroHpChanged; heroHpChanged = B4DI_heroHp_changed();
	if(heroHpChanged){
		B4DI_HpBar_Refresh();
	};
	var int heroManaChanged; heroManaChanged = B4DI_heroMana_changed();
	if(heroManaChanged){
		B4DI_manaBar_Refresh();
	};
	//TODO option on when to show/hide manaBar
	if ( (!Npc_IsInFightMode( hero, FMODE_NONE ) || heroHpChanged || heroManaChanged || isInventoryOpen ) & MEM_eBar_Hp.isFadedOut ) {
		B4DI_eBar_show(MEM_eBar_HP_handle);
		if(Npc_IsInFightMode( hero, FMODE_MAGIC ) || isInventoryOpen ) {
			B4DI_eBar_show(MEM_eBar_MANA_handle);
			B4DI_Info1("SpellMana:", oHero.spellMana);
		};
	} else if(Npc_IsInFightMode( hero, FMODE_NONE ) & !heroHpChanged & !heroManaChanged & !isInventoryOpen & !MEM_eBar_Hp.isFadedOut) {
		B4DI_eBar_hideFaded(MEM_eBar_MANA_handle);
		B4DI_eBar_hideFaded(MEM_eBar_HP_handle);
	};
	if(isInventoryOpen){
		selectedInvItem = _^(Inv_GetSelectedItem());
		//show only preview for new items // description instead of name cause potions are not destinguishable by name, which is "potion" for all
		if( (STR_Compare(lastSelectedItemName, selectedInvItem.description ) != STR_EQUAL) || (heroHpChanged != false ) || (heroManaChanged != false ) ) { 
			lastSelectedItemName = selectedInvItem.description;
			//TODO Filter for bar influencing items What about different types: timed, procentual, absolute
			//TODO pack into preView_Update Function?
			if(selectedInvItem.mainflag == ITEM_KAT_POTIONS || selectedInvItem.mainflag == ITEM_KAT_FOOD){
				MEM_Info(selectedInvItem.description);
				B4DI_Bars_showItemPreview();
			} else {
				if (!areItemPreviewsHidden) {
					B4DI_Bars_hideItemPreview();
				};
			};
		} else {
			//TODO check for preview animation end, repeat
		};
	} else {
		//Inventory got closed or is just not open
		if (!areItemPreviewsHidden) {
			B4DI_Bars_hideItemPreview(); //close previews after inventory closed
		};
	};
	//MEM_Info("B4DI_Bars_update");
	//B4DI_debugSpy("B4DI_ITEM_is: ", item.nameID);

};


//#################################################################
//
//  Apply changed Settings to all Bars
//
//#################################################################
func void B4DI_Bars_applySettings() {
	B4DI_InitBarScale(); // for resolution dependant scaling
	dynScalingFactor = B4DI_Bars_getDynamicScaleOptionValuef();

	//B4DI_Bar_dynamicMenuBasedScale(MEM_dBar_HP_handle);
	B4DI_Bar_dynamicMenuBasedScale(MEM_eBar_HP.bar);
	B4DI_HpBar_Refresh();

	B4DI_Bar_dynamicMenuBasedScale(MEM_eBar_MANA.bar);
	B4DI_manaBar_Refresh();

	B4DI_Bar_dynamicMenuBasedScale(MEM_eBar_FOCUS.bar);
	//TODO find a way rto refeshed if necessary and relevant NPC
	//B4DI_focusBar_Refresh();

	MEM_Info("B4DI_Bars_applySettings");
};





