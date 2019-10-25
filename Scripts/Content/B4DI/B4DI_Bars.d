//////
/// TODO move all changes in LeGo Classes here or at least seperate additions from vanilla LeGo




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
	//B4DI_eBar_RefreshLabel(MEM_eBar_HP_handle);
	//B4DI_eBar_RefreshLabel(MEM_eBar_MANA_handle);
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
//TODO check for other entries that might be selected items in loot/chests
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
		if (temp_item_ptr) {
			selectedInvItem = _^(temp_item_ptr);
			//show only preview for new items // description instead of name cause potions are not destinguishable by name, which is "potion" for all
			if( (STR_Compare(lastSelectedItemName, selectedInvItem.description ) != STR_EQUAL) || (heroHpChanged /*!= false*/ ) || (heroManaChanged/* != false*/ ) ) { 
				lastSelectedItemName = selectedInvItem.description;
				//TODO Filter for bar influencing items What about different types: timed, procentual, absolute
				//TODO pack into preView_Update Function?
				MEM_Info(selectedInvItem.description);
				if(selectedInvItem.mainflag == ITEM_KAT_POTIONS || selectedInvItem.mainflag == ITEM_KAT_FOOD){
					B4DI_Bars_showItemPreview();
				} else {
					if (!areItemPreviewsHidden) {
						B4DI_Bars_hideItemPreview();
					};
				};
			} else {
				//TODO check for preview animation end, repeat
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
	if ( (!Npc_IsInFightMode( hero, FMODE_NONE ) || heroHpChanged || heroManaChanged || isInventoryOpen ) && MEM_eBar_Hp.isFadedOut ) {
		B4DI_eBar_show(MEM_eBar_HP_handle);
		/*if(heroHpChanged ){
			B4DI_HpBar_Refresh(heroHpChanged);
		};*/
		if( (Npc_IsInFightMode( hero, FMODE_MAGIC ) || isInventoryOpen ) && MEM_eBar_MANA.isFadedOut ) {
			B4DI_eBar_show(MEM_eBar_MANA_handle);
			/*if( heroManaChanged ){
				B4DI_manaBar_Refresh(heroManaChanged);
			};*/
			B4DI_Info1("SpellMana:", oHero.spellMana);
		};
	} else if(Npc_IsInFightMode( hero, FMODE_NONE ) && !heroHpChanged && !heroManaChanged && !isInventoryOpen && !MEM_eBar_Hp.isFadedOut) {
		B4DI_eBar_hideFaded(MEM_eBar_MANA_handle);
		B4DI_eBar_hideFaded(MEM_eBar_HP_handle);
	};
	/*if(isInventoryOpen){
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
	};*/
	//MEM_Info("B4DI_Bars_update");
	//B4DI_debugSpy("B4DI_ITEM_is: ", item.nameID);

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





