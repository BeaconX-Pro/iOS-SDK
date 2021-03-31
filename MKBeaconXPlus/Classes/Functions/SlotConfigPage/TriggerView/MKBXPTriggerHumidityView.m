//
//  MKBXPTriggerHumidityView.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/26.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPTriggerHumidityView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKSlider.h"
#import "MKCustomUIAdopter.h"

@implementation MKBXPTriggerHumidityViewModel
@end

@interface MKBXPTriggerHumidityView ()

@property (nonatomic, strong)UILabel *msgLabe;

@property (nonatomic, strong)MKSlider *humiditySlider;

@property (nonatomic, strong)UILabel *sliderValueLabel;

@property (nonatomic, strong)UIImageView *startIcon;

@property (nonatomic, strong)UILabel *startLabel;

@property (nonatomic, strong)UIImageView *stopIcon;

@property (nonatomic, strong)UILabel *stopLabel;

@property (nonatomic, strong)UILabel *noteMsgLabel;

@property (nonatomic, assign)BOOL start;

@end

@implementation MKBXPTriggerHumidityView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.msgLabe];
        [self addSubview:self.humiditySlider];
        [self addSubview:self.sliderValueLabel];
        [self addSubview:self.startIcon];
        [self addSubview:self.startLabel];
        [self addSubview:self.stopIcon];
        [self addSubview:self.stopLabel];
        [self addSubview:self.noteMsgLabel];
    }
    return self;
}

#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.humiditySlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.sliderValueLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.msgLabe.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.sliderValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(50.f);
        make.centerY.mas_equalTo(self.humiditySlider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.startIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(10.f);
        make.centerY.mas_equalTo(self.startLabel.mas_centerY);
        make.height.mas_equalTo(10.f);
    }];
    [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.startIcon.mas_right).mas_offset(2.f);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.humiditySlider.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.stopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(10.f);
        make.centerY.mas_equalTo(self.stopLabel.mas_centerY);
        make.height.mas_equalTo(10.f);
    }];
    [self.stopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stopIcon.mas_right).mas_offset(2.f);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.startLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.noteMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-10.f);
        make.top.mas_equalTo(self.stopLabel.mas_bottom).mas_offset(5.f);
    }];
}

#pragma mark - event method
- (void)sliderValueChanged {
    NSString *value = [NSString stringWithFormat:@"%.f",self.humiditySlider.value];
    self.sliderValueLabel.text = [value stringByAppendingString:@"%"];
    [self updateNoteMsg];
    if ([self.delegate respondsToSelector:@selector(bxp_triggerHumidityThresholdValueChanged:)]) {
        [self.delegate bxp_triggerHumidityThresholdValueChanged:[value floatValue]];
    }
}

- (void)startLabelPressed {
    if (self.start) {
        return;
    }
    self.start = YES;
    [self updateNoteMsg];
    [self updateSlectedIcon];
    if ([self.delegate respondsToSelector:@selector(bxp_triggerHumidityStartStatusChanged:)]) {
        [self.delegate bxp_triggerHumidityStartStatusChanged:YES];
    }
}

- (void)stopLabelPressed {
    if (!self.start) {
        return;
    }
    self.start = NO;
    [self updateNoteMsg];
    [self updateSlectedIcon];
    if ([self.delegate respondsToSelector:@selector(bxp_triggerHumidityStartStatusChanged:)]) {
        [self.delegate bxp_triggerHumidityStartStatusChanged:NO];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXPTriggerHumidityViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.start = _dataModel.start;
    NSString *value = [NSString stringWithFormat:@"%.f",_dataModel.sliderValue];
    self.sliderValueLabel.text = [value stringByAppendingString:@"%"];
    self.humiditySlider.value = _dataModel.sliderValue;
    [self updateNoteMsg];
    [self updateSlectedIcon];
}

#pragma mark - private method

- (void)updateNoteMsg {
    NSString *msg = [NSString stringWithFormat:@"*The Beacon will %@ when the humidity is %@ %@",(self.start ? @"start to broadcast" : @"stop broadcasting"),(self.dataModel.above ? @"above" : @"below"),self.sliderValueLabel.text];
    self.noteMsgLabel.text = msg;
}

- (void)updateSlectedIcon {
    self.startIcon.image = (self.start ? LOADICON(@"MKBeaconXPlus", @"MKBXPTriggerHumidityView", @"bxp_slot_paramsConfig_selectedIcon.png") : LOADICON(@"MKBeaconXPlus", @"MKBXPTriggerHumidityView", @"bxp_slot_paramsConfig_unselectedIcon.png"));
    self.stopIcon.image = (self.start ? LOADICON(@"MKBeaconXPlus", @"MKBXPTriggerHumidityView", @"bxp_slot_paramsConfig_unselectedIcon.png") : LOADICON(@"MKBeaconXPlus", @"MKBXPTriggerHumidityView", @"bxp_slot_paramsConfig_selectedIcon.png"));
}

#pragma mark - setter & getter
- (UILabel *)msgLabe {
    if (!_msgLabe) {
        _msgLabe = [[UILabel alloc] init];
        _msgLabe.textColor = DEFAULT_TEXT_COLOR;
        _msgLabe.textAlignment = NSTextAlignmentLeft;
        _msgLabe.attributedText = [MKCustomUIAdopter attributedString:@[@"Humidity threshold",@"   (0%~95%)"] fonts:@[MKFont(13.f),MKFont(11.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _msgLabe;
}

- (MKSlider *)humiditySlider {
    if (!_humiditySlider) {
        _humiditySlider = [[MKSlider alloc] init];
        _humiditySlider.maximumValue = 95;
        _humiditySlider.minimumValue = 0;
        _humiditySlider.value = 0;
        [_humiditySlider addTarget:self
                            action:@selector(sliderValueChanged)
                  forControlEvents:UIControlEventValueChanged];
    }
    return _humiditySlider;
}

- (UILabel *)sliderValueLabel {
    if (!_sliderValueLabel) {
        _sliderValueLabel = [self createMsgLabel:MKFont(12.f)];
        _sliderValueLabel.text = @"0%";
    }
    return _sliderValueLabel;
}

- (UIImageView *)startIcon {
    if (!_startIcon) {
        _startIcon = [[UIImageView alloc] init];
        _startIcon.image = LOADICON(@"MKBeaconXPlus", @"MKBXPTriggerHumidityView", @"bxp_slot_paramsConfig_selectedIcon.png");
    }
    return _startIcon;
}

- (UILabel *)startLabel {
    if (!_startLabel) {
        _startLabel = [self createMsgLabel:MKFont(11.f)];
        _startLabel.text = @"Start advertising";
        [_startLabel addTapAction:self selector:@selector(startLabelPressed)];
    }
    return _startLabel;
}

- (UIImageView *)stopIcon {
    if (!_stopIcon) {
        _stopIcon = [[UIImageView alloc] init];
        _stopIcon.image = LOADICON(@"MKBeaconXPlus", @"MKBXPTriggerHumidityView", @"bxp_slot_paramsConfig_unselectedIcon.png");
    }
    return _stopIcon;
}

- (UILabel *)stopLabel {
    if (!_stopLabel) {
        _stopLabel = [self createMsgLabel:MKFont(11.f)];
        _stopLabel.text = @"Stop advertising";
        [_stopLabel addTapAction:self selector:@selector(stopLabelPressed)];
    }
    return _stopLabel;
}

- (UILabel *)noteMsgLabel {
    if (!_noteMsgLabel) {
        _noteMsgLabel = [[UILabel alloc] init];
        _noteMsgLabel.textColor = RGBCOLOR(229, 173, 140);
        _noteMsgLabel.textAlignment = NSTextAlignmentLeft;
        _noteMsgLabel.numberOfLines = 0;
        _noteMsgLabel.font = MKFont(11.f);
    }
    return _noteMsgLabel;
}

- (UILabel *)createMsgLabel:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = DEFAULT_TEXT_COLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    return label;
}

@end
