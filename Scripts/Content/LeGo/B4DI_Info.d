const int B4DI_preserve_current_StringBuilder = 0;

func void B4DI_Info1(var string param1_description, var int param1_value) {
	if(SB_Get()) {
		B4DI_preserve_current_StringBuilder = SB_Get();
	};
	var int sbuilder; sbuilder=SB_New();
	SB_Use(sbuilder);
	SB(param1_description);
	SBi(param1_value); 
	var string s; s = SB_ToString();
	MEM_Info(s);
	SB_Destroy();
	if(B4DI_preserve_current_StringBuilder) {
		SB_Use(B4DI_preserve_current_StringBuilder);
		B4DI_preserve_current_StringBuilder = 0;
	};
};

func void B4DI_Info2(var string param1_description, var int param1_value, var string param2_description, var int param2_value) {
	if(SB_Get()) {
		B4DI_preserve_current_StringBuilder = SB_Get();
	};
	var int sbuilder; sbuilder=SB_New();
	SB_Use(sbuilder);
	SB(param1_description); 
	SBi(param1_value); 
	SB(param2_description); 
	SBi(param2_value);
	var string s; s = SB_ToString();
	MEM_Info(s);
	SB_Destroy();
	if(B4DI_preserve_current_StringBuilder) {
		SB_Use(B4DI_preserve_current_StringBuilder);
		B4DI_preserve_current_StringBuilder = 0;
	};
};

func void B4DI_Info3(var string param1_description, var int param1_value, var string param2_description, var int param2_value, var string param3_description, var int param3_value) {
	if(SB_Get()) {
		B4DI_preserve_current_StringBuilder = SB_Get();
	};
	var int sbuilder; sbuilder=SB_New(); 
	SB_Use(sbuilder);
	SB(param1_description); 
	SBi(param1_value); 
	SB(param2_description); 
	SBi(param2_value);
	SB(param3_description); 
	SBi(param3_value);
	var string s; s = SB_ToString();
	MEM_Info(s);
	SB_Destroy();
	if(B4DI_preserve_current_StringBuilder) {
		SB_Use(B4DI_preserve_current_StringBuilder);
		B4DI_preserve_current_StringBuilder = 0;
	};
};

func void B4DI_Info4(var string param1_description, var int param1_value, var string param2_description, var int param2_value, var string param3_description, var int param3_value, var string param4_description, var int param4_value) {
	if(SB_Get()) {
		B4DI_preserve_current_StringBuilder = SB_Get();
	};
	var int sbuilder; sbuilder=SB_New(); 
	SB_Use(sbuilder);
	SB(param1_description); 
	SBi(param1_value); 
	SB(param2_description); 
	SBi(param2_value);
	SB(param3_description); 
	SBi(param3_value);
	SB(param4_description); 
	SBi(param4_value);
	var string s; s = SB_ToString();
	MEM_Info(s);
	SB_Destroy();
	if(B4DI_preserve_current_StringBuilder) {
		SB_Use(B4DI_preserve_current_StringBuilder);
		B4DI_preserve_current_StringBuilder = 0;
	};
};

