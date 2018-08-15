//
//
//  XYTimePickerConst.h
//  TimePicker
//
//  Created by 渠晓友 on 2018/8/4.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenW                 [[UIScreen mainScreen] bounds].size.width
#define ScreenH                 [[UIScreen mainScreen] bounds].size.height
#define AutoWidth(width)        ScreenW * (width) / 375.0              // 以屏幕宽高比来计算一个宽度对应的真实宽度
#define AutoHeight(height)      ScreenH * (height) / 667.0           // 以屏幕宽高比来计算一个高度对应的真实高度

#define iPhone4                 (ScreenH == 480)
#define iPhone5                 (ScreenH == 568)
#define iPhone6                 (ScreenH == 667)
#define iPhone6P                (ScreenH == 736)
#define iPhoneX                 (ScreenH == 812)
#define kNavHeight              (iPhoneX ? (88.f) : (64.f))     // statusBarH + TopBarH

#define SYSTEM_FONT_NAME        @"PingFangSC-Medium"
#define SYSTEM_FONT_SIZE(x)     [UIFont fontWithName:SYSTEM_FONT_NAME size:(x)]
#define DEFAULT_FONT_SIZE(x)    [UIFont systemFontOfSize:(x)]


// RGB颜色
#define XYColor(r, g, b)        [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define k159180Color            XYColor(159, 180, 180)
#define k104118118Color         XYColor(104, 118, 118)

// 常量
UIKIT_EXTERN NSString *const XYChooseTimeRefreshDate;
UIKIT_EXTERN NSString *const XYChooseTimeChooseTime;




@interface NSDate(XYAdd)

- (instancetype)dateByAddingDays:(NSInteger)days;
- (instancetype)dateByAddingHours:(NSInteger)hours;
- (NSString *)stringWithFormat:(NSString *)fmt;
- (NSInteger)weekday;
+ (NSString *)dayFromWeekday:(NSInteger)week;

@end
