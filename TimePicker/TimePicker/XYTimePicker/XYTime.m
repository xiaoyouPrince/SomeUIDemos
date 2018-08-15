//
//
//  XYTime.m
//  TimePicker
//
//  Created by 渠晓友 on 2018/8/13.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//

#import "XYTime.h"

@implementation XYTime
+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    [self setValuesForKeysWithDictionary:dict];
    return self;
}
@end
