//
//
//  XYTimePickerHeader.h
//  TimePicker
//
//  Created by 渠晓友 on 2018/8/4.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYHeaderView.h"

@interface XYTimePickerHeader : UIView

/// 外部传递的数组，header要展示的HeaderItem
@property(nonatomic , strong) NSArray  *weeksArray;

@end
