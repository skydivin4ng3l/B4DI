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
    if(!Hlp_IsValidHandle(bar_hndl)) { MEM_Warn("B4DI_Bar_SetBarSizeCenteredPercent failed"); return; };
    var _bar b; b = get(bar_hndl);
    var zCView vBar; vBar = View_Get(b.v1);
    //save the size before the resize
    //var int sizex_pre; sizex_pre = Print_ToVirtual(b.val,PS_X); 
    var int sizex_pre; sizex_pre = roundf( mulf( fracf( b.val , b.valMax), mulf( mkf(b.initialDynamicVSizes[IDS_VBAR_X]), dynScalingFactor ) ) ) ; 
    var int sizey_pre; sizey_pre = roundf( mulf( mkf(b.initialDynamicVSizes[IDS_VBAR_Y]), dynScalingFactor ) ) ; // Dynamic Test +1 is missing, but needed?

    //scale on all axis
    View_ResizeCentered(b.v1, sizex_pre * x_percentage / 100 , sizey_pre * y_percentage / 100 ); 
        
    //Debug
    //B4DI_debugSpy("Bar PositionX",IntToString(vBar.vposx));
    //B4DI_debugSpy("Bar PositionY",IntToString(vBar.vposy));
    //B4DI_debugSpy("Bar SizeX",IntToString(vBar.vsizex));
    //B4DI_debugSpy("Bar SizeY",IntToString(vBar.vsizey));

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
    if(!Hlp_IsValidHandle(bar_hndl)) { MEM_Warn("B4DI_Bar_dynamicMenuBasedScale failed"); return; };
    var _bar b; b = get(bar_hndl);
    
    var zCView vBack; vBack = View_Get(b.v0);
    var zCView vBar; vBar = View_Get(b.v1);

    /*var int dynScalingFactor;*/ dynScalingFactor = B4DI_Bars_getDynamicScaleOptionValuef();

    Bar_ResizeCenteredPercentFromInitial(bar_hndl, dynScalingFactor);
    //TODO Implement different customizeable alignments, maybe per set margin within the Resize process

    // Keep Left aligned
    //compensate scaling difference of left and top offset
    //should not be needed for centered//View_MoveTo(b.v1, vBar.vposx- barLeftOffset , vBar.vposy-barTopOffset);

};

//========================================
// eBar Alpha
//========================================
func void B4DI_eBar_SetAlpha(var int eBar_hndl, var int alpha) {
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_SetAlpha failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);
    var _bar bar; bar = get(eBar.bar);

    View_SetAlpha(bar.v0, alpha);
    View_SetAlphaAll(bar.vMiddle, alpha);
    View_SetAlpha(bar.v1, alpha);
    
};

//========================================
// eBar NPC
//========================================
func void B4DI_eBar_SetNpcRef(var int eBar_hndl, var int C_NPC_ptr) {
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_SetNpcRef failed: invalid eBar_hndl"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);
    var C_NPC new_npc_inst; new_npc_inst = MEM_PtrToInst(C_NPC_ptr);
    if ( !Hlp_IsValidNpc( new_npc_inst ) ) { MEM_Warn("B4DI_eBar_SetNpcRef failed: invalid C_NPC_ptr"); return; };
    eBar.npcRef = C_NPC_ptr;
};

func int B4DI_eBar_GetNpcRef(var int eBar_hndl) {
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_GetNpcRef failed: invalid eBar_hndl"); return 0; };
    var _extendedBar eBar; eBar = get(eBar_hndl);
    if ( eBar.npcRef ) {
        return eBar.npcRef;
    } else {
        return false;
    };
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
    //eBar.barPostview = B4DI_BarPreview_Create(new_eBar_hndl);

    Bar_Show(eBar.bar);
    //created invisible
    B4DI_eBar_SetAlpha(new_eBar_hndl, 0);
    eBar.isFadedOut = 1;

    eBar.npcRef = 0;

    return new_eBar_hndl;
};

//========================================
// eBar Animations
//========================================
func void B4DI_eBar_fadeOut(var int eBar_hndl, var int deleteBar) {
    var _extendedBar eBar_inst; eBar_inst = get(eBar_hndl);
    //var _bar bar_inst; bar_inst = get(eBar_inst.bar);
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

func void B4DI_eBar_pulse_size(var int eBar_hndl, var func pulseFunc) {
    if (!Hlp_IsValidHandle(ebar_hndl)) { MEM_Warn("B4DI_eBar_pulse_size failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);

    var int alreadyPulsating; alreadyPulsating = false;
    if ( Hlp_IsValidHandle(eBar.anim8PulseSize) ) {
            //Anim8_Delete(eBar.anim8PulseSize);
            alreadyPulsating = true;
        };
    if ( !alreadyPulsating ) {
        eBar.anim8PulseSize = Anim8_NewExt(100 , pulseFunc, eBar.bar, false);
    };
    Anim8_RemoveIfEmpty(eBar.anim8PulseSize, true);
    Anim8_RemoveDataIfEmpty(eBar.anim8PulseSize, false);

    if(alreadyPulsating) {
        Anim8q(eBar.anim8PulseSize, 100,  100, A8_Wait);
    } else {
        Anim8(eBar.anim8PulseSize, 100,  100, A8_Wait);
    };
    Anim8q(eBar.anim8PulseSize, 150, 200, A8_SlowEnd);
    Anim8q(eBar.anim8PulseSize, 100, 100, A8_SlowStart);

};

//========================================
// eBar Label
//========================================
//TODO Fix??? Label gets not shown after bar fades out and inventory gets opended
func string B4DI_eBar_generateLabelTextSimple(var int ebar_hndl) {
    if(!Hlp_IsValidHandle(ebar_hndl)) { MEM_Warn("B4DI_eBar_generateLabelTextSimple failed"); return ""; };

    if(SB_Get()) {
        B4DI_preserve_current_StringBuilder = SB_Get();
    };
    var int sbuilder; sbuilder=SB_New();
    SB_Use(sbuilder);

    var _extendedBar eBar; eBar = get(eBar_hndl);
    var _bar bar; bar = get(eBar.bar);
    var int previewValue; previewValue = B4DI_BarPreview_GetValue(eBar.barPreview);
    var int changesMaximum; changesMaximum = B4DI_BarPreview_GetChangesMaximum(eBar.barPreview);

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
    if(changesMaximum) {
        if(previewValue<0) {
            SB(" ");
        } else if (previewValue > 0) {
            SB(" +"); SBi(previewValue);
        };
    };
    var string label; label = SB_ToString();
    SB_Destroy();
    SB_Use(B4DI_preserve_current_StringBuilder);
    //B4DI_debugSpy("B4DI_eBar_generateLabelTextSimple: ", label);
    return label;
};

//========================================
// eBar RefreshLabel
//========================================
func void B4DI_eBar_RefreshLabel(var int eBar_hndl) {
    //TODO make optional
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_RefreshLabel failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);
    
    var _bar bar; bar = get(eBar.bar);
    var zCView vLabel; vLabel = View_Get(bar.vMiddle);
    var string label; label = B4DI_eBar_generateLabelTextSimple(eBar_hndl);

    var int lLenght; lLenght = Print_ToVirtual( Print_GetStringWidth(label, B4DI_LABEL_FONT), PS_X );
    var int fHeight; fHeight = Print_ToVirtual( Print_GetFontHeight(B4DI_LABEL_FONT), PS_Y );

    var int xPos; xPos = (PS_VMAX / 2) - ( Print_ToVirtual(lLenght, vLabel.vsizex) / 2 ); // >>1 == / 2
    var int yPos; yPos = (PS_VMAX / 2) - ( Print_ToVirtual(fHeight, vLabel.vsizey) / 2 ); // >>1 == / 2
    //B4DI_Info2("Label xPos: ", xPos, " yPos: ", yPos );

    View_DeleteText(bar.vMiddle);
    View_AddText(bar.vMiddle, xPos, yPos , label , B4DI_LABEL_FONT);
    if(eBar.isFadedOut) {
        B4DI_eBar_SetAlpha(eBar_hndl, 0);
    };

    //B4DI_Info1("B4DI_eBar_RefreshLabel call while isFadedOut: ", eBar.isFadedOut);
};

//========================================
// eBar Hide / Show
//========================================
func void B4DI_eBar_hideCustom( var int eBar_hndl, var int animated){
    if(!Hlp_IsValidHandle(ebar_hndl)) { MEM_Info("B4DI_eBar_hide failed"); return; };
    var _extendedBar eBar_inst; eBar_inst = get(ebar_hndl);

    if( !eBar_inst.isFadedOut ) {
        eBar_inst.isFadedOut = 1;
        if(!animated) {
            B4DI_eBar_SetAlpha(eBar_hndl, 0);
        } else {
            B4DI_eBar_fadeOut(eBar_hndl, false);
        };
        MEM_Info("B4DI_eBar_hide successful");
    } else {
        //MEM_Info("B4DI_eBar_hide already hidden");
    };
};

func void B4DI_eBar_hideInstant( var int eBar_hndl){
    B4DI_eBar_hideCustom(eBar_hndl, false);
    var _extendedBar eBar; eBar = get(eBar_hndl);
    if ( Hlp_IsValidHandle(eBar.barPostview) ) {
        B4DI_BarPostview_delete(eBar.barPostview);
    };
};

func void B4DI_eBar_hideFaded( var int eBar_hndl){
    B4DI_eBar_hideCustom(eBar_hndl, true);
};

func void B4DI_eBar_show( var int eBar_hndl){
    if(!Hlp_IsValidHandle(eBar_hndl)) {
        MEM_Warn("B4DI_eBar_show failed");
        return;
    };
    var _extendedBar eBar_inst; eBar_inst = get(eBar_hndl);
    if (eBar_inst.isFadedOut) {
        if(Hlp_IsValidHandle(eBar_inst.anim8FadeOut) ){
            Anim8_Delete(eBar_inst.anim8FadeOut);
        };
        eBar_inst.isFadedOut = 0;
        B4DI_eBar_SetAlpha(eBar_hndl, 255);
        //Bar_Show(eBar_inst.bar);
        MEM_Info("B4DI_eBar_show successful");
    } else {
        //MEM_Info("B4DI_eBar_show already visible");
    };

    ////TODO make optional 
    //B4DI_eBar_RefreshLabel(eBar_hndl);

    //var _bar bar; bar = get(eBar_inst.bar);
    //View_DeleteText(bar.vMiddle); //experimental use of middle

    //View_AddText(bar.vMiddle, 0, 0, B4DI_eBar_generateLabelTextSimple(eBar_hndl), TEXT_FONT_Inventory);

};

//========================================
// eBar Preview hide/show
//========================================
func void B4DI_eBar_HidePreview(var int eBar_hndl){
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_HidePreview failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);
    B4DI_BarPreview_hide(eBar.barPreview);

    MEM_Info("B4DI_eBar_HidePreview successful");
};

func void B4DI_eBar_ShowPreview(var int eBar_hndl, var int value) {
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_ShowPreview failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);

    B4DI_BarPreview_CalcPosScale(eBar.barPreview, value);
    B4DI_eBar_RefreshLabel(eBar_hndl);

    areItemPreviewsHidden = false;
    MEM_Info("B4DI_eBar_ShowPreview successful");
};

func void B4DI_eBar_SetPreviewChangesMaximum(var int eBar_hndl){
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_SetPreviewChangesMaximum failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);

    B4DI_BarPreview_SetChangesMaximum(eBar.barPreview);

};

//========================================
// eBar Value
//========================================
func void B4DI_Bar_SetValuesBasic(var int bar_hndl, var int value, var int valueMax) {
    if( !Hlp_IsValidHandle(bar_hndl) ) { MEM_Warn("B4DI_Bar_SetValuesBasic failed"); return; };
    
    Bar_SetMax(bar_hndl, valueMax);
    Bar_SetValue(bar_hndl, value);
};


func void B4DI_eBar_SetValuesBasic(var int eBar_hndl, var int value, var int valueMax) {
    if( !Hlp_IsValidHandle(eBar_hndl) ) { MEM_Warn("B4DI_eBar_SetValuesBasic failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);

    B4DI_Bar_SetValuesBasic(eBar.bar, value, valueMax);
};

//TODO depricate
//func void B4DI_eBar_SetValuesNPC(var int eBar_hndl, var int index_value, var int index_valueMax, var int C_NPC_ptr) {
//    if( !Hlp_IsValidHandle(eBar_hndl) ) { MEM_Warn("B4DI_eBar_SetValuesNPC failed"); return; };
    
//    var C_NPC my_npc;
//    if(C_NPC_ptr < 1) {
//        my_npc = _^(_@(hero));

//    } else {
//        my_npc = MEM_PtrToInst(C_NPC_ptr);
//        if( !Hlp_IsValidNpc( my_npc ) ) { 
//            MEM_Info("B4DI_eBar_SetValuesNpc failed not correct NPC");
//            return;
//        };
//        //MEM_Info("B4DI_eBar_SetValuesNPC");
//    };

//    B4DI_eBar_SetValuesBasic( eBar_hndl, MEM_ReadStatArr(my_npc.attribute, index_value), MEM_ReadStatArr(my_npc.attribute, index_valueMax) );    
    
//};

func void B4DI_eBar_SetValuesAttributeBased(var int eBar_hndl, var int index_value, var int index_valueMax) {
    if( !Hlp_IsValidHandle(eBar_hndl) ) { MEM_Warn("B4DI_eBar_SetValuesAttributeBased failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);
    var C_NPC npcRef_inst; npcRef_inst = MEM_PtrToInst(eBar.npcRef);
    
    if( !Hlp_IsValidNpc( npcRef_inst ) ) { 
        MEM_Info("B4DI_eBar_SetValuesAttributeBased failed not correct NPC");
        return;
    };
        //MEM_Info("B4DI_eBar_SetValuesAttributeBased");

    B4DI_eBar_SetValuesBasic( eBar_hndl, MEM_ReadStatArr(npcRef_inst.attribute, index_value), MEM_ReadStatArr(npcRef_inst.attribute, index_valueMax) );    
    
};

func void B4DI_eBar_SetValues(var int ebar_hndl, var int index_value, var int index_valueMax) {
    //B4DI_eBar_SetValuesNPC(ebar_hndl, index_value, index_valueMax, 0);
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_SetValues failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);

    if ( !eBar.npcRef ) {
        B4DI_eBar_SetValuesBasic(eBar_hndl, index_value, index_valueMax);
    } else {
        var C_NPC npcRef_inst; npcRef_inst = MEM_PtrToInst(eBar.npcRef);
        if ( !Hlp_IsValidNpc( npcRef_inst ) ) {
            MEM_Warn("B4DI_eBar_SetValues failed wrong npcRef");
            return;
        };
        B4DI_eBar_SetValuesAttributeBased(eBar_hndl, index_value, index_valueMax);
        //MEM_Info("B4DI_eBar_Refresh NPC specific");
    };
};

func void B4DI_eBar_SetValuesAnimated( var int eBar_hndl,var int index_value, var int index_valueMax, var int value_diff) {
    //TODO: adjust PostView Create to allow negative value_diff with correct behavior
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_SetValues failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);

    if (value_diff == 0) {
        //B4DI_Info1("B4DI_eBar_SetValuesAnimated: ", value_diff );
        B4DI_eBar_SetValues(eBar_hndl, index_value, index_valueMax);
    } else if ( value_diff < 0 ) {
        //B4DI_Info1("B4DI_eBar_SetValuesAnimated: ", value_diff );
        B4DI_eBar_SetValues(eBar_hndl, index_value, index_valueMax);

        eBar.barPostview = B4DI_BarPostview_Create(eBar_hndl, abs(value_diff) );
        B4DI_BarPostview_Show(eBar.barPostview);
        B4DI_BarPostview_slide_size(eBar.barPostview, B4DI_BarPostview_SetSizeLeftsidedPercentX);
    } else if ( value_diff > 0 ) {
        //B4DI_Info1("B4DI_eBar_SetValuesAnimated: ", value_diff );
        eBar.barPostview = B4DI_BarPostview_Create(eBar_hndl, abs(value_diff) );
        B4DI_BarPostview_Show(eBar.barPostview);
        B4DI_BarPostview_slide_size(eBar.barPostview, B4DI_BarPostview_SetSizeLeftsidedPercentX);

        B4DI_eBar_SetValues(eBar_hndl, index_value, index_valueMax);
    };
};


//========================================
// Bar Label may be deprecated
//========================================
//func string B4DI_Bar_generateLabel(var int bar_hndl, var int current_value, var int max_value) {
//    if(SB_Get()) {
//        B4DI_preserve_current_StringBuilder = SB_Get();
//    };
//    var int sbuilder; sbuilder=SB_New();
//    SB_Use(sbuilder);
//    SBi(current_value);
//    //if()
//     SB(" / "); SBi(max_value);
//    var string label; label = SB_ToString();
//    SB_Destroy();
//    SB_Use(B4DI_preserve_current_StringBuilder);
//    return label;
//};

//========================================
// eBar Refresh
//========================================
//TODO generalize maybe with pointer to npc in extenedbar,...to allow xpbar to use refresh the same way and refresh be simpler
//func void B4DI_eBar_RefreshNPC(var int eBar_hndl, var int index_value, var int index_valueMax, var int C_NPC_ptr) {
//    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_RefreshNPC failed"); return; };
//    var _extendedBar eBar; eBar = get(eBar_hndl);

//    if ( C_NPC_ptr < 1 ) {
//        B4DI_eBar_SetValues(eBar_hndl, index_value, index_valueMax);
//    } else {
//        var C_NPC my_npc; my_npc = MEM_PtrToInst(C_NPC_ptr);
//        if ( !Hlp_IsValidNpc( my_npc ) ) {
//            MEM_Warn("B4DI_eBar_RefreshNPC failed wrong NPC_ptr");
//            return;
//        };
//        B4DI_eBar_SetValuesNPC(eBar_hndl, index_value, index_valueMax, C_NPC_ptr);
//        //MEM_Info("B4DI_eBar_Refresh NPC specific");
//    };

//    B4DI_eBar_RefreshLabel(eBar_hndl);
//    var _bar bar; bar = get(eBar.bar);

//    //MEM_Info("B4DI_eBar_Refresh");
//    B4DI_debugSpy("B4DI_eBar_Refresh ", View_GetTexture(bar.v1) );
//};


func void B4DI_eBar_RefreshAnimated(var int eBar_hndl, var int index_value, var int index_valueMax, var int animated_value_diff) {
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_RefreshAnimated failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);

    if ( !animated_value_diff ) {
        B4DI_eBar_SetValues(eBar_hndl, index_value, index_valueMax);
    } else {
        MEM_Info("B4DI_eBar_RefreshAnimated Animation specific");
        B4DI_eBar_SetValuesAnimated(eBar_hndl, index_value, index_valueMax, animated_value_diff);
    };

    B4DI_eBar_RefreshLabel(eBar_hndl);
    var _bar bar; bar = get(eBar.bar);

    //MEM_Info("B4DI_eBar_RefreshAnimated");
    B4DI_debugSpy("B4DI_eBar_RefreshAnimated finished ", View_GetTexture(bar.v1) );
};

func void B4DI_eBar_Refresh(var int eBar_hndl, var int index_value, var int index_valueMax) {
    B4DI_eBar_RefreshAnimated( eBar_hndl, index_value, index_valueMax, false);
};


