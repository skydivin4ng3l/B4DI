/***********************************\
         B4DI extended BARS
\***********************************/

//========================================
// [Intern] Resizes actual bar according to percentage reltaive to center
//
//========================================
//TODO Rework to eBar
func void B4DI_Bar_SetBarSizeCenteredPercent(var int bar_hndl, var int x_percentage, var int y_percentage ) { 
    Print_GetScreenSize();
    //------------------
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    var _bar b; b = get(bar_hndl);
    var zCView vBar; vBar = View_Get(b.v1);
    //save the size before the resize
    //var int sizex_pre; sizex_pre = Print_ToVirtual(b.val,PS_X); 
    var int sizex_pre; sizex_pre = roundf( mulf( fracf( b.val , b.valMax), mulf( mkf(b.initialDynamicVSizes[IDS_VBAR_X]), dynScalingFactor ) ) ) ; 
    var int sizey_pre; sizey_pre = roundf( mulf( mkf(b.initialDynamicVSizes[IDS_VBAR_Y]), dynScalingFactor ) ) ; // Dynamic Test +1 is missing, but needed?

    //scale on all axis
    View_ResizeCentered(b.v1, sizex_pre * x_percentage / 100 , sizey_pre * y_percentage / 100 ); 
        
    //Debug
    B4DI_debugSpy("Bar PositionX",IntToString(vBar.vposx));
    B4DI_debugSpy("Bar PositionY",IntToString(vBar.vposy));
    B4DI_debugSpy("Bar SizeX",IntToString(vBar.vsizex));
    B4DI_debugSpy("Bar SizeY",IntToString(vBar.vsizey));

};

func void B4DI_Bar_SetBarSizeCenteredPercentY(var int bar_hndl, var int y_percentage){
    B4DI_Bar_SetBarSizeCenteredPercent(bar_hndl, 100, y_percentage);
};

func void B4DI_Bar_SetBarSizeCenteredPercentX(var int bar_hndl, var int x_percentage){
    B4DI_Bar_SetBarSizeCenteredPercent(bar_hndl, x_percentage,100 );
};

func void B4DI_Bar_SetBarSizeCenteredPercentXY(var int bar_hndl, var int xy_percentage){
    B4DI_Bar_SetBarSizeCenteredPercent(bar_hndl, xy_percentage, xy_percentage );
};


//========================================
// [intern] Helper Scales depenting on Resolution
//========================================
var int B4DI_BarScale[6];
func void B4DI_InitBarScale(){
    Print_GetScreenSize();
    B4DI_BarScale[0]= B4DI_BarScale_off;
    // auto scale inspired by systempack.ini
    B4DI_BarScale[1]= roundf( mulf( mkf(100) ,fracf( Print_Screen[PS_Y] ,512 ) ) );
    B4DI_BarScale[2]= B4DI_BarScale_50;
    B4DI_BarScale[3]= B4DI_BarScale_100;
    B4DI_BarScale[4]= B4DI_BarScale_150;
    B4DI_BarScale[5]= B4DI_BarScale_200;
};

//========================================
// [Intern] Get Dynamic Scale according of Menu value (gothic.ini) asFloat
//
//========================================
func int B4DI_Bars_getDynamicScaleOptionValuef(){
    B4DI_InitBarScale();
    var int scaleOption; scaleOption = STR_ToInt(MEM_GetGothOpt("B4DI", "B4DI_barScale"));
    var int scalingFactor; //scalingFactor = B4DI_BarScale_auto; //Default
    MEM_Info( ConcatStrings( "Bar scaleOption = ", IntToString( scaleOption ) ) );
    if(!scaleOption) {
        MEM_Error("Bar Scale Option not set using Default Auto instead!");
        scalingFactor = MEM_ReadStatArr(B4DI_BarScale,1);
        MEM_Info( ConcatStrings( "Bar Scalingfactor = ", IntToString(scalingFactor) ) );
    } else{
        scalingFactor = MEM_ReadStatArr(B4DI_BarScale,scaleOption);
        MEM_Info( ConcatStrings( "Bar Scalingfactor = ", IntToString(scalingFactor) ) );
    };

    var int percScalingFactor; percScalingFactor = fracf( scalingFactor, 100 );
    MEM_Info( ConcatStrings( "percScalingFactor = ", toStringf(percScalingFactor) ) );

    return percScalingFactor;
};

//========================================
// [Intern] Resizes bars according of Menu value (gothic.ini)
//========================================
func void B4DI_Bar_dynamicMenuBasedScale(var int bar_hndl){
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    var _bar b; b = get(bar_hndl);
    
    var zCView vBack; vBack = View_Get(b.v0);
    var zCView vBar; vBar = View_Get(b.v1);

    /*var int dynScalingFactor;*/ dynScalingFactor = B4DI_Bars_getDynamicScaleOptionValuef();

    Bar_ResizeCenteredPercentFromInitial(bar_hndl, dynScalingFactor);
    //TODO Implement different customizeable alignments, maybe per set margin within the Resize process

    // Keep Left aligned
    //compensate scaling difference of left and top offset
    //should not be needed for centered//View_MoveTo(b.v1, vBar.vposx- barLeftOffset , vBar.vposy-barTopOffset);

    ////---debug print
    
    var int s0;s0=SB_New();
    SB_Use(s0);
    SB("scaleFactor: "); SBi(roundf(dynScalingFactor));SB("  ");
    SB("dynScalingFactor: "); SB(toStringf(dynScalingFactor)); SB(" / ");
    SB("BACK: ");   SBi(vBack.psizex); SB(" , "); SBi(vBack.psizey); SB(" ");
    SB("BAR: ");   SBi(vBar.psizex); SB(" , "); SBi(vBar.psizey); SB(" ");
    SB("barW: "); SBi( Print_ToPixel( b.barW, PS_X ) );
    Print_ExtPxl(50,Print_Screen[PS_Y] / 2, SB_ToString(), FONT_Screen, RGBA(255,0,0,200),2500);
    SB_Destroy();
};

//========================================
// eBar Alpha
//========================================
func void B4DI_eBar_SetAlpha(var int eBar_hndl, var int alpha) {
    if(!Hlp_IsValidHandle(eBar_hndl)) { return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);
    var _bar bar; bar = get(eBar.bar);

    View_SetAlpha(bar.v0, alpha);
    View_SetAlphaAll(bar.vMiddle, alpha);
    View_SetAlpha(bar.v1, alpha);
    
};

//========================================
// eBar Create
//========================================
func int B4DI_eBar_Create(var int Bar_constructor_instance) {
    var int new_eBar_hndl; new_eBar_hndl = new(_extendedBar@);
    var _extendedBar eBar; eBar = get(new_eBar_hndl);
    
    eBar.bar = Bar_CreateCenterDynamic(Bar_constructor_instance);
    B4DI_Bar_dynamicMenuBasedScale(eBar.bar);

    eBar.barPreview = B4DI_BarPreview_Create(new_eBar_hndl);
    if(!Hlp_IsValidHandle(eBar.barPreview)) {
        MEM_Warn("B4DI_eBar_Create failed at B4DI_BarPreview_Create"); 
        return 0;
    };

    B4DI_eBar_SetAlpha(new_eBar_hndl, 0);
    eBar.isFadedOut = 1;

    return new_eBar_hndl;
};

//========================================
// eBar Animations
//========================================
func void B4DI_eBar_fadeOut(var int eBar_hndl, var int deleteBar) {
    var _extendedBar eBar_inst; eBar_inst = get(eBar_hndl);
    var _bar bar_inst; bar_inst = get(eBar_inst.bar);
    eBar_inst.anim8FadeOut = Anim8_NewExt(255, B4DI_eBar_SetAlpha, eBar_hndl, false);
    Anim8_RemoveIfEmpty(eBar_inst.anim8FadeOut, true);
    if (deleteBar) {
        Anim8_RemoveDataIfEmpty(eBar_inst.anim8FadeOut, true);
    } else {
        Anim8_RemoveDataIfEmpty(eBar_inst.anim8FadeOut, false);
    };
    
    Anim8(eBar_inst.anim8FadeOut, 255,  5000, A8_Wait);
    Anim8q(eBar_inst.anim8FadeOut,   0, 2000, A8_SlowEnd);
};

//========================================
// eBar Label
//========================================
//TODO Fix??? Label gets not shown after bar fades out and inventory gets opended
func string B4DI_eBar_generateLabelTextSimple(var int ebar_hndl) {
    if(!Hlp_IsValidHandle(ebar_hndl)) {
        MEM_Warn("B4DI_eBar_generateLabelTextSimple failed");
        return "";
    };
    if(SB_Get()) {
        B4DI_preserve_current_StringBuilder = SB_Get();
    };
    var int sbuilder; sbuilder=SB_New();
    SB_Use(sbuilder);

    var _extendedBar eBar; eBar = get(eBar_hndl);
    var _bar bar; bar = get(eBar.bar);
    var int previewValue; previewValue = B4DI_BarPreview_GetValue(eBar.barPreview);

    SBi(bar.val);
    if(previewValue < 0) {
        SB(" "); SBi(previewValue); //negative needs also repesentation
    } else if(previewValue > 0) {
        var int diffValueToBarValMax; diffValueToBarValMax = bar.valMax - bar.val;
        SB(" +");
        if(diffValueToBarValMax < previewValue){       
             SBi( diffValueToBarValMax ); SB("("); SBi(previewValue); SB(")");
        } else {
            SBi(previewValue);
        };
    };
    SB(" / "); SBi(bar.valMax);
    var string label; label = SB_ToString();
    SB_Destroy();
    SB_Use(B4DI_preserve_current_StringBuilder);
    B4DI_debugSpy("B4DI_eBar_generateLabelTextSimple: ", label);
    return label;
};

//========================================
// eBar Hide / Show
//========================================
func void B4DI_eBar_hide( var int eBar_hndl){
    if(!Hlp_IsValidHandle(ebar_hndl)) {
        MEM_Info("B4DI_eBar_hide failed");
        return;
    };
    var _extendedBar eBar_inst; eBar_inst = get(ebar_hndl);

    eBar_inst.isFadedOut = 1;
    B4DI_eBar_fadeOut(eBar_hndl, false);
    MEM_Info("B4DI_eBar_hide successful");
};

func void B4DI_eBar_show( var int eBar_hndl){
    if(!Hlp_IsValidHandle(eBar_hndl)) {
        MEM_Warn("B4DI_eBar_show failed");
        return;
    };
    var _extendedBar eBar_inst; eBar_inst = get(eBar_hndl);
    if(Hlp_IsValidHandle(eBar_inst.anim8FadeOut) ){
        Anim8_Delete(eBar_inst.anim8FadeOut);
    };
    eBar_inst.isFadedOut = 0;
    B4DI_eBar_SetAlpha(eBar_hndl, 255);
    Bar_Show(eBar_inst.bar);
    var _bar bar; bar = get(eBar_inst.bar);
    ////TODO make optional 
    //View_DeleteText(bar.vMiddle); //experimental use of middle

    //View_AddText(bar.vMiddle, 0, 0, B4DI_eBar_generateLabelTextSimple(eBar_hndl), TEXT_FONT_Inventory);

    MEM_Info("B4DI_eBar_show successful");
};

//========================================
// eBar Preview hide/show/Value
//========================================
func void B4DI_eBar_HidePreview(var int eBar_hndl){
    if(!Hlp_IsValidHandle(eBar_hndl)) { return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);
    B4DI_BarPreview_hide(eBar.barPreview);

    MEM_Info("B4DI_eBar_HidePreview successful");
};

func void B4DI_eBar_ShowPreview(var int eBar_hndl, var int value) {
    if(!Hlp_IsValidHandle(eBar_hndl)) { return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);

    B4DI_BarPreview_CalcPosScale(eBar.barPreview, value);
    //TODO Refresh label
    areItemPreviewsHidden = false;
    MEM_Info("B4DI_eBar_ShowPreview successful");
};

func void B4DI_Bar_SetValues(var int bar_hndl, var int index_value, var int index_valueMax) {
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };

    Bar_SetMax(bar_hndl, MEM_ReadStatArr(hero.attribute, index_valueMax) );
    Bar_SetValue(bar_hndl, MEM_ReadStatArr(hero.attribute, index_value) );
    
    MEM_Info("B4DI_Bar_SetValues");
    //var _bar bar; bar = get(bar_hndl);
    //MEM_Info(cs2("hero.attribute[ATR_HITPOINTS_MAX]: ",i2s(hero.attribute[ATR_HITPOINTS_MAX])));
    //MEM_Info(cs2(" hero.attribute[ATR_HITPOINTS]: ",i2s(hero.attribute[ATR_HITPOINTS])));
    //MEM_Info(cs2("bar.valMax: ",i2s(bar.valMax)));
    //MEM_Info(cs2(" bar.val: ",i2s(bar.val)));
};

//========================================
// Bar Label may be deprecated
//========================================
func string B4DI_Bar_generateLabel(var int bar_hndl, var int current_value, var int max_value) {
    if(SB_Get()) {
        B4DI_preserve_current_StringBuilder = SB_Get();
    };
    var int sbuilder; sbuilder=SB_New();
    SB_Use(sbuilder);
    SBi(current_value);
    //if()
     SB(" / "); SBi(max_value);
    var string label; label = SB_ToString();
    SB_Destroy();
    SB_Use(B4DI_preserve_current_StringBuilder);
    return label;
};

//========================================
// eBar Refresh
//========================================
func void B4DI_eBar_Refresh(var int eBar_hndl, var int index_value, var int index_valueMax) {
    if(!Hlp_IsValidHandle(eBar_hndl)) { return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);
    B4DI_Bar_SetValues(eBar.bar, index_value, index_valueMax);
    
    var _bar bar; bar = get(eBar.bar);
    //TODO make optional
    View_DeleteText(bar.vMiddle);
    View_AddText(bar.vMiddle, 0, 0, B4DI_eBar_generateLabelTextSimple(eBar_hndl), TEXT_FONT_Inventory);
    if(eBar.isFadedOut) {
        B4DI_eBar_SetAlpha(eBar_hndl, 0);
    };

    MEM_Info("B4DI_eBar_Refresh");
};

