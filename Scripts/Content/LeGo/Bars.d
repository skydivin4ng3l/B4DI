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
    var int v0;                         // zCView(h)
    var int vMiddle;                    // zCView(h)
    var int v1;                         // zCView(h)
    var int vLabel;                     // zCView(h)
    var int initialDynamicVSizes[4];    // Array<int>
    var int initialVPositions[8];       // Array<int>
    var int isFadedOut;                 // Bool
    //var int anim8FadeOut;               // A8Head(h)
};

instance _bar@(_bar);

func void _bar_Delete(var _bar b) {
    if(Hlp_IsValidHandle(b.v0)) {
        delete(b.v0);
    };
    if(Hlp_IsValidHandle(b.vMiddle)) {
        delete(b.vMiddle);
    };
    if(Hlp_IsValidHandle(b.v1)) {
        delete(b.v1);
    };
    if(Hlp_IsValidHandle(b.vLabel)) {
        delete(b.vLabel);
    };
    //if(Hlp_IsValidHandle(b.anim8FadeOut)) {
    //    Anim8_Delete(b.anim8FadeOut);
    //};
}; 

//========================================
// [intern] Helper store VPos and VSize as reference for scale/position based animations
//========================================

func void Bar_storePosSize(var int bar_hndl){
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    var _bar b; b = get(bar_hndl);
    var zCView v; v = View_Get(b.v0);

    b.initialVPositions[IP_VBACK_LEFT] = v.vposx;
    b.initialVPositions[IP_VBACK_TOP] = v.vposy;
    b.initialVPositions[IP_VBACK_CENTER_X] = v.vposx - v.vsizex>>1; // >>1 durch 2
    b.initialVPositions[IP_VBACK_CENTER_Y] = v.vposy - v.vsizey>>1;
    b.initialDynamicVSizes[IDS_VBACK_X] = v.vsizex;
    b.initialDynamicVSizes[IDS_VBACK_Y] = v.vsizey;
    
    v = View_Get(b.v1); //same as vMiddle and vLabel

    b.initialVPositions[IP_VBAR_LEFT] = v.vposx;
    b.initialVPositions[IP_VBAR_TOP] = v.vposy;
    b.initialVPositions[IP_VBAR_CENTER_X] = v.vposx - v.vsizex>>1; // >>1 durch 2
    b.initialVPositions[IP_VBAR_CENTER_Y] = v.vposy - v.vsizey>>1;
    b.initialDynamicVSizes[IDS_VBAR_X] = v.vsizex;
    b.initialDynamicVSizes[IDS_VBAR_Y] = v.vsizey;

    B4DI_debugSpy("Bar PositionX",IntToString(v.vposx));
    B4DI_debugSpy("Bar PositionY",IntToString(v.vposy));
    B4DI_debugSpy("Bar SizeX",IntToString(v.vsizex));
    B4DI_debugSpy("Bar SizeY",IntToString(v.vsizey));
    
};

//========================================
// Höchstwert setzen
//========================================
func void Bar_SetMax(var int bar, var int max) {
    if(!Hlp_IsValidHandle(bar)) { return; };
    var _bar b; b = get(bar);
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
    View_Resize(b.v1, (pro * b.barW) / 1000, -1);
    b.val = (pro * b.valMax) / 1000; //to keep both valMax | val in the same space
};

//========================================
// Wert in 1/100
//========================================
func void Bar_SetPercent(var int bar, var int perc) {
    if(!Hlp_IsValidHandle(bar)) { return; };
    var _bar b; b = get(bar);
    Bar_SetPromille(bar, perc*10);
    b.val = (perc * 1000 * b.valMax) / 1000; 
};

//========================================
// Wert der Bar
//========================================
func void Bar_SetValue(var int bar, var int val) {
    if(!Hlp_IsValidHandle(bar)) { return; };
    var _bar b; b = get(bar);
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

//========================================
// [Intern] Resizes bars in valid space 
//
// if back reaches screen borders before scaling is finished
//  it will be moved, middle and bar will be moved according to delta before resizing.
//========================================
func void Bar_ResizeCenteredPercent(var int bar_hndl, var int relativScalingFactor){ //float relativScalingFactor
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    var _bar b; b = get(bar_hndl);
    var zCView vBack; vBack = View_Get(b.v0);
    var zCView vMiddle; vMiddle = View_Get(b.vMiddle);
    var zCView vLabel; vLabel = View_Get(b.vLabel);
    var zCView vBar; vBar = View_Get(b.v1);
    
    b.barW = roundf( mulf( mkf( b.barW ) , relativScalingFactor ) );

    var int barTop; barTop = roundf(  mulf( mkf(  vBar.vposy - vBack.vposy ), relativScalingFactor ));
    var int barLeft; barLeft = roundf(  mulf( mkf( vBar.vposx - vBack.vposx ), relativScalingFactor ) );

    View_ResizeCenteredValidScreenSpace(b.v0, roundf( mulf( mkf(vBack.vsizex) , relativScalingFactor) ), roundf( mulf( mkf(vBack.vsizey) , relativScalingFactor ) ) );
    //to keep the margin valid if scaled back touches screen border
    View_MoveTo(b.vMiddle, vBack.vposx + barLeft, vBack.vposy + barTop );
    View_MoveTo(b.v1, vBack.vposx + barLeft, vBack.vposy + barTop );
    View_MoveTo(b.vLabel, vBack.vposx + barLeft, vBack.vposy + barTop );
        
    View_Resize(b.vMiddle, roundf( mulf( mkf(vMiddle.vsizex) , relativScalingFactor) ), roundf( mulf( mkf(vMiddle.vsizey) , relativScalingFactor) ) );
    View_Resize(b.v1, roundf( mulf( mkf(vBar.vsizex) , relativScalingFactor) ), roundf( mulf( mkf(vBar.vsizey) , relativScalingFactor) ) );
    View_Resize(b.vLabel, roundf( mulf( mkf(vLabel.vsizex) , relativScalingFactor) ), roundf( mulf( mkf(vLabel.vsizey) , relativScalingFactor) ) );
    Bar_SetValue(bar_hndl, b.val);
};

func void Bar_ResizeCenteredPercentFromInitial(var int bar_hndl, var int aboluteScalingFactor){ //float aboluteScalingFactor
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    var _bar b; b = get(bar_hndl);

    b.barW = roundf( mulf( mkf( b.initialDynamicVSizes[IDS_VBAR_X] ) , aboluteScalingFactor ) );

    View_ResizeCenteredValidScreenSpace(b.v0, roundf( mulf( mkf(b.initialDynamicVSizes[IDS_VBACK_X] ) , aboluteScalingFactor) ), roundf( mulf( mkf(b.initialDynamicVSizes[IDS_VBACK_Y]) , aboluteScalingFactor ) ) );

    var int barTopBottomMargin;
    barTopBottomMargin = roundf( mulf( mkf(b.initialVPositions[IP_VBAR_TOP] - b.initialVPositions[IP_VBACK_TOP]  ) , aboluteScalingFactor) );
    var int barLeftRightMargin;
    barLeftRightMargin = roundf( mulf( mkf(b.initialVPositions[IP_VBAR_LEFT] - b.initialVPositions[IP_VBACK_LEFT]  ) , aboluteScalingFactor) );

    View_SetMargin(b.vMiddle, b.v0, ALIGN_CENTER, barTopBottomMargin, barLeftRightMargin, barTopBottomMargin, barLeftRightMargin ); 
    View_SetMargin(b.v1, b.v0, ALIGN_CENTER, barTopBottomMargin, barLeftRightMargin, barTopBottomMargin, barLeftRightMargin );
    View_SetMargin(b.vLabel, b.v0, ALIGN_CENTER, barTopBottomMargin, barLeftRightMargin, barTopBottomMargin, barLeftRightMargin ); 

    Bar_SetValue(bar_hndl, b.val );
};

//========================================
// Resizes bar according to Resolution height
//
//========================================
func void Bar_dynamicResolutionBasedScale(var int bar_hndl){
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    
    Print_GetScreenSize();

    var int dynScalingFactor; dynScalingFactor = fracf( Print_Screen[PS_Y] ,512 );

    Bar_ResizeCenteredPercentFromInitial(bar_hndl, dynScalingFactor);
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
    b.vMiddle = View_CreatePxl(bu.x - buwh, bu.y - buhh, bu.x + buwh + aw, bu.y + buhh + ah);
    b.v1 =      View_CreatePxl(bu.x - buwh, bu.y - buhh, bu.x + buwh + aw, bu.y + buhh + ah);
    b.vLabel =  View_CreatePxl(bu.x - buwh, bu.y - buhh, bu.x + buwh + aw, bu.y + buhh + ah);
    View_SetTexture(b.v0, bu.backTex);
    View_SetTexture(b.vMiddle, bu.middleTex);
    View_SetTexture(b.v1, bu.barTex);
    
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
    View_Open(b.vMiddle);
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
    bar.v0 = View_CreateCenterPxl(bar_constr.x, bar_constr.y, bar_constr.width, bar_constr.height);
    bar.barW = bar_constr.width - bar_constr.barLeft *2;
    bar.vMiddle =   View_CreateCenterPxl(bar_constr.x, bar_constr.y, bar.barW, bar_constr.height- bar_constr.barTop *2);
    bar.v1 =        View_CreateCenterPxl(bar_constr.x, bar_constr.y, bar.barW, bar_constr.height- bar_constr.barTop *2);
    bar.vLabel =   View_CreateCenterPxl(bar_constr.x, bar_constr.y, bar.barW, bar_constr.height- bar_constr.barTop *2);
    //TODO remove? vMiddle is Range
    bar.barW = Print_ToVirtual(bar.barW, PS_X);
    //^^
    View_SetTexture(bar.v0, bar_constr.backTex);
    View_SetTexture(bar.vMiddle, bar_constr.middleTex);
    View_SetTexture(bar.v1, bar_constr.barTex);

    Bar_storePosSize(new_bar_hndl);
    Bar_SetValue(new_bar_hndl, bar_constr.value);

    var zCView v; v = View_Get(bar.v0);
    //v.alphafunc = zRND_ALPHA_FUNC_ADD;
    v = View_Get(bar.vMiddle);
    //v.alphafunc = zRND_ALPHA_FUNC_SUB;
    v = View_Get(bar.v1);
    //v.alphafunc = zRND_ALPHA_FUNC_ADD;

    View_Open(bar.v0);
    View_Open(bar.vMiddle);
    View_Open(bar.v1);
    View_Open(bar.vLabel); //this order that vMiddle can hold text label, therefore alphafunc
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
    View_Close(b.vMiddle);
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
    View_Open(b.vMiddle);
	View_Open(b.v1);
    View_Open(b.vLabel);
};

//========================================
// Bar Center bewegen 
//========================================
func void Bar_MoveTo(var int bar, var int x, var int y) {
	if(!Hlp_IsValidHandle(bar)) { return; };
	var _bar b; b = get(bar);
	var zCView v; v = View_Get(b.v0);
	x -= v.vsizex>>1;
	y -= v.vsizey>>1;
	x -= v.vposx;
	y -= v.vposy;
	View_Move(b.v0, x, y);
    View_Move(b.vMiddle, x, y);
	View_Move(b.v1, x, y);
    View_Move(b.vLabel, x, y);
};

//========================================
// Bar Linke Obere Ecke bewegen 
//========================================

func void Bar_MoveLeftUpperTo(var int bar, var int x, var int y) {
    if(!Hlp_IsValidHandle(bar)) { return; };
    var _bar b; b = get(bar);
    var zCView v; v = View_Get(b.v0);
    View_MoveTo(b.v0, x, y);
    View_MoveTo(b.vMiddle, x, y);
    View_MoveTo(b.v1, x, y);
    View_MoveTo(b.vLabel, x, y);
};

//========================================
// Bar Linke Obere Ecke bewegen innerhalb Valid Screenspace
//========================================

func void Bar_MoveLeftUpperToValidScreenSpace(var int bar, var int x, var int y) {
    if(!Hlp_IsValidHandle(bar)) { return; };
    var _bar b; b = get(bar);
    var zCView vBack; vBack = View_Get(b.v0);
    var zCView vBar; vBar = View_Get(b.v1);
    var int barTop; barTop = vBar.vposy - vBack.vposy ;
    var int barLeft; barLeft = vBar.vposx - vBack.vposx;

    View_MoveToValidScreenSpace(b.v0, x, y);
    //to keep the margin valid if movement would surpass screen border
    View_MoveTo(b.vMiddle, vBack.vposx + barLeft, vBack.vposy + barTop );
    View_MoveTo(b.v1, vBack.vposx + barLeft, vBack.vposy + barTop );
    View_MoveTo(b.vLabel, vBack.vposx + barLeft, vBack.vposy + barTop );
    
};

//========================================
// Bar Alpha
//========================================
func void Bar_SetAlpha(var int bar, var int alpha) {
	if(!Hlp_IsValidHandle(bar)) { return; };
	var _bar b; b = get(bar);
    View_SetAlpha(b.v0, alpha);
    View_SetAlpha(b.vMiddle, alpha);
    View_SetAlpha(b.v1, alpha);
    View_SetAlphaAll(b.vLabel, alpha);
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
    View_SetTexture(b.vMiddle, middleTex);
};

func void Bar_SetBarTexture(var int bar, var string barTex)
{
    if(!Hlp_IsValidHandle(bar)) { return; };
    var _bar b; b = get(bar);
    View_SetTexture(b.v1, barTex);
};

//========================================
// Bar Set Label Text (centered)
//========================================
func void Bar_SetLabelText(var int bar_hndl, var string labelText, var string font) {
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    var _bar bar; bar = get(bar_hndl);
    var zCView vLabel; vLabel = View_Get(bar.vLabel);

    var int lLenght; lLenght = Print_ToVirtual( Print_GetStringWidth(labelText, font), PS_X );
    var int fHeight; fHeight = Print_ToVirtual( Print_GetFontHeight(font), PS_Y );

    var int xPos; xPos = (PS_VMAX / 2) - ( Print_ToVirtual(lLenght, vLabel.vsizex) / 2 ); 
    var int yPos; yPos = (PS_VMAX / 2) - ( Print_ToVirtual(fHeight, vLabel.vsizey) / 2 ); 
    //B4DI_Info2("Label xPos: ", xPos, " yPos: ", yPos );

    View_DeleteText(bar.vLabel);
    View_AddText(bar.vLabel, xPos, yPos , labelText , font);

};

func void Bar_DeleteLabelText(var int bar_hndl) {
    if(!Hlp_IsValidHandle(bar_hndl)) { return; };
    var _bar bar; bar = get(bar_hndl);

    View_DeleteText(bar.vLabel);
};









