//
//
//  XYTimePickerBody.m
//  TimePicker
//
//  Created by 渠晓友 on 2018/8/4.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//

#import "XYTimePickerBody.h"

@implementation XYTimePickerBody
{
    XYBodyView *_selectedBodyView; // 之前已选中的预约时间的View
    NSInteger _currentTimeInteger;  // 当前时间的 integer 值 e.g 19:03 -> 1903
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setupContent];
        self.tag = 1000;
    }
    return self;
}

- (void)setupContent{
    
    self.backgroundColor = [UIColor clearColor];
    
    // 接受修改日期的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChangedWeek:) name:XYChooseTimeRefreshDate object:nil];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userChangedWeek:(NSNotification *)noti
{
    // 接到通知，刷新数据，看是不是当天。。。是当天，就判断当前时间，有一些已经过了的时间不可选
    
    NSNumber *nunber = noti.object;
    if (nunber.boolValue) { // 当天为0，非当天为1
        // 非当天，全部可选
        NSLog(@"不是当天");
        
        // 直接刷新数据
        [self reloadData];
        
    }else{
        // 当天
        NSLog(@"是当天");
        
        // 拿到当前时间。。。
        NSDate *currentDate = [NSDate date];
        if (@available(ios 11.0, *)) {
            
        }else
        {
            currentDate = [currentDate dateByAddingHours:8];
        }
        NSString *dateStr = [currentDate stringWithFormat:@"HHmm"];
        NSInteger timeInteger = [dateStr integerValue];
        
        
        _currentTimeInteger = timeInteger;
        
        // 当前时间去刷新
        [self reloadDataWithCurrentTimeStr:timeInteger];
    }
}


- (void)setDataArray:(NSArray *)dataArray
{
    // 根据用户传进来的时间数据，来加载数据，自己根据当前时间来判断是否可以点击
    _dataArray = dataArray;
    
    // 第一次展示数据，默认显示的是当天。
    // 这里需要判断当前时间之前的时间的item不能点击。其他的可以点击
    // 以后的用户选择之后就要根据选择的weekDay 来判断并重新刷新数据了
    // 以后刷新会调用 reloadDataWithCurrentTimeStr 方法来处理
    
    
    // 基本属性
    
    NSInteger clum = 5;
    
    CGFloat margin = 12;
    CGFloat viewW = ( ScreenW - (clum + 1) * margin ) / clum;
    CGFloat viewH = viewW * 0.67;
    
    for( int i = 0 ; i < dataArray.count; i++ )
    {
        XYTime *time = dataArray[i];
        
        XYBodyView *bodyView = [[XYBodyView alloc] init];
        bodyView.tag = i;
        [self addSubview:bodyView];
        bodyView.backgroundColor = UIColor.redColor;
        
        [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).offset((i%clum) * (viewW + margin) + margin); 
            make.top.equalTo(self).offset((i/clum) * (viewH + margin) + 20);
            
            make.width.equalTo(@(viewW));
            make.height.equalTo(@(viewH));
        }];
        
        // 赋值
        XYBodyItem  *item = [XYBodyItem new];
        item.timeStr = time.reserveTime;
        bodyView.item = item;
        
        // 设置点击效果
        [bodyView addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)chooseTime:(UIView *)sender{
    // 被选中的item的index
    NSInteger index = sender.tag;
    
    // 1. 设置当前headerView的选中状态
    _selectedBodyView.selected = NO;
    XYBodyView *bodyView = (XYBodyView *)[self viewWithTag:index];
    if ([bodyView isKindOfClass:[XYBodyView class]]) {
        bodyView.selected = YES;
        _selectedBodyView = bodyView;
    }
    
    XYBodyItem *item = bodyView.item;
    [[NSNotificationCenter defaultCenter] postNotificationName:XYChooseTimeChooseTime object:item.timeStr];;
}


/**
 刷新数据
 */
- (void)reloadData
{
    // 这里必须根据，header 发送的消息来刷新
    
    for( int i = 0 ; i < self.dataArray.count; i++ )
    {
        
        XYBodyView *bodyView = nil;
        if (self.subviews.count) {
            bodyView = self.subviews[i];
        }
        
        if (bodyView.disable) {
            [bodyView setDefault];
        }
        if (bodyView.selected) {
            [bodyView setDefault];
        }
    }
}


- (void)reloadDataWithCurrentTimeStr:(NSInteger)currentStr
{
    // 这里根据选择日期之后的星期几，来重新刷新当前的可选时间列表
    // 说白了就是只要不是今天，就直接展示所有营业时间内的可选时间，
    // 如果是今天当天，要判断当前时间之前的时间点都不可选
    
    for( int i = 0 ; i < self.dataArray.count; i++ )
    {
        XYBodyView *bodyView = nil;
        if (self.subviews.count) {
            bodyView = self.subviews[i];
        }
        if (bodyView.disable) {
            [bodyView setDefault];
        }
        if (bodyView.selected) {
            [bodyView setDefault];
        }
        
        XYTime *time = self.dataArray[i];
        NSArray *timeStr = [time.reserveTime componentsSeparatedByString:@":"];
        NSInteger timeInteger = [[NSString stringWithFormat:@"%@%@",timeStr.firstObject,timeStr.lastObject] integerValue];
        // 当前时间
        if( timeInteger < currentStr){
            [bodyView setDisable];
        }
    }
}




@end
