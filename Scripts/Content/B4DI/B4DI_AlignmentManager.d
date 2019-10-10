


//========================================
// [intern] get decicated slot sign
//========================================
func int B4DI_AligmentManager_GetSlotSign( var int alignmentSlot, var int axis ) {
	var int sign;
	if( alignmentSlot == B4DI_ALIGNMENT_LEFT_TOP ) {
		sign = 1;
	} else if ( alignmentSlot == B4DI_ALIGNMENT_LEFT_BOTTOM ) {
		if(axis == PS_X) { sign = 1; } else
		if(axis == PS_Y) { sign = -1; };

	} else if ( alignmentSlot == B4DI_ALIGNMENT_RIGHT_TOP ) {
		if(axis == PS_X) { sign = -1; } else
		if(axis == PS_Y) { sign = 1; };

	} else if ( alignmentSlot == B4DI_ALIGNMENT_RIGHT_BOTTOM ) {
		if(axis == PS_X) { sign = -1; } else
		if(axis == PS_Y) { sign = -1; };

	} else if ( alignmentSlot == B4DI_ALIGNMENT_CENTER ) {
		if(axis == PS_X) { sign = 1; } else
		if(axis == PS_Y) { sign = 1; };

	} else if ( alignmentSlot == B4DI_ALIGNMENT_CENTER_TOP ) {
		if(axis == PS_X) { sign = 1; } else
		if(axis == PS_Y) { sign = 1; };

	} else if ( alignmentSlot == B4DI_ALIGNMENT_CENTER_BOTTOM ) {
		if(axis == PS_X) { sign = 1; } else
		if(axis == PS_Y) { sign = -1; };

	} else if ( alignmentSlot == B4DI_ALIGNMENT_CENTER_LEFT ) {
		if(axis == PS_X) { sign = 1; } else
		if(axis == PS_Y) { sign = 1; };

	} else if ( alignmentSlot == B4DI_ALIGNMENT_CENTER_RIGHT ) {
		if(axis == PS_X) { sign = -1; } else
		if(axis == PS_Y) { sign = 1; };

	}; 

	return sign;
};

//========================================
// [intern] get decicated slot startPosition
//========================================
func int B4DI_AligmentManager_GetStartPosition( var int aM_hndl, var int alignmentSlot, var int axis ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Warn("B4DI_AligmentManager_GetStartPosition; Invalid Handle"); return 0; };
	var _alignmentManager aM; aM = get( new_aM_hndl );

	//TODO add Margin
	var zCArray marginArray;
	marginArray = MEM_ReadStatArr(aM.margins_perSlot, alignmentSlot);
	var int margin_x; margin_x = MEM_ReadStatArr(marginArray, PS_X);
	var int margin_y; margin_y = MEM_ReadStatArr(marginArray, PS_Y);

	var int startValue;
	if( alignmentSlot == B4DI_ALIGNMENT_LEFT_TOP ) {
		if(axis == PS_X) { startValue = 0 + margin_x; } else
		if(axis == PS_Y) { startValue = 0 + margin_y; };

	} else if ( alignmentSlot == B4DI_ALIGNMENT_LEFT_BOTTOM ) {
		if(axis == PS_X) { startValue = 0 + margin_x; } else
		if(axis == PS_Y) { startValue = PS_VMAX - margin_y; };

	} else if ( alignmentSlot == B4DI_ALIGNMENT_RIGHT_TOP ) {
		if(axis == PS_X) { startValue = PS_VMAX - margin_x; } else
		if(axis == PS_Y) { startValue = 0 + margin_y; };

	} else if ( alignmentSlot == B4DI_ALIGNMENT_RIGHT_BOTTOM ) {
		if(axis == PS_X) { startValue = PS_VMAX - margin_x; } else
		if(axis == PS_Y) { startValue = PS_VMAX - margin_y; };

	} else if ( alignmentSlot == B4DI_ALIGNMENT_CENTER ) {
		//TODO for center take list size into account?
		if(axis == PS_X) { startValue = PS_VMAX/2; } else
		if(axis == PS_Y) { startValue = PS_VMAX/2; };

	} else if ( alignmentSlot == B4DI_ALIGNMENT_CENTER_TOP ) {
		if(axis == PS_X) { startValue = PS_VMAX/2; } else
		if(axis == PS_Y) { startValue = 0 + margin_y; };

	} else if ( alignmentSlot == B4DI_ALIGNMENT_CENTER_BOTTOM ) {
		if(axis == PS_X) { startValue = PS_VMAX/2; } else
		if(axis == PS_Y) { startValue = PS_VMAX - margin_y; };

	} else if ( alignmentSlot == B4DI_ALIGNMENT_CENTER_LEFT ) {
		//TODO for center take list size into account?
		if(axis == PS_X) { startValue = 0 + margin_x; } else
		if(axis == PS_Y) { startValue = PS_VMAX/2; };

	} else if ( alignmentSlot == B4DI_ALIGNMENT_CENTER_RIGHT ) {
		//TODO for center take list size into account?
		if(axis == PS_X) { startValue = PS_VMAX - margin_x; } else
		if(axis == PS_Y) { startValue = PS_VMAX/2; };

	}; 

	return startValue;
};

//========================================
// [intern] Call updateHandler
//========================================
func void B4DI_AlignmentManager_Update_CallPositionHandler( var int obj_hndl, var int vposx, var int vposy, var func positionHandler ) {
	if ( !Hlp_IsValidHandle( obj_hndl ) ) { MEM_Warn("B4DI_AlignmentManager_Update_CallPositionHandler; Invalid Handle"); return; };
	
	MEM_PushIntParam(obj_hndl);
	MEM_PushIntParam(vposx);
	MEM_PushIntParam(vposy);

	MEM_Call(positionHandler);
};

//========================================
// [intern] Call getSizeHandler
//========================================
func int B4DI_AlignmentManager_Update_CallGetSizeHandler( var int obj_hndl, var int axis, var func getSizeHandler ) {
	if ( !Hlp_IsValidHandle( obj_hndl ) ) { MEM_Warn("B4DI_AlignmentManager_Update_CallGetSizeHandler; Invalid Handle"); return 0; };
	
	MEM_PushIntParam(obj_hndl);
	MEM_PushIntParam(axis);

	MEM_Call(positionHandler);

	result = MEM_PopIntResult;

	return result;
};

//========================================
// AlignmentManager Update Objects of Slot
//========================================
//TODO: add abstraction Layer for Objects with position and size function pointers for the actual object with size of Objects exposed
func void B4DI_AlignmentManager_UpdateSlotObjects( var int aM_hndl, var int alignmentSlot, var func updateHandler, var func getSizeHandler ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Warn("B4DI_AlignmentManager_UpdateSlotObjects; Invalid Handle"); return; };
	var _alignmentManager aM; aM = get( new_aM_hndl );

	var int slot_list_ptr;
	var int list_size;

	slot_list_ptr = MEM_ReadStatArr( aM.alignmentSlots, alignmentSlot );
	list_size = List_Length(slot_list_ptr);

	if( !list_size ) { MEM_Info("B4DI_AlignmentManager_UpdateSlotObjects: No Objects"); return; }

	var int next_xPosition; next_xPosition = B4DI_AligmentManager_GetStartValue( aM_hndl, alignmentSlot, PS_X );
	var int next_yPosition; next_yPosition = B4DI_AligmentManager_GetStartValue( aM_hndl, alignmentSlot, PS_Y );

	var zCArray marginArray; marginArray = MEM_ReadStatArr( aM.margins_perSlot, alignmentSlot );
	var int margin_betweenObjects; margin_betweenObjects = MEM_ReadStatArr( marginArray, B4DI_ALIGNMENT_SLOT_MARGIN_Y_BETWEENOBJECTS );

	var int x_sign; x_sign = B4DI_AligmentManager_GetSlotMultiplier(alignmentSlot, PS_X);
	var int y_sign; y_sign = B4DI_AligmentManager_GetSlotMultiplier(alignmentSlot, PS_Y);

	var int current_obj_hndl;
	var int current_obj_vsizex;
	var int current_obj_vsizey;
	
	var int index;
	repeat( index, list_size );
		current_obj_hndl = List_Get(slot_list_ptr, index);

		B4DI_AlignmentManager_Update_CallPositionHandler(current_obj_hndl, next_xPosition, next_yPosition, updateHandler );
		current_obj_vsizex = B4DI_AlignmentManager_Update_CallGetSizeHandler(current_obj_hndl, PS_X, getSizeHandler);
		current_obj_vsizey = B4DI_AlignmentManager_Update_CallGetSizeHandler(current_obj_hndl, PS_Y, getSizeHandler);
		next_xPosition += x_sign * current_obj_vsizex;
		next_yPosition += y_sign * ( current_obj_vsizey + margin_betweenObjects);

	end;
};

//========================================
// AlignmentManager Add Object to Slot
//========================================
func void B4DI_AligmentManager_AddtoSlot( var int aM_hndl, var int alignmentSlot, var obj_hndl ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) || !Hlp_IsValidHandle( obj_hndl ) ) { MEM_Warn("B4DI_AligmentManager_AddtoSlot; Invalid Handle"); return; };
	var _alignmentManager aM; aM = get( new_aM_hndl );
	
	var int slot_list_ptr; 
	slot_list_ptr = MEM_ReadStatArr(aM.alignmentSlots, alignmentSlot);
	if (!slot_list_ptr) {
		slot_list_ptr = List_Create(obj_hndl);

	} else {
		List_Add(slot_list_ptr, obj_hndl);
	};

	MEM_WriteStatArr(aM.alignmentSlots, alignmentSlot, slot_list_ptr );

	//TODO Update Objects of Slot
	B4DI_AlignmentManager_UpdateSlotObjects( aM_hndl, alignmentSlot, updateHandler, getSizeHandler );
};

//========================================
// size Limit of each Object per Slot Get/Set
//========================================
func void B4DI_AlignmentManager_GetSizeLimit_forSlot( var in aM_hndl, var int alignmentSlot, var int Axis) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Info("B4DI_AlignManager_SetMargin_Top; Invalid Handle"); return 0; };
	var _alignmentManager aM; aM = get( new_aM_hndl );
	var zCArray aSlot; 
	var int sizeLimit;

	aSlot = MEM_ReadStatArr( aM.sizelimits_ofObjects_perSlot, alignmentSlot );
	sizeLimit = MEM_ReadStatArr( aSlot, Axis);


	if (sizeLimit == B4DI_ALIGNMENT_SLOT_OBJECTSIZE_NO_LIMIT) {
		return VIEW_NO_SIZE_LIMIT; //<---change this maybe per ini?
	};

	return sizeLimit;

};


func void B4DI_AlignmentManager_SetSizeLimit_forSlot( var in aM_hndl, var int alignmentSlot, var int Axis, var int sizeLimitValue, var func updateHandler ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Info("B4DI_AlignManager_SetMargin_Top; Invalid Handle"); return 0; };
	var _alignmentManager aM; aM = get( new_aM_hndl );
	var zCArray aSlot; 

	aSlot = MEM_ReadStatArr( aM.sizelimits_ofObjects_perSlot, alignmentSlot );
	MEM_WriteStatArr( aSlot, Axis, sizeLimitValue );

	//TODO Update object according to new margin with updateHandler
	//it might be wiser to call here a loop for this alignmentSlot and within this loop the handler
	B4DI_AlignmentManager_UpdateSlotObjects( aM_hndl, alignmentSlot, updateHandler, getSizeHandler );

};

//========================================
// Margin Get/Set
//========================================
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


func void B4DI_AlignmentManager_SetMargin_forSlot( var in aM_hndl, var int alignmentSlot, var int marginSide, var int marginValue ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Info("B4DI_AlignManager_SetMargin_Top; Invalid Handle"); return 0; };
	var _alignmentManager aM; aM = get( new_aM_hndl );
	var zCArray aSlot; 

	aSlot = MEM_ReadStatArr( aM.margins_perSlot, alignmentSlot );
	MEM_WriteStatArr( aSlot, marginSide, marginValue );

	//TODO Update object according to new margin with updateHandler
	//it might be wiser to call here a loop for this alignmentSlot and within this loop the handler
	B4DI_AlignmentManager_UpdateSlotObjects( aM_hndl, alignmentSlot, updateHandler, getSizeHandler );

};


//========================================
// AlignmentManager Create
//========================================

func int B4DI_AlignmentManager_Create() {
	var int new_aM_hndl; new_aM_hndl = new(_alignmentManager@);
	var _alignmentManager aM; aM = get(new_aM_hndl);
    

    var int slot_index; var int margin_index; 
    var int current_slot_margin_array; var int current_slot_sizeLimit_array;

    aM.alignmentSlots = new(zCArray@);
    aM.margins_perSlot = new(zCArray@);
    aM.sizelimits_ofObjects_perSlot = new(zCArray@);

    repeat( slot_index, B4DI_ALIGNMENT_SLOT_ARRAY_SIZE );
    	MEM_WriteStatArr(aM.alignmentSlots, alignmentSlot, 0 );

    	current_slot_margin_array =  new(zCArray@);
    	MEM_WriteStatArr(aM.margins_perSlot, slot_index, current_slot_margin_array);

    	repeat( margin_index, B4DI_ALIGNMENT_SLOT_MARGIN_ARRAY_SIZE );
			MEM_WriteStatArr( current_slot_margin_array, margin_index, B4DI_ALIGNMENT_MARGIN_USE_DEFAULT);
		end;

    	current_slot_sizeLimit_array =  new(zCArray@);

    	MEM_WriteStatArr(current_slot_sizeLimit_array, PS_X, B4DI_ALIGNMENT_SLOT_OBJECTSIZE_NO_LIMIT);
    	MEM_WriteStatArr(current_slot_sizeLimit_array, PS_Y, B4DI_ALIGNMENT_SLOT_OBJECTSIZE_NO_LIMIT);
    	MEM_WriteStatArr(aM.sizelimits_ofObjects_perSlot, slot_index, current_slot_sizeLimit_array);

    end;


	return new_aM_hndl;

};

//========================================
// AlignmentManager Init
//========================================

func void B4DI_AlignmentManager_InitAlways() {
	if ( !Hlp_IsValidHandle( MEM_mainAlignManager_handle ) ) {
		MEM_Info("B4DI_AlignManager_InitAlways; Creating the Handle");

		MEM_mainAlignmenManager_handle = B4DI_AlignmentManager_Create();
	};
	MEM_mainAlignmentManager = get(MEM_mainAlignmentManager_handle);

	MEM_Info("B4DI_AlignManager_InitAlways finished");	
};

