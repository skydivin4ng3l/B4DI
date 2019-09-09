/***********************************\
         B4DI extended BARS
\***********************************/
//========================================
// [intern] Global Vars
//========================================
var int dynScalingFactor; //float
//========================================
// [intern] Klasse für PermMem
//========================================
class _extendedBar {
    
    var int bar;                    // _bar(h)
    var int barPreview;               // _barPreview(h)
    var int isFadedOut;                   // Bool
    var int anim8FadeOut;               // A8Head(h)
};

instance _extendedBar@(_extendedBar);

func void _barPreview_Delete(var _extendedBar eb) {
    if(Hlp_IsValidHandle(eb.bar)) {
        delete(eb.bar);
    };
    if(Hlp_IsValidHandle(eb.bar)) {
        delete(eb.barPreview);
    };
    if(Hlp_IsValidHandle(eb.anim8FadeOut)) {
        Anim8_Delete(eb.anim8FadeOut);
    };
};

//========================================
// [Intern] Resizes actual bar according to percentage reltaive to center
//
//========================================
func void B4DI_Bar_SetBarSizeCenteredPercent(var int bar_hndl, var int x_percentage, var int y_percentage ) { 
    Print_GetScreenSize();
    //------------------
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    var _bar b; b = get(bar_hndl);

    v1_ptr = View_Get(b.v1);
    //save the size before the resize
    var int sizex_pre; sizex_pre = Print_ToVirtual(b.val,PS_X); 
    var int sizey_pre; sizey_pre = roundf( mulf( mkf(b.initialDynamicVSizes[IDS_VBAR_Y]), dynScalingFactor ) ) ; // Dynamic Test +1 is missing, but needed?

    //scale on all axis
    View_ResizeCentered(b.v1, sizex_pre * x_percentage / 100 , sizey_pre * y_percentage / 100 ); 
        
    //Debug
    B4DI_debugSpy("Bar PositionX",IntToString(v1_ptr.vposx));
    B4DI_debugSpy("Bar PositionY",IntToString(v1_ptr.vposy));
    B4DI_debugSpy("Bar SizeX",IntToString(v1_ptr.vsizex));
    B4DI_debugSpy("Bar SizeY",IntToString(v1_ptr.vsizey));

};


func int B4DI_eBar_Create(var int _bar_constructor_instance) {
    var int new_eBar_hndl; new_eBar_hndl = new(_extendedBar@);
    var _extendedBar eBar; eBar = get(new_eBar_hndl);
    
    eBar.bar = Bar_CreateCenterDynamic(_bar_constructor_instance);
    B4DI_Bar_dynamicMenuBasedScale(eBar.bar);

    eBar.barPreview = B4DI_BarPreview_Create(eBar.bar);

    Bar_SetAlpha(eBar.bar, 0);
    eBar.isFadedOut = 1;

    return new_eBar_hndl;
};

func void B4DI_eBar_fadeOut(var int eBar_hndl, var int deleteBar) {
    var _extendedBar eBar_inst; eBar_inst = get(eBar_hndl);
    var _bar bar_inst; bar_inst = get(eBar_inst.bar);
    eBar_inst.anim8FadeOut = Anim8_NewExt(255, Bar_SetAlpha, eBar_inst.bar, false);
    Anim8_RemoveIfEmpty(eBar_inst.anim8FadeOut, true);
    if (deleteBar) {
        Anim8_RemoveDataIfEmpty(eBar_inst.anim8FadeOut, true);
    } else {
        Anim8_RemoveDataIfEmpty(eBar_inst.anim8FadeOut, false);
    };
    
    Anim8(eBar_inst.anim8FadeOut, 255,  5000, A8_Wait);
    Anim8q(eBar_inst.anim8FadeOut,   0, 2000, A8_SlowEnd);

};

func string B4DI_eBar_generateLabelSimple(var int ebar_hndl) {
    if(!Hlp_IsValidHandle(ebar_hndl)) {
        MEM_Info("B4DI_eBar_generateLabelSimple failed");
        return;
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
    return label;
};

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
    Bar_SetAlpha(eBar_inst.bar, 255);
    Bar_Show(eBar_inst.bar);
    var _bar bar; bar = get(eBar_inst.bar);
    //TODO make optional
    View_DeleteText(bar.vMiddle);
    View_AddText(bar.vMiddle, 0, 0, B4DI_eBar_generateLabelSimple(eBar_hndl), TEXT_FONT_Inventory);

    MEM_Info("B4DI_eBar_show successful");
};


func void B4DI_Bar_SetValues(var int bar_hndl, var int index_value, var int index_valueMax) {
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };

    Bar_SetMax(bar_hndl, MEM_ReadStatArr(hero.attribute, index_valueMax) );
    Bar_SetValue(bar_hndl, MEM_ReadStatArr(hero.attribute, index_valueM) );
    
    MEM_Info("B4DI_Bar_SetValues");
    //var _bar bar; bar = get(bar_hndl);
    //MEM_Info(cs2("hero.attribute[ATR_HITPOINTS_MAX]: ",i2s(hero.attribute[ATR_HITPOINTS_MAX])));
    //MEM_Info(cs2(" hero.attribute[ATR_HITPOINTS]: ",i2s(hero.attribute[ATR_HITPOINTS])));
    //MEM_Info(cs2("bar.valMax: ",i2s(bar.valMax)));
    //MEM_Info(cs2(" bar.val: ",i2s(bar.val)));
};

//TODO B4DI_eBar_calcPreView maybe in preview?

//TODO B4DI_eBar_showPreview
