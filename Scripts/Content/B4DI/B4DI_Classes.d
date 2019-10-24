/***********************************\
        B4DI AligmentManager
\***********************************/
//========================================
// [intern] Klasse für PermMem
//========================================
//aligmentSlots are a bit redundant to obj_hashtables if aOs carray their respetive slot information, but the SlotLists carry the order within the slot
class _alignmentManager {

    var int alignmentSlots/*[B4DI_ALIGNMENT_SLOT_ARRAY_SIZE]*/;                //@zCArray(h)<@zCList<_alignmentObject*hndl>>[B4DI_ALIGNMENT_SLOT_ARRAY_SIZE]
                                                                           //necessary for order within the slot
    var int margins_perSlot/*[B4DI_ALIGNMENT_SLOT_ARRAY_SIZE]*/;               //@zCArray(h)<@zCArray(h)<int>>[B4DI_ALIGNMENT_SLOT_ARRAY_SIZE][B4DI_ALIGNMENT_SLOT_MARGIN_ARRAY_SIZE]
    
    // TODO var int dynamic_sizelimits;                                            // Bool
    var int sizelimits_ofObjects_perSlot/*[B4DI_ALIGNMENT_SLOT_ARRAY_SIZE]*/;  //@zCArray(h)<@zCArray(h)<int>>[B4DI_ALIGNMENT_SLOT_ARRAY_SIZE][2] <-virtual

    var int obj_hashtable;                                                 //_Hashtable(h) //zCArray<zCArray<_HT_Obj>*>
};

instance _alignmentManager@(_alignmentManager);

//========================================
// [intern] Klasse für PermMem
//========================================
class _alignmentObject {

    var int objectHandle;                //obj(h)
    
    var int updateHandler;               //function ID which will be called to update the position (and size) of the obj_hndl
    var int getSizeHandler;              //function ID which will be called to get the size of the obj_hndl
    var int getPosHandler;              //function ID which will be called to get the Position of the obj_hndl

    var int alignmentSlot;               //index of aM.alignmentSlots array with the listptr the object is currenlty Listed in
};

instance _alignmentObject@(_alignmentObject);

/***********************************\
         B4DI extended BARS
\***********************************/
//========================================
// [intern] Klasse für PermMem
//========================================
class _extendedBar {
    
    var int bar;                    // _bar(h)
    var int barPreview;             // _barPreview(h)
    var int barPostview;            // _barPreview(h)
    var int isFadedOut;             // Bool
    var int anim8FadeOut;           // A8Head(h)
    var int anim8PulseSize;         // A8Head(h)
    var int npcRef;                 // Npc_GetID(C_NPC_PTR);
};

instance _extendedBar@(_extendedBar);

func void _extendedBar_Delete(var _extendedBar eBar) {
    if(Hlp_IsValidHandle(eBar.bar)) {
        delete(eBar.bar);
    };
    if(Hlp_IsValidHandle(eBar.barPreview)) {
        delete(eBar.barPreview);
    };
    if(Hlp_IsValidHandle(eBar.barPostview)) {
        delete(eBar.barPostview);
    };
    if(Hlp_IsValidHandle(eBar.anim8FadeOut)) {
        Anim8_Delete(eBar.anim8FadeOut);
    };
    if(Hlp_IsValidHandle(eBar.anim8PulseSize)) {
        Anim8_Delete(eBar.anim8PulseSize);
    };
};

// maybe not necessary ptr will be recreated
/*func void _extentedBar_Archiver( var _extendedBar this ) {
    PM_SaveInt("bar", this.bar);
    PM_SaveInt("barPreview", this.barPreview);
    PM_SaveInt("barPostview", this.barPostview);
    PM_SaveInt("isFadedOut", this.isFadedOut);
    PM_SaveInt("anim8FadeOut", this.anim8FadeOut);
    PM_SaveInt("anim8PulseSize", this.anim8PulseSize);

    PM_SaveInt("npcRef", this.npcRef); //Do not save Pointer
};

func void _extendedBar_Unarchiver( var _extendedBar this ) {
    if(PM_Exists("bar")) {this.bar = PM_Load("bar"); };  
    if(PM_Exists("barPreview")) {this.barPreview = PM_Load("barPreview"); };  
    if(PM_Exists("barPostview")) {this.barPostview = PM_Load("barPostview"); };  
    if(PM_Exists("isFadedOut")) {this.isFadedOut = PM_Load("isFadedOut"); };  
    if(PM_Exists("anim8FadeOut")) {this.anim8FadeOut = PM_Load("anim8FadeOut"); };  
    if(PM_Exists("anim8PulseSize")) {this.anim8PulseSize = PM_Load("anim8PulseSize"); };  
    
    if(PM_Exists("npcRef")) {this.npcRef = PM_Load("npcRef"); };  
};
*/

/***********************************\
                BARPREVIEW
\***********************************/
//========================================
// [intern] Klasse für PermMem
//========================================
class _barPreview {
    
    var int vPreView;                    // zCView(h)
    var int vOverShoot;                 // zCView(h)
    var int val;
    var int changesMaximum;
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
                BARPOSTVIEW
\***********************************/
//========================================
// [intern] Klasse für PermMem
//========================================
class _barPostview {
    
    var int vPostView;                    // zCView(h)
    var int val;
    var int anim8SlideSize;               // A8Head(h)
    var int eBar_parent;               // _extentedBar(h)
    var int isFadedOutPostview;                 // Boolean
};

instance _barPostview@(_barPostview);

func void _barPostview_Delete(var _barPostview bp) {
    if(Hlp_IsValidHandle(bp.vPostView)) {
        delete(bp.vPostView);
    };
    if(Hlp_IsValidHandle(bp.anim8SlideSize)) {
        Anim8_Delete(bp.anim8SlideSize);
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
    anchorPoint_mode = ANCHOR_CENTER_BOTTOM;
};

instance B4DI_HpBar(GothicBar){
    x = 128+90; //128 virtual should be margin left
    y = Print_Screen[PS_Y] -100;
    barTop = 2;     // 2 is almost too small
    barTex = "Bar_Health.tga";
    anchorPoint_mode = ANCHOR_LEFT_BOTTOM;
};

instance B4DI_ManaBar(GothicBar){
    x = 128+90; //128 virtual should be margin left
    y = Print_Screen[PS_Y] -100;
    barTop = 2;     // 2 is almost too small
    barTex = "Bar_Mana.tga";
    //anchorPoint_mode = ANCHOR_RIGHT_BOTTOM;
    anchorPoint_mode = ANCHOR_LEFT_BOTTOM;
};

instance B4DI_FocusBar(GothicBar){
    x = 128+90; //128 virtual should be margin left
    y = Print_Screen[PS_Y] -100;
    barTop = 2;     // 2 is almost too small
    barTex = "Bar_Health.tga";
    //value = 0;
    anchorPoint_mode = ANCHOR_CENTER_TOP;
};

/***********************************\
           Original Bars
\***********************************/

instance MEM_oBar_Hp(oCViewStatusBar);
instance MEM_oBar_Mana(oCViewStatusBar);
instance MEM_oBar_Focus(oCViewStatusBar);

/***********************************\
            extented Bars
\***********************************/

var int MEM_eBar_HP_handle;
instance MEM_eBar_HP(_extendedBar);

var int MEM_eBar_MANA_handle;
instance MEM_eBar_MANA(_extendedBar);

var int MEM_eBar_FOCUS_handle;
instance MEM_eBar_FOCUS(_extendedBar);

var int MEM_eBar_XP_handle;
instance MEM_eBar_XP(_extendedBar);

/***********************************\
        eBars Alignment lists
\***********************************/

var int MEM_mainAlignmentManager_handle;
instance MEM_mainAlignmentManager(_alignmentManager);

/***********************************\
      Selected Inventory Item
\***********************************/

instance selectedInvItem(oCItem);
var string lastSelectedItemName;

/***********************************\
      Hero Cast to oCNpc
\***********************************/

instance oHero(oCNpc);

