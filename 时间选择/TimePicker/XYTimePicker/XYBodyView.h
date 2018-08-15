//
//
//  XYBodyView.h
//  TimePicker
//
//  Created by 渠晓友 on 2018/8/4.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//

#import "XYTimePickerComponent.h"

@interface XYBodyItem : NSObject

@property(nonatomic , copy) NSString *timeStr;  /// 预约时间点
@property(nonatomic , copy) NSString *numStr;   /// 最大人数，之类的都不写了现在
@property(nonatomic , strong) NSDate  *date;

@end

@interface XYBodyView : XYTimePickerComponent

@property(nonatomic , assign , readonly) BOOL disable;
@property(nonatomic , strong) XYBodyItem  *item;

- (void)setDefault;
- (void)setDisable;

@end
