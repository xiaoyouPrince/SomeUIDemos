//
//
//  XYBodyView.m
//  TimePicker
//
//  Created by 渠晓友 on 2018/8/4.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//

#import "XYBodyView.h"
@implementation XYBodyItem
@end

@interface XYBodyView ()

@property(nonatomic,weak) UILabel *timeLabel;   // 时间label
@property(nonatomic,weak) UIImageView *markIV;  // 对勾IV
@end

@implementation XYBodyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = UIColor.clearColor;
        [self setupContent];
    }
    return self;
}

- (void)setupContent{
    
    UILabel *timeLabel = [UILabel new];
    self.timeLabel = timeLabel;
    [self addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(self);
    }];
    
    self.timeLabel.backgroundColor = [UIColor whiteColor];
    self.timeLabel.font = DEFAULT_FONT_SIZE(14);
    self.timeLabel.textColor = k104118118Color;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *markIV = [UIImageView new];
    self.markIV = markIV;
    markIV.hidden = YES;
    markIV.image = [UIImage imageNamed:@"mark"];
    [self addSubview:markIV];
    
    [markIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(3);
        make.top.equalTo(self.mas_top).offset(-3);
        make.height.width.equalTo(@14);
    }];
    
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) { // 设置自己选中状态
        
        self.timeLabel.textColor = XYColor(63, 213, 211);
        self.timeLabel.layer.borderColor = XYColor(63, 213, 211).CGColor;
        self.timeLabel.layer.borderWidth = 1;
        self.markIV.hidden = NO;
        
    }else{ // 设置自己非选中状态
        
        self.timeLabel.textColor = k104118118Color;
        self.timeLabel.layer.borderWidth = 0;
        self.markIV.hidden = YES;
        
    }
}

- (void)setItem:(XYBodyItem *)item
{
    _item = item;
    
    self.timeLabel.text = item.timeStr;
}


- (void)setDefault
{
    _disable = NO;
    
    // 设置可用的样式
    self.timeLabel.backgroundColor = [UIColor whiteColor];
    self.timeLabel.textColor = k104118118Color;
    self.timeLabel.layer.borderWidth = 0;
    self.markIV.hidden = YES;
    
    self.enabled = YES;
}

- (void)setDisable
{
    _disable = YES;
    
    // 设置不可用的样式
    self.timeLabel.backgroundColor = XYColor(240, 240, 240);
    self.timeLabel.textColor = XYColor(208, 208, 208);
    self.timeLabel.layer.borderWidth = 0;
    self.markIV.hidden = YES;
    
    self.enabled = NO;
}



@end
