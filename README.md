# BeaconPlus iOS Software Development Kit Guide

* This SDK support the company's BeaconX Pro series products.

# Design instructions

* We divide the communications between SDK and devices into two stages: Scanning stage, Connection stage.For ease of understanding, let's take a look at the related classes and the relationships between them.

`MKBXPCentralManager`：global manager, check system's bluetooth status, listen status changes, the most important is scan and connect to devices;

`MKBXPBaseBeacon`: instance of devices, MKBXPCentralManager will create an MKBXPBaseBeacon instance while it found a physical device, a device corresponds to an instance.Currently there are *UID broadcast frame*, *URL broadcast frame*, *TLM broadcast frame*, *device information frame*, *iBeacon broadcast frame*, *three-axis acceleration broadcast frame*, *temperature and humidity broadcast frame*;

`MKBXPInterface`: When the device is successfully connected, the device data can be read through the interface in `MKBXPInterface`;

`MKBXPInterface+MKBXPConfig.h`: When the device is successfully connected, you can configure the device data through the interface in `MKBXPInterface+MKBXPConfig.h`;


## Scanning Stage

in this stage, `MKBXPCentralManager ` will scan and analyze the advertisement data of BeaconX Pro devices, `MKBXPCentralManager ` will create `MKBXPBaseBeacon ` instance for every physical devices, developers can get all advertisement data by its property.


## Connection Stage

Developers can get the lock state of the current device by calling the `readLockStateWithPeripheral:sucBlock:failedBlock:` interface.If the current lock status is 00, you need to enter the connection password and call `connectPeripheral:password:progressBlock:sucBlock:failedBlock` to connect;If the current lock status is 02, it indicates that the current device can log in without password, call `connectPeripheral:progressBlock:sucBlock:failedBlock:` to connect.


# Get Started

### Development environment:

* Xcode9+， due to the DFU and Zip Framework based on Swift4.0, so please use Xcode9 or high version to develop;
* iOS12, we limit the minimum iOS system version to 12.0；

### Import to Project

CocoaPods

SDK-BXP is available through [CocoaPods](https://cocoapods.org).To install it, simply add the following line to your Podfile, and then import <MKBeaconXPlus/MKBXPSDK.h>：

**pod 'MKBeaconXPlus/SDK-BXP'**


* <font color=#FF0000 face="黑体">!!!on iOS 10 and above, Apple add authority control of bluetooth, you need add the string to "info.plist" file of your project: Privacy - Bluetooth Peripheral Usage Description - "your description". as the screenshot below.</font>

* <font color=#FF0000 face="黑体">!!! In iOS13 and above, Apple added permission restrictions on Bluetooth APi. You need to add a string to the project's info.plist file: Privacy-Bluetooth Always Usage Description-"Your usage description".</font>


## Start Developing

### Get sharedInstance of Manager

First of all, the developer should get the sharedInstance of Manager:

```
MKBXPCentralManager *manager = [MKBXPCentralManager shared];
```

#### 1.Start scanning task to find devices around you,please follow the steps below:

* 1.`manager.delegate = self;` //Set the scan delegate and complete the related delegate methods.
* 2.you can start the scanning task in this way:`[manager startScan];`    
* 3.at the sometime, you can stop the scanning task in this way:`[manager stopScan];`

#### 2.Connect to device

* 1.Developers should first read the lock state of the device, which determines whether a connection password is required when connecting to the device.

```
[[MKBXPCentralManager shared] readLockStateWithPeripheral:peripheral sucBlock:^(NSString *lockState) {
        if ([lockState isEqualToString:@"00"]) {
            //A password is required to connect to the device.
            return;
        }
        if ([lockState isEqualToString:@"02"]) {
            //No password is required to connect to the current device.
            return;
        }
    } failedBlock:^(NSError *error) {
        //Failed callback
    }];
```

* 2.If the device requires a connection password, the connection method is as follows:

```
[[MKBXPCentralManager shared] connectPeripheral:peripheral password:password progressBlock:^(float progress) {
        //progress
    } sucBlock:^(CBPeripheral *peripheral) {
        //Success 
    } failedBlock:^(NSError *error) {
        //Failure
    }];
```

* 3.If the device is connected without password, the connection method is as follows:

```
[[MKBXPCentralManager shared] connectPeripheral:peripheral progressBlock:^(float progress) {
        //progress
    } sucBlock:^(CBPeripheral *peripheral) {
        //Success
    } failedBlock:^(NSError *error) {
        //Failure
    }];
```

#### 3.Get State

Through the manager, you can get the current Bluetooth status of the mobile phone, the connection status of the device, and the lock status of the device. If you want to monitor the changes of these three states, you can register the following notifications to achieve:

*  When the Bluetooth status of the mobile phone changes，<font color=#FF0000 face="黑体">`mk_bxp_centralManagerStateChangedNotification`</font> will be posted.You can get status in this way:

```
[[MKBXPCentralManager shared] centralStatus];
```

*  When the device connection status changes，<font color=#FF0000 face="黑体"> `mk_bxp_peripheralConnectStateChangedNotification` </font> will be posted.You can get the status in this way:

```
[MKBXPCentralManager shared].connectState;
```

*  When the lock state of the device changes，<font color=#FF0000 face="黑体"> `mk_bxp_peripheralLockStateChangedNotification` </font> will be posted.You can get the status in this way: 

```
[MKBXPCentralManager shared].lockState;
```


#### 4.Monitor three-axis data.

When the device is connected, the developer can monitor the three-axis data of the device through the following steps:

*  1.Open data monitoring by the following method:

```
[[MKBXPCentralManager shared] notifyThreeAxisAcceleration:YES];
```


*  2.Register for `mk_bxp_receiveThreeAxisAccelerometerDataNotification` notifications to monitor device three-axis data changes.


```

[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAxisDatas:)
                                                 name:mk_bxp_receiveThreeAxisAccelerometerDataNotification
                                               object:nil];
```


```
#pragma mark - Notification
- (void)receiveAxisDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    NSArray *tempList = dic[@"axisData"];
    if (!ValidArray(tempList)) {
        return;
    }
}
```


#### 5.Monitor temperature and humidity data.

When the device is connected, the developer can monitor the temperature and humidity data of the device through the following steps:

* 1.Open data monitoring by the following method:

```
[[MKBXPCentralManager shared] notifyTHData:YES];
```

* 2.Register for `mk_bxp_receiveHTDataNotification` notifications to monitor device H&T data changes.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveHTDatas:)
                                                 name:mk_bxp_receiveHTDataNotification
                                               object:nil];
```

```
- (void)receiveHTDatas:(NSNotification *)note {
    NSDictionary *dataDic = note.userInfo;
    /*
        @{
        @"temperature":temperature,@"humidity":humidity,
        }
    */
    if (!ValidDict(dataDic)) {
        return;
    }
}
```

#### 6.Monitor the temperature and humidity data stored by the device.

When the device is connected, the developer can monitor the temperature and humidity data stored by the device through the following steps:

* 1.Open data monitoring by the following method:

```
[[MKBXPCentralManager shared] notifyRecordTHData:YES];
```

* 2.Register for `mk_bxp_receiveRecordHTDataNotification` notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveRecordHTData:)
                                                 name:mk_bxp_receiveRecordHTDataNotification
                                               object:nil];
```

```
#pragma mark - note
- (void)receiveRecordHTData:(NSNotification *)note {
    NSArray *dataList = note.userInfo[@"dataList"];
    /*
    datas
    */
}
```

#### 7.Monitor the light perception data stored by the device.

When the device is connected, the developer can monitor the light perception data stored by the device through the following steps:

* 1.Open data monitoring by the following method:

```
[[MKBXPCentralManager shared] notifyLightSensorData:YES];
```

* 2.Register for `mk_bxp_receiveLightSensorDataNotification` notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLightSensorDatas:)
                                                 name:mk_bxp_receiveLightSensorDataNotification
                                               object:nil];
```

```
#pragma mark - note
- (void)receiveLightSensorDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    NSString *state = @"Ambient light NOT detected";
    if ([dic[@"state"] isEqualToString:@"01"]) {
        state = @"Ambient light detected";
    }
    NSArray *dateList = [dic[@"date"] componentsSeparatedByString:@"-"];
    NSString *dateString = [NSString stringWithFormat:@"%@/%@/%@ %@:%@:%@",dateList[2],dateList[1],dateList[0],dateList[3],dateList[4],dateList[5]];
    NSString *text = [NSString stringWithFormat:@"\n%@\t\t%@",dateString,state];
}
```

#### 8.Monitor the current light status of the device.

When the device is connected, the developer can monitor the current light status of the device through the following steps:

* 1.Open data monitoring by the following method:

```
[[MKBXPCentralManager shared] notifyLightStatusData:YES];
```

* 2.Register for `mk_bxp_receiveLightSensorStatusDataNotification` notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLightSensorDatas:)
                                                 name: mk_bxp_receiveLightSensorStatusDataNotification
                                               object:nil];
```

```
#pragma mark - note
- (void)receiveLightSensorStatus:(NSNotification *)note {
    ///method.
}
```



#### 9.Monitoring device disconnect reason.

Register for `mk_bxp_deviceDisconnectTypeNotification` notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectTypeNotification:)
                                                 name:@"mk_bxp_deviceDisconnectTypeNotification"
                                               object:nil];

```

```
- (void)disconnectTypeNotification:(NSNotification *)note {
    NSString *type = note.userInfo[@"type"];
    //After connecting the device, if no password is entered within one minute, it returns 0x00. After successful password change, it returns 0x01. Factory reset of the device,it returns 0x02.
    self.disconnectType = YES;
    if ([type isEqualToString:@"01"]) {
        [self showAlertWithMsg:@"Password changed successfully! Please reconnect the device." title:@"Change Password"];
        return;
    }
    if ([type isEqualToString:@"02"]) {
        [self showAlertWithMsg:@"Factory reset successfully!Please reconnect the device." title:@"Dismiss"];
        return;
    }
}
```


### Communication with the device

**The device can communicate normally only when the device is in the unlocked state (the lock state cannot be the locked state 00).**

<font color=#FF0000 face="黑体">At present, BeaconX Pro produced by MOKO has different models, and the supported functions are also different. Read the current device type before operation to avoid unnecessary problems.</font>

* Read slot type

```
[MKBXPInterface bxp_readDeviceTypeWithSucBlock:^(id  _Nonnull returnData) {
        //Refer to the table below
        NSString *deviceType = returnData[@"result"][@"deviceType"];
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```

* Slot type table(All types of devices support setting slot broadcast data to UID, URL, TLM, Device Info, iBeacon, NO DATA)

|  deviceType   | 00  |  01   | 02  |  03 | 04 | 05 |
|  ----  | ----  | ----  | ----  | ----  | ----  |----  | ---- | ---- |
| sensor type  | None | LIS3DH3  | SHT3X | LIS3DH3 & SHT3X | Light sensor | Light sensor & LIS3DH3|
|  supported   | UID/URL/TLM/Device Info/iBeacon/NO DATA  |  UID/URL/TLM/Device Info/iBeacon/NO DATA/3-axis   | UID/URL/TLM/Device Info/iBeacon/NO DATA/T&H  |  UID/URL/TLM/Device Info/iBeacon/NO DATA/3-axis/T&H | UID/URL/TLM/Device Info/iBeacon/NO DATA | UID/URL/TLM/Device Info/iBeacon/3-axis/NO DATA |


#### Get data of each Slot

Next, let talk about the parameter data of every slot.Before read the code, let's talk about slot, you can think slot as a advertisement tool, it advertise the content of advertisement data even "don't know" what the content is. such as the 6 slots may like this:



|  Slot Number   | 0  |  1   | 2  |  3   | 4  |  5   |
|  ----  | ----  | ----  | ----  | ----  | ----  |----  | 
| Adv content  | iBeacon | TLM  | UID | URL  | T&H | 3-axis  |
| Adv interval(ms)  | 1000 | 2000  | 500 | 900  | 3000 | 600  |
| RSSI@0/m(dBm)  | -10 | -30  | -100 | -50  | -66 | -80  |
| Tx Power(dBm)  | -20 | -16  | -8 | -4  | 0 | 4  |
| Triggering conditions(Conditions to start broadcasting)  | Press button twice | Press button three times  | close | Temperature  | Humidity | Device moves  |

By meaning of the table, the No.0 slot will advertise iBeacon data, the No.1 slot will advertise TLM data, …, the No.5 slot will advertise 3-axis data. each of them have their own advertising interval, Txpower and Calibration RSSI. They are independent of each other.

PS: Calibration RSSI(RSSI@0/1m) is the RSSI when device @ 0/1m(iBeacon is 1, others 0).


#### How to get the slot advertisement data? please refer to the code example below.

* 1.Get each slot type in this way:

```
/**
 Reading current frame types of the 6 SLOTs,
 eg:@"001020506070":
 @[@"00",@"10",@"20",@"50",@"60",@"70"]
 
 @"00":UID,
 @"10":URL,
 @"20":TLM,
 @"40":Device Info,
 @"50":iBeacon,
 @"60":3-axis,
 @"70":H&T,
 @"FF":NO DATA

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readSlotDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;
```

* 2.Set the currently active slot as your target slot.

```
[MKBXPInterface bxp_configActiveSlot:slotIndex sucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```

* 3.When the current slot is non-NO DATA,you can get the slot broadcast data in this way:

```
[MKBXPInterface bxp_readAdvDataWithSucBlock:^(id  _Nonnull returnData) {
        //Refer to the table below for specific data.
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```



* UID 

```json
{
    "frameType":"00",        //slot type
    "rssi@0M":"-5",
    "namespaceId":"XXX",
    "instanceId":"XXXX"
}
```


* URL 

```json
{
    "frameType":"10",
    "advData":[NSData type],
    "rssi@0M":"-10",
}
```

* TLM

```json
{
    "frameType":"20",
    "version":"xxx",
    "mvPerbit":"1000",
    "temperature":"xxx",
    "advertiseCount":"12345",
    "deciSecondsSinceBoot":"123456789"
}
```

* Device info

```json
{
    "frameType":"40",
    "peripheralName":"BeaconX Pro",
}
```

* iBeacon

```json
{
    "frameType":"50",
    "major":"12",
    "minor":"23",
    "uuid":"11111111-1111-1111-111111-111111111111"
}
```

* 3-axis

```json
{
    "frameType":"60"
}
```

* H&T

```json
{
    "frameType":"70"
}
```

* NO DATA

```json
{
    "frameType":"ff"
}
```


#### Change slot data

The developer can modify advertisement and parameters of every slot freely via our APi.

* 1.Set the currently active slot as your target slot.

```
[MKBXPInterface bxp_configActiveSlot:slotIndex sucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```

* 2.Please refer to the code example below:

* UID


```
[MKBXPInterface bxp_configUIDAdvDataWithNameSpace: nameSpace instanceID:instanceID sucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```
    
    
* URL


```
    [MKBXPInterface bxp_configURLAdvData:mk_bxp_urlHeaderType1 urlContent:@"xxx"stringByAppendingString:@"xxx" sucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```


* TLM

```
    [MKBXPInterface bxp_configTLMAdvDataWithSucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```

* Device Info

```
    [MKBXPInterface bxp_configDeviceInfoAdvDataWithDeviceName:@"BeaconX Pro" sucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```

* iBeacon

```
    [MKBXPInterface bxp_configiBeaconAdvDataWithMajor:1 integerValue] minor:2 integerValue] uuid:@"xx" sucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```

* 3-axis

```
    [MKBXPInterface bxp_configThreeAxisAdvDataWithSucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```

* H&T

```
    [MKBXPInterface bxp_configHTAdvDataWithSucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```

* NO DATA

```
    [MKBXPInterface bxp_configNODATAAdvDataWithSucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```


#### Read the slot parameters.

* RSSI@0/m(dBm)

```
[MKBXPInterface bxp_readAdvTxPowerWithSucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```

* Tx Power

```
[MKBXPInterface bxp_readRadioTxPowerWithSucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```

* Advertisement interval

```
[MKBXPInterface bxp_readAdvIntervalWithSucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```

* Triggering conditions

```
[MKBXPInterface bxp_readTriggerConditionsWithSucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```

```json

Conditions

1.close(The Beacon will always broadcast.)
{
    "type":"00",
    "conditions":{}
}

2.Temperature
{
    "type":"01",
    "conditions":{
        "above":@(YES),        //YES:Above the temperature value，NO:Below the temperature value
        "temperature":"xxx",    //Trigger temperature
        "start":@(YES),        //YES:Start broadcasting，NO:Stop broadcasting
    }
}

3.Humidity
{
    "type":"02",
    "conditions":{
        "above":@(YES),        //YES:Above the humidity value，NO: Below the humidity value
        "humidity":"xxx",    //Trigger humidity
        "start":@(YES),        //YES:Start broadcasting，NO:Stop broadcasting
    }
}

3.Press button twice.
{
    "type":"03",
    "conditions":{
        "time":"xx",            //Continuous broadcast time.If the value is 0,it means always broadcasting (start=YES) or stop broadcasting (start=NO).
        "start":@(YES),        //YES:Start broadcasting，NO:Stop broadcasting
    }
}

4.Press button three times
{
    "type":"04",
    "conditions":{
        "time":"xx",            //Continuous broadcast time.If the value is 0,it means always broadcasting (start=YES) or stop broadcasting (start=NO).
        "start":@(YES),        //YES:Start broadcasting，NO:Stop broadcasting
    }
}

5.Device moves(It means start/stop broadcasting when static reaches this time, and start/stop broadcasting after moving.)
{
    "type":"05",
    "conditions":{
        "time":"xx",            //If it is 0, it means that the broadcast will continue after moving (start=YES)/stop the broadcast (start=NO)
        "start":@(YES),        //YES:Start broadcasting，NO:Stop broadcasting
    }
}

6.Light Sensor(Start/Stop advertising after ambient light continuously detected for time.)
{
    "type":"06",
    "conditions":{
        "time":"xx",            //If it is 0, Start and keep advertising(start=YES)/stop the broadcast (start=NO)
        "start":@(YES),        //YES:Start broadcasting，NO:Stop broadcasting
    }
}

```

#### Configure slot parameters

Becareful, the slot parameter has ranges:

* Advertisement interval: 100~10000 (ms)
* RSSI@0m: -100~0 (dBm)
* Tx Power:Radio txpower is not a range, it's grade, such as:  -40、-20、-16、-12、-8、-4、0、+3、+4 (dBm).
you can get all supported Radio Txpowers from mk*_*bxp_slotRadioTxPower.

**Start Configure Params.**

* Tx Power

```
typedef NS_ENUM(NSInteger, mk_bxp_slotRadioTxPower) {
    mk_bxp_slotRadioTxPowerNeg40dBm,   //-40dBm
    mk_bxp_slotRadioTxPowerNeg20dBm,   //-20dBm
    mk_bxp_slotRadioTxPowerNeg16dBm,   //-16dBm
    mk_bxp_slotRadioTxPowerNeg12dBm,   //-12dBm
    mk_bxp_slotRadioTxPowerNeg8dBm,    //-8dBm
    mk_bxp_slotRadioTxPowerNeg4dBm,    //-4dBm
    mk_bxp_slotRadioTxPower0dBm,       //0dBm
    mk_bxp_slotRadioTxPower3dBm,       //3dBm
    mk_bxp_slotRadioTxPower4dBm,       //4dBm 
};

mk_bxp_slotRadioTxPower power = mk_bxp_slotRadioTxPowerNeg40dBm;

[MKBXPInterface bxp_configRadioTxPower: power sucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];

```

* RSSI@0m

```
[MKBXPInterface bxp_configAdvTxPower:-55 sucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```

* Advertisement interval

```
[MKBXPInterface bxp_configAdvInterval:50 sucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
```

* Triggering conditions

```

1.close(The Beacon will always broadcast.)

[MKBXPInterface bxp_configTriggerConditionsNoneWithSucBlock:^(id  _Nonnull returnData) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failure
    }];
    
 2.Temperature
 
 /**
 Setting the current active SLOT temperature trigger condition

 @param above YES:Trigger when temperature is above temperature, NO: Trigger when temperature is lower than temperature
 @param temperature Triggered temperature condition, -20~90
 @param start YES: Start advertising, NO: stop advertising
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configTriggerConditionsWithTemperature:(BOOL)above
                                       temperature:(NSInteger)temperature
                                  startAdvertising:(BOOL)start
                                          sucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;
                                       
3.Humidity

/**
 Setting the current active SLOT humidity trigger condition

 @param above YES: Triggered when the temperature is above the humidity, NO: Triggered when the temperature is lower than the humidity
 @param humidity Triggered humidity condition, 0~100
 @param start YES: Start advertising, NO: stop advertising
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configTriggerConditionsWithHudimity:(BOOL)above
                                       humidity:(NSInteger)humidity
                               startAdvertising:(BOOL)start
                                       sucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;
                                    
4.Press button twice

/**
 Setting the current active SLOT double tap trigger condition

 @param time duration, unit s, 0~65535
 @param start YES: Start advertising, NO: stop advertising
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configTriggerConditionsWithDoubleTap:(NSInteger)time
                                           start:(BOOL)start
                                        sucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;
                                     
5.Press button three times

/**
 Setting the current active SLOT TripleTap trigger condition
 
 @param time duration, unit s, 0~65535
 @param start YES: Start advertising, NO: stop advertising
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configTriggerConditionsWithTripleTap:(NSInteger)time
                                           start:(BOOL)start
                                        sucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;
                                     

6.Device moves

/**
 Setting the current active SLOT move trigger condition
 
 @param time duration, unit s,0~65535
 @param start YES: Start advertising, NO: stop advertising
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configTriggerConditionsWithMoves:(NSInteger)time
                                       start:(BOOL)start
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;
                                 
                                 
                                 
7.Light Sensor
/// Setting the current active SLOT ambient light detected trigger condition
/// @param time duration, unit s,0~65535
/// @param start YES: Start advertising, NO: stop advertising
/// @param sucBlock success callback
/// @param failedBlock failed callback
+ (void)bxp_configTriggerConditionsWithAmbientLightDetected:(NSInteger)time
                                                      start:(BOOL)start
                                                   sucBlock:(void (^)(id returnData))sucBlock
                                                failedBlock:(void (^)(NSError *error))failedBlock;
                                 

```


#### Change global parameter

Global parameter of device is a device level feature, such as connectable, password require, reset to default and etc.

Please refer to the code example below.

```

/**
 Modifying connection password.Only if the device’s LockState is in UNLOCKED state, the password can be modified.
 
 @param newPassword New password, 16 characters
 @param originalPassword Old password, 16 characters
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configNewPassword:(NSString *)newPassword
             originalPassword:(NSString *)originalPassword
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Resetting to factory state (RESET).NOTE:When resetting the device, the connection password will not be restored which shall remain set to its current value.

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_factoryDataResetWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Setting lockState

 @param lockState MKBXPLockState
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configLockState:(mk_bxp_lockState)lockState
                   sucBlock:(void (^)(id returnData))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting device power off

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configPowerOffWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Setting device’s connection status.
 NOTE: Be careful to set device’s connection statue .Once the device is set to not connectable, it may not be connected, and other parameters cannot be configured.
 
 @param connectEnable YES：Connectable，NO：Not Connectable
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configConnectStatus:(BOOL)connectEnable
                       sucBlock:(void (^)(id returnData))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

```


## Notes

* In development progress, you may find there are multiple MKBXPBaseBeacon instance correspond to a physical device. On this point, we consulted Apple's engineers. they told us that currently on the iOS platform, CoreBluetooth framework unfriendly to the multiple slot devices(especially the advertisement data in changing). due to that sometimes app can't connect to the device, Google Eddystone solve this issue by press button on eddystone devices, our device support this operation too.
* In scanning stage, some properties may nil, especially MAC address(restriction of iOS),if current device advertise DeviceInfo frame, then you can get name, MAC address and battery.


# Change log

* 20211211 Added support for light sensing function;
* 20210316 first version;
