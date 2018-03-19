//
//  XYQuestion.h
//  XYSuperGuessPic
//
//  Created by XiaoYou on 18/3/19.
//  Copyright (c) 2018年 XiaoYou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYQuestion : NSObject

/**
 *  答案
 */
@property (nonatomic, copy) NSString *answer;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  图标
 */
@property (nonatomic, copy) NSString *icon;
/**
 *  待选项
 */
@property (nonatomic, strong) NSArray *options;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)questionWithDict:(NSDictionary *)dict;

@end
