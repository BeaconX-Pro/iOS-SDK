#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MKBXPApplicationModule.h"
#import "MKBXPConnectManager.h"
#import "CTMediator+MKBXPAdd.h"
#import "MKBXPSlotDataAdopter.h"
#import "MKBXPEnumerateDefine.h"
#import "MKBXPAccelerationController.h"
#import "MKBXPAccelerationModel.h"
#import "MKBXPAccelerationHeaderView.h"
#import "MKBXPAccelerationParamsCell.h"
#import "MKBXPDeviceInfoController.h"
#import "MKBXPDeviceInfoModel.h"
#import "MKBXPExportDataController.h"
#import "MKBXPExportDataCurveView.h"
#import "MKBXPTHCurveView.h"
#import "MKBXPHTConfigController.h"
#import "MKBXPHTConfigModel.h"
#import "MKBXPStorageTriggerHTView.h"
#import "MKBXPStorageTriggerHumidityView.h"
#import "MKBXPStorageTriggerTempView.h"
#import "MKBXPStorageTriggerTimeView.h"
#import "MKBXPHTConfigHeaderView.h"
#import "MKBXPHTConfigNormalCell.h"
#import "MKBXPStorageTriggerCell.h"
#import "MKBXPSyncBeaconTimeCell.h"
#import "MKBXPScanViewController.h"
#import "MKBXPBaseBeacon+MKBXPAdd.h"
#import "MKBXPScanBeaconModel.h"
#import "MKBXPScanBeaconCell.h"
#import "MKBXPScanFilterView.h"
#import "MKBXPScanHTCell.h"
#import "MKBXPScanInfoCell.h"
#import "MKBXPScanSearchButton.h"
#import "MKBXPScanThreeASensorCell.h"
#import "MKBXPScanTLMCell.h"
#import "MKBXPScanUIDCell.h"
#import "MKBXPScanURLCell.h"
#import "MKBXPSettingController.h"
#import "MKBXPSettingModel.h"
#import "MKBXPSlotConfigController.h"
#import "MKBXPSlotConfigCellProtocol.h"
#import "MKBXPSlotConfigModel.h"
#import "MKBXPTriggerHumidityView.h"
#import "MKBXPTriggerTapView.h"
#import "MKBXPTriggerTemperatureView.h"
#import "MKBXPSlotConfigAdvParamsCell.h"
#import "MKBXPSlotConfigBeaconCell.h"
#import "MKBXPSlotConfigFrameTypeView.h"
#import "MKBXPSlotConfigInfoCell.h"
#import "MKBXPSlotConfigTriggerCell.h"
#import "MKBXPSlotConfigUIDCell.h"
#import "MKBXPSlotConfigURLCell.h"
#import "MKBXPSlotController.h"
#import "MKBXPSlotDataModel.h"
#import "MKBXPTabBarController.h"
#import "MKBXPUpdateController.h"
#import "MKBXPDFUModule.h"
#import "CBPeripheral+MKBXPAdd.h"
#import "MKBXPAdopter.h"
#import "MKBXPBaseBeacon.h"
#import "MKBXPCentralManager.h"
#import "MKBXPInterface+MKBXPConfig.h"
#import "MKBXPInterface.h"
#import "MKBXPOperation.h"
#import "MKBXPOperationID.h"
#import "MKBXPPeripheral.h"
#import "MKBXPSDK.h"
#import "MKBXPService.h"
#import "MKBXPTaskAdopter.h"
#import "Target_BXP_Module.h"
#import "MKBXPApplicationModule.h"
#import "CTMediator+MKBXPAdd.h"
#import "MKBXPConnectManager.h"
#import "MKBXPSlotDataAdopter.h"
#import "MKBXPEnumerateDefine.h"
#import "MKBXPAccelerationController.h"
#import "MKBXPAccelerationModel.h"
#import "MKBXPAccelerationHeaderView.h"
#import "MKBXPAccelerationParamsCell.h"
#import "MKBXPDeviceInfoController.h"
#import "MKBXPDeviceInfoModel.h"
#import "MKBXPExportDataController.h"
#import "MKBXPExportDataCurveView.h"
#import "MKBXPTHCurveView.h"
#import "MKBXPHTConfigController.h"
#import "MKBXPHTConfigModel.h"
#import "MKBXPStorageTriggerHTView.h"
#import "MKBXPStorageTriggerHumidityView.h"
#import "MKBXPStorageTriggerTempView.h"
#import "MKBXPStorageTriggerTimeView.h"
#import "MKBXPHTConfigHeaderView.h"
#import "MKBXPHTConfigNormalCell.h"
#import "MKBXPStorageTriggerCell.h"
#import "MKBXPSyncBeaconTimeCell.h"
#import "MKBXPScanViewController.h"
#import "MKBXPBaseBeacon+MKBXPAdd.h"
#import "MKBXPScanBeaconModel.h"
#import "MKBXPScanBeaconCell.h"
#import "MKBXPScanFilterView.h"
#import "MKBXPScanHTCell.h"
#import "MKBXPScanInfoCell.h"
#import "MKBXPScanSearchButton.h"
#import "MKBXPScanThreeASensorCell.h"
#import "MKBXPScanTLMCell.h"
#import "MKBXPScanUIDCell.h"
#import "MKBXPScanURLCell.h"
#import "MKBXPSettingController.h"
#import "MKBXPSettingModel.h"
#import "MKBXPSlotConfigController.h"
#import "MKBXPSlotConfigModel.h"
#import "MKBXPTriggerHumidityView.h"
#import "MKBXPTriggerTapView.h"
#import "MKBXPTriggerTemperatureView.h"
#import "MKBXPSlotConfigAdvParamsCell.h"
#import "MKBXPSlotConfigBeaconCell.h"
#import "MKBXPSlotConfigFrameTypeView.h"
#import "MKBXPSlotConfigInfoCell.h"
#import "MKBXPSlotConfigTriggerCell.h"
#import "MKBXPSlotConfigUIDCell.h"
#import "MKBXPSlotConfigURLCell.h"
#import "MKBXPSlotController.h"
#import "MKBXPSlotDataModel.h"
#import "MKBXPTabBarController.h"
#import "MKBXPUpdateController.h"
#import "MKBXPDFUModule.h"
#import "CBPeripheral+MKBXPAdd.h"
#import "MKBXPAdopter.h"
#import "MKBXPBaseBeacon.h"
#import "MKBXPCentralManager.h"
#import "MKBXPInterface+MKBXPConfig.h"
#import "MKBXPInterface.h"
#import "MKBXPOperation.h"
#import "MKBXPOperationID.h"
#import "MKBXPPeripheral.h"
#import "MKBXPSDK.h"
#import "MKBXPService.h"
#import "MKBXPTaskAdopter.h"
#import "Target_BXP_Module.h"

FOUNDATION_EXPORT double MKBeaconXPlusVersionNumber;
FOUNDATION_EXPORT const unsigned char MKBeaconXPlusVersionString[];

