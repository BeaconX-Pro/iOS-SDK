//
//  MKBXPScanUIDCell.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/23.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@class MKBXPUIDBeacon;
@interface MKBXPScanUIDCell : MKBaseCell

@property (nonatomic, strong)MKBXPUIDBeacon *beacon;

+ (MKBXPScanUIDCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
