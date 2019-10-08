//#################################################################
//
//  Focus Bar
//
//#################################################################
func void B4DI_focusBar_Refresh(var int animated_value_diff){
	B4DI_eBar_RefreshAnimated(MEM_eBar_FOCUS_handle, ATR_HITPOINTS, ATR_HITPOINTS_MAX, animated_value_diff);
};

func void B4DI_focusBar_BindNPC(var int C_NPC_ptr){
	B4DI_eBar_SetNpcRef(MEM_eBar_FOCUS_handle, C_NPC_ptr);
};


func void B4DI_focusBar_show() {
	B4DI_eBar_show(MEM_eBar_FOCUS_handle);
	//B4DI_hook_UpdatePlayerStatus_return();
	FocusBar_update_CallbackActive = true;
};

func void B4DI_focusBar_hide() {
	last_ID_ofFocus = 0;
	B4DI_eBar_hideInstant(MEM_eBar_FOCUS_handle);
	FocusBar_update_CallbackActive = false;
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

// Will be called Twice 
func void B4DI_focusBar_update(){
	//MEM_Info("B4DI_focusBar_update called");
	//B4DI_Info1("B4DI_focusBar_update showPlayerStatus:", MEM_GAME.showPlayerStatus);
	if( Hlp_Is_oCNpc(oHero.focus_vob) && MEM_GAME.showPlayerStatus ) {
		//MEM_Info("B4DI_focusBar_update Its an NPC!");
		var C_Npc npc_inFocus; npc_inFocus = MEM_PtrToInst(oHero.focus_vob);
		var int current_ID_ofFocus; current_ID_ofFocus = Npc_GetID(npc_inFocus);
		// Refresh only when HP Changed or different NPC in Focus
		//TODO check if it is the same npc as before and check for HP difference for animation
		if( !Npc_isDead( npc_inFocus ) ) {

			if (current_ID_ofFocus != last_ID_ofFocus ) {
				B4DI_debugSpy("npc_inFocus Name: ", npc_inFocus.name);
				B4DI_focusBar_BindNPC(oHero.focus_vob);
				B4DI_focusBar_Refresh(B4DI_eBAR_INTITIAL_REFRESH);
				last_ID_ofFocus = Npc_GetID(npc_inFocus);
				B4DI_focusedNpcHP_setLastHP();
			} else if ( current_ID_ofFocus == last_ID_ofFocus ) {
				var int hp_diff; hp_diff = B4DI_focusedNpcHp_changed();
				if ( hp_diff ) {
					//Mark for animation
					B4DI_focusBar_Refresh(hp_diff);
				};
			};
			//B4DI_Info1("npc_HP: ", npc_inFocus.attribute[ATR_HITPOINTS]);

			
			var int att; att = Npc_GetPermAttitude(hero, npc_inFocus);
			if ( B4DI_focusBar_handleAttitude(att) && !npc_inFocus.noFocus ) {
				//TODO Customizeable if focus is present at all / only in Combat?
				B4DI_focusBar_show();
				//TODO Animated If marked for?? maybe better in refresh function?
			} else {
				//B4DI_eBar_hideInstant(MEM_eBar_FOCUS_handle);
				B4DI_focusBar_hide();

			};
			
		} else {
			//MEM_Info("I am an NPC but DEAD ");
			//TODO Check for avilable loot?
			B4DI_focusBar_hide();
			//B4DI_eBar_hideInstant(MEM_eBar_FOCUS_handle);
		};
	} else if(Hlp_Is_oCItem(oHero.focus_vob) && MEM_GAME.showPlayerStatus ) {
		var c_item itm; itm = MEM_PtrToInst(oHero.focus_vob);
		if( ( Hlp_GetInstanceID(itm) != last_ID_ofFocus ) ) {
			B4DI_debugSpy("item_inFocus: ", itm.name);
			last_ID_ofFocus = Hlp_GetInstanceID(itm);
			B4DI_eBar_hideInstant(MEM_eBar_FOCUS_handle);
			// Setze col = RGBA(.., .., .., ..); um die Farbe einzustellen
			//TODO show preview??
		} else{ 
			
		};
	//Is a neutral element / Callback of StatusUpdate Return / dialog
	} else {
		MEM_Info("B4DI_focusBar_update else branch");
		B4DI_focusBar_hide();
	};
};

func void B4DI_focusBar_InitAlways(){
	//original bars
	MEM_oBar_Focus = MEM_PtrToInst (MEM_GAME.focusBar); //original
	//B4DI_originalBar_hide(MEM_GAME.focusBar);
	// new dBars dynamic
	if(!Hlp_IsValidHandle(MEM_eBar_FOCUS_handle)){
		MEM_Info("B4DI_focusBar_InitAlways: Creating an FOCUS Bar Handle");
		MEM_eBar_FOCUS_handle = B4DI_eBar_CreateAsReplacement(B4DI_FocusBar, MEM_GAME.focusBar );
	};
	MEM_eBar_FOCUS = get(MEM_eBar_FOCUS_handle);
	//B4DI_focusBar_Refresh();


	//TODO: Update on option change of Barsize
	//TODO: implement customizable Positions Left Right Top bottom,...
	//TODO: implement a Screen margin
	//Bar_MoveLeftUpperToValidScreenSpace(MEM_eBar_FOCUS.bar, MEM_oBar_Focus.zCView_vposx, MEM_oBar_Focus.zCView_vposy );

	last_ID_ofFocus = 0;
	lastNpcHP = 0;
	FocusBar_update_CallbackActive = 0;

	MEM_Info("B4DI_focusBar_InitAlways");
};

func void B4DI_focusBar_InitOnce(){
	MEM_Info("B4DI_focusBar_InitOnce");

};

