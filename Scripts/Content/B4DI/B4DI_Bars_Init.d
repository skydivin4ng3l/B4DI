//#################################################################
//
//  BDI Bars: Initialisation & Function Hooks
//
//#################################################################

// called in B4DI_InitOnce
func void B4DI_Bars_InitOnce() {
	//init globals
	MEM_InitGlobalInst ();
	//FMODE_NONE as not in combat 
	B4DI_hpBar_InitOnce();
	B4DI_manaBar_InitOnce();
	HookDaedalusFuncS("B_GivePlayerXP", "B4DI_xpBar_update"); 						// B4DI_xpBar_update(var int add_xp)
	//MEM_Game.pause_screen as a TODO condition
	HookEngine(cGameManager__ApplySomeSettings_rtn, 6, "B4DI_Bars_applySettings");  // B4DI_Bars_applySettings()
	HookEngine(oCNpc__OpenScreen_Status, 7 , "B4DI_xpBar_show"); 					// B4DI_xpBar_show()

	HookEngine(oCNpc__OpenInventory, 6 , "B4DI_inventory_opend");					// B4DI_inventory_opend()
	HookEngine(oCNpc__CloseInventory, 9 , "B4DI_inventory_closed");					// B4DI_inventory_closed()
	//HookEngine(CGameManager__HandleCancelKey, 7 , "B4DI_inventory_closed");			// B4DI_inventory_closed()
	//HookEngine(zCMenuItemInput__HasBeenCanceled, 6 , "B4DI_inventory_closed");			// B4DI_inventory_closed()
	//HookEngine(oCItemContainer__Close, 7 , "B4DI_inventory_closed");			// B4DI_inventory_closed() //works
	HookEngine(oCNpc__CloseDeadNpc, 5 , "B4DI_inventory_closed");			// B4DI_inventory_closed() // does the job the best
	//HookEngine(oCGame__UpdateStatus, 8 , "B4DI_Bars_update"); Cloud be an Option but does not cover draw/sheat weapons, option for focus bar update
	// oCNpc::GetFocusNpc(void) alternative for focus bar

	// B_AssessDamage for damage related show HPbar

	//HookEngine(oCNpc__EV_DrawWeapon, 6, "B4DI_drawWeapon");	// direct draw PC, NPC
	//HookEngine(oCNpc__EV_DrawWeapon1, 5, "B4DI_drawWeapon1"); 	// General Draw PC, NPC
	//HookEngine(oCNpc__EV_DrawWeapon2, 6, "B4DI_drawWeapon2");		// Gernal Draw PC, NPC
	HookEngine(oCNpc__OpenSpellBook, 10, "B4DI_openSpellbook");
	HookEngine(oCNpc__CloseSpellBook, 6, "B4DI_closeSpellbook");
	//HookEngine(oCNpc__EV_ChooseWeapon, 6, "B4DI_ChooseWeapon");

	//HookEngine(oCNpc__EV_RemoveWeapon, 7, "B4DI_removeWeapon"); //will be called by: direct weapon sheath, NPCs
	//HookEngine(oCNpc__EV_RemoveWeapon1, 7, "B4DI_removeWeapon1"); // General sheath PC
	//HookEngine(oCNpc__EV_RemoveWeapon2, 6, "B4DI_removeWeapon2");	// General sheath PC

	HookEngine(oCViewDialogInventory__GetSelectedItem, 6, "B4DI_oCViewDialogInventory_GetSelectedItem");
	//HookEngine(oCItemContainer__GetSelectedItem, 5, "B4DI_oCItemContainer_GetSelectedItem");
	//HookEngine(oCNpcInventory__GetItem, 6, "B4DI_oCNpcInventory_GetItem");
	HookEngine(oCNpc__GetFromInv, 10, "B4DI_oCNpc_GetFromInv");

	HookEngine(oCNpc__SetWeaponMode_custom_branch1, 5, "B4DI_oCNpc__SetWeaponMode_custom_branch1");
	HookEngine(oCNpc__SetWeaponMode_custom_branch2, 5, "B4DI_oCNpc__SetWeaponMode_custom_branch2");
	HookEngine(oCNpc__SetWeaponMode_custom_branch3, 5, "B4DI_oCNpc__SetWeaponMode_custom_branch3");
	//HookEngine(oCNpc__SetWeaponMode, 5, "B4DI_oCNpc__SetWeaponMode");
	//HookEngine(oCNpc__SetWeaponMode2, 6, "B4DI_oCNpc__SetWeaponMode2");
	//HookEngine(oCNpc__SetWeaponMode2__zSTRING, 7, "B4DI_oCNpc__SetWeaponMode2__zSTRING");

	HookEngine(oCNpc__OnDamage_Hit, 7, "B4DI_oCNpc__OnDamage_Hit");
	//HookEngine(oCNpc__OnDamage_Hit_custom, 5, "B4DI_oCNpc__OnDamage_Hit");
	HookEngine(oCNpc__OnDamage_Hit_return, 6, "B4DI_oCNpc__OnDamage_Hit_return"); //B4DI_oCNpc__OnDamage_Hit()
	//HookEngine(oCNpc__UseItem, 7, "B4DI_oCNpc__UseItem");


	MEM_Info("B4DI Bars ininitialised");
};

func void B4DI_Bars_InitAlways() {
	isInventoryOpen = false;
	areItemPreviewsHidden = true;

	B4DI_hpBar_InitAlways();
	B4DI_manaBar_InitAlways();
};
