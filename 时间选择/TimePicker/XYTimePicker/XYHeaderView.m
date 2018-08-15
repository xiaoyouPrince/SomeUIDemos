//
//
//  XYHeaderView.m
//  TimePicker
//
//  Created by 渠晓友 on 2018/8/4.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//

#import "XYHeaderView.h"

@implementation XYHeaderItem
@end


@interface XYHeaderView ()
@property(nonatomic,weak) UILabel *dateLabel; // 星期
@property(nonatomic,weak) UILabel *numLabel;  // 日期
@end

@implementation XYHeaderView

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
    
    UILabel *dateLabel = [UILabel new];
    //dateLabel.text = @"今天";
    self.dateLabel = dateLabel;
    [self addSubview:dateLabel];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(self).multipliedBy(0.5);
    }];
    
    self.dateLabel.backgroundColor = [UIColor clearColor];
    self.dateLabel.font = DEFAULT_FONT_SIZE(12);
    self.dateLabel.textColor = k159180Color;
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *numLabel = [UILabel new];
    //numLabel.text = @"2018年8月";
    self.numLabel = numLabel;
    [self addSubview:numLabel];
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).multipliedBy(1.3);
        make.height.width.equalTo(@30);
    }];
    self.numLabel.backgroundColor = [UIColor clearColor];
    self.numLabel.font = SYSTEM_FONT_SIZE(17);
    self.numLabel.textColor = k104118118Color;
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
        
    if (selected) { // 设置自己选中状态
        
        self.numLabel.backgroundColor = XYColor(63, 213, 211);
        self.numLabel.textColor = [UIColor whiteColor];
        self.numLabel.layer.cornerRadius = 15;
        self.numLabel.clipsToBounds = YES;
        
    }else{ // 设置自己非选中状态
        
        self.numLabel.backgroundColor = [UIColor clearColor];
        self.numLabel.textColor = k104118118Color;
        
    }
    
}

- (void)setItem:(XYHeaderItem *)item
{
    _item = item;
    
    self.dateLabel.text = item.dateStr;
    self.numLabel.text = item.numStr;
}

@end
