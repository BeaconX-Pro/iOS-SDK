
/**
 广播帧类型
 
 - MKBXPUIDFrameType: UID
 - MKBXPURLFrameType: URL
 - MKBXPTLMFrameType: TLM
 - MKBXPDeviceInfoFrameType: 设备信息帧
 - MKBXPBeaconFrameType: iBeacon信息帧
 - MKBXPThreeASensorFrameType: 3轴加速度传感器信息帧
 - MKBXPTHSensorFrameType: 温湿度传感器信息帧
 - MKBXPNODATAFrameType: NO DATA
 - MKBXPUnkonwFrameType:未知信息帧
 */
typedef NS_ENUM(NSInteger, MKBXPDataFrameType) {
    MKBXPUIDFrameType,
    MKBXPURLFrameType,
    MKBXPTLMFrameType,
    MKBXPDeviceInfoFrameType,
    MKBXPBeaconFrameType,
    MKBXPThreeASensorFrameType,
    MKBXPTHSensorFrameType,
    MKBXPNODATAFrameType,
    MKBXPUnknownFrameType,
};

typedef NS_ENUM(NSInteger, MKBXPConnectStatus) {
    MKBXPConnectStatusUnknow,
    MKBXPConnectStatusConnecting,
    MKBXPConnectStatusConnected,
    MKBXPConnectStatusConnectedFailed,
    MKBXPConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, MKBXPCentralManagerState) {
    MKBXPCentralManagerStateUnable,
    MKBXPCentralManagerStateEnable,
};

typedef NS_ENUM(NSInteger, MKBXPLockState) {
    MKBXPLockStateUnknow,
    MKBXPLockStateLock,
    MKBXPLockStateOpen,
    MKBXPLockStateUnlockAutoMaticRelockDisabled,
};


/**
 Target SLOT numbers(enum)，slot0~slot4
 */
typedef NS_ENUM(NSInteger, bxpActiveSlotNo) {
    bxpActiveSlot1,//SLOT 0
    bxpActiveSlot2,//SLOT 1
    bxpActiveSlot3,//SLOT 2
    bxpActiveSlot4,//SLOT 3
    bxpActiveSlot5,//SLOT 4
    bxpActiveSlot6,//SLOT 5
};
typedef NS_ENUM(NSInteger, slotRadioTxPower) {
    slotRadioTxPower4dBm,       //RadioTxPower:4dBm
    slotRadioTxPower3dBm,       //3dBm
    slotRadioTxPower0dBm,       //0dBm
    slotRadioTxPowerNeg4dBm,    //-4dBm
    slotRadioTxPowerNeg8dBm,    //-8dBm
    slotRadioTxPowerNeg12dBm,   //-12dBm
    slotRadioTxPowerNeg16dBm,   //-16dBm
    slotRadioTxPowerNeg20dBm,   //-20dBm
    slotRadioTxPowerNeg40dBm,   //-40dBm
};
typedef NS_ENUM(NSInteger, urlHeaderType) {
    urlHeaderType1,             //http://www.
    urlHeaderType2,             //https://www.
    urlHeaderType3,             //http://
    urlHeaderType4,             //https://
};

typedef NS_ENUM(NSInteger, threeAxisDataRate) {
    threeAxisDataRate1hz,           //1hz
    threeAxisDataRate10hz,          //10hz
    threeAxisDataRate25hz,          //25hz
    threeAxisDataRate50hz,          //50hz
    threeAxisDataRate100hz          //100hz
};

typedef NS_ENUM(NSInteger, threeAxisDataAG) {
    threeAxisDataAG0,               //±2g
    threeAxisDataAG1,               //±4g
    threeAxisDataAG2,               //±8g
    threeAxisDataAG3                //±16g
};
