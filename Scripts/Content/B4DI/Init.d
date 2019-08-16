func void B4DI_InitFeatures(){

	B4DI_Bars_init();
	// Read INI Settings
    MEM_Info("Initializing entries in Gothic.ini.");

    if (!MEM_GothOptExists("B4DI", "B4DI_barScale")) {
        // Add INI-entry, if not set
        MEM_SetGothOpt("B4DI", "B4DI_barScale", "1");
    };
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
        B4DI_InitFeatures();
    };

    

    // Successfully initialized
    return TRUE;
};

func void B4DI_InitAlways(){

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

    // Perform for every new session and on every load and level change
    B4DI_InitAlways();

    MEM_Info(ConcatStrings(B4DI_VERSION, " was initialized successfully."));
};