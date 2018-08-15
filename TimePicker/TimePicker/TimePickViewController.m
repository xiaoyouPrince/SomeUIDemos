//
//
//  TimePickViewController.m
//  TimePicker
//
//  Created by 渠晓友 on 2018/8/4.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//

#import "TimePickViewController.h"
#import "XYTimePicker.h"

@interface TimePickViewController ()
@property(nonatomic , strong) XYTimePicker *picker;
@property(nonatomic , strong) NSArray  *dataArray;
@end

@implementation TimePickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选取时间";
    // right Btn
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(0, 0, 50, 40);
    [btn setTitleColor:k104118118Color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    // 创建picker
    XYTimePicker *picker = [XYTimePicker picker];
    self.picker = picker;
    [self.view addSubview:picker];
    
    // 数据:模拟耗时
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
        NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:path];
        self.dataArray = data[@"businessTime"];
        
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dict in self.dataArray) {
            XYTime *time = [XYTime modelWithDict:dict];
            [arrayM addObject:time];
        }
        self.dataArray = [arrayM copy];
        
        self.picker.businessArray = self.dataArray;
    });
    
    // 添加页面并刷新时间
}

- (void)doneBtnClick{
    
    // 判断是否选择了时间
    NSString *choosenTime = self.picker.choosenTime;
    if (!choosenTime.length) {
        // 要退出了
        UIAlertController *av = [UIAlertController alertControllerWithTitle:@"提示"
                                                                    message:@"尚未选择时间"
                                                             preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDestructive
                                                       handler:nil];
        [av addAction:action];
        [self presentViewController:av animated:YES completion:nil];

        return;
    }
    
    
    // 已经选择了时间，回调并退出
    if (self.chooseTimeBlock) {
        XYTime *time = [XYTime new];
        time.resultTimeStr = choosenTime;
        self.chooseTimeBlock(time);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
