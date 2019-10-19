

//========================================
// size Limit of each Object per Slot Get
//========================================
func int B4DI_AlignmentManager_GetSizeLimit_forSlot( var int aM_hndl, var int index_alignmentSlot, var int Axis) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Info("B4DI_AlignmentManager_GetSizeLimit_forSlot; Invalid Handle"); return 0; };
	var _alignmentManager aM; aM = get( aM_hndl );
	var int aSlot_array_hndl; 
	var int sizeLimit;

	aSlot_array_hndl = MEM_ArrayRead( getPtr(aM.sizelimits_ofObjects_perSlot), index_alignmentSlot );
	sizeLimit = MEM_ArrayRead( getPtr(aSlot_array_hndl), Axis);


	if (sizeLimit == B4DI_ALIGNMENT_SLOT_OBJECTSIZE_NO_LIMIT) {
		return VIEW_NO_SIZE_LIMIT; //<---change this maybe per ini?
	};

	return sizeLimit;

};


//========================================
// Margin Get
//========================================
func int B4DI_AlignmentManager_GetMargin_forSlot( var int aM_hndl, var int index_alignmentSlot, var int marginSide) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Info("B4DI_AlignmentManager_GetMargin_forSlot; Invalid Handle"); return 0; };
	var _alignmentManager aM; aM = get( aM_hndl );

	var int marginArray_hndl;
	marginArray_hndl = MEM_ArrayRead(getPtr(aM.margins_perSlot), index_alignmentSlot);

	var int marginValue;
	marginValue = MEM_ArrayRead(getPtr(marginArray_hndl), marginSide);

	if (marginValue == B4DI_ALIGNMENT_MARGIN_USE_DEFAULT) {
		return B4DI_ALIGNMENT_MARGIN_DEFAULT_VALUE; //<---change this maybe per ini?
	};

	return marginValue;

};

func int  B4DI_AlignmentManager_GetMargin_forSlotByAxis(var int aM_hndl, var int index_alignmentSlot, var int axis ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Info("B4DI_AlignmentManager_GetMargin_forSlotByAxis; Invalid Handle"); return 0; };
	var int marginValue;

	if( axis == PS_X ) {
		if (index_alignmentSlot == B4DI_ALIGNMENT_LEFT_TOP || index_alignmentSlot == B4DI_ALIGNMENT_LEFT_BOTTOM || index_alignmentSlot == B4DI_ALIGNMENT_CENTER_LEFT ) {
			marginValue = B4DI_AlignmentManager_GetMargin_forSlot( aM_hndl, index_alignmentSlot, B4DI_ALIGNMENT_SLOT_MARGIN_LEFT);
		} else if (index_alignmentSlot == B4DI_ALIGNMENT_RIGHT_TOP || index_alignmentSlot == B4DI_ALIGNMENT_RIGHT_BOTTOM || index_alignmentSlot == B4DI_ALIGNMENT_CENTER_RIGHT ) {
			marginValue = B4DI_AlignmentManager_GetMargin_forSlot( aM_hndl, index_alignmentSlot, B4DI_ALIGNMENT_SLOT_MARGIN_RIGHT);
		} else if (index_alignmentSlot == B4DI_ALIGNMENT_CENTER) {
			marginValue = 0;
		};
	} else if ( axis == PS_Y ) {
		if (index_alignmentSlot == B4DI_ALIGNMENT_LEFT_TOP || index_alignmentSlot == B4DI_ALIGNMENT_RIGHT_TOP || index_alignmentSlot == B4DI_ALIGNMENT_CENTER_TOP ) {
			marginValue = B4DI_AlignmentManager_GetMargin_forSlot( aM_hndl, index_alignmentSlot, B4DI_ALIGNMENT_SLOT_MARGIN_TOP);
		} else if (index_alignmentSlot == B4DI_ALIGNMENT_LEFT_BOTTOM || index_alignmentSlot == B4DI_ALIGNMENT_RIGHT_BOTTOM || index_alignmentSlot == B4DI_ALIGNMENT_CENTER_BOTTOM ) {
			marginValue = B4DI_AlignmentManager_GetMargin_forSlot( aM_hndl, index_alignmentSlot, B4DI_ALIGNMENT_SLOT_MARGIN_BOTTOM);
		} else if (index_alignmentSlot == B4DI_ALIGNMENT_CENTER) {
			marginValue = 0;
		};
	} else {
		MEM_Warn("B4DI_AlignmentManager_GetMargin_forSlotByAxis failed invalid axis/ index_alignmentSlot");
	};

	return marginValue;
};

//========================================
// [intern] get decicated slot sign
//========================================
func int B4DI_AlignmentManager_GetSlotSign( var int index_alignmentSlot, var int axis ) {
	var int sign;
	if( index_alignmentSlot == B4DI_ALIGNMENT_LEFT_TOP ) {
		sign = 1;
	} else if ( index_alignmentSlot == B4DI_ALIGNMENT_LEFT_BOTTOM ) {
		if(axis == PS_X) { sign = 1; } else
		if(axis == PS_Y) { sign = -1; };

	} else if ( index_alignmentSlot == B4DI_ALIGNMENT_RIGHT_TOP ) {
		if(axis == PS_X) { sign = -1; } else
		if(axis == PS_Y) { sign = 1; };

	} else if ( index_alignmentSlot == B4DI_ALIGNMENT_RIGHT_BOTTOM ) {
		if(axis == PS_X) { sign = -1; } else
		if(axis == PS_Y) { sign = -1; };

	} else if ( index_alignmentSlot == B4DI_ALIGNMENT_CENTER ) {
		if(axis == PS_X) { sign = 1; } else
		if(axis == PS_Y) { sign = 1; };

	} else if ( index_alignmentSlot == B4DI_ALIGNMENT_CENTER_TOP ) {
		if(axis == PS_X) { sign = 1; } else
		if(axis == PS_Y) { sign = 1; };

	} else if ( index_alignmentSlot == B4DI_ALIGNMENT_CENTER_BOTTOM ) {
		if(axis == PS_X) { sign = 1; } else
		if(axis == PS_Y) { sign = -1; };

	} else if ( index_alignmentSlot == B4DI_ALIGNMENT_CENTER_LEFT ) {
		if(axis == PS_X) { sign = 1; } else
		if(axis == PS_Y) { sign = 1; };

	} else if ( index_alignmentSlot == B4DI_ALIGNMENT_CENTER_RIGHT ) {
		if(axis == PS_X) { sign = -1; } else
		if(axis == PS_Y) { sign = 1; };

	}; 

	return sign;
};

//========================================
// [intern] get decicated slot startPosition
//========================================
func int B4DI_AlignmentManager_GetStartPosition( var int aM_hndl, var int index_alignmentSlot, var int axis ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Warn("B4DI_AlignmentManager_GetStartPosition; Invalid Handle"); return 0; };
	var _alignmentManager aM; aM = get( aM_hndl );

	var int margin; margin = B4DI_AlignmentManager_GetMargin_forSlotByAxis(aM_hndl, index_alignmentSlot, axis);

	var int startValue;
	if( index_alignmentSlot == B4DI_ALIGNMENT_LEFT_TOP ) {
		if(axis == PS_X) { startValue = 0 + margin; } else 
		if(axis == PS_Y) { startValue = 0 + margin;	};

	} else if ( index_alignmentSlot == B4DI_ALIGNMENT_LEFT_BOTTOM ) {
		if(axis == PS_X) { startValue = 0 + margin; } else
		if(axis == PS_Y) { startValue = PS_VMAX - margin; };

	} else if ( index_alignmentSlot == B4DI_ALIGNMENT_RIGHT_TOP ) {
		if(axis == PS_X) { startValue = PS_VMAX - margin; } else
		if(axis == PS_Y) { startValue = 0 + margin; };

	} else if ( index_alignmentSlot == B4DI_ALIGNMENT_RIGHT_BOTTOM ) {
		if(axis == PS_X) { startValue = PS_VMAX - margin; } else
		if(axis == PS_Y) { startValue = PS_VMAX - margin; };

	} else if ( index_alignmentSlot == B4DI_ALIGNMENT_CENTER ) {
		//TODO for center take list size into account?
		if(axis == PS_X) { startValue = PS_VMAX/2; } else
		if(axis == PS_Y) { startValue = PS_VMAX/2; };

	} else if ( index_alignmentSlot == B4DI_ALIGNMENT_CENTER_TOP ) {
		if(axis == PS_X) { startValue = PS_VMAX/2; } else
		if(axis == PS_Y) { startValue = 0 + margin; };

	} else if ( index_alignmentSlot == B4DI_ALIGNMENT_CENTER_BOTTOM ) {
		if(axis == PS_X) { startValue = PS_VMAX/2; } else
		if(axis == PS_Y) { startValue = PS_VMAX - margin; };

	} else if ( index_alignmentSlot == B4DI_ALIGNMENT_CENTER_LEFT ) {
		//TODO for center take list size into account?
		if(axis == PS_X) { startValue = 0 + margin; } else
		if(axis == PS_Y) { startValue = PS_VMAX/2; };

	} else if ( index_alignmentSlot == B4DI_ALIGNMENT_CENTER_RIGHT ) {
		//TODO for center take list size into account?
		if(axis == PS_X) { startValue = PS_VMAX - margin; } else
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
	//B4DI_Info3("B4DI_AlignmentManager_Update_CallPositionHandler called with x= ", vposx, " y= ", vposy, " anchorPoint_mode= ", anchorPoint_mode);
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

	//B4DI_Info2("B4DI_AlignmentManager_Update_CallGetSizeHandler called for Axis= ", axis, " resulting in size= ", result);

	return result;
};

//========================================
// Get Object count of Slot
//========================================
func int B4DI_AlignmentManager_GetObjectCountOfSlot( var int aM_hndl, var int index_alignmentSlot ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Warn("B4DI_AlignmentManager_GetObjectCountOfSlot; Invalid Handle"); return 0; };
	//B4DI_Info1("B4DI_AlignmentManager_UpdateSlotObjects: index_alignmentSlot = ", index_alignmentSlot);
	var _alignmentManager aM; aM = get( aM_hndl );

	var int slot_list_ptr;
	var int list_size;

	slot_list_ptr = MEM_ArrayRead( getPtr(aM.alignmentSlots), index_alignmentSlot );

	if( !slot_list_ptr ) { MEM_Info("B4DI_AlignmentManager_UpdateSlotObjects: No Objects"); return 0; };
	list_size = List_Length(slot_list_ptr);
	//B4DI_Info1("B4DI_AlignmentManager_GetObjectCountOfSlot: processing Objectlist of size: ", list_size);
	return list_size;
};

//========================================
// AlignmentManager Update Objects of Slot
//========================================
//TODO: take sizelimits into consideration
//TODO: x_pos for next Object makes in this setup no sense -> Iterate,...maybe different version of aM handles y axis aligned objects? or slotbased?
func void B4DI_AlignmentManager_UpdateSlotObjects( var int aM_hndl, var int index_alignmentSlot ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Warn("B4DI_AlignmentManager_UpdateSlotObjects; Invalid Handle"); return; };
	//B4DI_Info1("B4DI_AlignmentManager_UpdateSlotObjects: index_alignmentSlot = ", index_alignmentSlot);
	var _alignmentManager aM; aM = get( aM_hndl );

	var int slot_list_ptr;
	var int list_size;

	slot_list_ptr = MEM_ArrayRead( getPtr(aM.alignmentSlots), index_alignmentSlot );

	if( !slot_list_ptr ) { MEM_Info("B4DI_AlignmentManager_UpdateSlotObjects: No Objects"); return; };
	list_size = List_Length(slot_list_ptr);

	var int next_xPosition; next_xPosition = B4DI_AlignmentManager_GetStartPosition( aM_hndl, index_alignmentSlot, PS_X );
	var int next_yPosition; next_yPosition = B4DI_AlignmentManager_GetStartPosition( aM_hndl, index_alignmentSlot, PS_Y );

	var int margin_betweenObjects; margin_betweenObjects = B4DI_AlignmentManager_GetMargin_forSlot( aM_hndl, index_alignmentSlot, B4DI_ALIGNMENT_SLOT_MARGIN_Y_BETWEENOBJECTS );
	var int x_sign; x_sign = B4DI_AlignmentManager_GetSlotSign(index_alignmentSlot, PS_X);
	var int y_sign; y_sign = B4DI_AlignmentManager_GetSlotSign(index_alignmentSlot, PS_Y);

	var int current_obj_hndl;
	var int current_obj_vsizex;
	var int current_obj_vsizey;
	
	var int index; index = 1;
	// lists are indexed with 1 instead of 0
	while( index <= list_size );
		//B4DI_Info1("B4DI_AlignmentManager_UpdateSlotObjects: index = ", index);
		current_obj_hndl = List_Get(slot_list_ptr, index);

		B4DI_AlignmentManager_Update_CallPositionHandler(current_obj_hndl, next_xPosition, next_yPosition, index_alignmentSlot );
		//current_obj_vsizex = B4DI_AlignmentManager_Update_CallGetSizeHandler(current_obj_hndl, PS_X);
		//next_xPosition += x_sign * current_obj_vsizex;
		current_obj_vsizey = B4DI_AlignmentManager_Update_CallGetSizeHandler(current_obj_hndl, PS_Y);
		next_yPosition += y_sign * ( current_obj_vsizey + margin_betweenObjects);
		index +=1;
	end;
};

func void B4DI_AlignmentManager_UpdateAllSlots( var int aM_hndl ) {
	MEM_Info("B4DI_AlignmentManager_UpdateAllSlots <--------------------------- started");
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Warn("B4DI_AlignmentManager_UpdateAllSlots; Invalid Handle"); return; };
	//var _alignmentManager aM; aM = get( aM_hndl );

	var int index_alignmentSlot; index_alignmentSlot = B4DI_ALIGNMENT_LEFT_TOP;

	while( index_alignmentSlot < B4DI_ALIGNMENT_SLOT_ARRAY_SIZE );
		//B4DI_Info1("B4DI_AlignmentManager_UpdateAllSlots processing Slot= ",index_alignmentSlot);
		B4DI_AlignmentManager_UpdateSlotObjects( aM_hndl, index_alignmentSlot);
		index_alignmentSlot += 1;
	end;
	MEM_Info("B4DI_AlignmentManager_UpdateAllSlots <--------------------------- Finished");
};

//========================================
// Margin Set
//========================================
func void B4DI_AlignmentManager_SetMargin_forSlot( var int aM_hndl, var int index_alignmentSlot, var int marginSide, var int marginValue ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Info("B4DI_AlignmentManager_SetMargin_forSlot; Invalid Handle"); return; };
	var _alignmentManager aM; aM = get( aM_hndl );
	var int marginArray_hndl; 

	marginArray_hndl = MEM_ArrayRead( getPtr(aM.margins_perSlot), index_alignmentSlot );
	MEM_ArrayWrite( getPtr(marginArray_hndl), marginSide, marginValue );

	B4DI_AlignmentManager_UpdateSlotObjects( aM_hndl, index_alignmentSlot);

};

//========================================
// size Limit of each Object per Slot Set
//========================================
func void B4DI_AlignmentManager_SetSizeLimit_forSlot( var int aM_hndl, var int index_alignmentSlot, var int Axis, var int sizeLimitValue, var func updateHandler ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Info("B4DI_AlignmentManager_SetSizeLimit_forSlot; Invalid Handle"); return; };
	var _alignmentManager aM; aM = get( aM_hndl );
	var int aSlot_array_hndl; 

	aSlot_array_hndl = MEM_ArrayRead( getPtr(aM.sizelimits_ofObjects_perSlot), index_alignmentSlot );
	MEM_ArrayWrite( getPtr(aSlot_array_hndl), Axis, sizeLimitValue );

	B4DI_AlignmentManager_UpdateSlotObjects( aM_hndl, index_alignmentSlot );

};


//========================================
// AlignmentObject Create
//========================================
func int B4DI_AlignmentObject_Create( var int aM_hndl, var int obj_hndl, var func updateHandler, var func getSizeHandler, var int index_alignmentSlot ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) || !Hlp_IsValidHandle( obj_hndl ) ) { MEM_Warn("B4DI_AlignmentObject_Create; Invalid Handle"); return 0; };
	var _alignmentManager aM; aM = get( aM_hndl );
	var int new_aO_hndl; new_aO_hndl = new( _alignmentObject@ );
	var _alignmentObject new_aO; new_aO = get(new_aO_hndl);

	//link from obj_hndl to aO_hndl
	if ( !HT_Has(aM.obj_hashtable, obj_hndl) ) {
		HT_Insert(aM.obj_hashtable, new_aO_hndl, obj_hndl);
	};
	//link from aO_hndl to obj_hndl
	new_aO.objectHandle = obj_hndl;
	new_aO.updateHandler = MEM_GetFuncID(updateHandler);
	new_aO.getSizeHandler = MEM_GetFuncID(getSizeHandler);
	//in which slot is the object supposed to be
	new_aO.alignmentSlot = index_alignmentSlot;

	return new_aO_hndl;
};

//========================================
// AlignmentObject ExistsForObj
//
// 		returning the aO_hndl corresponding to the obj_hndl if it exists already
//========================================
func int B4DI_AlignmentObject_GetHandleOfObj( var int aM_hndl, var int obj_hndl) {
	if ( !Hlp_IsValidHandle( aM_hndl ) || !Hlp_IsValidHandle( obj_hndl ) ) { MEM_Warn("B4DI_AlignmentObject_GetHandleOfObj; Invalid Handle"); return 0; };
	var _alignmentManager aM; aM = get( aM_hndl );
	var int aO_hndl; aO_hndl = 0;
	if( HT_Has(aM.obj_hashtable, obj_hndl) ) {
			aO_hndl = HT_Get(aM.obj_hashtable, obj_hndl);
	};
	return aO_hndl;
};


//========================================
// [intern] AlignmentManager Add alignmentObject to Slot
//========================================
func void _B4DI_AlignmentManager_AddToSlot( var int aM_hndl, var int aO_hndl, var int index_targetAlignmentSlot ) {
	//B4DI_Info1("B4DI_AlignmentManager_AddToSlotInitial: Slot", index_targetAlignmentSlot);
	if ( !Hlp_IsValidHandle( aM_hndl ) || !Hlp_IsValidHandle( aO_hndl ) ) { MEM_Warn("_B4DI_AlignmentManager_AddToSlot; Invalid Handle"); return; };
	var _alignmentManager aM; aM = get( aM_hndl );
	var _alignmentObject aO; aO = get( aO_hndl );
	
	var int slot_list_ptr; 
	slot_list_ptr = MEM_ArrayRead(getPtr(aM.alignmentSlots), index_targetAlignmentSlot);
	if (!slot_list_ptr) {
		slot_list_ptr = List_Create(aO_hndl);

	} else {
		List_AddFront(slot_list_ptr, aO_hndl);
	};

	MEM_ArrayWrite(getPtr(aM.alignmentSlots), index_targetAlignmentSlot, slot_list_ptr );

	aO.alignmentSlot = index_targetAlignmentSlot;
	
};

//========================================
// AlignmentManager Add Object to Slot/initialize
//========================================
func void B4DI_AlignmentManager_AddToSlotInitial( var int aM_hndl, var int obj_hndl, var int index_targetAlignmentSlot, var func updateHandler, var func getSizeHandler ) {
	B4DI_Info1("B4DI_AlignmentManager_AddToSlotInitial: Slot", index_targetAlignmentSlot);
	if ( !Hlp_IsValidHandle( aM_hndl ) || !Hlp_IsValidHandle( obj_hndl ) ) { MEM_Warn("B4DI_AlignmentManager_AddToSlotInitial; Invalid Handle"); return; };
	var _alignmentManager aM; aM = get( aM_hndl );

	var int aO_hndl; aO_hndl = B4DI_AlignmentObject_GetHandleOfObj(aM_hndl, obj_hndl);
	if ( !Hlp_IsValidHandle(aO_hndl) ) {
		aO_hndl = B4DI_AlignmentObject_Create( aM_hndl, obj_hndl, updateHandler, getSizeHandler, index_targetAlignmentSlot );
	};
	
	_B4DI_AlignmentManager_AddToSlot(aM_hndl, aO_hndl, index_targetAlignmentSlot);

	B4DI_AlignmentManager_UpdateSlotObjects( aM_hndl, index_targetAlignmentSlot );
	B4DI_Info1("B4DI_AlignmentManager_AddToSlotInitial: Finished Slot", index_targetAlignmentSlot);
};

//========================================
// [intern] AlignmentManager Remove Object from Slot
//========================================
func void _B4DI_AlignmentManager_RemoveFromSlot( var int aM_hndl, var int aO_hndl/*, var int index_alignmentSlot*/ ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) || !Hlp_IsValidHandle( aO_hndl ) ) { MEM_Warn("_B4DI_AlignmentManager_RemoveFromSlot; Invalid Handle"); return; };
	var _alignmentManager aM; aM = get( aM_hndl );
	var _alignmentObject aO; aO = get( aO_hndl );

	var int index_originAlignmentSlot; index_originAlignmentSlot = aO.alignmentSlot;
	var int origin_slot_list_ptr;
	origin_slot_list_ptr = MEM_ArrayRead(getPtr(aM.alignmentSlots), index_originAlignmentSlot);
	var int origin_listPos;
	origin_listPos = List_Contains(origin_slot_list_ptr, aO_hndl);
	if(origin_listPos) {
		List_Delete(origin_slot_list_ptr, origin_listPos);
		//List is empty and data = 0; 
		if( List_HasLength( origin_slot_list_ptr, 1 ) && !List_Get( origin_slot_list_ptr, 1 ) ) {
			List_Destroy(origin_slot_list_ptr);
			MEM_ArrayWrite( getPtr(aM.alignmentSlots), index_originAlignmentSlot, 0 );
		};
	} else {
		MEM_Warn("B4DI_AlignmentManager_RemoveFromSlot; Invalid Slot");
	};
	aO.alignmentSlot = -1;


};

//========================================
// AlignmentManager Remove Object from Slot [should not be used alone cause postion etc of obj_hndl is still the same]
//========================================
func void B4DI_AlignmentManager_RemoveFromSlot( var int aM_hndl, var int obj_hndl/*, var int index_alignmentSlot*/ ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) || !Hlp_IsValidHandle( obj_hndl ) ) { MEM_Warn("B4DI_AlignmentManager_RemoveFromSlot; Invalid Handle"); return; };
	var _alignmentObject aO; aO = get( B4DI_AlignmentObject_GetHandleOfObj(aM_hndl, obj_hndl) );
	var int index_originAlignmentSlot; index_originAlignmentSlot = aO.alignmentSlot;

	_B4DI_AlignmentManager_RemoveFromSlot( aM_hndl, obj_hndl );
	B4DI_AlignmentManager_UpdateSlotObjects( aM_hndl, index_originAlignmentSlot );
};

//========================================
// AlignmentManager Move Object from current Slot to targetSlot, can also be used to move the obj to the front of the list
//========================================
func void B4DI_AlignmentManager_MoveToSlot( var int aM_hndl, var int obj_hndl, var int index_targetAlignmentSlot ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) || !Hlp_IsValidHandle( obj_hndl ) ) { MEM_Warn("B4DI_AlignmentManager_MoveToSlot; Invalid Handle"); return; };
	var _alignmentManager aM; aM = get( aM_hndl );

	var int aO_hndl; aO_hndl = B4DI_AlignmentObject_GetHandleOfObj(aM_hndl, obj_hndl);
	var _alignmentObject aO; aO = get( aO_hndl );
	var int index_originAlignmentSlot; index_originAlignmentSlot = aO.alignmentSlot;

	_B4DI_AlignmentManager_RemoveFromSlot(aM_hndl, aO_hndl);
	_B4DI_AlignmentManager_AddToSlot(aM_hndl, aO_hndl, index_targetAlignmentSlot);

	//var int origin_slot_list_ptr;
	//origin_slot_list_ptr = MEM_ReadStatArr(getPtr(aM.alignmentSlots), aO.alignmentSlot);
	//var int traget_slot_list_ptr;
	//traget_slot_list_ptr = MEM_ReadStatArr(getPtr(aM.alignmentSlots), index_targetAlignmentSlot);

	//var int origin_listPos;
	//origin_listPos = List_Contains(origin_slot_list_ptr, aO_hndl);
	//if(origin_listPos) {
	//	List_Delete(origin_slot_list_ptr, origin_listPos);
	//};
	//List_Add(traget_slot_list_ptr, aO_hndl);

	//aO.alignmentSlot = index_targetAlignmentSlot;
	B4DI_AlignmentManager_UpdateSlotObjects( aM_hndl, index_targetAlignmentSlot );
	if( index_targetAlignmentSlot != index_originAlignmentSlot ) {
		//incase it is used to set "top"
		B4DI_AlignmentManager_UpdateSlotObjects( aM_hndl, index_originAlignmentSlot );
	};

};

//========================================
// AlignmentManager Move Object within Slot to the Top
//========================================
/*func void B4DI_AlignmentManager_SetTopOfSlot( var int aM_hndl, var int obj_hndl ) {
	if ( !Hlp_IsValidHandle( aM_hndl ) || !Hlp_IsValidHandle( obj_hndl ) ) { MEM_Warn("B4DI_AlignmentManager_MoveToSlot; Invalid Handle"); return; };
	var _alignmentManager aM; aM = get( aM_hndl );

};*/

//========================================
// AlignmentManager Create
//========================================

func int B4DI_AlignmentManager_Create() {
	var int new_aM_hndl; new_aM_hndl = new(_alignmentManager@);
	var _alignmentManager aM; aM = get(new_aM_hndl);
    

    var int slot_index; var int margin_index; 
    var int current_slot_margin_array; var int current_slot_sizeLimit_array;

    //aM.alignmentSlots = new(zCArray@);
    aM.alignmentSlots = B4DI_ArrayCreateExactSize( B4DI_ALIGNMENT_SLOT_ARRAY_SIZE ,sizeOf_Int );
    //aM.margins_perSlot = new(zCArray@);
    aM.margins_perSlot = B4DI_ArrayCreateExactSize( B4DI_ALIGNMENT_SLOT_ARRAY_SIZE ,sizeOf_Int );
    //aM.sizelimits_ofObjects_perSlot = new(zCArray@);
    aM.sizelimits_ofObjects_perSlot = B4DI_ArrayCreateExactSize( B4DI_ALIGNMENT_SLOT_ARRAY_SIZE ,sizeOf_Int );

    MEM_Info("Before obj_hashtable");
    aM.obj_hashtable = HT_Create();
    B4DI_Info1("After obj_hashtable:", aM.obj_hashtable );

    repeat( slot_index, B4DI_ALIGNMENT_SLOT_ARRAY_SIZE );
    	MEM_ArrayWrite( getPtr(aM.alignmentSlots), slot_index, 0 ); //no list yet

    	//current_slot_margin_array =  new(zCArray@);
    	current_slot_margin_array =  B4DI_ArrayCreateExactSize( B4DI_ALIGNMENT_SLOT_MARGIN_ARRAY_SIZE, sizeOf_Int );
    	MEM_ArrayWrite(getPtr(aM.margins_perSlot), slot_index, current_slot_margin_array);

    	repeat( margin_index, B4DI_ALIGNMENT_SLOT_MARGIN_ARRAY_SIZE );
			MEM_ArrayWrite( getPtr(current_slot_margin_array), margin_index, B4DI_ALIGNMENT_MARGIN_USE_DEFAULT);
		end;

    	current_slot_sizeLimit_array = B4DI_ArrayCreateExactSize( B4DI_NUM_OF_AXIS, sizeOf_Int);
    	
    	MEM_ArrayWrite(getPtr(current_slot_sizeLimit_array), PS_X, B4DI_ALIGNMENT_SLOT_OBJECTSIZE_NO_LIMIT);
    	MEM_ArrayWrite(getPtr(current_slot_sizeLimit_array), PS_Y, B4DI_ALIGNMENT_SLOT_OBJECTSIZE_NO_LIMIT);
    	MEM_ArrayWrite(getPtr(aM.sizelimits_ofObjects_perSlot), slot_index, current_slot_sizeLimit_array);
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

