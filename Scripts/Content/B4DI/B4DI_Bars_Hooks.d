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
	B4DI_Info1("B4DI_manaBar_hooking_Spell_ProcessMana called " , manaInvested);
};

//decide which animation of consumtionBar should be chosen
func void B4DI_manaBar_hooking_Spell_ProcessMana_Release( var int manaInvested) {
	PassArgumentI(manaInvested);
	ContinueCall();
	//TODO animations, cancelation of ConsumtionBar
	var int returnValue; returnValue = MEM_PopIntResult();
	if( returnValue == SPL_SENDCAST ) {
		//enough Mana successfully used
	} else {
		if( returnValue == SPL_SENDSTOP ){
		//not enough mana send or just stopped charging
		};
	};
	B4DI_Info1("B4DI_manaBar_hooking_Spell_ProcessMana_Release called " , manaInvested);
};

func void B4DI_oCNpc__UnreadySpell() {
	MEM_Info("B4DI_oCNpc__UnreadySpell");
};

func void B4DI_oCNpc__ReadySpell(){
	MEM_Info("B4DI_oCNpc__ReadySpell");

};

func void B4DI_oCSpell__Cast_return(){
	MEM_Info("B4DI_oCSpell__Cast_return");
	//B4DI_Bars_update();
};

func void B4DI_oCGame__UpdatePlayerStatus_manaBar() {
	//MEM_Info("B4DI_oCGame__UpdatePlayerStatus_manaBar");
	if (!isInventoryOpen) {
		B4DI_Bars_update();	
	};
};

//========================================
// FocusBar
//========================================
func void B4DI_oCGame__UpdatePlayerStatus(){
	//MEM_Info("B4DI_oCGame__UpdatePlayerStatus called");
	B4DI_focusBar_update();
	//MEM_Info("B4DI_oCGame__UpdatePlayerStatus finished");
};

func void B4DI_oCGame__UpdatePlayerStatus_FocusBar(){
	//MEM_Info("B4DI_oCGame__UpdatePlayerStatus_FocusBar called");
	//B4DI_focusBar_update();
	//MEM_Info("B4DI_oCGame__UpdatePlayerStatus_FocusBar finished");
};

//========================================
// Bar Callback after Playerstatus got updated
//========================================
func void B4DI_oCGame__UpdatePlayerStatus_return(){
	//MEM_Info("B4DI_oCGame__UpdatePlayerStatus_return called");
	if (FocusBar_update_CallbackActive) {
		B4DI_focusBar_update();
	};
	if (B4DI_HpBar_update_CallbackActive) {
		B4DI_Bars_update();
	};
	//MEM_Info("B4DI_oCGame__UpdatePlayerStatus_return finished");
};

//========================================
// Inventory
//========================================
func void B4DI_inventory_opend(){
	var C_NPC caller; caller = MEM_PtrToInst(ECX);
	if (Npc_IsPlayer(caller)) {
		isInventoryOpen = true;
		lastSelectedItemName = "none";
		//B4DI_Bars_update();
		B4DI_eBar_show(MEM_eBar_HP_handle);
		B4DI_eBar_show(MEM_eBar_MANA_handle);
		if(!B4DI_barShowLabel){
			B4DI_eBar_showLabel(MEM_eBar_HP_handle);
			B4DI_eBar_showLabel(MEM_eBar_MANA_handle);
		};

		//FF_ApplyOnceExtGT(B4DI_Bars_update,50,-1);
		FF_ApplyOnceExtGT(B4DI_Bars_Inventory_update, 50,-1);
		MEM_Info("B4DI_inventory_opend");
	};
};

func void B4DI_inventory_closeHelper() {
	FF_Remove(B4DI_Bars_Inventory_update);
	//FF_Remove(B4DI_Bars_update);
	isInventoryOpen = false;
	lastSelectedItemName = "none";
	B4DI_Bars_Inventory_update();
	//B4DI_Bars_update(); // call again to make sure status get updated, not necessary i think caus of the FF?
	B4DI_eBar_hideFaded(MEM_eBar_HP_handle);
	B4DI_eBar_hideFaded(MEM_eBar_MANA_handle);
	if(!B4DI_barShowLabel){
		B4DI_eBar_hideLabel(MEM_eBar_HP_handle);
		B4DI_eBar_hideLabel(MEM_eBar_MANA_handle);
	};
	
	//B4DI_Bars_hideItemPreview(); //maybe redundant?!

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
	//Reversed Logic cause calling functions are called themselves AFTER FMODE change
	if( !Npc_IsInFightMode( hero, FMODE_NONE ) ){
		B4DI_Info1("B4DI_update_fight_mode: ENTERING ->", !Npc_IsInFightMode( hero, FMODE_NONE ) );
		//no fight mode is active previously to we are going to active
		//closing Inventory by drawing weapon
		if(isInventoryOpen){
			B4DI_inventory_closeHelper();
			return;
		};
	} else if( Npc_IsInFightMode( hero, FMODE_NONE ) ) {
		B4DI_Info1("B4DI_update_fight_mode: EXITING ->", Npc_IsInFightMode( hero, FMODE_NONE ) );
		//exit fightmode by e.g. opening inventory or sheating weapon
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

func void B4DI_oCNpc__SetWeaponMode_Ninja_GFA(){
	MEM_Info("B4DI_oCNpc__SetWeaponMode_Ninja_GFA");
	var oCNpc caller; caller = MEM_PtrToInst(ECX);
	if (Npc_IsPlayer(caller)) {
		B4DI_debugSpy("B4DI_oCNpc__SetWeaponMode_Ninja_GFA called by: ", caller.name);
		B4DI_debugSpy("B4DI_oCNpc__SetWeaponMode_Ninja_GFA fMode is: ", IntToString(caller.fmode));
		B4DI_update_fight_mode();
	};
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
// HpBar/FocusBar
//========================================
func void B4DI_oCNpc__OnDamage_Hit(){
	//MEM_Info("B4DI_oCNpc__OnDamage_Hit");
	var C_NPC caller; caller = MEM_PtrToInst(ECX);
	//Setting Variables for HP/Focus Bar update in B4DI_oCNpc__OnDamage_Hit_return
	if (Npc_IsPlayer(caller)) {
		heroGotHit = true;
	} else {
		heroGotHit = false;
		var int callerID; callerID = Npc_GetID(caller);
		//B4DI_Info1("callerID: ",callerID);
		if (callerID == last_ID_ofFocus){
			enemyInFocusGotHit = true;
		};
	};
	//B4DI_debugSpy("B4DI_oCNpc__OnDamage_Hit called by: ", caller.name);
};

func void B4DI_oCNpc__OnDamage_Hit_return(){
	//MEM_Info("B4DI_oCNpc__OnDamage_Hit_return");
	//TODO else part for Focusbar update?
	if (heroGotHit) {
		//B4DI_update_fight_mode();
		B4DI_Bars_update(); //might have to call this twice to fade out again after hit register
		//MEM_Info("B4DI_oCNpc__OnDamage_Hit_return called after hero got hit");
		heroGotHit = false;
	};
	if(enemyInFocusGotHit) { 
		B4DI_focusBar_update(); //Maybe just refresh the bar instead?
		//MEM_Info("B4DI_oCNpc__OnDamage_Hit_return called after enemy in Focus got hit");
		enemyInFocusGotHit = false;
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

//========================================
// DialogCam
//========================================

func void B4DI_oCNpc__ActivateDialogCam(){
	MEM_Info("B4DI_oCNpc__ActivateDialogCam");
};

func void B4DI_oCNpc__DeactivateDialogCam(){
	MEM_Info("B4DI_oCNpc__DeactivateDialogCam");
};

//========================================
// Apply Settings Return
//========================================
func void B4DI_cGameManager__ApplySomeSettings_rtn(){
	B4DI_Info1("B4DI_cGameManager__ApplySomeSettings_rtn: B4DI_BARS_INITIALIZED_ALWAYS= ", B4DI_BARS_INITIALIZED_ALWAYS );
	if(B4DI_BARS_INITIALIZED_ALWAYS) { //<--- useless for after hot load
		FF_ApplyOnceExt(B4DI_Bars_applySettings, 1, 1); 
		//B4DI_Bars_applySettings();
	};
};

