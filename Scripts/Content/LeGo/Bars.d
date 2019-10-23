/***********************************\
                BARS
\***********************************/

//========================================
// Klasse für den Nutzer
//========================================
class Bar {
    var int x;
    var int y;
    var int barTop;
    var int barLeft;
    var int width;
    var int height;
    var string backTex;
    var string barTex;
    var string middleTex;
    var int value;
    var int valueMax;
    var int anchorPoint_mode;   //0-8 See Anchor Const
};

//========================================
// Prototyp für Konstruktor-Instanz
//========================================
prototype GothicBar(Bar) {
    x = Print_Screen[PS_X] / 2;
    y = Print_Screen[PS_Y] - 20;
    barTop = 3;
    barLeft = 7;
    width = 180;
    height = 20;
    backTex = "Bar_Back.tga";
    barTex = "Bar_Misc.tga";
    middleTex = "Bar_TempMax.tga";
    value = 100;
    valueMax = 100;
    anchorPoint_mode = ANCHOR_LEFT_TOP;
};

//========================================
// Beispiel für Konstruktor-Instanz
//========================================
instance GothicBar@(GothicBar);

//========================================
// [intern] Klasse für PermMem
//========================================
class _bar {
    var int valMax;
    var int val;
    var int barW;
    var int v0;               // zCView(h)
    var int vRange;          // zCView(h)
    var int v1;               // zCView(h)
    var int vLabel;           // zCView(h)
    var int initVSizes[4];    // Array<int>
    var int initVPos[12];     // Array<int>
    var int isFadedOut;       // Bool
    var int anchorPoint_mode; // Anchor for advanced resizing
                              //var int anim8FadeOut;               // A8Head(h)
};

instance _bar@(_bar);

func void _bar_Delete(var _bar b) {
    if(Hlp_IsValidHandle(b.v0)) {
        delete(b.v0);
    };
    if(Hlp_IsValidHandle(b.vRange)) {
        delete(b.vRange);
    };
    if(Hlp_IsValidHandle(b.v1)) {
        delete(b.v1);
    };
    if(Hlp_IsValidHandle(b.vLabel)) {
        delete(b.vLabel);
    };
    
}; 

//========================================
// [intern] Helper store VPos and VSize as reference for scale/position based animations
//========================================
//TODO protect write of values from active animations
func void Bar_storePosSize(var int bar_hndl){
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    var _bar b; b = get(bar_hndl);
    var zCView v; v = View_Get(b.v0);

    b.initVPos[IP_VBACK_LEFT]     = v.vposx;
    //b.initVPos[IP_VBACK_RIGHT] = v.vposx + v.vsizex;
    b.initVPos[IP_VBACK_TOP]      = v.vposy;
    //b.initVPos[IP_VBACK_BOTTOM] = v.vposy + v.vsizey;
    b.initVPos[IP_VBACK_CENTER_X] = v.vposx + v.vsizex>>1; // >>1 durch 2
    b.initVPos[IP_VBACK_CENTER_Y] = v.vposy + v.vsizey>>1;
    b.initVSizes[IDS_VBACK_X]     = v.vsizex;
    b.initVSizes[IDS_VBACK_Y]     = v.vsizey;
    
    v = View_Get(b.vRange); //same as v1/vBar(at full state) and vLabel

    b.initVPos[IP_VRANGE_LEFT]     = v.vposx;
    //b.initVPos[IP_VRANGE_RIGHT] = v.vposx + v.vsizex;
    b.initVPos[IP_VRANGE_TOP]      = v.vposy;
    //b.initVPos[IP_VRANGE_BOTTOM] = v.vposy + v.vsizey;
    b.initVPos[IP_VRANGE_CENTER_X] = v.vposx + v.vsizex>>1; // >>1 durch 2
    b.initVPos[IP_VRANGE_CENTER_Y] = v.vposy + v.vsizey>>1;
    b.initVSizes[IDS_VBAR_X]     = v.vsizex;
    b.initVSizes[IDS_VBAR_Y]     = v.vsizey;

    //B4DI_debugSpy("Bar PositionX",IntToString(v.vposx));
    //B4DI_debugSpy("Bar PositionY",IntToString(v.vposy));
    //B4DI_debugSpy("Bar SizeX",IntToString(v.vsizex));
    //B4DI_debugSpy("Bar SizeY",IntToString(v.vsizey));
    
};
//========================================
// [AlignmentManager Helper]Get initial vsize per axis
//========================================
// Do Not use "View_GetSize( var int hndl, var int axis )", cause Animation may has influence, use this instead.
func int Bar_GetSize(var int bar_hndl, var int axis) {
    if(!Hlp_IsValidHandle(bar_hndl)) { return 0; };
    var _bar bar; bar = get(bar_hndl);

    if (axis == PS_X) {
        return bar.initVSizes[IDS_VBACK_X];
    } else if(axis == PS_Y) {
        return bar.initVSizes[IDS_VBACK_Y];
    };
};

//========================================
// Höchstwert setzen
//========================================
func void Bar_SetMax(var int bar, var int max) {
    if(!Hlp_IsValidHandle(bar)) { return; };
    var _bar b; b = get(bar);
    // ignore max change - keep current max
    //if(max == BAR_REFRESH_NO_CHANGE) {
    //    return;
    //};
    b.valMax = max;
    //MEM_Info(cs2("Bar_SetMax: ",i2s(max)));
};

//========================================
// Wert in 1/1000
//========================================
func void Bar_SetPromille(var int bar, var int pro) {
    if(!Hlp_IsValidHandle(bar)) { return; };
    var _bar b; b = get(bar);
    if(pro > 1000) { pro = 1000; };
    //if(pro == BAR_REFRESH_NO_CHANGE) {
    //    pro = (b.val * 1000) / b.valMax;
    //    View_Resize(b.v1, (pro * b.barW) / 1000, BAR_SIZE_LOCK_Y_AXIS);
    //    return;
    //};
    View_Resize(b.v1, (pro * b.barW) / 1000, BAR_SIZE_LOCK_Y_AXIS);
    b.val = (pro * b.valMax) / 1000; //to keep both valMax | val in the same space
};

//========================================
// Wert in 1/100
//========================================
func void Bar_SetPercent(var int bar, var int perc) {
    if(!Hlp_IsValidHandle(bar)) { return; };
    var _bar b; b = get(bar);
    //if(perc == BAR_REFRESH_NO_CHANGE) {
    //    Bar_SetPromille(bar, BAR_REFRESH_NO_CHANGE);
    //    return;        
    //};
    Bar_SetPromille(bar, perc*10);
    b.val = (perc * 1000 * b.valMax) / 1000; 
};

//========================================
// Wert der Bar
//========================================
func void Bar_SetValue(var int bar, var int val) {
    if(!Hlp_IsValidHandle(bar)) { return; };
    var _bar b; b = get(bar);
    //if(val == BAR_REFRESH_NO_CHANGE) {
    //    Bar_SetPromille(bar, BAR_REFRESH_NO_CHANGE);
    //    return;        
    //};
    if(val) {
        Bar_SetPromille(bar, (val * 1000) / b.valMax);
        b.val = val;
    }
    else {
        Bar_SetPromille(bar, 0);
    };
};

func int Bar_GetValue( var int bar_hndl ) {
    if(!Hlp_IsValidHandle(bar_hndl)) { return 0; };
    var _bar b; b = get(bar_hndl);

    return b.val;
};

func void Bar_SetAnchor( var int bar_hndl, var int new_anchorPoint_mode ) {
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    var _bar b; b = get(bar_hndl);

    b.anchorPoint_mode = new_anchorPoint_mode;
};

func int Bar_GetAnchor( var int bar_hndl ) {
    if(!Hlp_IsValidHandle(bar_hndl)) { return 0; };
    var _bar b; b = get(bar_hndl);
    var int curr_anchor; curr_anchor = b.anchorPoint_mode;
    if ( curr_anchor < ANCHOR_LEFT_TOP || curr_anchor > ANCHOR_CENTER_RIGHT ) {
        curr_anchor = ANCHOR_LEFT_TOP;
        b.anchorPoint_mode = curr_anchor;
    };

    return curr_anchor;
};

//========================================
// [Intern] Resize bars  
//  ValidSpace means
//  if back reaches screen borders before scaling is finished
//  it will be moved to allow scaling, anchors might be ignored to stay within screenborders.
//  ScreenLimits might force deformation if scaled beyond screensize before finished scaling
//========================================
//scalingFactor is a float
func void Bar_ResizePercentagedAdvanced(var int bar_hndl, var int scalingFactor , var int scaling_mode, var int anchorPoint_mode, var int validScreenSpace, var int x_size_limit, var int y_size_limit ) {
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    var _bar b; b = get(bar_hndl);

    var int base_barW; 
    var int base_Back_vsizex; 
    var int base_Back_vsizey; 
    var int base_TopMargin; 
    var int base_BottomMargin; 
    var int base_LeftMargin; 
    var int base_RightMargin; 
    // scaling_mode == SCALING_ABSOLUTE --------
    base_barW         = mkf( b.initVSizes[IDS_VBAR_X] );
    base_Back_vsizex  = mkf( b.initVSizes[IDS_VBACK_X] );
    base_Back_vsizey  = mkf( b.initVSizes[IDS_VBACK_Y] );
    base_TopMargin    = mkf( b.initVPos[IP_VRANGE_TOP] - b.initVPos[IP_VBACK_TOP] );
    base_BottomMargin = mkf((b.initVPos[IP_VBACK_TOP] + b.initVSizes[IDS_VBACK_Y]) - (b.initVPos[IP_VRANGE_TOP] + b.initVSizes[IDS_VBAR_Y]) );
    base_LeftMargin   = mkf( b.initVPos[IP_VRANGE_LEFT] - b.initVPos[IP_VBACK_LEFT] );
    base_RightMargin  = mkf((b.initVPos[IP_VBACK_LEFT] + b.initVSizes[IDS_VBACK_X]) - (b.initVPos[IP_VRANGE_LEFT] + b.initVSizes[IDS_VBAR_X]) );
    //------------------------------------------

    var zCView vBack; vBack = View_Get(b.v0);
    var zCView vRange; vRange = View_Get(b.vRange);
    var zCView vLabel; vLabel = View_Get(b.vLabel);
    var zCView vBar; vBar = View_Get(b.v1);

    if( scaling_mode == SCALING_RELATIVE ) {
        base_barW         = mkf( b.barW );
        base_Back_vsizex  = mkf( vBack.vsizex );
        base_Back_vsizey  = mkf( vBack.vsizey );
        base_TopMargin    = mkf( vRange.vposy - vBack.vposy );
        base_BottomMargin = mkf( (vBack.vposy + vBack.vsizey) - (vRange.vposy + vRange.vsizey) );
        base_LeftMargin   = mkf( vRange.vposx - vBack.vposx );
        base_RightMargin  = mkf( (vBack.vposx  + vBack.vsizex) - (vRange.vposx + vRange.vsizex) );   
    };

    b.barW = roundf( mulf( base_barW , scalingFactor ) );

    var int new_Back_vsizex; new_Back_vsizex = roundf( mulf( base_Back_vsizex , scalingFactor) );
    var int new_Back_vsizey; new_Back_vsizey = roundf( mulf( base_Back_vsizey , scalingFactor) );

    View_ResizeAdvanced(b.v0,  new_Back_vsizex, new_Back_vsizey, anchorPoint_mode, validScreenSpace, x_size_limit, y_size_limit );

    var int new_TopMargin; new_TopMargin       = roundf( mulf( base_TopMargin, scalingFactor ) );
    var int new_RightMargin; new_RightMargin   = roundf( mulf( base_RightMargin, scalingFactor ) );
    var int new_BottomMargin; new_BottomMargin = roundf( mulf( base_BottomMargin, scalingFactor ) );
    var int new_LeftMargin; new_LeftMargin     = roundf( mulf( base_LeftMargin, scalingFactor ) );

    View_SetMargin( b.vRange , b.v0, ALIGN_CENTER, new_TopMargin, new_RightMargin, new_BottomMargin, new_LeftMargin ); 
    View_SetMargin( b.v1     , b.v0, ALIGN_CENTER, new_TopMargin, new_RightMargin, new_BottomMargin, new_LeftMargin ); 
    View_SetMargin( b.vLabel , b.v0, ALIGN_CENTER, new_TopMargin, new_RightMargin, new_BottomMargin, new_LeftMargin ); 

    Bar_SetValue(bar_hndl, b.val );

};

func void Bar_ResizeCenteredPercentFromInitial(var int bar_hndl, var int aboluteScalingFactor){ //float aboluteScalingFactor
    Bar_ResizePercentagedAdvanced(bar_hndl, aboluteScalingFactor, SCALING_ABSOLUTE, ANCHOR_CENTER, VALIDSCREENSPACE, VIEW_NO_SIZE_LIMIT, VIEW_NO_SIZE_LIMIT );
};

func void Bar_ResizeCenteredPercent(var int bar_hndl, var int relativScalingFactor){ //float relativScalingFactor
    Bar_ResizePercentagedAdvanced(bar_hndl, relativScalingFactor, SCALING_RELATIVE, ANCHOR_CENTER, VALIDSCREENSPACE, VIEW_NO_SIZE_LIMIT, VIEW_NO_SIZE_LIMIT );
};
//========================================
// Resizes bar according to Resolution height by default, accepts custom values
//
//========================================
func void Bar_dynamicResolutionBasedScale(var int bar_hndl, var int scalingFactor){
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    
    Print_GetScreenSize();

    var int dynResScalingFactor; dynResScalingFactor = fracf( Print_Screen[PS_Y] ,512 );
    if( scalingFactor ) {
        dynResScalingFactor = scalingFactor;
    };

    Bar_ResizePercentagedAdvanced(bar_hndl, dynResScalingFactor, SCALING_ABSOLUTE, Bar_GetAnchor(bar_hndl), VALIDSCREENSPACE, VIEW_NO_SIZE_LIMIT, VIEW_NO_SIZE_LIMIT );
};

//========================================
// Neue Bar erstellen
//========================================
func int Bar_Create(var int inst) {
    Print_GetScreenSize();
    var int ptr; ptr = create(inst);
    var bar bu; bu = MEM_PtrToInst(ptr);
    var int bh; bh = new(_bar@);
    var _bar b; b = get(bh);
    b.valMax = bu.valueMax;
    var int buhh; var int buwh;
    var int ah; var int aw;
    buhh = bu.height / 2;
    buwh = bu.width / 2;
    if(buhh*2 < bu.height) {ah = 1;} else {ah = 0;};
    if(buwh*2 < bu.width) {aw = 1;} else {aw = 0;};
    b.v0 = View_CreatePxl(bu.x - buwh, bu.y - buhh, bu.x + buwh + aw, bu.y + buhh + ah);
    buhh -= bu.barTop;
    buwh -= bu.barLeft;
    b.barW = Print_ToVirtual(bu.width - bu.barLeft * 2 + aw, PS_X);
    b.vRange = View_CreatePxl(bu.x - buwh, bu.y - buhh, bu.x + buwh + aw, bu.y + buhh + ah);
    b.v1 =      View_CreatePxl(bu.x - buwh, bu.y - buhh, bu.x + buwh + aw, bu.y + buhh + ah);
    b.vLabel =  View_CreatePxl(bu.x - buwh, bu.y - buhh, bu.x + buwh + aw, bu.y + buhh + ah);
    View_SetTexture(b.v0, bu.backTex);
    View_SetTexture(b.vRange, bu.middleTex);
    View_SetTexture(b.v1, bu.barTex);
    
    b.anchorPoint_mode = bu.anchorPoint_mode;

    Bar_storePosSize(bh);
    Bar_SetValue(bh, bu.value);
    //Redundant ->_ViewPtr_CreateIntoPtr
    /*var zCView v; v = View_Get(b.v0);
    v.fxOpen = 0;
    v.fxClose = 0;
    v = View_Get(b.v1);
   
    v.fxOpen = 0;
    v.fxClose = 0;*/
    View_Open(b.v0);
    View_Open(b.vRange);
    View_Open(b.v1);
    b.isFadedOut = 0;
    free(ptr, inst);
    return bh;
};

func int Bar_CreateCenterDynamic(var int constructor_instance) {
    Print_GetScreenSize();
    var int ptr; ptr = create(constructor_instance);
    var bar bar_constr; bar_constr = MEM_PtrToInst(ptr);
    var int new_bar_hndl; new_bar_hndl = new(_bar@);
    var _bar bar; bar = get(new_bar_hndl);
    bar.valMax = bar_constr.valueMax;
    //TODO change to virtual? dynamic Resultionbased scale in Prototype?
    bar.v0      = View_CreateCenterPxl(bar_constr.x, bar_constr.y, bar_constr.width, bar_constr.height);
    bar.barW    = bar_constr.width - bar_constr.barLeft *2;
    bar.vRange = View_CreateCenterPxl(bar_constr.x, bar_constr.y, bar.barW, bar_constr.height- bar_constr.barTop *2);
    bar.v1      = View_CreateCenterPxl(bar_constr.x, bar_constr.y, bar.barW, bar_constr.height- bar_constr.barTop *2);
    bar.vLabel  = View_CreateCenterPxl(bar_constr.x, bar_constr.y, bar.barW, bar_constr.height- bar_constr.barTop *2);
    //TODO remove? vRange is Range
    bar.barW = Print_ToVirtual(bar.barW, PS_X);
    //^^
    View_SetTexture(bar.v0, bar_constr.backTex);
    View_SetTexture(bar.vRange, bar_constr.middleTex);
    View_SetTexture(bar.v1, bar_constr.barTex);

    Bar_storePosSize(new_bar_hndl);
    Bar_SetValue(new_bar_hndl, bar_constr.value);

    bar.anchorPoint_mode = bar_constr.anchorPoint_mode;

    var zCView v; v = View_Get(bar.v0);
    //v.alphafunc = zRND_ALPHA_FUNC_ADD;
    v = View_Get(bar.vRange);
    //v.alphafunc = zRND_ALPHA_FUNC_SUB;
    v = View_Get(bar.v1);
    //v.alphafunc = zRND_ALPHA_FUNC_ADD;

    View_Open(bar.v0);
    View_Open(bar.vRange);
    View_Open(bar.v1);
    View_Open(bar.vLabel); //this order that vRange can hold text label, therefore alphafunc
    bar.isFadedOut = 0;
    
    free(ptr, constructor_instance);
    return new_bar_hndl;
};


//========================================
// Bar löschen
//========================================
func void Bar_Delete(var int bar) {
    if(Hlp_IsValidHandle(bar)) {
        delete(bar);
    };
};

//========================================
// Bar schließen
//========================================
func void Bar_Hide(var int bar) {
	if(!Hlp_IsValidHandle(bar)) { return; };
	var _bar b; b = get(bar);
	View_Close(b.v0);
    View_Close(b.vRange);
	View_Close(b.v1);
    View_Close(b.vLabel);
};

//========================================
// Bar oeffnen
//========================================
func void Bar_Show(var int bar) {
	if(!Hlp_IsValidHandle(bar)) { return; };
	var _bar b; b = get(bar);
	View_Open(b.v0);
    View_Open(b.vRange);
	View_Open(b.v1);
    View_Open(b.vLabel);
};

//========================================
// Bar MoveToAdvanced anchorPoint_mode / validScreenSpace based 
//========================================
func void Bar_MoveToAdvanced( var int bar_hndl, var int x, var int y, var int anchorPoint_mode, var int validScreenSpace ) {
    B4DI_Info3("Bar_MoveToAdvanced: x= ", x, " y= ", y, " anchorPoint_mode= ", anchorPoint_mode);
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    var _bar b; b = get(bar_hndl);
    var zCView vBack; vBack = View_Get(b.v0);
    var zCView vRange; vRange = View_Get(b.vRange);
    
    if( anchorPoint_mode == ANCHOR_USE_OBJECTS_ANCHOR ) {
        anchorPoint_mode = Bar_GetAnchor(bar_hndl);  
    };


    var int base_TopMargin; 
    var int base_BottomMargin; 
    var int base_LeftMargin; 
    var int base_RightMargin;

    //TODO Protect against wrong values caused by mid "actual bar" animation movement?
    base_TopMargin    = vRange.vposy - vBack.vposy;
    base_RightMargin  = (vBack.vposx  + vBack.vsizex) - (vRange.vposx + vRange.vsizex);
    base_BottomMargin = (vBack.vposy + vBack.vsizey) - (vRange.vposy + vRange.vsizey);
    base_LeftMargin   = vRange.vposx - vBack.vposx;

    View_MoveToAdvanced( b.v0 , x, y, anchorPoint_mode, validScreenSpace );
    
    View_SetMargin( b.vRange , b.v0, ALIGN_CENTER, base_TopMargin, base_RightMargin, base_BottomMargin, base_LeftMargin ); 
    View_SetMargin( b.v1     , b.v0, ALIGN_CENTER, base_TopMargin, base_RightMargin, base_BottomMargin, base_LeftMargin ); 
    View_SetMargin( b.vLabel , b.v0, ALIGN_CENTER, base_TopMargin, base_RightMargin, base_BottomMargin, base_LeftMargin ); 

    B4DI_Info2("Bar_MoveToAdvanced: vsizex= ", vRange.vsizex, " vsizey= ", vRange.vsizey);
};

//========================================
// Bar AnchorPoint bewegen, moves the wohle bar in such a way that the anchorpoint will be on the coordinates afterwards
//========================================
func void Bar_Anchor_MoveTo( var int bar_hndl, var int x, var int y ) {
    Bar_MoveToAdvanced( bar_hndl, x, y, ANCHOR_USE_OBJECTS_ANCHOR, NON_VALIDSCREENSPACE);
};

func void Bar_Anchor_MoveToValidScreenSpace( var int bar_hndl, var int x, var int y ) {
    Bar_MoveToAdvanced( bar_hndl, x, y, ANCHOR_USE_OBJECTS_ANCHOR, VALIDSCREENSPACE);
};

//========================================
// Bar Center bewegen 
//========================================
//keep for legacy
func void Bar_MoveTo(var int bar, var int x, var int y) {
	if(!Hlp_IsValidHandle(bar)) { return; };
	var _bar b; b = get(bar);
	var zCView v; v = View_Get(b.v0);
	x -= v.vsizex>>1;
	y -= v.vsizey>>1;
	x -= v.vposx;
	y -= v.vposy;
    View_Move( b.v0     , x, y );
    View_Move( b.vRange, x, y );
    View_Move( b.v1     , x, y );
    View_Move( b.vLabel , x, y );
};


func void Bar_MoveToCenter( var int bar_hndl, var int x, var int y ) {
    Bar_MoveToAdvanced( bar_hndl, x, y, ANCHOR_CENTER, NON_VALIDSCREENSPACE );
};


func void Bar_MoveToCenterValidScreenSpace( var int bar_hndl, var int x, var int y ) {
    Bar_MoveToAdvanced( bar_hndl, x, y, ANCHOR_CENTER, VALIDSCREENSPACE );
};

//========================================
// Bar Linke Obere Ecke bewegen 
//========================================

func void Bar_MoveLeftUpperTo(var int bar_hndl, var int x, var int y) {
    Bar_MoveToAdvanced( bar_hndl, x, y, ANCHOR_LEFT_TOP, NON_VALIDSCREENSPACE );
};

//========================================
// Bar Linke Obere Ecke bewegen innerhalb Valid Screenspace
//========================================
func void Bar_MoveLeftUpperToValidScreenSpace(var int bar_hndl, var int x, var int y) {
    Bar_MoveToAdvanced( bar_hndl, x, y, ANCHOR_LEFT_TOP, VALIDSCREENSPACE );
};

//========================================
// Bar Alpha
//========================================
func void Bar_SetAlpha(var int bar, var int alpha) {
	if(!Hlp_IsValidHandle(bar)) { return; };
	var _bar b; b = get(bar);
    View_SetAlpha(b.v0       , alpha);
    View_SetAlpha(b.vRange   , alpha);
    View_SetAlpha(b.v1       , alpha);
    View_SetAlphaAll(b.vLabel, alpha);
};

func int Bar_GetAlpha( var int bar ) {
    if(!Hlp_IsValidHandle(bar)) { return 0; };
    var _bar b; b = get(bar);
    //vBack as representation for overall alpha
    return View_GetAlpha(b.v0 );
};

//========================================
// Bar Texture
//========================================
func void Bar_SetBackTexture(var int bar, var string backTex)
{
    if(!Hlp_IsValidHandle(bar)) { return; };
    var _bar b; b = get(bar);
    View_SetTexture(b.v0, backTex);
};

func void Bar_SetMiddleTexture(var int bar, var string middleTex)
{
    if(!Hlp_IsValidHandle(bar)) { return; };
    var _bar b; b = get(bar);
    View_SetTexture(b.vRange, middleTex);
};

func void Bar_SetBarTexture(var int bar, var string barTex)
{
    if(!Hlp_IsValidHandle(bar)) { return; };
    var _bar b; b = get(bar);
    View_SetTexture(b.v1, barTex);
};

//========================================
// Bar Show Hide Label Text
//========================================
func void Bar_showLabel( var int bar_hndl ) {
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    var _bar bar; bar = get(bar_hndl);

    View_Open(bar.vLabel);
};

func void Bar_hideLabel( var int bar_hndl ) {
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    var _bar bar; bar = get(bar_hndl);

    View_Close(bar.vLabel);
};

//========================================
// Bar Set Label Text (centered)
//========================================
func void Bar_SetLabelText(var int bar_hndl, var string labelText, var string font) {
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    var zCView vLabel; vLabel = View_Get(bar.vLabel);
    var _bar bar; bar = get(bar_hndl);

    var int lLenght; lLenght = Print_ToVirtual( Print_GetStringWidth(labelText, font), PS_X );
    var int fHeight; fHeight = Print_ToVirtual( Print_GetFontHeight(font), PS_Y );
    // calculation seem to happen too early after resize?
    var int xPos; xPos = roundf ( subf( fracf(PS_VMAX , 2) , fracf( Print_ToVirtual(lLenght, vLabel.vsizex) , 2 ) ) ); 
    var int yPos; yPos = roundf ( subf( fracf(PS_VMAX , 2) , fracf( Print_ToVirtual(fHeight, vLabel.vsizey) , 2 ) ) ); 
    //var int yPos; yPos = (PS_VMAX / 2) - ( Print_ToVirtual(fHeight, vLabel.vsizey) / 2 ); 
    B4DI_Info2("Label xPos: ", xPos, " yPos: ", yPos );

    View_DeleteText(bar.vLabel);
    View_AddText(bar.vLabel, xPos, yPos , labelText , font);

};

func void Bar_DeleteLabelText(var int bar_hndl) {
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    var _bar bar; bar = get(bar_hndl);

    View_DeleteText(bar.vLabel);
};









