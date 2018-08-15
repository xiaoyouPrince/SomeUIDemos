//
//
//  XYTime.h
//  TimePicker
//
//  Created by 渠晓友 on 2018/8/13.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYTime : NSObject

//{
//    "reserveTime": "09:00",
//    "maxCount": "3",
//    "count": 0
//}
@property (nonatomic,copy) NSString *reserveTime;  ///< 可预约时间
@property (nonatomic,copy) NSString *maxCount;     ///< 可预约最大数量
@property (nonatomic,copy) NSString *count;        ///< 已预约数量

///< 用户最终选择的时间 egg: 2018-8-3 19:00
@property (nonatomic,copy) NSString *resultTimeStr;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
