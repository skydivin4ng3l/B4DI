func int B4DI_Aligment_Ceate() {
	var int new_alleBarsLists_hndl; new_alleBarsLists_hndl = new(_alleBarsLists@);
	var _alleBarsLists aBLists; aBLists = get(new_alleBarsLists_hndl);

	aBLists.eBarList_Top_Left		= 0;
	aBLists.eBarList_Top_Center		= 0;
	aBLists.eBarList_Top_Right		= 0;     
	
	aBLists.eBarList_Center_Left	= 0;      
	aBLists.eBarList_Center_Center	= 0;    
	aBLists.eBarList_Center_Right	= 0;     
	
	aBLists.eBarList_Bottom_Left	= 0;      
	aBLists.eBarList_Bottom_Center	= 0;    
	aBLists.eBarList_Bottom_Right	= 0;     

	return new_alleBarsLists_hndl;

};

//TODO rework as zCARRAY
func void B4DI_Alignment_InitAlways() {
	if ( !Hlp_IsValidHandle( MEM_alleBarsLists_handle ) ) {
		MEM_Info("B4DI_Aligment_InitAlways; Creating the Handle");

		MEM_alleBarsLists_handle = B4DI_Aligment_Ceate();
	};
	MEM_alleBarsLists = get(MEM_alleBarsLists_handle);

	MEM_Info("B4DI_Aligment_InitAlways finished");	
};

