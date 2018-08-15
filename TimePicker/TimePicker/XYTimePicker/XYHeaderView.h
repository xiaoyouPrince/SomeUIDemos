//
//
//  XYHeaderView.h
//  TimePicker
//
//  Created by 渠晓友 on 2018/8/4.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//

#import "XYTimePickerComponent.h"

@interface XYHeaderItem : NSObject

@property(nonatomic , copy) NSString *dateStr;      ///< 日期 周几
@property(nonatomic , copy) NSString *numStr;       ///< 编号 1-7

@property(nonatomic , copy) NSString *weekDay;      ///< MM/dd
@property(nonatomic , copy) NSString *dateTime;     ///< yyyy-MM-dd HH:mm
@property(nonatomic , copy) NSString *day;          ///< yyyy-MM-dd
@property(nonatomic , copy) NSString *dateDay;      ///< dd
@property(nonatomic , assign) NSInteger week;       ///< 一周中的第几天

@property(nonatomic , strong) NSDate  *date;        ///< date 源

@end

@interface XYHeaderView : XYTimePickerComponent

@property(nonatomic , strong) XYHeaderItem  *item;

@end
