//
//  代码地址：https://github.com/xiaoyouPrince/SomeUIDemos
//  Blog地址：http://xiaoyouPrince.com/
//
//  ViewController.swift
//  XYSuperGuessPic
//
//  Created by 渠晓友 on 2018/3/17.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height


#import "ViewController.h"
#import "XYQuestion.h"

@interface ViewController ()

/**  一些属性  */

/** 得分按钮 */
@property (weak, nonatomic) IBOutlet UIButton *scoreBtn;

/** 存放正确答案按钮的view */
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *optionView;



/** 序号 */
@property (weak, nonatomic) IBOutlet UILabel *noLabel;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 头像(图标) */
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

/** 下一题按钮 */
@property (weak, nonatomic) IBOutlet UIButton *nextQuestionBtn;

/** 遮盖 */
@property (nonatomic, weak) UIButton *cover;

/** 所有的题目 */
@property (nonatomic, strong) NSArray *questions;

/** 当前是第几题(当前题目的序号) */
@property (nonatomic, assign) int index;

// constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconCenterYCons;


/**  按钮点击方法   */
- (IBAction)tip;
- (IBAction)bigImg;
- (IBAction)help;
- (IBAction)nextQuestion;
- (IBAction)iconClick;

@end

@implementation ViewController

/**
 *  懒加载数据源
 */
- (NSArray *)questions
{
    if (_questions == nil) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            XYQuestion *question = [XYQuestion questionWithDict:dict];
            [arrayM addObject:question];
        }
        
        _questions = arrayM;
    }
    return _questions;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}



- (IBAction)tip;
{
    
}
- (IBAction)bigImg
{
    // 查看大图，创建cover，覆盖动画
    UIButton *cover = [[UIButton alloc] initWithFrame:self.view.bounds];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.0;
    [cover addTarget:self action:@selector(smallImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cover];
    self.cover = cover;
    
    // icon 放到顶部
    [self.view bringSubviewToFront:self.iconBtn];
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        
        //cover 透明度
        self.cover.alpha = 0.7;
        
        self.iconWidthCons.constant = ScreenW;
        self.iconCenterYCons.constant = 0;
        
    }];
    
    
    
}

- (void)smallImage{
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        
        //cover 透明度
        self.cover.alpha = 0.0;
        
        self.iconWidthCons.constant = 150;
        self.iconCenterYCons.constant = 84.5;
        
        
    } completion:^(BOOL finished) {
        
        [self.cover removeFromSuperview];
        self.cover = nil;
    }];
    
}
- (IBAction)help
{
    
}
- (IBAction)nextQuestion
{
    
}
- (IBAction)iconClick{
    
    // 根据当前icon大小查看大小图
    if (self.cover) {
        [self smallImage];
    }else {
        [self bigImg];
    }
    
}




@end
