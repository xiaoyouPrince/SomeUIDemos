//
//
//  XYTimePickerHeader.m
//  TimePicker
//
//  Created by 渠晓友 on 2018/8/4.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//

#import "XYTimePickerHeader.h"


@interface XYTimePickerHeader()
@property(nonatomic,weak) UILabel *yearLabel;
@property(nonatomic,weak) UIScrollView *scrollView;
@end

@implementation XYTimePickerHeader
{
    XYHeaderView *_selectedHeaderView; // 之前已选中的日期
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupContent];
    }
    return self;
}

- (void)setupContent{
    
    // 当前时间的 年月
    NSDate *currentDate = [NSDate date];
    
    UILabel *yearLabel = [UILabel new];
    yearLabel.text = [currentDate stringWithFormat:@"yyyy年MM月"];
    self.yearLabel = yearLabel;
    [self addSubview:yearLabel];
    
    [yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(AutoHeight(16));
        make.right.equalTo(self);
        make.height.equalTo(@(AutoHeight(21)));
    }];
    self.yearLabel.backgroundColor = [UIColor clearColor];
    self.yearLabel.font = SYSTEM_FONT_SIZE(15);
    self.yearLabel.textColor = k159180Color;
    self.yearLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UIScrollView *scrollView = [UIScrollView new];
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.top.equalTo(yearLabel.mas_bottom);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.tag = 1000; // 这里防止之后取值有误，1000这个数字无意义
}

- (void)setWeeksArray:(NSArray *)weeksArray
{
    _weeksArray = weeksArray;
    self.scrollView.contentSize = CGSizeMake(ScreenW / 7 * weeksArray.count, 0);
    
    // 根据数组来展示自己内部的item
    // 7 个日期
    for (int i = 0; i < weeksArray.count; i++) {
        XYHeaderView *headerView = [[XYHeaderView alloc] init];
        headerView.tag = i;
        [self.scrollView addSubview:headerView];
        
        if (@available(ios 11.0, *)) {
            [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.scrollView).offset(i * ScreenW / 7);
                make.top.equalTo(self.scrollView);
                
                make.width.equalTo(@(ScreenW / 7));
                make.height.equalTo(self.scrollView);
            }];
            
        }else
        {   // iPhone 6 Plus iOS 10 上面发现的问题
            headerView.frame = CGRectMake((i * ScreenW / 7), 0, ScreenW / 7, self.scrollView.bounds.size.height);
        }
        
        
        // 赋值
        headerView.item = weeksArray[i];
        
        // 设置点击事件
        [headerView addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) { // 默认第一个选中
            [self chooseDate:headerView];
        }
    }
}

- (void)chooseDate:(UIView *)sender{
    
    // 被选中的item的index
    NSInteger index = sender.tag;
    
    // 1. 设置当前headerView的选中状态
    _selectedHeaderView.selected = NO;
    XYHeaderView *headerView = (XYHeaderView *)[self.scrollView viewWithTag:index];
    if ([headerView isKindOfClass:[XYHeaderView class]]) {
        headerView.selected = YES;
        _selectedHeaderView = headerView;
    }
    
    
    // 对外发消息需要刷新body数据
    [[NSNotificationCenter defaultCenter] postNotificationName:XYChooseTimeRefreshDate object:[NSNumber numberWithInteger:index]];
}


@end
