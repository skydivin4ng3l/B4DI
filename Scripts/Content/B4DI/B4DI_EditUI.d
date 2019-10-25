
var int selectedUIElement;

var int selectedAlignmentSlot;

var int B4DI_UIEdit_Buttons_array;

//TODO protect illegal read of already deleted array_ptr
func void B4DI_EditUI_Buttons_deleteAll() {
    if ( !B4DI_UIEdit_Buttons_array ) { MEM_Info("B4DI_EditUI_Buttons_deleteAll; Invalid PTR"); return; };

    var int array_size; array_size = MEM_ArraySize(B4DI_UIEdit_Buttons_array);
    B4DI_Info1("B4DI_EditUI_Buttons_deleteAll: array_size=", array_size);
    var int index;
    repeat(index, array_size);
        B4DI_Info1("B4DI_EditUI_Buttons_deleteAll: index=", index);
        var int btn_hndl; btn_hndl = MEM_ArrayPop(B4DI_UIEdit_Buttons_array);
        if(btn_hndl) {
            Button_Delete(btn_hndl);
        };
    end;
    MEM_ArrayFree(B4DI_UIEdit_Buttons_array);

};

func void B4DI_EditUI_generateButtonForAlignmentObject( var int obj_hndl, var int aO_hndl) {
    if ( !Hlp_IsValidHandle( aO_hndl ) ) { MEM_Info("B4DI_EditUI_generateButtonForAlignmentObject; Invalid Handle"); return; };
    var _alignmentManager aO; aO = get( aO_hndl );

    var int vposx; vposx = B4DI_AlignmentManager_Update_CallGetPosHandler( aO_hndl, PS_X );
    var int vposy; vposy = B4DI_AlignmentManager_Update_CallGetPosHandler( aO_hndl, PS_Y );
    var int vsizex; vsizex = B4DI_AlignmentManager_Update_CallGetSizeHandler( aO_hndl, PS_X ); 
    var int vsizey; vsizey = B4DI_AlignmentManager_Update_CallGetSizeHandler( aO_hndl, PS_Y ); 
    var string tex; tex = "Bar_Back.tga";

    var int new_btn_hndl;
    new_btn_hndl = Button_Create( vposx, vposy, vsizex, vsizey, tex, B4DI_EditUI_SelectElement_Button_entered, B4DI_EditUI_SelectElement_Button_left, B4DI_EditUI_SelectElement_Button_click );
    Button_SetUserData( new_btn_hndl, obj_hndl );
    Button_Show(new_btn_hndl);
    Button_Activate(new_btn_hndl);

    MEM_ArrayInsert( B4DI_UIEdit_Buttons_array, new_btn_hndl );
};

func void B4DI_EditUI_generateButtonsForAllAlignmentObjects( var int aM_hndl ) {
    if ( !Hlp_IsValidHandle( aM_hndl ) ) { MEM_Info("B4DI_EditUI_generateButtonsForAlignmentManager; Invalid Handle"); return; };
    var _alignmentManager aM; aM = get( aM_hndl );

    B4DI_UIEdit_Buttons_array = MEM_ArrayCreate();
    HT_ForEach(aM.obj_hashtable, B4DI_EditUI_generateButtonForAlignmentObject );

};

// This index_alignmentSlot is currently not the same there fore use of translation array
func void B4DI_EditUI_generateButtonForAlignmentSlot( var int vposx, var int vposy, var int index_alignmentSlot ) {

    var int new_vposx; new_vposx = vposx;
    var int new_vposy; new_vposy = vposy;
    var int margin_x; margin_x = 50;
    var int margin_y; margin_y = 50;
    var int vsizex; vsizex = 300; 
    var int vsizey; vsizey = 300; 
    var string tex; tex = "Bar_Back.tga";

    if ( index_alignmentSlot%3 >= 1 ) { new_vposx = new_vposx + vsizex + margin_x; }; 
    if ( index_alignmentSlot%3 == 2 ) { new_vposx = new_vposx + vsizex + margin_x; }; 

    if ( index_alignmentSlot >= 3 ) { new_vposy = new_vposy + vsizey + margin_y; }; 
    if ( index_alignmentSlot >= 6 ) { new_vposy = new_vposy + vsizey + margin_y; };  

    var int new_btn_hndl;
    new_btn_hndl = Button_Create( new_vposx, new_vposy, vsizex, vsizey, tex, B4DI_EditUI_SelectSlot_Button_entered, B4DI_EditUI_SelectSlot_Button_left, B4DI_EditUI_SelectSlot_Button_click );
    
    Button_SetUserData( new_btn_hndl, MEM_ReadStatArr( B4DI_AlignmentMananger_SlotsOrder, index_alignmentSlot ) );
    Button_SetCaption(new_btn_hndl, i2s(index_alignmentSlot), B4DI_LABEL_FONT);
    Button_Show(new_btn_hndl);
    Button_Activate(new_btn_hndl);

    MEM_ArrayInsert( B4DI_UIEdit_Buttons_array, new_btn_hndl );
};

func void B4DI_EditUI_generateButtonForAllAlignmentSlots() {
    var int slot_chooser_start_x; slot_chooser_start_x = Print_ToVirtual( Cursor_X, PS_X ) + 50;
    var int slot_chooser_start_y; slot_chooser_start_y = Print_ToVirtual( Cursor_Y, PS_Y ) + 50;
    B4DI_Info1("B4DI_EditUI_generateButtonForAllAlignmentSlots: slot_chooser_start_x= ", slot_chooser_start_x);
    B4DI_Info1("B4DI_EditUI_generateButtonForAllAlignmentSlots: slot_chooser_start_y= ", slot_chooser_start_y);
    if( slot_chooser_start_x + 1000 > PS_VMAX ) { slot_chooser_start_x -= 1000; };
    if( slot_chooser_start_y + 1000 > PS_VMAX ) { slot_chooser_start_y -= 1000; };

    B4DI_UIEdit_Buttons_array = MEM_ArrayCreate();
    var int index_alignmentSlot;
    repeat( index_alignmentSlot, B4DI_ALIGNMENT_SLOT_ARRAY_SIZE);
        B4DI_EditUI_generateButtonForAlignmentSlot(slot_chooser_start_x, slot_chooser_start_y, index_alignmentSlot);
    end;
};


func void B4DI_EditUI_enable(){
    B4DI_EditUI_enabled = true;
    B4DI_enableEditUIMode = false;
    MEM_SetGothOpt("B4DI", "B4DI_enableEditUIMode", "0");
	Cursor_Show();
    Cursor_NoEngine = true;
	Event_AddOnce(Cursor_Event, B4DI_EditUI_CursorListener);
    B4DI_EditUI_generateButtonsForAllAlignmentObjects(MEM_mainAlignmentManager_handle);
};


func void B4DI_EditUI_disable(){
    B4DI_EditUI_enabled = false;
    Cursor_NoEngine = false;
    Button_DeleteMouseover();
	Cursor_Hide();
	if( Event_Has(Cursor_Event, B4DI_EditUI_CursorListener)) {
		Event_Remove(Cursor_Event, B4DI_EditUI_CursorListener);
	};
    B4DI_EditUI_Buttons_deleteAll();

};

func void B4DI_EditUI_CursorListener(var int state) {
	if(state == CUR_WheelUp) {
        PrintS("Wheel up!");
    };
    if(state == CUR_WheelDown) {
        PrintS("Wheel down!");
    };
    if(state == CUR_LeftClick) {
        PrintS("Leftclick!");
    };
    if(state == CUR_RightClick) {
        PrintS("Rightclick!");
        B4DI_EditUI_disable();
    };
    if(state == CUR_MidClick) {
        PrintS("Wheelclick!");
    };
};

func void B4DI_EditUI_SelectElement_Button_entered( var int btn_hndl ) {
    Button_CreateMouseover("Click to Change this UI Elements Slot", B4DI_LABEL_FONT);
};

func void B4DI_EditUI_SelectElement_Button_left( var int btn_hndl ) {
    Button_DeleteMouseover();
};

func void B4DI_EditUI_SelectElement_Button_click( var int btn_hndl ) {
    Button_DeleteMouseover();
    selectedUIElement = Button_GetUserData( btn_hndl );
    B4DI_EditUI_Buttons_deleteAll();
    B4DI_EditUI_generateButtonForAllAlignmentSlots();
};

func void B4DI_EditUI_SelectSlot_Button_entered( var int btn_hndl ) {
    Button_CreateMouseover("Click to assign UI Element to this Slot", B4DI_LABEL_FONT);
};

func void B4DI_EditUI_SelectSlot_Button_left( var int btn_hndl ) {
    Button_DeleteMouseover();
};

func void B4DI_EditUI_SelectSlot_Button_click( var int btn_hndl ) {
    Button_DeleteMouseover();
    selectedAlignmentSlot = Button_GetUserData( btn_hndl );
    B4DI_EditUI_Buttons_deleteAll();
    B4DI_AlignmentManager_MoveToSlot( MEM_mainAlignmentManager_handle, selectedUIElement, selectedAlignmentSlot );
    B4DI_EditUI_generateButtonsForAllAlignmentObjects(MEM_mainAlignmentManager_handle);
};



