//////
/// TODO move all changes in LeGo Classes here or at least seperate additions from vanilla LeGo


//#################################################################
//
//  General Functions
//
//#################################################################

//TODO Depricated -> migrate XP-Bar
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

func void B4DI_Bar_pulse_size(var int bar_hndl) {
	var int a8_XpBar_pulse; a8_XpBar_pulse = Anim8_NewExt(100 , B4DI_Bar_SetBarSizeCenteredPercentXY, bar_hndl, false); //height input
	Anim8_RemoveIfEmpty(a8_XpBar_pulse, true);
	Anim8_RemoveDataIfEmpty(a8_XpBar_pulse, false);
	
	Anim8 (a8_XpBar_pulse, 100,  100, A8_Wait);
	Anim8q(a8_XpBar_pulse, 150, 200, A8_SlowEnd);
	Anim8q(a8_XpBar_pulse, 100, 100, A8_SlowStart);

};

//TODO Depricated
//func void B4DI_Bar_hide( var int bar_hndl){
//	if(!Hlp_IsValidHandle(bar_hndl)) {
//		MEM_Info("B4DI_Bar_hide failed");
//		return;
//	};
//	var _bar bar_inst; bar_inst = get(bar_hndl);
//	bar_inst.isFadedOut = 1;
//	B4DI_Bar_fadeOut(bar_hndl, false);
//	MEM_Info("B4DI_Bar_hide successful");

//};

//TODO Depricated
//func void B4DI_Bar_show( var int bar_hndl){
//	if(!Hlp_IsValidHandle(bar_hndl)) {
//		MEM_Info("B4DI_Bar_show failed");
//		return;
//	};
//	var _bar bar_inst; bar_inst = get(bar_hndl);
//	if(Hlp_IsValidHandle(bar_inst.anim8FadeOut) ){
//		Anim8_Delete(bar_inst.anim8FadeOut);
//	};
//	bar_inst.isFadedOut = 0;
//	Bar_SetAlpha(bar_hndl, 255);
//	Bar_Show(bar_hndl);
	
//	MEM_Info("B4DI_Bar_show successful");
//};

func void B4DI_originalBar_hide( var int obar_ptr){
	var oCViewStatusBar bar_inst; bar_inst = MEM_PtrToInst(obar_ptr);
	bar_inst.zCView_alpha = 0; //backView
	ViewPtr_SetAlpha(bar_inst.range_bar, 0); //middleView
	ViewPtr_SetAlpha(bar_inst.value_bar, 0);	//barView
};

//#################################################################
//
//  Inventory related
//
//#################################################################
//#################################################################
//PreViews
//#################################################################
//depricated
//func void B4DI_Bar_calcPreView(var int bar_hndl, var int preview_hndl, var int value){
//	var _bar bar; bar = get(bar_hndl);
//	var zCview vBar; vBar = View_Get(bar.v1);
//	var zCView preview; preview = View_Get(preview_hndl);

//	View_DeleteText(preview_hndl);

//	var int preview_vsizex; preview_vsizex = (((value *1000) / bar.valMax) * bar.barW / 1000);
//	View_Resize(preview_hndl, preview_vsizex, vBar.vsizey);
//	View_MoveTo(preview_hndl, vBar.vposx + vBar.vsizex, vBar.vposy );
		
//	//TODO handle overshoot
//	var int s0;s0=SB_New(); SB_Use(s0);
//    SB("+");
//    var int diffValueToBarValMax; diffValueToBarValMax = bar.valMax - bar.val;
//    MEM_Info(IntToString(diffValueToBarValMax));
//	if(diffValueToBarValMax < value){    	
//    	SBi( diffValueToBarValMax ); SB("("); SBi(value); SB(")");
//	} else {
//		SBi(value);
//	};
	
//	View_AddText(preview_hndl, preview.vsizex>>1, preview.vsizey>>1, SB_ToString(), TEXT_FONT_Inventory );
//    SB_Destroy();

//	MEM_Info("B4DI_Bar_calcPreView");
//};

// Deprecated
//func void B4DI_Bar_showPreview(var int bar_hndl, var int preview_hndl, var int value){
//	if(!Hlp_IsValidHandle(bar_hndl)) {
//		MEM_Info("tried to show Preview of a not initialized bar ");
//		return;
//	};
//	if(!Hlp_IsValidHandle(preview_hndl)){
//		return;
//	};
//	//B4DI_HpBar_Refresh();
//	B4DI_Bar_calcPreView(bar_hndl, preview_hndl, value);
//	View_Open(preview_hndl);
//	View_SetAlpha(preview_hndl, 127);
//	View_Top(preview_hndl);
//	areItemPreviewsHidden = false;
//	MEM_Info("B4DI_Bar_showPreview");
//};


// Deprecated
//func void B4DI_Bar_InitPreView( var int bar_hndl){
//	if(!Hlp_IsValidHandle(MEM_preView_HP_handle)){
//		if(!Hlp_IsValidHandle(bar_hndl)) {
//			MEM_Info("tried to init Preview of a not initialized bar ");
//			return;
//		};
//		var _bar bar; bar = get(bar_hndl);
//		var zCview vBar; vBar = View_Get(bar.v1);
//		MEM_preView_HP_handle = View_Create(vBar.vposx, vBar.vposy, vBar.vposx + vBar.vsizex, vBar.vposy + vBar.vsizey );
//	};
//	View_SetTexture(MEM_preView_HP_handle, "Bar_Health.tga" );
//	MEM_preView_HP = get(MEM_preView_HP_handle);
//	MEM_Info("B4DI_Bar_InitPreView");
//};

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
			//TODO preview HP
			//B4DI_Bar_showPreview(MEM_dBar_HP_handle, MEM_preView_HP_handle, value);
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
			//TODO preview mana
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
	var int hero_ptr; hero_ptr = MEM_InstToPtr(hero);
	var oCNpc oCNPC_hero; oCNPC_hero = MEM_PtrToInst(hero_ptr);
	var int itm_index; itm_index = oCNPC_hero.inventory2_oCItemContainer_selectedItem + 2; 		//anscheinend sind die ersten beiden items in der List nie belegt.
	var zCListSort list; list = _^(oCNPC_hero.inventory2_oCItemContainer_contents);
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
	//var oCViewStatusBar bar_hp; bar_hp = MEM_PtrToInst (MEM_GAME.hpBar);
	//Bar_SetMax(MEM_dBar_HP_handle, hero.attribute[ATR_HITPOINTS_MAX]);
	//Bar_SetValue(MEM_dBar_HP_handle, hero.attribute[ATR_HITPOINTS]);
	
	////TODO make optional
	//View_DeleteText(MEM_dBar_Hp.vMiddle);
	//View_AddText(MEM_dBar_Hp.vMiddle, 0, 0, B4DI_Bar_generateLabel(MEM_dBar_HP_handle, hero.attribute[ATR_HITPOINTS], hero.attribute[ATR_HITPOINTS_MAX]), TEXT_FONT_Inventory);
	//if(MEM_dBar_Hp.isFadedOut) {
	//	Bar_SetAlpha(MEM_dBar_HP_handle, 0);
	//};


	//MEM_Info("B4DI_HpBar_Refresh");
	//var _bar bar; bar = get(MEM_dBar_HP_handle);
	//MEM_Info(cs2("hero.attribute[ATR_HITPOINTS_MAX]: ",i2s(hero.attribute[ATR_HITPOINTS_MAX])));
	//MEM_Info(cs2(" hero.attribute[ATR_HITPOINTS]: ",i2s(hero.attribute[ATR_HITPOINTS])));
	//MEM_Info(cs2("bar.valMax: ",i2s(bar.valMax)));
	//MEM_Info(cs2(" bar.val: ",i2s(bar.val)));

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
	//B4DI_originalBar_hide(MEM_GAME.hpBar);
	// new dBars dynamic
	if(/*!Hlp_IsValidHandle(MEM_dBar_HP_handle) &*/ !Hlp_IsValidHandle(MEM_eBar_HP_handle) ){
		MEM_Info("B4DI_hpBar_InitAlways: Creating an HP Bar Handle");
		//MEM_dBar_HP_handle = Bar_CreateCenterDynamic(B4DI_HpBar);
		//B4DI_Bar_dynamicMenuBasedScale(MEM_dBar_HP_handle);

		MEM_eBar_HP_handle = B4DI_eBar_Create(B4DI_HpBar);
	};
	//MEM_dBar_Hp = get(MEM_dBar_HP_handle);
	MEM_eBar_Hp = get(MEM_eBar_HP_handle);
	B4DI_HpBar_Refresh();
	//Bar_SetAlpha(MEM_dBar_HP_handle, 0);	 //prevents working state within Fmode Saves
	//MEM_dBar_Hp.isFadedOut = 1;				 //prevents working state within Fmode Saves

	lastHeroHP = hero.attribute[ATR_HITPOINTS];
	lastHeroMaxHP = hero.attribute[ATR_HITPOINTS_MAX];
	//TODO: Update on option change of Barsize
	//TODO: implement customizable Positions Left Right Top bottom,...
	//TODO: implement a Screen margin
	//Bar_MoveLeftUpperToValidScreenSpace(MEM_dBar_HP_handle, MEM_oBar_Hp.zCView_vposx, MEM_oBar_Hp.zCView_vposy );
	//Bar_MoveLeftUpperToValidScreenSpace(MEM_dBar_HP_handle, MEM_oBar_Hp.zCView_vposx, MEM_oBar_Hp.zCView_vposy-200 );
	Bar_MoveLeftUpperToValidScreenSpace(MEM_eBar_HP.bar, MEM_oBar_Hp.zCView_vposx, MEM_oBar_Hp.zCView_vposy-500 );

	//B4DI_Bar_InitPreView(MEM_dBar_HP_handle);

	//FF_ApplyOnceExtGT(B4DI_Bars_update,0,-1);

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
		lastHeroMANA = hero.attribute[ATR_HITPOINTS];
		//B4DI_debugSpy( "B4DI_heroMana_changed: ", IntToString(heroManaDifference) );
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

	//FF_ApplyOnceExtGT(B4DI_Bars_update,0,-1);

	MEM_Info("B4DI_manaBar_InitAlways");
};

func void B4DI_manaBar_InitOnce(){
	HookDaedalusFuncS("Spell_ProcessMana", "B4DI_manaBar_hooking_Spell_ProcessMana" ); //B4DI_manaBar_hooking_Spell_ProcessMana( var int manaInvested)
	HookDaedalusFuncS("Spell_ProcessMana_Release", "B4DI_manaBar_hooking_Spell_ProcessMana_Release"); //B4DI_manaBar_hooking_Spell_ProcessMana_Release( var int manaInvested)
	MEM_Info("B4DI_manaBar_InitOnce");
};

//#################################################################
//
//  XP Bar
//
//#################################################################
//TODO: change to persitent bar 
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

	return XpBar;
};

func void B4DI_xpBar_show(){
	var int XpBar; XpBar = B4DI_xpBar_create();
	B4DI_Bar_fadeOut(XpBar, true);
	//B4DI_hpBar_show();
	//Bar_Show(XpBar);
	//B4DI_Bar_pulse_size(XpBar);
	
};


func void B4DI_xpBar_update(var int add_xp) {
	PassArgumentI(add_xp);
	ContinueCall();
	var int XpBar; XpBar = B4DI_xpBar_create();
	B4DI_Bar_pulse_size(XpBar);
	B4DI_Bar_fadeOut(XpBar, true);
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
		//B4DI_hpBar_show();
		//B4DI_Bar_show(MEM_dBar_HP_handle); //TODO Update
		B4DI_eBar_show(MEM_eBar_MANA_handle);
		B4DI_eBar_show(MEM_eBar_HP_handle);
	} else if(Npc_IsInFightMode( hero, FMODE_NONE ) & !heroHpChanged & !heroManaChanged & !isInventoryOpen & !MEM_eBar_Hp.isFadedOut) {
		//B4DI_hpBar_hide();	
		//B4DI_Bar_hide(MEM_dBar_HP_handle);	//TODO Update
		B4DI_eBar_hide(MEM_eBar_MANA_handle);
		B4DI_eBar_hide(MEM_eBar_HP_handle);
	};
	if(isInventoryOpen){
		selectedInvItem = _^(Inv_GetSelectedItem());
		//show only preview for new items // description instead of name cause potions are not destinguishable by name, which is "potion" for all
		if( (STR_Compare(lastSelectedItemName, selectedInvItem.description ) != STR_EQUAL) || (heroHpChanged != false ) || (heroManaChanged != false ) ) { 
			lastSelectedItemName = selectedInvItem.description;
			//TODO Filter for bar influencing items What about different types: timed, procentual, absolute
			//TODO pack into preView_Update Function
			if(selectedInvItem.mainflag == ITEM_KAT_POTIONS || selectedInvItem.mainflag == ITEM_KAT_FOOD){
				MEM_Info(selectedInvItem.description);
				B4DI_Bars_showItemPreview();
			} else {
				if (!areItemPreviewsHidden) {
					B4DI_Bars_hideItemPreview();
				};
			};
			//TODO Disable preview after inventory closed and update on: item used | got dmg | switched Item
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

	MEM_Info("B4DI_Bars_applySettings");
};


//#################################################################
//
//  Hooking Functions to Update bars
//
//#################################################################
//========================================
// ManaBar
//========================================
//update mana Consumtion
func void B4DI_manaBar_hooking_Spell_ProcessMana( var int manaInvested){
	PassArgumentI(manaInvested);
	ContinueCall();
	B4DI_Bars_update();
	B4DI_Info1("B4DI_manaBar_hooking_Spell_ProcessMana called" , manaInvested);
};

//decide which animation of consumtionBar should be chosen
func void B4DI_manaBar_hooking_Spell_ProcessMana_Release( var int manaInvested) {
	PassArgumentI(manaInvested);
	ContinueCall();
	//TODO animations, cancelation of ConsumtionBar
	var int returnValue; returnValue = MEM_PopIntResult();
	If(returnValue == SPL_SENDCAST){
		//enough Mana successfully used
	} else 
	if(returnValue == SPL_SENDSTOP){
		//not enough mana send or just stopped charging
	};
	B4DI_Info1("B4DI_manaBar_hooking_Spell_ProcessMana_Release called" , manaInvested);
};

//========================================
// Inventory
//========================================
func void B4DI_inventory_opend(){
	var C_NPC caller; caller = MEM_PtrToInst(ECX);
	if (Npc_IsPlayer(caller)) {
		isInventoryOpen = true;
		lastSelectedItemName = "none";
		FF_ApplyOnceExtGT(B4DI_Bars_update,0,-1);
		MEM_Info("B4DI_inventory_opend");
	};
};

func void B4DI_inventory_closeHelper() {
	isInventoryOpen = false;
	B4DI_Bars_update(); // call again to make sure status get updated, not necessary i think caus of the FF?
	lastSelectedItemName = "none";
	B4DI_Bars_hideItemPreview(); //maybe redundant?!

	FF_Remove(B4DI_Bars_update);
	MEM_Info("B4DI_inventory_closed");
};

func void B4DI_inventory_closed(){
	var C_NPC caller; caller = MEM_PtrToInst(ECX);
	if (Npc_IsPlayer(caller)) {
		B4DI_inventory_closeHelper();
	};
};

//========================================
// StatusScreen
//========================================
func void B4DI_OpenScreen_Status() {
	MEM_Info("B4DI_OpenScreen_Status called");
	B4DI_xpBar_show();
	if(isInventoryOpen) {
		B4DI_inventory_closeHelper();
	};
};


//========================================
// Fightmode
//========================================
func void B4DI_update_fight_mode(){
	//MEM_Info("B4DI_update_fight_mode");
	//TODO exiting fightmode by opening Inventory
	//Reversed Logic cause calling functions are called themselves AFTER FMODE change
	if( !Npc_IsInFightMode( hero, FMODE_NONE ) ){
		B4DI_Info1("B4DI_update_fight_mode: ENTERING ->", !Npc_IsInFightMode( hero, FMODE_NONE ) );
		//no fight mode is active previously to we are going to active
		//anyFightModeActive = true;
		//closing Inventory by drawing weapon
		if(isInventoryOpen){
			isInventoryOpen = false;
			FF_Remove(B4DI_Bars_update);
		};
	} else if( Npc_IsInFightMode( hero, FMODE_NONE ) ) {
		B4DI_Info1("B4DI_update_fight_mode: EXITING ->", Npc_IsInFightMode( hero, FMODE_NONE ) );
		//exit fightmode by e.g. opening inventory
		//anyFightModeActive = false;
	};
	B4DI_Bars_update();
};

func void B4DI_drawWeapon(){
	//MEM_Info("B4DI_drawWeapon");
	var C_NPC caller; caller = MEM_PtrToInst(ECX);
	if (Npc_IsPlayer(caller)) {
		//B4DI_update_fight_mode();
		B4DI_debugSpy("B4DI_drawWeapon called by: ", caller.name);
	};
};

func void B4DI_oCNpc__SetWeaponMode_custom_branch1(){
	MEM_Info("B4DI_oCNpc__SetWeaponMode_custom_branch1");
	/*var oCNpc caller; caller = MEM_PtrToInst(ECX);
	if (Npc_IsPlayer(caller)) {
		B4DI_debugSpy("B4DI_oCNpc__SetWeaponMode called by: ", caller.name);
		B4DI_debugSpy("B4DI_oCNpc__SetWeaponMode fMode is: ", IntToString(caller.fmode));
	};*/
		B4DI_update_fight_mode();
};

func void B4DI_oCNpc__SetWeaponMode_custom_branch2(){
	MEM_Info("B4DI_oCNpc__SetWeaponMode_custom_branch2");
	/*var oCNpc caller; caller = MEM_PtrToInst(ECX);
	if (Npc_IsPlayer(caller)) {
		B4DI_debugSpy("B4DI_oCNpc__SetWeaponMode called by: ", caller.name);
		B4DI_debugSpy("B4DI_oCNpc__SetWeaponMode fMode is: ", IntToString(caller.fmode));
	};*/
		B4DI_update_fight_mode();
};

func void B4DIoCNpc__SetWeaponMode_custom_branch3(){
	MEM_Info("B4DIoCNpc__SetWeaponMode_custom_branch3");
	/*var oCNpc caller; caller = MEM_PtrToInst(ECX);
	if (Npc_IsPlayer(caller)) {
		B4DI_debugSpy("B4DI_oCNpc__SetWeaponMode called by: ", caller.name);
		B4DI_debugSpy("B4DI_oCNpc__SetWeaponMode fMode is: ", IntToString(caller.fmode));
	};*/
		B4DI_update_fight_mode();
};

func void B4DI_oCNpc__SetWeaponMode2(){
	//MEM_Info("B4DI_drawWeapon");
	var oCNpc caller; caller = MEM_PtrToInst(ECX);
	if (Npc_IsPlayer(caller)) {
		B4DI_debugSpy("B4DI_oCNpc__SetWeaponMode2 called by: ", caller.name);
		B4DI_debugSpy("B4DI_oCNpc__SetWeaponMode2 fMode is: ", IntToString(caller.fmode));
		B4DI_update_fight_mode();
	};
};

func void B4DI_oCNpc__SetWeaponMode2__zSTRING(){
	//MEM_Info("B4DI_drawWeapon");
	var oCNpc caller; caller = MEM_PtrToInst(ECX);
	if (Npc_IsPlayer(caller)) {
		B4DI_debugSpy("B4DI_oCNpc__SetWeaponMode2__zSTRING called by: ", caller.name);
		B4DI_debugSpy("B4DI_oCNpc__SetWeaponMode2__zSTRING fMode is: ", IntToString(caller.fmode));
		B4DI_update_fight_mode();
	};
};

//========================================
// HpBar
//========================================
func void B4DI_oCNpc__OnDamage_Hit(){
	MEM_Info("B4DI_oCNpc__OnDamage_Hit");
	var C_NPC caller; caller = MEM_PtrToInst(ECX);
	//TODO else part for Focusbar update?
	if (Npc_IsPlayer(caller)) {
		heroGotHit = true;
	} else {
		heroGotHit = false;
	};
	B4DI_debugSpy("B4DI_oCNpc__OnDamage_Hit called by: ", caller.name);
};

func void B4DI_oCNpc__OnDamage_Hit_return(){
	MEM_Info("B4DI_oCNpc__OnDamage_Hit_return");
	//TODO else part for Focusbar update?
	if (heroGotHit) {
		//B4DI_update_fight_mode();
		B4DI_Bars_update();
		MEM_Info("B4DI_oCNpc__OnDamage_Hit_return called after hero got hit");
		heroGotHit = false;
	};
};

//========================================
// Spellbook??? What is this?
//========================================
func void B4DI_openSpellbook(){
	B4DI_update_fight_mode();
	MEM_Info("B4DI_openSpellbook");
};

func void B4DI_closeSpellbook(){
	B4DI_update_fight_mode();
	MEM_Info("B4DI_closeSpellbook");
};

//func void B4DI_ChooseWeapon(){
//	B4DI_update_fight_mode();
//	MEM_Info("B4DI_ChooseWeapon");
//};

/*func void B4DI_oCViewDialogInventory_GetSelectedItem(){
	MEM_Info("B4DI_oCViewDialogInventory_GetSelectedItem");
	var oCItem selectedInvItem; selectedInvItem = MEM_PtrToInst(EAX);

	B4DI_debugSpy("B4DI_ITEM_is: ", selectedInvItem.name);
};

func void B4DI_oCItemContainer_GetSelectedItem(){
	MEM_Info("B4DI_oCItemContainer_GetSelectedItem");
	//var oCItem selectedInvItem; selectedInvItem = MEM_PtrToInst(EAX);
	//var oCItem selectedInvItem; selectedInvItem = CALL_RetValAsStructPtr();

	//B4DI_debugSpy("B4DI_ITEM_is: ", selectedInvItem.name);
};

func void B4DI_oCNpcInventory_GetItem(){
	MEM_Info("B4DI_oCNpcInventory_GetItem");
	//var oCItem selectedInvItem; selectedInvItem = MEM_PtrToInst(EAX);
	//var oCItem selectedInvItem; selectedInvItem = CALL_RetValAsStructPtr();

	//B4DI_debugSpy("B4DI_ITEM_is: ", selectedInvItem.name);
};

func void B4DI_oCNpc_GetFromInv(){
	MEM_Info("B4DI_oCNpc_GetFromInv");
	var C_NPC caller; caller = MEM_PtrToInst(ECX);
	if (Npc_IsPlayer(caller)) {
		//var oCItem selectedInvItem; selectedInvItem = MEM_PtrToInst(EAX);
		//var oCItem selectedInvItem; selectedInvItem = CALL_RetValAsStructPtr();
		//B4DI_debugSpy("B4DI_ITEM_is: ", selectedInvItem.name);
		MEM_Info("Called by Player");
	};

};*/


