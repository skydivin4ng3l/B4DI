func void B4DI_EditUI_enable(){
	Cursor_Show();
	Event_AddOnce(Cursor_Event, B4DI_EditUI_CursorListener);
};


func void B4DI_EditUI_disable(){
	Cursor_Hide();
	if( Event_Has(Cursor_Event, B4DI_EditUI_CursorListener)) {
		Event_Remove(Cursor_Event, B4DI_EditUI_CursorListener);
	};
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
    };
    if(state == CUR_MidClick) {
        PrintS("Wheelclick!");
    };
};


