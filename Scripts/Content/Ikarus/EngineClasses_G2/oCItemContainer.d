class oCItemContainer {
  var int    vtbl;                           // 0x0000
  var int    contents;                       // 0x0004 zCListSort<oCItem>*
  var int    npc;                            // 0x0008 oCNpc*
  var string titleText;                      // 0x001C zSTRING
  var int    invMode;                        // 0x0020 int
  var int    selectedItem;                   // 0x0024 int access with oCItemContainer.selectedItem +2 for correct offset
  var int    offset;                         // 0x0028 int
  var int    maxSlotsCol;                    // 0x002C int
  var int    maxSlotsColScr;                 // 0x0030 int
  var int    maxSlotsRow;                    // 0x0034 int
  var int    maxSlotsRowScr;                 // 0x0038 int
  var int    maxSlots;                       // 0x003C int
  var int    marginTop;                      // 0x0040 int
  var int    marginLeft;                     // 0x0044 int
  var int    frame;                          // 0x0048 zBOOL
  var int    right;                          // 0x004C zBOOL
  var int    ownList;                        // 0x0050 zBOOL
  var int    prepared;                       // 0x0054 zBOOL
  var int    passive;                        // 0x0058 zBOOL
  var int    TransferCount;                  // 0x005C zINT
  var int    viewTitle;                      // 0x005E zCView*
  var int    viewBack;                       // 0x0062 zCView*
  var int    viewItem;                       // 0x0066 zCView*
  var int    viewItemActive;                 // 0x006A zCView*
  var int    viewItemHightlighted;           // 0x006E zCView*
  var int    viewItemActiveHighlighted;      // 0x0072 zCView*
  var int    viewItemInfo;                   // 0x0076 zCView*
  var int    viewItemInfoItem;               // 0x007A zCView*
  var int    textView;                       // 0x007E zCView*
  var int    viewArrowAtTop;                 // 0x0082 zCView*
  var int    viewArrowAtBottom;              // 0x0086 zCView*
  var int    rndWorld;                       // 0x008A zCWorld*
  var int    posx;                           // 0x008E int
  var int    posy;                           // 0x0092 int
  var int    m_bManipulateItemsDisabled;     // 0x0096 zBOOL
  var int    m_bCanTransferMoreThanOneItem;  // 0x009A zBOOL
};

