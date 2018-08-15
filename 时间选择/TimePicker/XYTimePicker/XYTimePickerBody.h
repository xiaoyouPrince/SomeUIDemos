//
//
//  XYTimePickerBody.h
//  TimePicker
//
//  Created by 渠晓友 on 2018/8/4.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYTime.h"
#import "XYBodyView.h"

@interface XYTimePickerBody : UIView

/**
 body中可选择的时间，即营业时间
 */
@property(nonatomic , strong) NSArray <XYTime* > *dataArray;

// 刷新数据
- (void)reloadData;

@end
