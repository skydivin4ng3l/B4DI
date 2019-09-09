/***********************************\
                BARPREVIW
\***********************************/
//========================================
// [intern] Klasse für PermMem
//========================================
class _barPreview {
    
    var int vPreView;                    // zCView(h)
    var int val;
    var int anim8Pulse;               // A8Head(h)
};

instance _barPreview@(_barPreview);

func void _barPreview_Delete(var _barPreview bp) {
    if(Hlp_IsValidHandle(bp.vPreView)) {
        delete(bp.vPreView);
    };
    if(Hlp_IsValidHandle(bp.anim8Pulse)) {
        Anim8_Delete(bp.anim8Pulse);
    };
}; 

func int B4DI_BarPreview_Create( var int bar_hndl){
    if(!Hlp_IsValidHandle(bar_hndl)) {
        MEM_Info("tried to init Preview of a not initialized bar ");
        return;
    };
    var _bar b; b = get(bar_hndl);
    var zCView vBar; vBar = View_Get(bar.v1);   

    var int new_bp_hndl; new_bp_hndl = new(_barPreview@);
    var _barPreview bp; bp = get(new_bp_hndl);
    
    bp.vPreView = View_Create(vBar.vposx, vBar.vposy, vBar.vposx + vBar.vsizex, vBar.vposy + vBar.vsizey );
    //TODO maybe different texture for previews?
    View_SetTexture(bp.vPreView, ViewPtr_GetTexture( MEM_InstToPtr(vBar) ) );

    bp.val = 0;

    return new_bp_hndl;
};

func int B4DI_BarPreview_GetValue( var int barPreview_hndl) {
    if(!Hlp_IsValidHandle(barPreview_hndl)) {
        MEM_Warn("B4DI_BarPreview_GetValue failed ");
        return;
    };
    var _barPreview bp; bp = get(barPreview_hndl);
    return bp.val;
};
