//
//  XYQuestion.m
//  XYSuperGuessPic
//
//  Created by XiaoYou on 18/3/19.
//  Copyright (c) 2018年 XiaoYou. All rights reserved.
//

#import "XYQuestion.h"

@implementation XYQuestion

- (instancetype)initWithDict:(NSDictionary *)dict
{
    [self setValuesForKeysWithDictionary:dict];
    
    return self;
}

+ (instancetype)questionWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


@end
