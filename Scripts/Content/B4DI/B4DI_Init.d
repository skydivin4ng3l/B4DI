func void B4DI_InitAlways(){
    B4DI_AlignmentManager_InitAlways();
    B4DI_Bars_InitAlways();

    B4DI_Bars_applySettings();
};

func void B4DI_InitBarFeatures(){

	B4DI_Bars_InitOnce();
    //FF_ApplyExt(B4DI_Bars_InitOnce, 1, 1);
	// Read INI Settings
    B4DI_OptionGetters_InitOnce();

    //B4DI_InitAlways();
    
    //B4DI_BARS_FEATURES_INITIALISED = 1;
    MEM_Info("B4DI Bars ininitialised");
};

func int B4DI_InitOnce() {
    // Make sure LeGo is initialized with the required flags
    if ((_LeGo_Flags & B4DI_LEGO_FLAGS) != B4DI_LEGO_FLAGS) {
    	MEM_Info(ConcatStrings("_LeGo_Flags & B4DI_LEGO_FLAGS: ", IntToString(_LeGo_Flags & B4DI_LEGO_FLAGS) ) );
    	MEM_Info(ConcatStrings(" != ", IntToString(B4DI_LEGO_FLAGS) ) );
        MEM_Error("Insufficient LeGo flags for B4DI.");
        return FALSE;
    };

    
    // FEATURE: Dynamic Bars
    if (B4DI_Flags & B4DI_BARS) {
        B4DI_InitBarFeatures();
        //TODO think about this, cause only init always seem to have an issue with game start.
        //FF_ApplyExt(B4DI_InitBarFeatures,1,1);
    };

    

    // Successfully initialized
    return TRUE;
};


func void B4DI_Init(var int flags) {
    // Ikarus and LeGo need to be initialized first
    const int INIT_LEGO_NEEDED = 0; // Set to 1, if LeGo is not initialized by user (in INIT_Global())
    if (!_LeGo_Init) {
        LeGo_Init(_LeGo_Flags | B4DI_LEGO_FLAGS);
        INIT_LEGO_NEEDED = 1;
        MEM_Info("Setting INIT_LEGO_NEEDED to 1.");
    } else if (INIT_LEGO_NEEDED) {
        // If user does not initialize LeGo in INIT_Global(), as determined by INIT_LEGO_NEEDED, reinitialize Ikarus and
        // LeGo on every level change and loading here
        LeGo_Init(_LeGo_Flags);
    };

    MEM_Info(ConcatStrings(ConcatStrings("Initialize ", B4DI_VERSION), "."));
    B4DI_Flags = flags;

    // Perform only once per session
    if (!B4DI_INITIALIZED) {
        if (!B4DI_InitOnce()) {
            MEM_Info(ConcatStrings(B4DI_VERSION, " failed to initialize."));
            return;
        };
        B4DI_INITIALIZED = 1;
    };

    // performs only after once initialized actually happended 
    //if( B4DI_BARS_FEATURES_INITIALISED ) {
        // Perform for every new session and on every load and level change
        //B4DI_InitAlways();
    //};
    FF_ApplyExt(B4DI_InitAlways, 1, 1); //TODO totally unsafe think about this

    MEM_Info(ConcatStrings(B4DI_VERSION, " was initialized successfully."));
};