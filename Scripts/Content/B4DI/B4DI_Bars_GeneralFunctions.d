//#################################################################
//
//  General Functions
//
//#################################################################

//TODO Depricated -> migrate XP-Bar
//func void B4DI_Bar_fadeOut(var int bar_hndl, var int deleteBar) {
//	var _bar bar_inst; bar_inst = get(bar_hndl);
//	bar_inst.anim8FadeOut = Anim8_NewExt(255, Bar_SetAlpha, bar_hndl, false);
//	Anim8_RemoveIfEmpty(bar_inst.anim8FadeOut, true);
//	if (deleteBar) {
//		Anim8_RemoveDataIfEmpty(bar_inst.anim8FadeOut, true);
//	} else {
//		Anim8_RemoveDataIfEmpty(bar_inst.anim8FadeOut, false);
//	};
	
//	Anim8(bar_inst.anim8FadeOut, 255,  5000, A8_Wait);
//	Anim8q(bar_inst.anim8FadeOut,   0, 2000, A8_SlowEnd);

//};

func void B4DI_Bar_pulse_size(var int bar_hndl) {
	var int a8_XpBar_pulse; a8_XpBar_pulse = Anim8_NewExt(100 , B4DI_Bar_SetBarSizeCenteredPercentXY, bar_hndl, false); //height input
	Anim8_RemoveIfEmpty(a8_XpBar_pulse, true);
	Anim8_RemoveDataIfEmpty(a8_XpBar_pulse, false);
	
	Anim8 (a8_XpBar_pulse, 100,  100, A8_Wait);
	Anim8q(a8_XpBar_pulse, 150, 200, A8_SlowEnd);
	Anim8q(a8_XpBar_pulse, 100, 100, A8_SlowStart);

};

func void B4DI_originalBar_hide( var int obar_ptr){
	var oCViewStatusBar bar_inst; bar_inst = MEM_PtrToInst(obar_ptr);
	bar_inst.zCView_alpha = 0; //backView
	ViewPtr_SetAlpha(bar_inst.range_bar, 0); //middleView
	ViewPtr_SetAlpha(bar_inst.value_bar, 0);	//barView
};

