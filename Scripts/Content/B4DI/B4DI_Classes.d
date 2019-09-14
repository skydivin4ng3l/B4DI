/***********************************\
         B4DI extended BARS
\***********************************/
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

func void _extendedBar_Delete(var _extendedBar eBar) {
    if(Hlp_IsValidHandle(eBar.bar)) {
        delete(eBar.bar);
    };
    if(Hlp_IsValidHandle(eBar.bar)) {
        delete(eBar.barPreview);
    };
    if(Hlp_IsValidHandle(eBar.anim8FadeOut)) {
        Anim8_Delete(eBar.anim8FadeOut);
    };
};

/***********************************\
                BARPREVIW
\***********************************/
//========================================
// [intern] Klasse für PermMem
//========================================
class _barPreview {
    
    var int vPreView;                    // zCView(h)
    var int vOverShoot;                 // zCView(h)
    var int val;
    var int anim8Pulse;               // A8Head(h)
    var int eBar_parent;               // _extentedBar(h)
    var int isFadedOutPreview;                 // Boolean
    var int isFadedOutOvershoot;                 // Boolean
};

instance _barPreview@(_barPreview);

func void _barPreview_Delete(var _barPreview bp) {
    if(Hlp_IsValidHandle(bp.vPreView)) {
        delete(bp.vPreView);
    };
    if(Hlp_IsValidHandle(bp.vOverShoot)) {
        delete(bp.vOverShoot);
    };
    if(Hlp_IsValidHandle(bp.anim8Pulse)) {
        Anim8_Delete(bp.anim8Pulse);
    };
};

/***********************************\
            BAR Constructors
\***********************************/

prototype B4DI_MyXpBar(Bar) {
    x = Print_Screen[PS_X] / 2;
    y = Print_Screen[PS_Y] -20;
    barTop = 3; // 6 Texture 4 good
    barLeft = 8; // 11/12 Texture 
    width = 192; // 256 texture
    height = 24; // 32 texture
    backTex = "Bar_Back.tga";
    barTex = "Bar_XP.tga";
    middleTex = "Bar_TempMax.tga";
    value = 100;
    valueMax = 100;
};

//////

instance B4DI_XpBar(B4DI_MyXpBar){
    //x = 10+128;
    //y = 20+16;
};

instance B4DI_HpBar(GothicBar){
    x = 128+90; //128 virtual should be margin left
    y = Print_Screen[PS_Y] -100;
    barTop = 2;     // 2 is almost too small
    barTex = "Bar_Health.tga";
};

instance B4DI_ManaBar(GothicBar){
    x = 128+90; //128 virtual should be margin left
    y = Print_Screen[PS_Y] -100;
    barTop = 2;     // 2 is almost too small
    barTex = "Bar_Mana.tga";
};

/***********************************\
           Original Bars
\***********************************/

instance MEM_oBar_Hp(oCViewStatusBar);
instance MEM_oBar_Mana(oCViewStatusBar);

/***********************************\
            extented Bars
\***********************************/

var int MEM_dBar_HP_handle;
instance MEM_dBar_HP(_bar);

var int MEM_eBar_HP_handle;
instance MEM_eBar_HP(_extendedBar);

var int MEM_eBar_MANA_handle;
instance MEM_eBar_MANA(_extendedBar);

var int MEM_preView_HP_handle;
instance MEM_preView_HP(zCView);

/***********************************\
      Selected Inventory Item
\***********************************/

instance selectedInvItem(oCItem);
var string lastSelectedItemName;
