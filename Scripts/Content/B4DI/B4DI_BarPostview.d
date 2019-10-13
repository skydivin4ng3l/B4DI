/***********************************\
                BARPOSTVIEW
\***********************************/
//========================================
// BarPostview Create
//========================================
func int B4DI_BarPostview_Create( var int eBar_hndl, var int value){
    //B4DI_Info1("B4DI_BarPostview_Create called with value: ", value);
    if(!Hlp_IsValidHandle(eBar_hndl)) {
        MEM_Warn("tried to init Postview of a not initialized ebar ");
        return 0;
    };
    var _extendedBar eBar; eBar = get(eBar_hndl);
    var _bar bar; bar = get(eBar.bar);
    var zCView vBar; vBar = View_Get(bar.v1);   

    var int new_bp_hndl; new_bp_hndl = new(_barPostview@);
    var _barPostview bp; bp = get(new_bp_hndl);

    var int postview_vsizex; postview_vsizex = (((value *1000) / bar.valMax) * bar.barW / 1000);
    
    bp.vPostView = View_Create(vBar.vposx + vBar.vsizex, vBar.vposy, vBar.vposx + vBar.vsizex + postview_vsizex, vBar.vposy + vBar.vsizey );
    //TODO maybe different texture for postviews?
    View_SetTexture(bp.vPostView, ViewPtr_GetTexture( MEM_InstToPtr(vBar) ) );

    bp.val = value;
    bp.isFadedOutPostview = 1;
    bp.eBar_parent = eBar_hndl;

    return new_bp_hndl;
};

//========================================
// BarPostview Size percentagebased
//========================================
func void B4DI_BarPostview_SetSizeRightsidedPercent( var int barPostview_hndl, var int x_percentage, var int y_percentage) {
    //Print_GetScreenSize();
    //------------------
    if(!Hlp_IsValidHandle(barPostview_hndl)) { MEM_Warn("B4DI_BarPostview_SetSizeLeftsidedPercent failed"); return; };
    var _barPostview bp; bp = get(barPostview_hndl);
    var zCView vPostView; vPostView = View_Get(bp.vPostView);
    var _extendedBar eBar_parent; eBar_parent = get(bp.eBar_parent);
    var _bar bar; bar = get(eBar_parent.bar);
    //save the size before the resize
    var int sizex_pre; sizex_pre = roundf( mulf( fracf( bp.val , bar.valMax), mulf( mkf(bar.initVSizes[IDS_VBAR_X]), dynScalingFactor ) ) ) ; 
    var int sizey_pre; sizey_pre = roundf( mulf( mkf(bar.initVSizes[IDS_VBAR_Y]), dynScalingFactor ) ) ; 

    //scale on all axis
    View_ResizeRightsided(bp.vPostView, sizex_pre * x_percentage / 100 , sizey_pre * y_percentage / 100); 
        
    //Debug
    //B4DI_debugSpy("B4DI_BarPostview_SetSizeRightsidedPercent PositionX",IntToString(vPostView.vposx));
    //B4DI_debugSpy("B4DI_BarPostview_SetSizeRightsidedPercent PositionY",IntToString(vPostView.vposy));
    //B4DI_debugSpy("B4DI_BarPostview_SetSizeRightsidedPercent SizeX",IntToString(vPostView.vsizex));
    //B4DI_debugSpy("B4DI_BarPostview_SetSizeRightsidedPercent SizeY",IntToString(vPostView.vsizey));

};

func void B4DI_BarPostview_SetSizeRightsidedPercentXY( var int barPostview_hndl, var int xy_percentage ) {
    B4DI_BarPostview_SetSizeRightsidedPercent(barPostview_hndl, xy_percentage, xy_percentage);
};

func void B4DI_BarPostview_SetSizeRightsidedPercentX( var int barPostview_hndl, var int x_percentage ) {
    B4DI_BarPostview_SetSizeRightsidedPercent(barPostview_hndl, x_percentage, 100);
};

func void B4DI_BarPostview_SetSizeRightsidedPercentY( var int barPostview_hndl, var int y_percentage ) {
    B4DI_BarPostview_SetSizeRightsidedPercent(barPostview_hndl, 100, y_percentage);
};

func void B4DI_BarPostview_SetSizeLeftsidedPercent( var int barPostview_hndl, var int x_percentage, var int y_percentage) {
    //Print_GetScreenSize();
    //------------------
    if(!Hlp_IsValidHandle(barPostview_hndl)) { MEM_Warn("B4DI_BarPostview_SetSizeLeftsidedPercent failed"); return; };
    var _barPostview bp; bp = get(barPostview_hndl);
    var zCView vPostView; vPostView = View_Get(bp.vPostView);
    var _extendedBar eBar_parent; eBar_parent = get(bp.eBar_parent);
    var _bar bar; bar = get(eBar_parent.bar);
    //save the size before the resize
    var int sizex_pre; sizex_pre = roundf( mulf( fracf( bp.val , bar.valMax), mulf( mkf(bar.initVSizes[IDS_VBAR_X]), dynScalingFactor ) ) ) ; 
    var int sizey_pre; sizey_pre = roundf( mulf( mkf(bar.initVSizes[IDS_VBAR_Y]), dynScalingFactor ) ) ; 

    //scale on all axis
    //View_Resize(bp.vPostView, sizex_pre * x_percentage / 100 , sizey_pre * y_percentage / 100 ); 
    View_ResizeAdvanced(bp.vPostView, sizex_pre * x_percentage / 100 , sizey_pre * y_percentage / 100, ANCHOR_CENTER_LEFT, NON_VALIDSCREENSPACE, VIEW_NO_SIZE_LIMIT, VIEW_NO_SIZE_LIMIT ); 
        
    //Debug
    //B4DI_debugSpy("B4DI_BarPostview_SetSizeLeftsidedPercent PositionX",IntToString(vPostView.vposx));
    //B4DI_debugSpy("B4DI_BarPostview_SetSizeLeftsidedPercent PositionY",IntToString(vPostView.vposy));
    //B4DI_debugSpy("B4DI_BarPostview_SetSizeLeftsidedPercent SizeX",IntToString(vPostView.vsizex));
    //B4DI_debugSpy("B4DI_BarPostview_SetSizeLeftsidedPercent SizeY",IntToString(vPostView.vsizey));

};

func void B4DI_BarPostview_SetSizeLeftsidedPercentXY( var int barPostview_hndl, var int xy_percentage ) {
    B4DI_BarPostview_SetSizeLeftsidedPercent(barPostview_hndl, xy_percentage, xy_percentage);
};

func void B4DI_BarPostview_SetSizeLeftsidedPercentX( var int barPostview_hndl, var int x_percentage ) {
    B4DI_BarPostview_SetSizeLeftsidedPercent(barPostview_hndl, x_percentage, 100);
};

func void B4DI_BarPostview_SetSizeLeftsidedPercentY( var int barPostview_hndl, var int y_percentage ) {
    B4DI_BarPostview_SetSizeLeftsidedPercent(barPostview_hndl, 100, y_percentage);
};


//========================================
// BarPostview Animation
//========================================
func void B4DI_BarPostview_slide_size(var int barPostview_hndl, var func slideFunc) {
    //MEM_Info("B4DI_BarPostview_slide_size called");
    if ( !Hlp_IsValidHandle(barPostview_hndl) ) { return; };
    var _barPostview bp; bp = get(barPostview_hndl);
    bp.anim8SlideSize = Anim8_NewExt(100 , slideFunc, barPostview_hndl, false); //height input
    Anim8_RemoveIfEmpty(bp.anim8SlideSize, true);
    Anim8_RemoveDataIfEmpty(bp.anim8SlideSize, true);
    
    Anim8 (bp.anim8SlideSize, 100,  100, A8_Wait);
    Anim8q(bp.anim8SlideSize, 0, 500, A8_SlowEnd);

    //MEM_Info("B4DI_BarPostview_slide_size finshed");
};

//========================================
// BarPostview Show
//========================================
func void B4DI_BarPostview_Show( var int barPostview_hndl) {
    //MEM_Info("B4DI_BarPostview_Show Called");
    if(!Hlp_IsValidHandle(barPostview_hndl)) {
        MEM_Warn("B4DI_BarPostview_Show failed ");
        return;
    };
    var _barPostview bp; bp = get(barPostview_hndl);
    var _extendedBar eBar_parent; eBar_parent = get(bp.eBar_parent);
    var _bar bar; bar = get(eBar_parent.bar);
    //if( !eBar_parent.isFadedOut ) { //TODO isFadedOut may be to early set and prevent display of Postview
        //TODO: Check Value and adjust for value increase bar and label have to be top
        bp.isFadedOutPostview = 0;
        View_Open(bp.vPostView);
        View_SetAlpha(bp.vPostView, B4DI_barFadeInMax/2);
        View_Top(bp.vPostView);
        View_Top(bar.vLabel);
        //MEM_Info("B4DI_BarPostview_Show finished");
    //};
};

func void B4DI_BarPostview_SetAlphaFunc( var int barPostview_hndl, var int new_alphafunc ) {
    if(!Hlp_IsValidHandle(barPostview_hndl)) {
        MEM_Warn("B4DI_BarPostview_Show failed ");
        return;
    };
    var _barPostview bp; bp = get(barPostview_hndl);
    View_SetAlphaFunc( bp.vPostView, new_alphafunc );
};

//========================================
// BarPostview Delete instead of hide cause nonpersitance
//========================================
func void B4DI_BarPostview_delete( var int barPostview_hndl) {
    if(!Hlp_IsValidHandle(barPostview_hndl)) {
        MEM_Info("B4DI_BarPostview_delete failed ");
        return;
    };
    var _barPostview bp; bp = get(barPostview_hndl);
    _barPostview_Delete(bp);
};

//========================================
// BarPostview WIP?
//========================================
func void B4DI_BarPostView_show_decrease( var int barPostview_hndl, var int value ) {
    if(!Hlp_IsValidHandle(barPostview_hndl)) {
        MEM_Warn("B4DI_BarPostView_show_decrease failed ");
        return;
    };
    
};



