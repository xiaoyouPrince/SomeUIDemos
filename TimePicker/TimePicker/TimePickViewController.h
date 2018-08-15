//
//
//  TimePickViewController.h
//  TimePicker
//
//  Created by 渠晓友 on 2018/8/4.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYTime;
typedef void(^ChooseTimeBlock)(XYTime *time);

@interface TimePickViewController : UIViewController
@property(nonatomic , strong) ChooseTimeBlock  chooseTimeBlock;

@end
