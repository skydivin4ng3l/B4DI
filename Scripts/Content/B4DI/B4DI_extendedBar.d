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
    var int sizex_pre; sizex_pre = roundf( mulf( fracf( b.val , b.valMax), mulf( mkf(b.initVSizes[IDS_VBAR_X]), dynScalingFactor ) ) ) ; 
    var int sizey_pre; sizey_pre = roundf( mulf( mkf(b.initVSizes[IDS_VBAR_Y]), dynScalingFactor ) ) ; // Dynamic Test +1 is missing, but needed?

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
// [Intern] Resizes bars according of Menu value (gothic.ini)
//========================================
func void B4DI_eBar_dynamicMenuBasedScale(var int eBar_hndl){
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_dynamicMenuBasedScale failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);
    
    /*var int dynScalingFactor;*/ dynScalingFactor = B4DI_Bars_getDynamicScaleOptionValuef();


    //Bar_ResizeCenteredPercentFromInitial(bar_hndl, dynScalingFactor);
    Bar_ResizePercentagedAdvanced(eBar.bar, dynScalingFactor, SCALING_ABSOLUTE, Bar_GetAnchor(eBar.bar), VALIDSCREENSPACE, VIEW_NO_SIZE_LIMIT, VIEW_NO_SIZE_LIMIT );
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
    //var _bar bar; bar = get(eBar.bar);

    //View_SetAlpha(bar.v0, alpha);
    //View_SetAlpha(bar.vRange, alpha);
    //View_SetAlpha(bar.v1, alpha);
    //View_SetAlphaAll(bar.vLabel, alpha);
    Bar_SetAlpha(eBar.bar, alpha);
};

func int B4DI_eBar_GetAlpha( var int eBar_hndl ) {
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_SetAlpha failed"); return 0; };
    var _extendedBar eBar; eBar = get(eBar_hndl);

    //vBack as representation for overall Alpha
    return Bar_GetAlpha(eBar.bar);
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

func void B4DI_eBar_ClearNpcRef( var int eBar_hndl ) {
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_SetNpcRef failed: invalid eBar_hndl"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);

    eBar.npcRef = 0;
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
//  eBar Update Bar InitPositions for Animations
//========================================
//Actually only needed if sizelimit is exceeded
func void B4DI_eBar_Bar_StorePosSize( var int eBar_hndl ) {
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_Bar_StorePosSize failed: invalid eBar_hndl"); return; };
    var _extendedBar eBar; eBar = get( eBar_hndl );
    Bar_storePosSize(eBar.bar);
};

//========================================
//  eBar Get Size per Axis
//========================================
func int B4DI_eBar_Bar_GetSize( var int eBar_hndl, var int axis ) {
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_Bar_GetSize failed: invalid eBar_hndl"); return 0; };
    var _extendedBar eBar; eBar = get( eBar_hndl );

    dynScalingFactor = B4DI_Bars_getDynamicScaleOptionValuef();

    var int scaled_size; scaled_size = roundf( mulf( mkf( Bar_GetSize(eBar.bar, axis) ), dynScalingFactor ) );

    return scaled_size;
};


//========================================
// eBar add to alignment lists
//========================================
func void B4DI_eBar_AddToAlignmentSlot( var int eBar_hndl, var int alignmentSlot ) {
    MEM_Info("B4DI_eBar_AddToAlignmentSlot started");
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_AddToAlignmentSlot failed: invalid eBar_hndl"); return; };
    var _extendedBar eBar; eBar = get( eBar_hndl );
    if (alignmentSlot == B4DI_ALIGNMENT_USE_ANCHOR) {
        alignmentSlot = Bar_GetAnchor(eBar.bar);
    };
    B4DI_AlignmentManager_AddToSlotInitial(MEM_mainAlignmentManager_handle, eBar_hndl, alignmentSlot, B4DI_eBar_AlignmentManager_Updatehandler, B4DI_eBar_Bar_GetSize );
    
    //B4DI_eBar_Bar_StorePosSize(eBar_hndl);
    //this will break dynScaling of initValues and maybe not necessay until sizelimits are introduced correctly
    //interbar margins will remain the same although pos may change
    MEM_Info("B4DI_eBar_AddToAlignmentSlot finished");
};


//========================================
// eBar Create
//========================================
//TODO Fix initial position after creation? -> Cause maybe that creation gets called to early and widescreen pos fix may come too late.
func int B4DI_eBar_CreateCustomXY(var int Bar_constructor_instance, var int left_vposx, var int top_vposy, var int alignmentSlot ) {
    var int new_eBar_hndl; new_eBar_hndl = new(_extendedBar@);
    var _extendedBar eBar; eBar = get(new_eBar_hndl);
    
    eBar.bar = Bar_CreateCenterDynamic(Bar_constructor_instance);
    
    if( left_vposx >= 0 || top_vposy >= 0) {
        Bar_MoveLeftUpperToValidScreenSpace(eBar.bar, left_vposx, top_vposy);
    };

    B4DI_eBar_dynamicMenuBasedScale(new_eBar_hndl);

    eBar.barPreview = B4DI_BarPreview_Create(new_eBar_hndl);
    if(!Hlp_IsValidHandle(eBar.barPreview)) {
        MEM_Warn("B4DI_eBar_CreateCustomXY failed at B4DI_BarPreview_Create"); 
        return 0;
    };
    //eBar.barPostview = B4DI_BarPreview_Create(new_eBar_hndl);

    Bar_Show(eBar.bar);
    //created invisible
    //B4DI_eBar_SetAlpha(new_eBar_hndl, B4DI_barFadeOutMin); //<--- think about this Focusbar makes trouble
    B4DI_eBar_SetAlpha(new_eBar_hndl, 0); //<--- think about this Focusbar makes trouble

    eBar.isFadedOut = 1;

    eBar.npcRef = 0;
    //TODO add alignmentSlot as parameter with default
    B4DI_eBar_AddToAlignmentSlot(new_eBar_hndl, alignmentSlot);
    MEM_Info("B4DI_eBar_CreateCustomXY finished <----------------------------"); 
    return new_eBar_hndl;
};

func int B4DI_eBar_CreateAsReplacement(var int Bar_constructor_instance, var int oCViewStatusBar_ptr) {
    var int new_eBar_hndl; new_eBar_hndl = new(_extendedBar@);
    
    var int new_vposx; new_vposx = -1;    
    var int new_vposy; new_vposy = -1;

    if(oCViewStatusBar_ptr != B4DI_eBAR_NO_REPLACEMENT) {
        var oCViewStatusBar oBar; oBar = MEM_PtrToInst(oCViewStatusBar_ptr);
        //B4DI_originalBar_hide(oCViewStatusBar_ptr); //needs to be called in int always
        new_vposx = oBar.zCView_vposx;
        new_vposy = oBar.zCView_vposy;
        B4DI_Info1("oBar.zCView_vposx: ", oBar.zCView_vposx);
        B4DI_Info1("oBar.zCView_vposy: ", oBar.zCView_vposy);
    };

    return B4DI_eBar_CreateCustomXY(Bar_constructor_instance, new_vposx, new_vposy, B4DI_ALIGNMENT_USE_ANCHOR);
};


func int B4DI_eBar_Create(var int Bar_constructor_instance ) {
    return B4DI_eBar_CreateAsReplacement(Bar_constructor_instance, B4DI_eBAR_NO_REPLACEMENT);
};

//========================================
// eBar Animations
//========================================
func void B4DI_eBar_fadeOut(var int eBar_hndl, var int deleteBar) {
    var _extendedBar eBar_inst; eBar_inst = get(eBar_hndl);
    //var _bar bar_inst; bar_inst = get(eBar_inst.bar);
    eBar_inst.anim8FadeOut = Anim8_NewExt(B4DI_barFadeInMax, B4DI_eBar_SetAlpha, eBar_hndl, false);
    Anim8_RemoveIfEmpty(eBar_inst.anim8FadeOut, true);
    if (deleteBar) {
        Anim8_RemoveDataIfEmpty(eBar_inst.anim8FadeOut, true);
    } else {
        Anim8_RemoveDataIfEmpty(eBar_inst.anim8FadeOut, false);
    };
    
    Anim8(eBar_inst.anim8FadeOut, B4DI_barFadeInMax,  5000, A8_Wait);
    Anim8q(eBar_inst.anim8FadeOut,   B4DI_barFadeOutMin, 2000, A8_SlowEnd);
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
func void B4DI_eBar_showLabel( var int eBar_hndl ) {
    if(!Hlp_IsValidHandle(ebar_hndl)) { MEM_Warn("B4DI_eBar_showLabel failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);

    Bar_showLabel(eBar.bar);

};

func void B4DI_eBar_hideLabel( var int eBar_hndl ) {
    if(!Hlp_IsValidHandle(ebar_hndl)) { MEM_Warn("B4DI_eBar_hideLabel failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);

    Bar_hideLabel(eBar.bar);
};

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
    B4DI_debugSpy("B4DI_eBar_generateLabelTextSimple: ", label);
    return label;
};

//========================================
// eBar RefreshLabel
//========================================
//TODO Fix??? Label gets not shown after bar fades out and inventory gets opended with previewable item selected
func void B4DI_eBar_RefreshLabel(var int eBar_hndl) {
    //TODO make optional
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_RefreshLabel failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);
    
    var _bar bar; bar = get(eBar.bar);
    var string label; label = B4DI_eBar_generateLabelTextSimple(eBar_hndl);


    //add text in closed mode
    Bar_SetLabelText(eBar.bar, label, B4DI_LABEL_FONT );
    if(eBar.isFadedOut) {
        //B4DI_eBar_hideLabel(eBar_hndl);
        B4DI_eBar_SetAlpha(eBar_hndl, B4DI_barFadeOutMin); //TODO <----think about this, this causes Focus Bar to get drawn although no focus, 
        //B4DI_eBar_GetAlpha(eBar_hndl) could be an option but if animation is currently onGoing problematic

    };

    B4DI_Info1("B4DI_eBar_RefreshLabel call while isFadedOut: ", eBar.isFadedOut);
};

//========================================
// eBar Hide / Show
//========================================
func void B4DI_eBar_hideCustom( var int eBar_hndl, var int animated){
    if(!Hlp_IsValidHandle(ebar_hndl)) { MEM_Info("B4DI_eBar_hide failed"); return; };
    var _extendedBar eBar_inst; eBar_inst = get(ebar_hndl);

    if(!animated) {
        eBar_inst.isFadedOut = 1;
        //B4DI_eBar_SetAlpha(eBar_hndl, B4DI_barFadeOutMin); //TODO: Think about this Focus Bar has to completly fade away!
        B4DI_eBar_SetAlpha(eBar_hndl, 0);
        MEM_Info("B4DI_eBar_hideCustom NOT Animated successful");
    } else {
        if( !eBar_inst.isFadedOut ) { //TODO <------think about this
            eBar_inst.isFadedOut = 1;
            B4DI_eBar_fadeOut(eBar_hndl, false);
            MEM_Info("B4DI_eBar_hideCustom Animated successful");
        } else {
            MEM_Info("B4DI_eBar_hideCustom already hidden");
        };

    };
    MEM_Info("B4DI_eBar_hideCustom successful");
};

func void B4DI_eBar_hideInstant( var int eBar_hndl){
    if(!Hlp_IsValidHandle(ebar_hndl)) { MEM_Info("B4DI_eBar_hideInstant failed"); return; };

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
        B4DI_eBar_SetAlpha(eBar_hndl, B4DI_barFadeInMax);

        //Bar_Show(eBar_inst.bar);
        MEM_Info("B4DI_eBar_show successful");
    } else {
        //MEM_Info("B4DI_eBar_show already visible");
    };

    ////TODO make optional
    //if(B4DI_barShowLabel){
    //    B4DI_eBar_showLabel(eBar_hndl);
    //};


};

//========================================
// eBar Preview hide/show
//========================================
func void B4DI_eBar_HidePreview(var int eBar_hndl){
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_HidePreview failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);
    B4DI_BarPreview_hide(eBar.barPreview);
    B4DI_eBar_RefreshLabel(eBar_hndl);

    MEM_Info("B4DI_eBar_HidePreview successful");
};

func void B4DI_eBar_ShowPreview(var int eBar_hndl, var int value) {
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_ShowPreview failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);

    B4DI_BarPreview_CalcPosScale(eBar.barPreview, value);
    B4DI_eBar_RefreshLabel(eBar_hndl);
    B4DI_eBar_showLabel(eBar_hndl);

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
    
    if( value == BAR_REFRESH_NO_CHANGE || valueMax == BAR_REFRESH_NO_CHANGE) {
        //Bar_SetValue(bar_hndl, BAR_REFRESH_NO_CHANGE);
        var _bar b; b = get(bar_hndl);
        Bar_SetMax(bar_hndl, b.valMax);
        Bar_SetValue(bar_hndl, b.val);
    } else {
        Bar_SetMax(bar_hndl, valueMax);
        Bar_SetValue(bar_hndl, value);
    };
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
    if( index_value == BAR_REFRESH_NO_CHANGE || index_valueMax == BAR_REFRESH_NO_CHANGE) {
        B4DI_eBar_SetValuesBasic( eBar_hndl, BAR_REFRESH_NO_CHANGE, BAR_REFRESH_NO_CHANGE );    
    } else {
        B4DI_eBar_SetValuesBasic( eBar_hndl, MEM_ReadStatArr(npcRef_inst.attribute, index_value), MEM_ReadStatArr(npcRef_inst.attribute, index_valueMax) );    
    }; 
    
};

func void B4DI_eBar_SetValues(var int ebar_hndl, var int index_value, var int index_valueMax) {
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
        B4DI_BarPostview_SetAlphaFunc(eBar.barPostview, zRND_ALPHA_FUNC_BLEND);
        B4DI_BarPostview_slide_size(eBar.barPostview, B4DI_BarPostview_SetSizeLeftsidedPercentX);
    } else if ( value_diff > 0 ) {
        //B4DI_Info1("B4DI_eBar_SetValuesAnimated: ", value_diff );
        eBar.barPostview = B4DI_BarPostview_Create(eBar_hndl, abs(value_diff) );
        B4DI_BarPostview_Show(eBar.barPostview);
        B4DI_BarPostview_SetAlphaFunc(eBar.barPostview, zRND_ALPHA_FUNC_SUB);
        B4DI_BarPostview_slide_size(eBar.barPostview, B4DI_BarPostview_SetSizeRightsidedPercentX);

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

func void B4DI_eBar_RefreshWithoutChange(var int eBar_hndl) {
    B4DI_eBar_RefreshAnimated( eBar_hndl, BAR_REFRESH_NO_CHANGE, BAR_REFRESH_NO_CHANGE, false);
};

//========================================
// [intern] eBar MoveTo part of updatehandler
//========================================
func void B4DI_eBar_MoveTo( var int eBar_hndl, var int x, var int y, var int anchorPoint_mode ) {
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_MoveTo failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);
    if (anchorPoint_mode == B4DI_ALIGNMENT_USE_ANCHOR) {
        var _bar b; b = get(eBar.bar);
        anchorPoint_mode = b.anchorPoint_mode;
    };
    Bar_MoveToAdvanced(eBar.bar, x, y, anchorPoint_mode, VALIDSCREENSPACE);

};

func void B4DI_eBar_AlignmentManager_Updatehandler( var int eBar_hndl, var int x, var int y, var int anchorPoint_mode ) {
    if(!Hlp_IsValidHandle(eBar_hndl)) { MEM_Warn("B4DI_eBar_AlignmentManager_Updatehandler failed"); return; };
    var _extendedBar eBar; eBar = get(eBar_hndl);

    B4DI_eBar_MoveTo(eBar_hndl, x, y, anchorPoint_mode);
    //TODO SIZE caused by Limit
    B4DI_eBar_RefreshWithoutChange(eBar_hndl);

};


