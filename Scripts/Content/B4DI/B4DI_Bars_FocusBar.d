//#################################################################
//
//  Focus Bar
//
//#################################################################
func void B4DI_focusBar_show() {
	B4DI_eBar_show(MEM_eBar_FOCUS_handle);
	//B4DI_hook_UpdatePlayerStatus_return();
	FocusBar_update_CallbackActive = true;
};

func void B4DI_focusBar_hide() {
	last_focused_NpcID = 0;
	B4DI_eBar_hideInstant(MEM_eBar_FOCUS_handle);
	B4DI_eBar_ClearNpcRef(MEM_eBar_FOCUS_handle);
	FocusBar_update_CallbackActive = false;
};

func void B4DI_focus_Set_focusedItem(var int c_itm_ptr) {
	var c_item itm; itm = MEM_PtrToInst(oHero.focus_vob);
	if( ( Hlp_GetInstanceID(itm) != last_focused_ItemID ) ) {
		B4DI_debugSpy("item_inFocus: ", itm.name);
		last_focused_ItemID = Hlp_GetInstanceID(itm);
		
		FocusedItem_update_CallbackActive = true;
		
		// Setze col = RGBA(.., .., .., ..); um die Farbe einzustellen
		//TODO show preview??
	} else{ 
		//same item
	};

};

func void B4DI_focus_Reset_focusedItem() {
	last_focused_ItemID = 0;
	FocusedItem_update_CallbackActive = false;
};

func void B4DI_focus_Set_focusedMobContainer(var int mobContainer_ptr) {
	if( mobContainer_ptr != focused_MobContainer_ptr ) {
		focused_MobContainer_ptr = mobContainer_ptr;
		container_inFocus = MEM_PtrToInst(mobContainer_ptr);
		B4DI_debugSpy("Chest in Focus= ", container_inFocus._oCMob_name);
		B4DI_Info1("Chest in Focus PTR= ", focused_MobContainer_ptr);
		B4DI_Info1("Chest in Focus HashIndex= ", container_inFocus._zCObject_hashIndex);
		FocusedMobContainer_update_CallbackActive = true;
	} else {

	};
};

func void B4DI_focus_Reset_focusedMobContainer() {
	focused_MobContainer_ptr = 0;
	MEM_AssignInstNull(container_inFocus);
	FocusedMobContainer_update_CallbackActive = false;	
};

func void B4DI_focusBar_Refresh(var int animated_value_diff){
	B4DI_eBar_RefreshAnimated( MEM_eBar_FOCUS_handle, ATR_HITPOINTS, ATR_HITPOINTS_MAX, animated_value_diff );
	B4DI_Info1("B4DI_focusBar_Refresh: MEM_eBar_FOCUS.npcRef= ", MEM_eBar_FOCUS.npcRef);
	if(!MEM_eBar_FOCUS.npcRef){
		B4DI_focusBar_hide();
	};
};

func void B4DI_focusBar_BindNPC(var int C_NPC_ptr){
	B4DI_eBar_SetNpcRef(MEM_eBar_FOCUS_handle, C_NPC_ptr);
};

func int B4DI_focusBar_handleAttitude(var int attitude) {
	if ( attitude == ATT_FRIENDLY && B4DI_FOCUSBAR_SHOW_ATT_FRIENDLY) {
		//MEM_Info("ATT_FRIENDLY");
		return true;

	} else if( attitude == ATT_NEUTRAL && B4DI_FOCUSBAR_SHOW_ATT_NEUTRAL )  {   
		//MEM_Info("ATT_NEUTRAL");
		return true;

	} else if( attitude == ATT_ANGRY && B4DI_FOCUSBAR_SHOW_ATT_ANGRY )    {
		//MEM_Info("ATT_ANGRY");
		return true;

	} else if( attitude == ATT_HOSTILE && B4DI_FOCUSBAR_SHOW_ATT_HOSTILE )  { 
		//MEM_Info("ATT_HOSTILE");
		return true;
	};
	//don't show focusbar based on selected options on attitudes
	return false;
};

func int B4DI_focusedNpcHp_changed(){
	var C_Npc npc_inFocus; npc_inFocus = MEM_PtrToInst(oHero.focus_vob);
	var int HpDifference; HpDifference = npc_inFocus.attribute[ATR_HITPOINTS]-lastNpcHP;
	if (HpDifference) {
		lastNpcHP = npc_inFocus.attribute[ATR_HITPOINTS];
		B4DI_debugSpy( "B4DI_focusBar_focusedNpcHp_changed: ", IntToString(HpDifference) );
		return HpDifference;
	} else {
		return false;
	};
};

func void B4DI_focusedNpcHP_setLastHP(){
	var C_Npc npc_inFocus; npc_inFocus = MEM_PtrToInst(oHero.focus_vob);
	lastNpcHP = npc_inFocus.attribute[ATR_HITPOINTS];
};

// Will be called Twice if (FocusBar_update_CallbackActive) begin and end of updatePlayerStatus
func void B4DI_focusBar_update(){
	//MEM_Info("B4DI_focusBar_update called");
	//B4DI_Info1("B4DI_focusBar_update showPlayerStatus:", MEM_GAME.showPlayerStatus);
	if( Hlp_Is_oCNpc(oHero.focus_vob) && MEM_GAME.showPlayerStatus ) {
		//MEM_Info("B4DI_focusBar_update Its an NPC!");
		B4DI_focus_Reset_focusedMobContainer();
		B4DI_focus_Reset_focusedItem();

		var C_Npc npc_inFocus; npc_inFocus = MEM_PtrToInst(oHero.focus_vob);
		var int current_ID_ofFocus; current_ID_ofFocus = Npc_GetID(npc_inFocus);
		if( !Npc_isDead( npc_inFocus ) ) {

			if (current_ID_ofFocus != last_focused_NpcID ) {
				B4DI_debugSpy("npc_inFocus Name: ", npc_inFocus.name);
				B4DI_focusBar_BindNPC(oHero.focus_vob);
				B4DI_focusBar_Refresh(B4DI_eBAR_INTITIAL_REFRESH);
				last_focused_NpcID = Npc_GetID(npc_inFocus);
				B4DI_focusedNpcHP_setLastHP();
			} else if ( current_ID_ofFocus == last_focused_NpcID ) {
				var int hp_diff; hp_diff = B4DI_focusedNpcHp_changed();
				if ( hp_diff ) {
					//with animation
					B4DI_focusBar_Refresh(hp_diff);
				};
			};

			
			var int att; att = Npc_GetPermAttitude(hero, npc_inFocus);
			if ( B4DI_focusBar_handleAttitude(att) && !npc_inFocus.noFocus ) {
				//TODO Customizeable if focus is present at all / only in Combat?
				B4DI_focusBar_show();
			} else {
				B4DI_focusBar_hide();

			};
			
		} else {
			//MEM_Info("I am an NPC but DEAD ");
			//TODO Check for avilable loot?
			B4DI_focusBar_hide();
		};

	} else if(Hlp_Is_oCItem(oHero.focus_vob) && MEM_GAME.showPlayerStatus ) {
		B4DI_focusBar_hide();
		B4DI_focus_Reset_focusedMobContainer();
	
		B4DI_focus_Set_focusedItem(oHero.focus_vob);
		
	//Is a neutral element / Callback of StatusUpdate Return / dialog
	} else if( Hlp_Is_oCMobContainer(oHero.focus_vob) && MEM_GAME.showPlayerStatus ) {
		//MEM_Info("B4DI_focusBar_update else branch");
		B4DI_focusBar_hide();
		B4DI_focus_Reset_focusedItem();

		B4DI_focus_Set_focusedMobContainer(oHero.focus_vob);
		
	} else {
		B4DI_focusBar_hide();
		B4DI_focus_Reset_focusedItem();
		B4DI_focus_Reset_focusedMobContainer();
	};
};

func void B4DI_focusBar_InitAlways(){
	//original bars
	MEM_oBar_Focus = MEM_PtrToInst (MEM_GAME.focusBar); //original
	B4DI_originalBar_hide(MEM_GAME.focusBar);
	// new eBar
	if(!Hlp_IsValidHandle(MEM_eBar_FOCUS_handle)){
		MEM_Info("B4DI_focusBar_InitAlways: Creating an FOCUS Bar Handle");
		MEM_eBar_FOCUS_handle = B4DI_eBar_CreateAsReplacement(B4DI_FocusBar, MEM_GAME.focusBar );
	};
	MEM_eBar_FOCUS = get(MEM_eBar_FOCUS_handle);
	//B4DI_eBar_Bar_SetTitleString(MEM_eBar_FOCUS_handle, B4DI_GetMenuItemText("MENUITEM_GAME_FIGHTFOCUS",0));
	//Reset npcRef
	B4DI_eBar_ClearNpcRef(MEM_eBar_FOCUS_handle);
	//B4DI_focusBar_Refresh();

	last_focused_NpcID = 0;
	lastNpcHP = 0;
	FocusBar_update_CallbackActive = false;
	B4DI_focus_Reset_focusedItem();
	B4DI_focus_Reset_focusedMobContainer();

	MEM_Info("B4DI_focusBar_InitAlways");
};

func void B4DI_focusBar_InitOnce(){
	MEM_Info("B4DI_focusBar_InitOnce");

};

