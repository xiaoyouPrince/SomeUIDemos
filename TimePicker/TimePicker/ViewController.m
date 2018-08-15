//
//
//  ViewController.m
//  TimePicker
//
//  Created by 渠晓友 on 2018/8/4.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//

#import "ViewController.h"
#import "XYTime.h"
#import "TimePickViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultTimeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    __weak typeof(self) weakSelf = self;
    ViewController *source = (ViewController *)segue.sourceViewController;
    TimePickViewController *picker = (TimePickViewController *)segue.destinationViewController;
    picker.chooseTimeBlock = ^(XYTime *time) {
        weakSelf.resultTimeLabel.text = time.resultTimeStr;
    };
    
//    [source.navigationController pushViewController:picker animated:YES];
}


@end
