//////
/// TODO move all changes in LeGo Classes here or at least seperate additions from vanilla LeGo




//#################################################################
//
//  Inventory related
//
//#################################################################
//========================================
// ENGINE CALL
//========================================
func int B4DI_CALL_oCItemContainer__IsActive( var int itm_container_ptr ) {

	CALL__thiscall(itm_container_ptr,oCItemContainer__IsActive_void);
	var int returnValue;
	returnValue = CALL_RetValAsInt();
	
	//B4DI_Info1("B4DI_CALL_oCItemContainer__IsActive return = ", returnValue );

	return returnValue;
};

func int B4DI_CALL_oCMag_Book__GetSelectedSpell() {
	//get oCSpell*
	CALL__thiscall( oHero.mag_book ,oCMag_Book__GetSelectedSpell__void );
	var int returnValue;
	returnValue = CALL_RetValAsPtr();

	B4DI_Info1("B4DI_CALL_oCMag_Book__GetSelectedSpell return = ", returnValue );
	if(!returnValue){ return 0; };
	//get oCItem*
	CALL_PtrParam(returnValue);
	CALL__thiscall( oHero.mag_book, oCMag_Book__GetSpellItem__oCSpell_ptr );
	returnValue = CALL_RetValAsPtr();

	B4DI_Info1("oCMag_Book__GetSpellItem__oCSpell_ptr return = ", returnValue );

	return returnValue;
};

//#################################################################
//PreViews
//#################################################################
func void B4DI_Bars_hideItemPreview() {

	B4DI_eBar_HidePreview(MEM_eBar_HP_handle);
	B4DI_eBar_HidePreview(MEM_eBar_MANA_handle);
	areItemPreviewsHidden = true;

	MEM_Info("B4DI_Bars_hideItemPreview finished");
};


func void B4DI_Bars_showItemPreview() {
	var int index; var STRING type; var int value;

	B4DI_Bars_hideItemPreview(); // hide all previews to prevent old ones to persist if selected remains in valid category // Might not belong here 


	repeat(index, ITM_TEXT_MAX); 
		type = MEM_ReadStatStringArr(selectedInvItem.TEXT,index);
		//MEM_Info( cs2("type: ", type) );

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
		if( STR_Compare(type , NAME_HealingPerCast) == STR_EQUAL ) {
			value = MEM_ReadStatArr(selectedInvItem.COUNT,index);
			MEM_Info("B4DI_Bars_showItemPreview NAME_HealingPerCast");
			B4DI_eBar_ShowPreview(MEM_eBar_HP_handle, value);
		};
		if( STR_Compare(type , NAME_HealingPerMana) == STR_EQUAL ) {
			value = MEM_ReadStatArr(selectedInvItem.COUNT,index);
			MEM_Info("B4DI_Bars_showItemPreview NAME_HealingPerMana");
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
			B4DI_eBar_ShowPreview(MEM_eBar_MANA_handle, -value);
		};
		if( STR_Compare(type , NAME_Manakosten ) == STR_EQUAL ) {
			value = MEM_ReadStatArr(selectedInvItem.COUNT,index);
			MEM_Info("B4DI_Bars_showItemPreview MANA costs");
			B4DI_eBar_ShowPreview(MEM_eBar_MANA_handle, -value);
		};
		if( STR_Compare(type , NAME_MinManakosten ) == STR_EQUAL ) {
			value = MEM_ReadStatArr(selectedInvItem.COUNT,index);
			MEM_Info("B4DI_Bars_showItemPreview MANA MIN costs");
			B4DI_eBar_ShowPreview(MEM_eBar_MANA_handle, -value);
		};
		//TODO think about how this actually works
		if( STR_Compare(type , NAME_Addon_NeedsAllMana ) == STR_EQUAL ) {
			value = B4DI_eBar_GetValue(MEM_eBar_MANA_handle);
			MEM_Info("B4DI_Bars_showItemPreview NEEDS ALL MANA");
			B4DI_eBar_ShowPreview(MEM_eBar_MANA_handle, -value);
		};

	end;

	
};


var int debug_helper_itemContainer_passive;
var int debug_helper_itemContainer_right;
var int debug_helper_itemContainer_invMode;
var int debug_helper_item_index;

func int B4DI_oCItemContainer_GetSelectedItem( var int itemContainer_ptr ) {
	if (!Hlp_Is_oCItemContainer( itemContainer_ptr ) ) { return 0; };
	var oCItemContainer itemContainer; 
	itemContainer = MEM_PtrToInst(itemContainer_ptr);

	var int itm_index; itm_index = itemContainer.selectedItem + 2;
	if(debug_helper_item_index != itm_index ) {
		debug_helper_item_index = itm_index;
		B4DI_Info1("trying to select a oCItemContainer Item at postion <<<<<", itm_index);
	};		//anscheinend sind die ersten beiden items in der List nie belegt.
	//if(debug_helper_itemContainer_passive != itemContainer.passive ) {
	//	debug_helper_itemContainer_passive = itemContainer.passive;
	//	B4DI_Info1("itemContainer.passive <<<<<", itemContainer.passive);
	//};
	//if(debug_helper_item_right != itemContainer.right ) {
	//	debug_helper_item_right = itemContainer.right;
	//	B4DI_Info1("itemContainer.right= ", itemContainer.right);
	//};
	//if(debug_helper_hero_invMode != itemContainer.invMode ) {
	//	debug_helper_hero_invMode = itemContainer.invMode;	
	//	B4DI_Info1("itemContainer.invMode= ", itemContainer.invMode);
	//};
	//ViewPtr_ResizeAdvanced( itemContainer.viewItemInfoItem, PS_VMAX/2, PS_VMAX/2, ANCHOR_CENTER_BOTTOM, VALIDSCREENSPACE, VIEW_NO_SIZE_LIMIT, VIEW_NO_SIZE_LIMIT ); 
	ViewPtr_SetAlpha(itemContainer.viewItemInfoItem, 0);
	ViewPtr_SetAlpha(itemContainer.viewItemInfo, 0);
	ViewPtr_SetAlpha(itemContainer.textView, 0);
	ViewPtr_SetAlpha(itemContainer.viewItemActiveHighlighted, 0);
	


	var zCListSort list; list = MEM_PtrToInst(itemContainer.contents);
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


//=====Inv_GetSelectedItem=====
func int Inv_GetSelectedItem(){
	var int hero_itemContainer_ptr;
	hero_itemContainer_ptr = MEM_InstToPtr(oHero)+1640;
	if( !B4DI_CALL_oCItemContainer__IsActive(hero_itemContainer_ptr) ) { return 0; };
	
	return B4DI_oCItemContainer_GetSelectedItem( hero_itemContainer_ptr );
		
};

func int Inv_GetSelectedMobItem(){
	//continue if a MobContainer is current focus_vob
	if (!focused_MobContainer_ptr) {return 0;};
	//continue if the current focus_vob was used to open the inventory and not just opening the inventory while a chest is in focus
	if (!heroOpenedThisContainer) {return 0;};

	if( !B4DI_CALL_oCItemContainer__IsActive(container_inFocus.items) ) { return 0; };
	opened_ItemContainer = _^(container_inFocus.items);
	
	return B4DI_oCItemContainer_GetSelectedItem(container_inFocus.items);
};




func void B4DI_Bars_Inventory_update() {
	if(isInventoryOpen){
		var int heroHpChanged; heroHpChanged = B4DI_heroHp_changed();
		if( heroHpChanged /*&& !MEM_eBar_Hp.isFadedOut*/ ){
			B4DI_HpBar_Refresh(heroHpChanged);
			MEM_Info("Within Inventory HP Changed");
		};
		var int heroManaChanged; heroManaChanged = B4DI_heroMana_changed();
		if( heroManaChanged /*&& !MEM_eBar_MANA.isFadedOut*/ ){
			B4DI_manaBar_Refresh(heroManaChanged);
		};
		//TODO PROTECT Against invalid Read -> empty inventory think about it further
		var int temp_item_ptr; temp_item_ptr = Inv_GetSelectedItem();
		//B4DI_Info1("temp_item_ptr= ", temp_item_ptr);
				
		var int temp_chest_item_ptr; temp_chest_item_ptr = Inv_GetSelectedMobItem();
		if (temp_item_ptr || temp_chest_item_ptr ) {
			//if chest is in focus overwrite Item,...will cause Issues when inventory opend while chest is in focus but not used
			if(temp_item_ptr) {
				selectedInvItem = _^(temp_item_ptr);

			} else if(temp_chest_item_ptr) {
				selectedInvItem = _^(temp_chest_item_ptr);
				//MEM_Info(selectedInvItem.description);
			};
			//show only preview for new items // description instead of name cause potions are not destinguishable by name, which is "potion" for all
			if( (STR_Compare(lastSelectedItemName, selectedInvItem.description ) != STR_EQUAL) || (heroHpChanged /*!= false*/ ) || (heroManaChanged/* != false*/ ) ) { 
				lastSelectedItemName = selectedInvItem.description;
				MEM_Info(lastSelectedItemName);
				//TODO Filter for bar influencing items What about different types: timed, procentual, absolute
				//TODO pack into preView_Update Function?
				MEM_Info(selectedInvItem.description);
				if(selectedInvItem.mainflag == ITEM_KAT_POTIONS || selectedInvItem.mainflag == ITEM_KAT_FOOD || selectedInvItem.mainflag == ITEM_KAT_RUNE ){
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
			if (!areItemPreviewsHidden) {
				B4DI_Bars_hideItemPreview();
			};
		};

		//B4DI_eBars_SetLabelTop(MEM_eBar_HP_handle);

	} else {
		//Inventory got closed or is just not open
		if (!areItemPreviewsHidden) {
			B4DI_Bars_hideItemPreview(); //close previews after inventory closed
		};
	};

	//B4DI_eBar_RefreshLabel(MEM_eBar_HP_handle);
	//B4DI_eBar_RefreshLabel(MEM_eBar_MANA_handle);

};

func void B4DI_Bars_ShowSpellPreview() {
	var int spell_itm_ptr;
	spell_itm_ptr = B4DI_CALL_oCMag_Book__GetSelectedSpell();
	selectedInvItem = _^(spell_itm_ptr);
	if(selectedInvItem.mainflag == ITEM_KAT_RUNE ){
		B4DI_Bars_showItemPreview();
	};
};

func void B4DI_Bars_HideSpellPreview() {
	B4DI_Bars_hideItemPreview();
	MEM_AssignInstNull(selectedInvItem);
};

//#################################################################
//
//  Update all "normal" Bars
//
//#################################################################

func void B4DI_Bars_update(){
	var int heroHpChanged; heroHpChanged = B4DI_heroHp_changed();
	if( heroHpChanged /*&& !MEM_eBar_Hp.isFadedOut*/ ){
		B4DI_HpBar_Refresh(heroHpChanged);
	};
	var int heroManaChanged; heroManaChanged = B4DI_heroMana_changed();
	if( heroManaChanged /*&& !MEM_eBar_MANA.isFadedOut*/ ){
		B4DI_manaBar_Refresh(heroManaChanged);
	};
	//TODO option on when to show/hide manaBar
	//HP
	if ( (!Npc_IsInFightMode( hero, FMODE_NONE ) || heroHpChanged || isInventoryOpen ) && MEM_eBar_Hp.isFadedOut ) {
		B4DI_HpBar_show();
		
	} else if(Npc_IsInFightMode( hero, FMODE_NONE ) && !heroHpChanged && !isInventoryOpen && !MEM_eBar_Hp.isFadedOut) {
		B4DI_HpBar_hide();
	};
	//Mana
	if( (Npc_IsInFightMode( hero, FMODE_MAGIC ) || heroManaChanged || isInventoryOpen ) && MEM_eBar_MANA.isFadedOut ) {
		B4DI_eBar_show(MEM_eBar_MANA_handle);
		//B4DI_Info1("SpellMana:", oHero.spellMana);
		//Npc_GetActiveSpell(hero); //useless
		B4DI_Bars_ShowSpellPreview();
		

	} else if( !Npc_IsInFightMode( hero, FMODE_MAGIC ) && !heroManaChanged && !isInventoryOpen && !MEM_eBar_MANA.isFadedOut) {
		B4DI_eBar_hideFaded(MEM_eBar_MANA_handle);
		B4DI_Bars_HideSpellPreview();
	};


};

//#################################################################
//
//  Apply changed Settings to all Bars
//
//#################################################################
//TODO make sure it is not called before bars are fully initialized npcRef is correct
func void B4DI_Bars_applySettings() {
	MEM_Info("B4DI_Bars_applySettings <----------- Started");
	B4DI_InitBarScale(); // for resolution dependant scaling

	//Load Ini based menue altered Values
	//dynScalingFactor = B4DI_Bars_getDynamicScaleOptionValuef();
	B4DI_Bars_getFadeOutMinOptionValue();
	B4DI_Bars_getFadeInMaxOptionValuef();
	B4DI_Bars_getbarShowLabelOptionValue();
	B4DI_getEnableEditUIModeOptionValue();


	if( Hlp_IsValidHandle(MEM_eBar_HP_handle) ){
		B4DI_eBar_dynamicMenuBasedScale(MEM_eBar_HP_handle);
		B4DI_HpBar_Refresh(B4DI_eBAR_INTITIAL_REFRESH);
		if(B4DI_barShowLabel){
    	    B4DI_eBar_showLabel(MEM_eBar_HP_handle);
	    } else {
	    	B4DI_eBar_hideLabel(MEM_eBar_HP_handle);
	    };
	};

	if( Hlp_IsValidHandle(MEM_eBar_MANA_handle) ){
		B4DI_eBar_dynamicMenuBasedScale(MEM_eBar_MANA_handle);
		B4DI_manaBar_Refresh(B4DI_eBAR_INTITIAL_REFRESH);
		if(B4DI_barShowLabel){
    	    B4DI_eBar_showLabel(MEM_eBar_MANA_handle);
	    } else {
	    	B4DI_eBar_hideLabel(MEM_eBar_MANA_handle);
	    };
	};

	if( Hlp_IsValidHandle(MEM_eBar_FOCUS_handle) ){
		B4DI_eBar_dynamicMenuBasedScale(MEM_eBar_FOCUS_handle);
		B4DI_focusBar_Refresh(B4DI_eBAR_INTITIAL_REFRESH);
		if(B4DI_barShowLabel){
    	    B4DI_eBar_showLabel(MEM_eBar_FOCUS_handle);
	    } else {
	    	B4DI_eBar_hideLabel(MEM_eBar_FOCUS_handle);
	    };
	};

	if( Hlp_IsValidHandle(MEM_eBar_XP_handle) ){
		B4DI_eBar_dynamicMenuBasedScale(MEM_eBar_XP_handle);
		B4DI_XpBar_calcXp();
		if(!B4DI_barFadeOutMin) {
			B4DI_xpBar_show();
		};
	};

	//TODO Fix FocusBar visiblily caused by AlignmentManger Update
	if( Hlp_IsValidHandle(MEM_mainAlignmentManager_handle) ){
		B4DI_AlignmentManager_UpdateAllSlots( MEM_mainAlignmentManager_handle );		
	};

	if(B4DI_enableEditUIMode && !B4DI_EditUI_enabled) {
		B4DI_EditUI_enable();
	} else if (B4DI_EditUI_enabled) {
		B4DI_EditUI_disable();
	};

	MEM_Info("B4DI_Bars_applySettings <----------- finished");
};





