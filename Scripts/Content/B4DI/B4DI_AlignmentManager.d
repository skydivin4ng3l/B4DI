


//========================================
// [intern] get decicated slot sign
//========================================
func int B4DI_AlignmentManager_GetSlotSign( var int alignmentSlot, var int axis ) {
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
func int B4DI_AlignmentManager_GetStartPosition( var int aM_hndl, var int alignmentSlot, var int axis ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Warn("B4DI_AlignmentManager_GetStartPosition; Invalid Handle"); return 0; };
	var _alignmentManager aM; aM = get( aM_hndl );

	//TODO add Margin
	var int marginArray_hndl;
	marginArray_hndl = MEM_ReadStatArr(getPtr(aM.margins_perSlot), alignmentSlot);
	var int margin_x; margin_x = MEM_ReadStatArr(getPtr(marginArray_hndl), PS_X);
	var int margin_y; margin_y = MEM_ReadStatArr(getPtr(marginArray_hndl), PS_Y);

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
//TODO: take sizelimits into consideration
//TODO: take Slot for position update into consideration
func void B4DI_AlignmentManager_Update_CallPositionHandler( var int obj_hndl, var int vposx, var int vposy, var int anchorPoint_mode ) {
	if ( !Hlp_IsValidHandle( obj_hndl ) ) { MEM_Warn("B4DI_AlignmentManager_Update_CallPositionHandler; Invalid Handle"); return; };
	var _alignmentObject aObj; aObj = get(obj_hndl);

	MEM_PushIntParam(aObj.objectHandle);
	MEM_PushIntParam(vposx);
	MEM_PushIntParam(vposy);
	MEM_PushIntParam(anchorPoint_mode);

	MEM_CallByID(aObj.updateHandler);
};

//========================================
// [intern] Call getSizeHandler
//========================================
func int B4DI_AlignmentManager_Update_CallGetSizeHandler( var int obj_hndl, var int axis ) {
	if ( !Hlp_IsValidHandle( obj_hndl ) ) { MEM_Warn("B4DI_AlignmentManager_Update_CallGetSizeHandler; Invalid Handle"); return 0; };
	var _alignmentObject aObj; aObj = get(obj_hndl);
	
	MEM_PushIntParam(aObj.objectHandle);
	MEM_PushIntParam(axis);

	MEM_CallByID(aObj.getSizeHandler);

	var int result; result = MEM_PopIntResult();

	return result;
};

//========================================
// AlignmentManager Update Objects of Slot
//========================================
//TODO: take sizelimits into consideration
func void B4DI_AlignmentManager_UpdateSlotObjects( var int aM_hndl, var int alignmentSlot ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Warn("B4DI_AlignmentManager_UpdateSlotObjects; Invalid Handle"); return; };
	B4DI_Info1("B4DI_AlignmentManager_UpdateSlotObjects: alignmentSlot = ", alignmentSlot);
	var _alignmentManager aM; aM = get( aM_hndl );

	var int slot_list_ptr;
	var int list_size;

	slot_list_ptr = MEM_ReadStatArr( getPtr(aM.alignmentSlots), alignmentSlot );

	if( !slot_list_ptr ) { MEM_Info("B4DI_AlignmentManager_UpdateSlotObjects: No Objects"); return; };
	list_size = List_Length(slot_list_ptr);


	var int next_xPosition; next_xPosition = B4DI_AlignmentManager_GetStartPosition( aM_hndl, alignmentSlot, PS_X );
	var int next_yPosition; next_yPosition = B4DI_AlignmentManager_GetStartPosition( aM_hndl, alignmentSlot, PS_Y );

	var int marginArray_hndl; marginArray_hndl = MEM_ReadStatArr( getPtr(aM.margins_perSlot), alignmentSlot );
	var int margin_betweenObjects; margin_betweenObjects = MEM_ReadStatArr( getPtr(marginArray_hndl), B4DI_ALIGNMENT_SLOT_MARGIN_Y_BETWEENOBJECTS );

	var int x_sign; x_sign = B4DI_AlignmentManager_GetSlotSign(alignmentSlot, PS_X);
	var int y_sign; y_sign = B4DI_AlignmentManager_GetSlotSign(alignmentSlot, PS_Y);

	var int current_obj_hndl;
	var int current_obj_vsizex;
	var int current_obj_vsizey;
	
	var int index;
	repeat( index, list_size );
		B4DI_Info1("B4DI_AlignmentManager_UpdateSlotObjects: index = ", index);
		current_obj_hndl = List_Get(slot_list_ptr, index);

		B4DI_AlignmentManager_Update_CallPositionHandler(current_obj_hndl, next_xPosition, next_yPosition, alignmentSlot );
		current_obj_vsizex = B4DI_AlignmentManager_Update_CallGetSizeHandler(current_obj_hndl, PS_X);
		current_obj_vsizey = B4DI_AlignmentManager_Update_CallGetSizeHandler(current_obj_hndl, PS_Y);
		next_xPosition += x_sign * current_obj_vsizex;
		next_yPosition += y_sign * ( current_obj_vsizey + margin_betweenObjects);

	end;
};

func void B4DI_AlignmentManager_UpdateAllSlots( var int aM_hndl ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Warn("B4DI_AlignmentManager_UpdateAllSlots; Invalid Handle"); return; };
	var _alignmentManager aM; aM = get( aM_hndl );

	var int alignmentSlot; alignmentSlot = B4DI_ALIGNMENT_LEFT_TOP;

	while( alignmentSlot < B4DI_ALIGNMENT_SLOT_ARRAY_SIZE );
		B4DI_AlignmentManager_UpdateSlotObjects( aM_hndl, alignmentSlot);
		alignmentSlot += 1;
	end;
};

//========================================
// AlignmentObject Create
//========================================
func int B4DI_AlignmentObject_Create( var int obj_hndl, var func updateHandler, var func getSizeHandler ) {
	if ( !Hlp_IsValidHandle( obj_hndl ) ) { MEM_Warn("B4DI_AlignmentObject_Create; Invalid Handle"); return 0; };
	var int new_aO_hndl; new_aO_hndl = new( _alignmentObject@ );
	var _alignmentObject new_aO; new_aO = get(new_aO_hndl);

	new_aO.objectHandle = obj_hndl;
	new_aO.updateHandler = MEM_GetFuncID(updateHandler);
	new_aO.getSizeHandler = MEM_GetFuncID(getSizeHandler);

	return new_aO_hndl;
};

//========================================
// AlignmentManager Add Object to Slot
//========================================
func void B4DI_AlignmentManager_AddToSlot( var int aM_hndl, var int alignmentSlot, var int obj_hndl, var func updateHandler, var func getSizeHandler ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) || !Hlp_IsValidHandle( obj_hndl ) ) { MEM_Warn("B4DI_AlignmentManager_AddToSlot; Invalid Handle"); return; };
	var _alignmentManager aM; aM = get( aM_hndl );
	var int aO_hndl; aO_hndl = B4DI_AlignmentObject_Create(obj_hndl, updateHandler, getSizeHandler);
	
	var int slot_list_ptr; 
	slot_list_ptr = MEM_ReadStatArr(getPtr(aM.alignmentSlots), alignmentSlot);
	if (!slot_list_ptr) {
		slot_list_ptr = List_Create(aO_hndl);

	} else {
		List_Add(slot_list_ptr, aO_hndl);
	};

	MEM_WriteStatArr(getPtr(aM.alignmentSlots), alignmentSlot, slot_list_ptr );

	B4DI_AlignmentManager_UpdateSlotObjects( aM_hndl, alignmentSlot );
};

//========================================
// size Limit of each Object per Slot Get/Set
//========================================
func int B4DI_AlignmentManager_GetSizeLimit_forSlot( var int aM_hndl, var int alignmentSlot, var int Axis) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Info("B4DI_AlignmentManager_GetSizeLimit_forSlot; Invalid Handle"); return 0; };
	var _alignmentManager aM; aM = get( aM_hndl );
	var int aSlot_array_hndl; 
	var int sizeLimit;

	aSlot_array_hndl = MEM_ReadStatArr( getPtr(aM.sizelimits_ofObjects_perSlot), alignmentSlot );
	sizeLimit = MEM_ReadStatArr( getPtr(aSlot_array_hndl), Axis);


	if (sizeLimit == B4DI_ALIGNMENT_SLOT_OBJECTSIZE_NO_LIMIT) {
		return VIEW_NO_SIZE_LIMIT; //<---change this maybe per ini?
	};

	return sizeLimit;

};


func void B4DI_AlignmentManager_SetSizeLimit_forSlot( var int aM_hndl, var int alignmentSlot, var int Axis, var int sizeLimitValue, var func updateHandler ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Info("B4DI_AlignmentManager_SetSizeLimit_forSlot; Invalid Handle"); return; };
	var _alignmentManager aM; aM = get( aM_hndl );
	var int aSlot_array_hndl; 

	aSlot_array_hndl = MEM_ReadStatArr( getPtr(aM.sizelimits_ofObjects_perSlot), alignmentSlot );
	MEM_WriteStatArr( getPtr(aSlot_array_hndl), Axis, sizeLimitValue );

	B4DI_AlignmentManager_UpdateSlotObjects( aM_hndl, alignmentSlot );

};

//========================================
// Margin Get/Set
//========================================
func int B4DI_AlignmentManager_GetMargin_forSlot( var int aM_hndl, var int alignmentSlot, var int marginSide) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Info("B4DI_AlignmentManager_GetMargin_forSlot; Invalid Handle"); return 0; };
	var _alignmentManager aM; aM = get( aM_hndl );
	var int aSlot_array_hndl; 
	var int marginValue;

	aSlot_array_hndl = MEM_ReadStatArr( getPtr(aM.margins_perSlot), alignmentSlot );
	marginValue = MEM_ReadStatArr( getPtr(aSlot_array_hndl), marginSide);


	if (marginValue == B4DI_ALIGNMENT_MARGIN_USE_DEFAULT) {
		return B4DI_ALIGNMENT_MARGIN_DEFAULT_VALUE; //<---change this maybe per ini?
	};

	return marginValue;

};


func void B4DI_AlignmentManager_SetMargin_forSlot( var int aM_hndl, var int alignmentSlot, var int marginSide, var int marginValue ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Info("B4DI_AlignmentManager_SetMargin_forSlot; Invalid Handle"); return; };
	var _alignmentManager aM; aM = get( aM_hndl );
	var int aSlot_array_hndl; 

	aSlot_array_hndl = MEM_ReadStatArr( getPtr(aM.margins_perSlot), alignmentSlot );
	MEM_WriteStatArr( getPtr(aSlot_array_hndl), marginSide, marginValue );

	B4DI_AlignmentManager_UpdateSlotObjects( aM_hndl, alignmentSlot);

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
    	MEM_WriteStatArr( getPtr(aM.alignmentSlots), slot_index, 0 );

    	current_slot_margin_array =  new(zCArray@);
    	MEM_WriteStatArr(getPtr(aM.margins_perSlot), slot_index, current_slot_margin_array);

    	repeat( margin_index, B4DI_ALIGNMENT_SLOT_MARGIN_ARRAY_SIZE );
			MEM_WriteStatArr( getPtr(current_slot_margin_array), margin_index, B4DI_ALIGNMENT_MARGIN_USE_DEFAULT);
		end;

    	current_slot_sizeLimit_array =  new(zCArray@);

    	MEM_WriteStatArr(getPtr(current_slot_sizeLimit_array), PS_X, B4DI_ALIGNMENT_SLOT_OBJECTSIZE_NO_LIMIT);
    	MEM_WriteStatArr(getPtr(current_slot_sizeLimit_array), PS_Y, B4DI_ALIGNMENT_SLOT_OBJECTSIZE_NO_LIMIT);
    	MEM_WriteStatArr(getPtr(aM.sizelimits_ofObjects_perSlot), slot_index, current_slot_sizeLimit_array);

    end;


	return new_aM_hndl;

};

//========================================
// AlignmentManager Init
//========================================

func void B4DI_AlignmentManager_InitAlways() {
	if ( !Hlp_IsValidHandle( MEM_mainAlignmentManager_handle ) ) {
		MEM_Info("B4DI_AlignmentManager_InitAlways; Creating the Handle");

		MEM_mainAlignmentManager_handle = B4DI_AlignmentManager_Create();
	};
	MEM_mainAlignmentManager = get(MEM_mainAlignmentManager_handle);

	MEM_Info("B4DI_AlignmentManager_InitAlways finished");	
};

