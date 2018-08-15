//
//
//  XYTimePicker.h
//  TimePicker
//
//  Created by 渠晓友 on 2018/8/4.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYTime.h"
#import "XYTimePickerConst.h"

@interface XYTimePicker : UIView

/** 快速创建方法 */
+ (instancetype)picker;

/** 营业时间数组-外界传入 */
@property(nonatomic , strong) NSArray  <XYTime *>*businessArray;

/** 用户选择的最终时间 */
@property(nonatomic , copy , readonly) NSString *choosenTime;

@end



