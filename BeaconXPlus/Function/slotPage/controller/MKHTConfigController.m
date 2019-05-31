//
//  MKHTConfigController.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/30.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKHTConfigController.h"
#import "MKBaseTableView.h"
#import "MKSlotLineHeader.h"
#import "MKHTDataCell.h"
#import "MKHTParamsConfigCell.h"
#import "MKHTDateTimeCell.h"
#import "MKExportHTDataCell.h"

@interface MKHTDateModel : NSObject<MKBXPDeviceTimeProtocol>

@property (nonatomic, assign)NSInteger year;

@property (nonatomic, assign)NSInteger month;

@property (nonatomic, assign)NSInteger day;

@property (nonatomic, assign)NSInteger hour;

@property (nonatomic, assign)NSInteger minutes;

@property (nonatomic, assign)NSInteger seconds;

@end

@implementation MKHTDateModel

@end

@interface MKHTConfigController ()<UITableViewDelegate, UITableViewDataSource, MKHTDateTimeCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKHTConfigController

- (void)dealloc {
    NSLog(@"MKHTConfigController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[MKBXPCentralManager shared] notifyTHData:YES];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[MKBXPCentralManager shared] notifyTHData:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveHTData:)
                                                 name:MKBXPReceiveHTDataNotification
                                               object:nil];
    [self loadCells];
    [self readParamsFromDevice];
    // Do any additional setup after loading the view.
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self configParams];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150.f;
    }
    if (indexPath.section == 1) {
        return 170.f;
    }
    if (indexPath.section == 2) {
        return 80.f;
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MKSlotLineHeader *header = [MKSlotLineHeader initHeaderViewWithTableView:tableView];
    return header;
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataList[indexPath.section];
}

#pragma mark - MKHTDateTimeCellDelegate
- (void)bxpUpdateDeviceTime {
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    dispatch_async(self.configQueue, ^{
        BOOL success = [self setDeviceTime];
        if (!success) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Set the current time failure equipment"];
            });
            return ;
        }
        NSString *deviceTime = [self readDeviceTime];
        if (!ValidStr(deviceTime)) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Reading equipment current time failed"];
            });
            return;
        }
        moko_dispatch_main_safe((^{
            [[MKHudManager share] hide];
            MKHTDateTimeCell *timeCell = self.dataList[2];
            if ([timeCell isKindOfClass:NSClassFromString(@"MKHTDateTimeCell")]) {
                NSArray *dateList = [deviceTime componentsSeparatedByString:@"-"];
                timeCell.timeLabel.text = [NSString stringWithFormat:@"%@/%@/%@   %@:%@:%@",dateList[0],dateList[1],dateList[2],dateList[3],dateList[4],dateList[5]];
            }
        }));
    });
    
}

#pragma mark - note
- (void)receiveHTData:(NSNotification *)note {
    MKHTDataCell *cell = self.dataList[0];
    if (![cell isKindOfClass:NSClassFromString(@"MKHTDataCell")]) {
        return;
    }
    cell.dataDic = note.userInfo;
}

#pragma mark - interface
- (void)readParamsFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    dispatch_async(self.configQueue, ^{
        NSString *samplingRate = [self readSamplingRate];
        NSDictionary *storageConditions = [self readHTStorageConditions];
        NSString *deviceTime = [self readDeviceTime];
        moko_dispatch_main_safe((^{
            [[MKHudManager share] hide];
            if (!ValidStr(samplingRate)) {
                [self.view showCentralToast:@"Read the temperature and humidity sampling rate errors"];
                return ;
            }
            if (!ValidDict(storageConditions)) {
                [self.view showCentralToast:@"Error reading the temperature and humidity storage conditions"];
                return;
            }
            if (!ValidStr(deviceTime)) {
                [self.view showCentralToast:@"Reading equipment current time failed"];
                return;
            }
            MKHTDataCell *cell = self.dataList[0];
            if ([cell isKindOfClass:NSClassFromString(@"MKHTDataCell")]) {
                cell.textField.text = samplingRate;
            }
            MKHTParamsConfigCell *paramsCell = self.dataList[1];
            if ([paramsCell isKindOfClass:NSClassFromString(@"MKHTParamsConfigCell")]) {
                [paramsCell setDataDic:storageConditions];
            }
            MKHTDateTimeCell *timeCell = self.dataList[2];
            if ([timeCell isKindOfClass:NSClassFromString(@"MKHTDateTimeCell")]) {
                NSArray *dateList = [deviceTime componentsSeparatedByString:@"-"];
                timeCell.timeLabel.text = [NSString stringWithFormat:@"%@/%@/%@   %@:%@:%@",dateList[0],dateList[1],dateList[2],dateList[3],dateList[4],dateList[5]];
            }
        }));
    });
}

- (void)configParams {
    MKSlotBaseCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (cell == nil || ![cell isKindOfClass:NSClassFromString(@"MKAxisParametersCell")]) {
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    NSDictionary *dic = [cell getContentData];
    [MKBXPInterface setBXPThreeAxisDataParams:[dic[@"result"][@"dataRate"] integerValue] acceleration:[dic[@"result"][@"scale"] integerValue] sensitivity:[dic[@"result"][@"sensitivity"] integerValue] sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (NSString *)readSamplingRate {
    __block NSString *samplingRate = @"";
    [MKBXPInterface readBXPHTSamplingRateWithSuccessBlock:^(id  _Nonnull returnData) {
        samplingRate = returnData[@"result"][@"samplingRate"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return samplingRate;
}

- (NSDictionary *)readHTStorageConditions {
    __block NSDictionary *dataDic = @{};
    [MKBXPInterface readBXPHTStorageConditionsWithSuccessBlock:^(id  _Nonnull returnData) {
        dataDic = returnData[@"result"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return dataDic;
}

- (NSString *)readDeviceTime {
    __block NSString *deviceTime = @"";
    [MKBXPInterface readBXPDeviceTimeWithSuccessBlock:^(id  _Nonnull returnData) {
        deviceTime = returnData[@"result"][@"deviceTime"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return deviceTime;
}

- (BOOL)setDeviceTime {
    __block BOOL success = NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *toTimeZone = [NSTimeZone localTimeZone];
    //转换后源日期与世界标准时间的偏移量
    NSInteger toGMTOffset = [toTimeZone secondsFromGMTForDate:[NSDate date]];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:toGMTOffset];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    NSArray *dateList = [date componentsSeparatedByString:@"-"];
    MKHTDateModel *dateModel = [[MKHTDateModel alloc] init];
    dateModel.year = [dateList[0] integerValue];
    dateModel.month = [dateList[1] integerValue];
    dateModel.day = [dateList[2] integerValue];
    dateModel.hour = [dateList[3] integerValue];
    dateModel.minutes = [dateList[4] integerValue];
    dateModel.seconds = [dateList[5] integerValue];
    [MKBXPInterface setBXPDeviceTime:dateModel sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method

- (void)loadCells {
    MKHTDataCell *htCell = [MKHTDataCell initCellWithTableView:self.tableView];
    [self.dataList addObject:htCell];
    MKHTParamsConfigCell *paramsCell = [MKHTParamsConfigCell initCellWithTableView:self.tableView];
    [self.dataList addObject:paramsCell];
    MKHTDateTimeCell *dateCell = [MKHTDateTimeCell initCellWithTableView:self.tableView];
    dateCell.delegate = self;
    [self.dataList addObject:dateCell];
    MKExportHTDataCell *exportCell = [MKExportHTDataCell initCellWithTableView:self.tableView];
    [self.dataList addObject:exportCell];
    [self.tableView reloadData];
}

- (void)loadSubViews {
    self.defaultTitle = @"H&T";
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    self.custom_naviBarColor = UIColorFromRGB(0x2F84D0);
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];
    [self.rightButton setImage:LOADIMAGE(@"slotSaveIcon", @"png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(defaultTopInset + 5.f);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - setter & getter
-(MKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)configQueue {
    if (!_configQueue) {
        _configQueue = dispatch_queue_create("HTConfigParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _configQueue;
}

@end
