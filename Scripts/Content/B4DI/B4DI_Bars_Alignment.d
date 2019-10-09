
func void B4DI_AlignmentManager_GetMargin_forSlot( var in aM_hndl, var int alignmentSlot, var int marginSide) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Info("B4DI_AlignManager_SetMargin_Top; Invalid Handle"); return 0; };
	var _alignmentManager aM; aM = get( new_aM_hndl );
	var zCArray aSlot; 
	var int marginValue;

	aSlot = MEM_ReadStatArr( aM.margins_perSlot, alignmentSlot );
	marginValue = MEM_ReadStatArr( aSlot, marginSide);


	if (marginValue == B4DI_ALIGNMENT_MARGIN_USE_DEFAULT) {
		return B4DI_ALIGNMENT_MARGIN_DEFAULT_VALUE; //<---change this maybe per ini?
	};

	return marginValue;

};


func void B4DI_AlignmentManager_SetMargin_forSlot( var in aM_hndl, var int alignmentSlot, var int marginSide, var int marginValue, var func updateHandler ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Info("B4DI_AlignManager_SetMargin_Top; Invalid Handle"); return 0; };
	var _alignmentManager aM; aM = get( new_aM_hndl );
	var zCArray aSlot; 

	aSlot = MEM_ReadStatArr( aM.margins_perSlot, alignmentSlot );
	MEM_WriteStatArr( aSlot, marginSide, marginValue );

	//TODO Update object according to new margin with updateHandler
	//it might be wiser to call here a loop for this alignmentSlot and within this loop the handler
	MEM_Call(updateHandler);

};

func int B4DI_AlignmentManager_Create() {
	var int new_aM_hndl; new_aM_hndl = new(_alignmentManager@);
	var _alignmentManager aM; aM = get(new_aM_hndl);
    

    aM.x_sizelimit_ofObjects_perSlot = new(zCArray@);
    aM.y_sizelimit_ofObjects_perSlot = new(zCArray@);

    var int slot_index; var int margin_index; var int current_slot_margin_array;
    aM.margins_perSlot = new(zCArray@);

    repeat( slot_index, B4DI_ALIGNMENT_SLOT_ARRAY_SIZE );
    	current_slot_margin_array =  new(zCArray@);
    	MEM_WriteStatArr(aM.margins_perSlot, slot_index, current_slot_margin_array);

    	repeat( margin_index, B4DI_ALIGNMENT_SLOT_MARGIN_ARRAY_SIZE );
			MEM_WriteStatArr( current_slot_margin_array, margin_index, B4DI_ALIGNMENT_MARGIN_USE_DEFAULT);
		end;

    	MEM_WriteStatArr(aM.x_sizelimit_ofObjects_perSlot, slot_index, B4DI_ALIGNMENT_SLOT_OBJECTSIZE_NO_LIMIT);
    	MEM_WriteStatArr(aM.y_sizelimit_ofObjects_perSlot, slot_index, B4DI_ALIGNMENT_SLOT_OBJECTSIZE_NO_LIMIT);

    end;


	return new_aM_hndl;

};

func void B4DI_AlignmentManager_InitAlways() {
	if ( !Hlp_IsValidHandle( MEM_mainAlignManager_handle ) ) {
		MEM_Info("B4DI_AlignManager_InitAlways; Creating the Handle");

		MEM_mainAlignmenManager_handle = B4DI_Aligment_Create();
	};
	MEM_mainAlignmentManager = get(MEM_mainAlignmentManager_handle);

	MEM_Info("B4DI_AlignManager_InitAlways finished");	
};

