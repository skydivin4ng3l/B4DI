/***********************************\
                BARPREVIEW
\***********************************/

func int B4DI_BarPreview_Create( var int eBar_hndl){
    if(!Hlp_IsValidHandle(eBar_hndl)) {
        MEM_Warn("tried to init Preview of a not initialized ebar ");
        return 0;
    };
    var _extendedBar eBar; eBar = get(eBar_hndl);
    var _bar bar; bar = get(eBar.bar);
    var zCView vBar; vBar = View_Get(bar.v1);   

    var int new_bp_hndl; new_bp_hndl = new(_barPreview@);
    var _barPreview bp; bp = get(new_bp_hndl);
    
    bp.vPreView = View_Create(vBar.vposx + vBar.vsizex, vBar.vposy, vBar.vposx + vBar.vsizex * 2, vBar.vposy + vBar.vsizey );
    bp.vOverShoot = View_Create(vBar.vposx + vBar.vsizex, vBar.vposy, vBar.vposx + vBar.vsizex * 2, vBar.vposy + vBar.vsizey );
    //TODO maybe different texture for previews?
    View_SetTexture(bp.vPreView, ViewPtr_GetTexture( MEM_InstToPtr(vBar) ) );
    View_SetTexture(bp.vOverShoot, ViewPtr_GetTexture( MEM_InstToPtr(vBar) ) );

    bp.val = 0;
    bp.changesMaximum = 0;
    bp.isFadedOutPreview = 1;
    bp.isFadedOutOvershoot = 1;
    bp.eBar_parent = eBar_hndl;

    /*eBar.barPreview = new_bp_hndl; *///unsure about this here
    return new_bp_hndl;
};

func int B4DI_BarPreview_GetValue( var int barPreview_hndl) {
    if(!Hlp_IsValidHandle(barPreview_hndl)) {
        MEM_Warn("B4DI_BarPreview_GetValue failed ");
        return 0;
    };
    var _barPreview bp; bp = get(barPreview_hndl);
    //B4DI_Info1("B4DI_BarPreview_GetValue: ", bp.val);
    return bp.val;
};

func void B4DI_BarPreview_SetChangesMaximum( var int barPreview_hndl ){
    if(!Hlp_IsValidHandle(barPreview_hndl)) {
        MEM_Warn("B4DI_BarPreview_SetChangesMaximum failed ");
        return;
    };
    var _barPreview bp; bp = get(barPreview_hndl);
    bp.changesMaximum = 1;
};

func int B4DI_BarPreview_GetChangesMaximum( var int barPreview_hndl ){
    if(!Hlp_IsValidHandle(barPreview_hndl)) {
        MEM_Warn("B4DI_BarPreview_GetChangesMaximum failed ");
        return 0;
    };
    var _barPreview bp; bp = get(barPreview_hndl);

    return bp.changesMaximum;
};

func void B4DI_BarPreview_SetSizeLeftsidedPercent( var int barPreview_hndl, var int x_percentage, var int y_percentage) {
    Print_GetScreenSize();
    //------------------
    if(!Hlp_IsValidHandle(barPreview_hndl)) { MEM_Warn("B4DI_BarPreview_SetSizePercent failed"); return; };
    var _barPreview bp; bp = get(barPreview_hndl);
    var zCView vPreView; vPreView = View_Get(bp.vPreView);
    var _extendedBar eBar_parent; eBar_parent = get(bp.eBar_parent);
    var _bar bar; bar = get(eBar_parent.bar);
    //save the size before the resize
    //var int sizex_pre; sizex_pre = Print_ToVirtual(b.val,PS_X); 
    var int sizex_pre; sizex_pre = roundf( mulf( fracf( bp.val , bar.valMax), mulf( mkf(bar.initialDynamicVSizes[IDS_VBAR_X]), dynScalingFactor ) ) ) ; 
    var int sizey_pre; sizey_pre = roundf( mulf( mkf(bar.initialDynamicVSizes[IDS_VBAR_Y]), dynScalingFactor ) ) ; 

    //scale on all axis
    View_Resize(bp.vPreView, sizex_pre * x_percentage / 100 , sizey_pre * y_percentage / 100 ); 
        
    //Debug
    //B4DI_debugSpy("B4DI_BarPreview_SetSizeLeftsidedPercent PositionX",IntToString(vPreView.vposx));
    //B4DI_debugSpy("B4DI_BarPreview_SetSizeLeftsidedPercent PositionY",IntToString(vPreView.vposy));
    //B4DI_debugSpy("B4DI_BarPreview_SetSizeLeftsidedPercent SizeX",IntToString(vPreView.vsizex));
    //B4DI_debugSpy("B4DI_BarPreview_SetSizeLeftsidedPercent SizeY",IntToString(vPreView.vsizey));

};

func void B4DI_BarPreview_SetSizeLeftsidedPercentXY( var int barPreview_hndl, var int xy_percentage ) {
    B4DI_BarPreview_SetSizeLeftsidedPercent(barPreview_hndl, xy_percentage, xy_percentage);
};

func void B4DI_BarPreview_SetSizeLeftsidedPercentX( var int barPreview_hndl, var int x_percentage ) {
    B4DI_BarPreview_SetSizeLeftsidedPercent(barPreview_hndl, x_percentage, 100);
};

func void B4DI_BarPreview_SetSizeLeftsidedPercentY( var int barPreview_hndl, var int y_percentage ) {
    B4DI_BarPreview_SetSizeLeftsidedPercent(barPreview_hndl, 100, y_percentage);
};

func void B4DI_BarPreview_slide_size(var int barPreview_hndl, var func slideFunc) {
    if ( !Hlp_IsValidHandle(barPreview_hndl) ) { return; };
    var _barPreview bp; bp = get(barPreview_hndl);
    bp.anim8Pulse = Anim8_NewExt(100 , slideFunc, barPreview_hndl, false); //height input
    Anim8_RemoveIfEmpty(bp.anim8Pulse, true);
    Anim8_RemoveDataIfEmpty(bp.anim8Pulse, true);
    
    Anim8 (bp.anim8Pulse, 100,  100, A8_Wait);
    Anim8q(bp.anim8Pulse, 0, 500, A8_SlowEnd);

};

func void B4DI_BarPreview_Show( var int barPreview_hndl) {
    if(!Hlp_IsValidHandle(barPreview_hndl)) {
        MEM_Warn("B4DI_BarPreview_Show failed ");
        return;
    };
    var _barPreview bp; bp = get(barPreview_hndl);
    //TODO: cancle animanitions
    //TODO: Start animanitions
    bp.isFadedOutPreview = 0;
    View_Open(bp.vPreView);
    View_SetAlpha(bp.vPreView, 127);
    View_Top(bp.vPreView);
};

func void B4DI_BarPreview_ShowOverShoot( var int barPreview_hndl) {
    if(!Hlp_IsValidHandle(barPreview_hndl)) {
        MEM_Warn("B4DI_BarPreview_Show failed ");
        return;
    };
    var _barPreview bp; bp = get(barPreview_hndl);
    //TODO: cancle animanitions
    //TODO: Start animanitions
    bp.isFadedOutOvershoot = 0;
    View_Open(bp.vOverShoot);
    View_SetAlpha(bp.vOverShoot, 80);
    View_Top(bp.vOverShoot);  
};

func void B4DI_BarPreview_hideOverShoot( var int barPreview_hndl) {
    if(!Hlp_IsValidHandle(barPreview_hndl)) {
        MEM_Warn("B4DI_BarPreview_hideOverShoot failed ");
        return;
    };
    var _barPreview bp; bp = get(barPreview_hndl);
    //TODO: cancle animanitions
    bp.isFadedOutOvershoot = 1;
    View_Close(bp.vOverShoot);
    //MEM_Info("B4DI_BarPreview_hideOverShoot");
};

func void B4DI_BarPreview_hide( var int barPreview_hndl) {
    if(!Hlp_IsValidHandle(barPreview_hndl)) {
        MEM_Warn("B4DI_BarPreview_hide failed ");
        return;
    };
    var _barPreview bp; bp = get(barPreview_hndl);
    //TODO: cancle animanitions
    bp.val = 0;
    bp.changesMaximum = 0;
    bp.isFadedOutPreview = 1;
    View_Close(bp.vPreView);
    B4DI_BarPreview_hideOverShoot(barPreview_hndl);
    MEM_Info("B4DI_Bars_hideItemPreview");
};

func void B4DI_BarPreview_CalcPosScale( var int barPreview_hndl, var int value) {
    if(!Hlp_IsValidHandle(barPreview_hndl)) {
        MEM_Warn("B4DI_BarPreview_CalcPosScale failed ");
        return;
    };
    var _barPreview bp; bp = get(barPreview_hndl);
    var _extendedBar eBar; eBar = get(bp.eBar_parent);
    var _bar bar; bar = get(eBar.bar);
    var zCview vBar; vBar = View_Get(bar.v1);
    var zCView vPreview; vPreview = View_Get(bp.vPreView);

    bp.val = value;

    //TODO negative Preview
    if(B4DI_BARPREVIEW_HAS_OWN_LABEL){
        var int s0;s0=SB_New(); SB_Use(s0);
        SB("+");
    };
    var int diffValueToBarValMax; diffValueToBarValMax = bar.valMax - bar.val;
    //MEM_Info(IntToString(diffValueToBarValMax));
    
    var int preview_vsizex;
    //value(preview) with overshoot
    if(diffValueToBarValMax < value){       
        preview_vsizex = (((diffValueToBarValMax *1000) / bar.valMax) * bar.barW / 1000);
        var int overshoot_vsizex; overshoot_vsizex = ((( (value - diffValueToBarValMax) *1000) / bar.valMax) * bar.barW / 1000);

        View_Resize(bp.vPreView, preview_vsizex, vBar.vsizey);
        View_MoveTo(bp.vPreView, vBar.vposx + vBar.vsizex, vBar.vposy );
        
        B4DI_BarPreview_Show(barPreview_hndl);
        
        View_Resize(bp.vOverShoot, overshoot_vsizex, vBar.vsizey);
        View_MoveTo(bp.vOverShoot, vBar.vposx + vBar.vsizex + preview_vsizex, vBar.vposy );
        
        B4DI_BarPreview_ShowOverShoot(barPreview_hndl);

        if(B4DI_BARPREVIEW_HAS_OWN_LABEL){
            SBi( diffValueToBarValMax ); SB("("); SBi(value); SB(")");
        };

    } else {
        preview_vsizex = (((value *1000) / bar.valMax) * bar.barW / 1000);

        B4DI_BarPreview_hideOverShoot(barPreview_hndl);

        View_Resize(bp.vPreView, preview_vsizex, vBar.vsizey);
        View_MoveTo(bp.vPreView, vBar.vposx + vBar.vsizex, vBar.vposy );

        B4DI_BarPreview_Show(barPreview_hndl);

        if(B4DI_BARPREVIEW_HAS_OWN_LABEL){
            SBi(value);
        };
    };
    //TODO preview for maximum increase
    
    if(B4DI_BARPREVIEW_HAS_OWN_LABEL){
        var string label; label = SB_ToString();

        var int lLenght; lLenght = Print_ToVirtual( Print_GetStringWidth(label, B4DI_LABEL_FONT), PS_X );
        var int fHeight; fHeight = Print_ToVirtual( Print_GetFontHeight(B4DI_LABEL_FONT), PS_Y );

        var int xPos; xPos = (PS_VMAX / 2) - ( Print_ToVirtual(lLenght, vPreView.vsizex) / 2 ); // >>1 == / 2
        var int yPos; yPos = (PS_VMAX / 2) - ( Print_ToVirtual(fHeight, vPreView.vsizey) / 2 ); // >>1 == / 2

        View_DeleteText(bp.vPreView);
        View_AddText(bp.vPreView, xPos, yPos, label, TEXT_FONT_Inventory );
        SB_Destroy();
    };

};


