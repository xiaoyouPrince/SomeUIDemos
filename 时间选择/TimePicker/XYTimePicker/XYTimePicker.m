//
//
//  XYTimePicker.m
//  TimePicker
//
//  Created by 渠晓友 on 2018/8/4.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//

#import "XYTimePicker.h"
#import "XYTimePickerHeader.h"
#import "XYTimePickerBody.h"

@interface XYTimePicker()

@property(nonatomic , strong) NSMutableArray  *weekDataArray; // 星期数据
@property(nonatomic , strong) NSMutableArray  *dateDataArray; // 日期数据

@property(nonatomic , strong) XYTimePickerHeader *headerView;
@property(nonatomic , strong) XYTimePickerBody *bodyView;

@end

@implementation XYTimePicker
{
    NSString *_choosenYMDStr; ///< 用户选择的日期 yyyy-MM-dd
}

+ (instancetype)picker
{
    return [[self alloc] initWithFrame:CGRectMake(0, kNavHeight, ScreenW, ScreenH - kNavHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.backgroundColor = UIColor.groupTableViewBackgroundColor;
        
        // setup content
        [self setuContent];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasChoosenDate:) name:XYChooseTimeRefreshDate object:nil]; // 选择日期通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasChoosenTime:) name:XYChooseTimeChooseTime object:nil];  // 选择时间通知
    }
    return self;
}

/**
 选择日期之后的通知-此通知肯定先于时间选择
 */
- (void)hasChoosenDate:(NSNotification *)noti{
    
    // 拿到是第几天。用户选择的日期
    NSInteger index = [noti.object integerValue];
    
    // 当期天数加上 index 天就是选择的日期
    // 拼接年月
    NSDate *currentDate = [NSDate date];
    NSDate *realDate = [currentDate dateByAddingDays:index];
    NSString *ymdStr = [realDate stringWithFormat:@"yyyy-MM-dd"];
    
    _choosenYMDStr = ymdStr;
    _choosenTime = nil;
    
}

- (void)hasChoosenTime:(NSNotification *)noti{
    
    // 时间点 09:00
    NSString *timeStr = noti.object;
    
    // 拼接年月日时间
    // yyyy-MM-dd HH:mm
    NSString *chooseTimeStr = [NSString stringWithFormat:@"%@ %@",_choosenYMDStr,timeStr];
    
    _choosenTime = chooseTimeStr;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setuContent{
    // header + body
    
    CGFloat headerH = AutoHeight(115);
    XYTimePickerHeader *header = [[XYTimePickerHeader alloc] initWithFrame:CGRectMake(0, 0, ScreenW, headerH)];
    self.headerView = header;
    [self addSubview:header];
    header.backgroundColor = [UIColor whiteColor];
    
    CGFloat bodyH = self.frame.size.height - headerH;
    XYTimePickerBody *body = [[XYTimePickerBody alloc] initWithFrame:CGRectMake(0, headerH, ScreenW, bodyH)];
    self.bodyView = body;
    [self addSubview:body];
}

- (void)setBusinessArray:(NSArray<XYTime *> *)businessArray
{
    // 拿到营业时间，初始化header的时间和body的所有时间
    if (businessArray.count == 0) {
        return;
    }
    
    _businessArray = businessArray;
    [self setupDataSource];
}

- (void)setupDataSource
{
    [self.weekDataArray removeAllObjects];
    
    // 初始化数据
    // 头部数据 weakData  ---  根据当前时间往后推7天
    // 底部数据 dateData  ---  根据用户传的营业时间显示对应个数的可选数据==需要注意对应的item的时间小于当前时间，就直接不可以用
    
    [self.weekDataArray removeAllObjects];
    
    NSDate *date = [NSDate date];
    NSUInteger count = 30;
    for (NSInteger i = 0; i < count; i++) {
        
        // 创建头部数据源
        XYHeaderItem *item = [XYHeaderItem new];
        
        NSDate *indeDate = [date dateByAddingDays:i];
        
        item.weekDay = [indeDate stringWithFormat:@"MM/dd"];
        item.dateTime = [indeDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
        item.day = [indeDate stringWithFormat:@"yyyy-MM-dd"];
        item.dateDay = [indeDate stringWithFormat:@"dd"];
        item.week = [[NSString stringWithFormat:@"%lu",(unsigned long)indeDate.weekday] integerValue];
        
        if (i==0) {
            item.week = [[NSString stringWithFormat:@"%d",8] integerValue];
        } else if (i==1) {
            item.week = [[NSString stringWithFormat:@"%d",9] integerValue];
        } else if (i==2) {
            item.week = [[NSString stringWithFormat:@"%d",10] integerValue];
        }
        
        item.dateStr = [NSString stringWithFormat:@"%@",[NSDate dayFromWeekday:item.week]];
        item.numStr = [NSString stringWithFormat:@"%@",item.dateDay];
        
        [self.weekDataArray addObject:item];
    }
    
    // 有数据了，上下同时刷新
    self.bodyView.dataArray = self.businessArray; // 自己从前面拿到的所有营业时间
    self.headerView.weeksArray = self.weekDataArray;
}

-(NSMutableArray *)dateDataArray
{
    if (!_dateDataArray) {
        _dateDataArray = [NSMutableArray array];
    }
    return _dateDataArray;
}
-(NSMutableArray *)weekDataArray
{
    if (!_weekDataArray) {
        _weekDataArray = [NSMutableArray array];
    }
    return _weekDataArray;
}




@end
