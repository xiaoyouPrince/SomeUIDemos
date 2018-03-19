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
    
    self.index = -1;
    [self nextQuestion];
    
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
    self.index ++;
    
    XYQuestion *question = (XYQuestion *)self.questions[self.index];
    
    [self settingData:question];
    
    [self addAnswerBtn:question];
    
    [self addOptionBtn:question];
}
- (IBAction)iconClick{
    
    // 根据当前icon大小查看大小图
    if (self.cover) {
        [self smallImage];
    }else {
        [self bigImg];
    }
    
}

/**
 *  设置控件的数据
 */
- (void)settingData:(XYQuestion *)question
{
    // 3.1.设置序号
    self.noLabel.text = [NSString stringWithFormat:@"%d/%zd", self.index + 1, self.questions.count];
    
    // 3.2.设置标题
    self.titleLabel.text = question.title;
    
    // 3.3.设置图片
    [self.iconBtn setImage:[UIImage imageNamed:question.icon] forState:UIControlStateNormal];
    
    // 3.4.设置下一题按钮的状态
    self.nextQuestionBtn.enabled = self.index != (self.questions.count - 1);
}

/**
 *  添加待选项
 */
- (void)addOptionBtn:(XYQuestion *)question
{
    // 6.1.删掉之前的所有按钮
    [self.optionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //    for (UIView *subview in self.optionView.subviews) {
    //        [subview removeFromSuperview];
    //    }
    
    // 6.2.添加新的待选按钮
    NSUInteger count = question.options.count;
    for (int i = 0; i<count; i++) {
        // 6.2.1.创建按钮
        UIButton *optionBtn = [[UIButton alloc] init];
        
        // 6.2.2.设置背景
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
        
        // 6.2.3.设置frame
        // 按钮尺寸
        CGFloat optionW = 35;
        CGFloat optionH = 35;
        // 按钮之间的间距
        CGFloat margin = 10;
        // 控制器view的宽度
        CGFloat viewW = self.view.frame.size.width;
        // 总列数
        int totalColumns = 7;
        // 最左边的间距 = 0.5 * (控制器view的宽度 - 总列数 * 按钮宽度 - (总列数 - 1) * 按钮之间的间距)
        CGFloat leftMargin = (viewW - totalColumns * optionW - margin * (totalColumns - 1)) * 0.5;
        int col = i % totalColumns;
        // 按钮的x = 最左边的间距 + 列号 * (按钮宽度 + 按钮之间的间距)
        CGFloat optionX = leftMargin + col * (optionW + margin);
        int row = i / totalColumns;
        // 按钮的y = 行号 * (按钮高度 + 按钮之间的间距)
        CGFloat optionY = row * (optionH + margin);
        optionBtn.frame = CGRectMake(optionX, optionY, optionW, optionH);
        
        // 6.2.4.设置文字
        [optionBtn setTitle:question.options[i] forState:UIControlStateNormal];
        [optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 6.2.5.添加
        [self.optionView addSubview:optionBtn];
        
        // 6.2.6.监听点击
        [optionBtn addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  监听待选按钮的点击
 */
- (void)optionClick:(UIButton *)optionBtn
{
    // 1.让被点击的待选按钮消失
    optionBtn.hidden = YES;
    
    // 2.显示文字到正确答案上
    for (UIButton *answerBtn in self.answerView.subviews) {
        // 判断按钮是否有文字
        NSString *answerTitle = [answerBtn titleForState:UIControlStateNormal];
        
        if (answerTitle.length == 0) { // 没有文字
            // 设置答案按钮的 文字 为 被点击待选按钮的文字
            NSString *optionTitle = [optionBtn titleForState:UIControlStateNormal];
            [answerBtn setTitle:optionTitle forState:UIControlStateNormal];
            break; // 停止遍历
        }
    }
    
    // 3.检测答案是否填满
    BOOL full = YES;
    NSMutableString *tempAnswerTitle = [NSMutableString string];
    for (UIButton *answerBtn in self.answerView.subviews) {
        // 判断按钮是否有文字
        NSString *answerTitle = [answerBtn titleForState:UIControlStateNormal];
        
        if (answerTitle.length == 0) { // 没有文字(按钮没有填满)
            full = NO;
        }
        
        // 拼接按钮文字
        if(answerTitle) {
            [tempAnswerTitle appendString:answerTitle];
        }
    }
    
    // 4.答案满了
    if (full) {
        XYQuestion *question = self.questions[self.index];
        
        if ([tempAnswerTitle isEqualToString:question.answer]) { // 答对了(文字显示蓝色)
            for (UIButton *answerBtn in self.answerView.subviews) {
                [answerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
            
            // 加分
            [self addScore:800];
            
            // 0.5秒后跳到下一题
            [self performSelector:@selector(nextQuestion) withObject:nil afterDelay:0.5];
        } else { // 答错了(文字显示红色)
            for (UIButton *answerBtn in self.answerView.subviews) {
                [answerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
}

/**
 *  添加正确答案
 */
- (void)addAnswerBtn:(XYQuestion *)question
{
    // 5.1.删除之前的所有按钮
    // 让数组中的所有对象都执行removeFromSuperview方法
    [self.answerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //    for (UIView *subview in self.answerView.subviews) {
    //        [subview removeFromSuperview];
    //    }
    
    // 5.2.添加新的答案按钮
    NSUInteger length = question.answer.length;
    for (int i = 0; i<length; i++) {
        // 5.2.1.创建按钮
        UIButton *answerBtn = [[UIButton alloc] init];
        [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 5.2.2.设置背景
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        
        // 5.2.3.设置frame
        CGFloat viewW = self.view.frame.size.width;
        // 按钮之间的间距
        CGFloat margin = 10;
        // 按钮的尺寸
        CGFloat answerW = 35;
        CGFloat answerH = 35;
        // 最左边的间距 = 0.5 * (控制器view的宽度 - 按钮个数 * 按钮宽度 - (按钮个数 - 1) * 按钮之间的间距)
        CGFloat leftMargin = (viewW - length * answerW - margin * (length - 1)) * 0.5;
        // 按钮的x = 最左边的间距 + i * (按钮宽度 + 按钮之间的间距)
        CGFloat answerX = leftMargin + i * (answerW + margin);
        answerBtn.frame = CGRectMake(answerX, 0, answerW, answerH);
        
        // 5.2.4.添加
        [self.answerView addSubview:answerBtn];
        
        // 5.2.5.监听点击
        [answerBtn addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  监听答案按钮的点击
 */
- (void)answerClick:(UIButton *)answerBtn
{
    // 1.让答案按钮文字对应的待选按钮显示出来(hidden = NO)
    for (UIButton *optionBtn in self.optionView.subviews) {
        if ([optionBtn.currentTitle isEqualToString:answerBtn.currentTitle]
            
            && optionBtn.hidden == YES) { // 发现跟答案按钮相同文字的待选按钮
            
            optionBtn.hidden = NO;
            break;
        }
    }
    
    // 2.让被点击答案按钮的文字消失(去除文字)
    [answerBtn setTitle:nil forState:UIControlStateNormal];
    
    // 3.让所有的答案按钮变为黑色
    for (UIButton *answerBtn in self.answerView.subviews) {
        [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}


/**
 *  添加分数
 *
 *  @param deltaScore 需要添加多少分
 */
- (void)addScore:(int)deltaScore
{
    int score = [self.scoreBtn titleForState:UIControlStateNormal].intValue;
    score += deltaScore;
    [self.scoreBtn setTitle:[NSString stringWithFormat:@"%d", score] forState:UIControlStateNormal];
}




@end
