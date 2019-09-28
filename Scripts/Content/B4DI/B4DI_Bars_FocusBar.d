//#################################################################
//
//  Focus Bar
//
//#################################################################
//TODO somehow add callback hide once focus bar gets hidden,...other hook maybe?
func void B4DI_focusBar_Refresh(var int C_NPC_ptr){
	B4DI_eBar_RefreshNPC(MEM_eBar_FOCUS_handle, ATR_HITPOINTS, ATR_HITPOINTS_MAX, C_NPC_ptr);
};

func void B4DI_hook_UpdatePlayerStatus_return() {
	if ( !isHookF(oCGame__UpdatePlayerStatus_return, B4DI_oCGame__UpdatePlayerStatus_return) ) {
		HookEngineF(oCGame__UpdatePlayerStatus_return, 7, B4DI_oCGame__UpdatePlayerStatus_return); //B4DI_oCGame__UpdatePlayerStatus_return()
	};
};

func void B4DI_unhook_UpdatePlayerStatus_return() {
	if ( isHookF(oCGame__UpdatePlayerStatus_return, B4DI_oCGame__UpdatePlayerStatus_return) ) {
		RemoveHookF(oCGame__UpdatePlayerStatus_return, 7, B4DI_oCGame__UpdatePlayerStatus_return); //B4DI_oCGame__UpdatePlayerStatus_return()
	};
};

func void B4DI_focusBar_update(){
	//MEM_Info("B4DI_focusBar_update called");
	if( Hlp_Is_oCNpc(oHero.focus_vob) ) {
		//MEM_Info("B4DI_focusBar_update Its an NPC!");
		var C_Npc npc_inFocus; npc_inFocus = MEM_PtrToInst(oHero.focus_vob);
		B4DI_focusBar_Refresh(MEM_InstToPtr(npc_inFocus));
		B4DI_debugSpy("npc_inFocus Name: ", npc_inFocus.name);
		B4DI_Info1("npc_inFocus IDX: ", npc_inFocus.id);
		B4DI_Info1("npc_HP: ", npc_inFocus.attribute[ATR_HITPOINTS]);

		//TODO check if it is the same npc than before and check for HP difference for animation
		var int att; att = Npc_GetPermAttitude(hero, npc_inFocus);

		if( Npc_GetID(npc_inFocus) != idOfCurrentFocus || (Npc_GetID(npc_inFocus) == idOfCurrentFocus && att != lastAttitudeOfCurrentFocus) ) {

			idOfCurrentFocus = Npc_GetID(npc_inFocus);
			lastAttitudeOfCurrentFocus = att;
			//TODO customizable when to show FocusBar
			//TODO allow show of focus bar when att towards player changes
			if (att == ATT_FRIENDLY) {
				B4DI_Info1("idOfCurrentFocus: ", idOfCurrentFocus);
				MEM_Info("ATT_FRIENDLY");
				B4DI_eBar_show(MEM_eBar_FOCUS_handle);
				B4DI_hook_UpdatePlayerStatus_return();
			} else if(att == ATT_NEUTRAL)  {   
				B4DI_Info1("idOfCurrentFocus: ", idOfCurrentFocus);
				MEM_Info("ATT_NEUTRAL");
				B4DI_eBar_show(MEM_eBar_FOCUS_handle);
				B4DI_hook_UpdatePlayerStatus_return();

			} else if(att == ATT_ANGRY)    {
				B4DI_Info1("idOfCurrentFocus: ", idOfCurrentFocus);
				MEM_Info("ATT_ANGRY");
				B4DI_eBar_show(MEM_eBar_FOCUS_handle);
				B4DI_hook_UpdatePlayerStatus_return();

			} else if(att == ATT_HOSTILE)  { 
				B4DI_Info1("idOfCurrentFocus: ", idOfCurrentFocus);
				MEM_Info("ATT_HOSTILE");
				B4DI_eBar_show(MEM_eBar_FOCUS_handle);
				B4DI_hook_UpdatePlayerStatus_return();

			};
		};
	} else if(Hlp_Is_oCItem(oHero.focus_vob) ) {
		var c_item itm; itm = MEM_PtrToInst(oHero.focus_vob);
		if( ( Hlp_GetInstanceID(itm) != idOfCurrentFocus ) ) {
			idOfCurrentFocus = Hlp_GetInstanceID(itm);
			B4DI_debugSpy("item_inFocus: ", itm.name);
			B4DI_eBar_hide(MEM_eBar_FOCUS_handle, true);
			B4DI_hook_UpdatePlayerStatus_return();
			// Setze col = RGBA(.., .., .., ..); um die Farbe einzustellen
			//TODO show preview??
		};
	} else {
		MEM_Info("B4DI_focusBar_update else branch");
		if( !MEM_eBar_FOCUS.isFadedOut ) {
			idOfCurrentFocus = 0;
			B4DI_eBar_hide(MEM_eBar_FOCUS_handle, true);
			B4DI_unhook_UpdatePlayerStatus_return();
		};
		//Is a neutral element or nothing?
	};
};

func void B4DI_focusBar_InitAlways(){
	//original bars
	MEM_oBar_Focus = MEM_PtrToInst (MEM_GAME.focusBar); //original
	B4DI_originalBar_hide(MEM_GAME.focusBar);
	// new dBars dynamic
	if(!Hlp_IsValidHandle(MEM_eBar_FOCUS_handle)){
		MEM_eBar_FOCUS_handle = B4DI_eBar_Create(B4DI_FocusBar);
	};
	MEM_eBar_FOCUS = get(MEM_eBar_FOCUS_handle);
	//B4DI_focusBar_Refresh();


	//TODO: Update on option change of Barsize
	//TODO: implement customizable Positions Left Right Top bottom,...
	//TODO: implement a Screen margin
	Bar_MoveLeftUpperToValidScreenSpace(MEM_eBar_FOCUS.bar, MEM_oBar_Focus.zCView_vposx, MEM_oBar_Focus.zCView_vposy );

	idOfCurrentFocus = 0;

	MEM_Info("B4DI_focusBar_InitAlways");
};

func void B4DI_focusBar_InitOnce(){
	MEM_Info("B4DI_focusBar_InitOnce");

};

