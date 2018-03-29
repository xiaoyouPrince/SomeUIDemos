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


/**
 *  提示用户
 *
 *  @param tip 提示文字内容
 */
- (void)showTipViewWithTips:(NSString *)tip{
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = tip;
    tipLabel.numberOfLines = 0;
    
    [tipLabel sizeToFit];
    CGRect frame = tipLabel.frame;
    frame.size = CGSizeMake(tipLabel.frame.size.width + 30, tipLabel.frame.size.height + 20);
    tipLabel.frame = frame;
    tipLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    tipLabel.center = self.view.center;
    
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.layer.cornerRadius = frame.size.height / 4;
    tipLabel.clipsToBounds = YES;
    
    [UIView animateWithDuration:1 animations:^{
        [self.view addSubview:tipLabel];
    } completion:^(BOOL finished) {
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                tipLabel.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                [tipLabel removeFromSuperview];
            }];
        });
    }];
    
    
}



- (IBAction)tip;
{
    // 【注意】此思路不好，Swift 版本中思路好些，更加面向对象，此实现过于面向过程了，比较麻烦
    // 1.查看分数是否足够提示的，每次提示 -800分
    // 2.遍历所选答案，比对对应的文字，
    //   如果没有选择正确答案，直接移除所有文字，提示第一个字
    //   如果第一个字对，移除后面所选提示第二个字
    //   ...
    // 3.如果提示最后一个字完成后，进入下一题（不加分）
    
    int currentScore = [[self.scoreBtn titleForState:UIControlStateNormal] intValue];
    if (currentScore <= 800) {
        [self showTipViewWithTips:@"您当前分数过低，无法进行提示!"];
    }else
    {
        // 1. 当前question
        XYQuestion *question = self.questions[self.index];
        
        // 2. 用户当前选择的答案
        NSMutableString *userAnswer = [NSMutableString string];
        for (UIButton *answeBtn in self.answerView.subviews) {
            
            if ([[answeBtn titleForState:UIControlStateNormal] isEqualToString:@""] || [answeBtn titleForState:UIControlStateNormal] == nil) {
                break;
            }
            [userAnswer appendString:[answeBtn titleForState:UIControlStateNormal]];
        }
        
        // 2.1 如果用户选择的答案为nil,直接提示第一个字
        if (userAnswer.length == 0) {
            
            NSString *questionAnwerWord = [question.answer substringWithRange:NSMakeRange(0, 1)];
            
            UIButton *answerBtn = self.answerView.subviews.firstObject;
            [answerBtn setTitle:questionAnwerWord forState:UIControlStateNormal];
            
            for (UIButton *optionBtn in self.optionView.subviews) {
                
                if ([[optionBtn titleForState:UIControlStateNormal] isEqualToString:questionAnwerWord]) {// 无需判断，是否隐藏，此状态都是显示的
                    optionBtn.hidden = YES;
                    // 只隐藏第一个
                    break;
                }
                
            }
        }
        
        // 2.2 如果用户选择的答案都正确，就提示下面一个答案
        if ([question.answer containsString:userAnswer] && userAnswer.length < question.answer.length) {
         
            NSString *questionAnwerWord = [question.answer substringWithRange:NSMakeRange(userAnswer.length, 1)];
            
            // answerBtn 展示提示的答案
            UIButton *answerBtn = self.answerView.subviews[userAnswer.length];
            [answerBtn setTitle:questionAnwerWord forState:UIControlStateNormal];
            
            // optionBtn 隐藏
            for (UIButton *optionBtn in self.optionView.subviews) {
                if ([[optionBtn titleForState:UIControlStateNormal] isEqualToString:questionAnwerWord] && optionBtn.hidden == NO ) {
                    optionBtn.hidden = YES;
                    break;
                }
            }
            
            // 提示完判断，是否此题已经答完
            if (userAnswer.length + 1 == question.answer.length ) {
                
                
                // 所有文字变蓝色，然后进入下一题
                for (UIButton *answerBtn in self.answerView.subviews) {
                    [answerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self nextQuestion];
                });
                return;// 直接返回，此情况不扣分
            }
        }
        
        // 2.3 用户有选择但是选择的文字中有错误，逐字判断正误，并提示（每次只提示一个字）
        for (int i = 0; i < userAnswer.length; i++) {
            
            NSString *userAnwerWord = [userAnswer substringWithRange:NSMakeRange(i, 1)];
            NSString *questionAnwerWord = [question.answer substringWithRange:NSMakeRange(i, 1)];
            
            if ([userAnwerWord isEqualToString:questionAnwerWord]) {
                // 当前位置答案相同，直接对比下一位答案文字
                continue;
            }else {
                // 进行提示当前位置的答案
                
                // 1. answerView显示提示的答案
                UIButton *answeBtn =  self.answerView.subviews[i];
                [answeBtn setTitle:questionAnwerWord forState:UIControlStateNormal];
                
                // 2. optionView遍历并隐藏对应位置答案
                for (UIButton *optionBtn in self.optionView.subviews) {
                    
                    // 2.1 显示之前被选的答案文字
                    if ([[optionBtn titleForState:UIControlStateNormal] isEqualToString:userAnwerWord] && optionBtn.hidden == YES){
                        optionBtn.hidden = NO;
                        break;
                    }
                }
                
                // 2. optionView遍历并隐藏对应位置答案
                for (UIButton *optionBtn in self.optionView.subviews) {
                    
                    // 2.2 隐藏被提示的答案文字（只隐藏遍历到的第一个文字）
                    if ([[optionBtn titleForState:UIControlStateNormal] isEqualToString:questionAnwerWord] && optionBtn.hidden == NO) {
                        optionBtn.hidden = YES;
                        break;
                    }
                }
                
                // 3.提示完判断，是否此题已经答完
                NSString *subStr = [userAnswer substringWithRange:NSMakeRange(0, userAnswer.length-1)];
                if ([question.answer containsString:subStr] && userAnswer.length == question.answer.length) {
                    
                    // 所有文字变蓝色，然后进入下一题
                    for (UIButton *answerBtn in self.answerView.subviews) {
                        [answerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self nextQuestion];
                    });
                    return; // 此情况也不减分
                }

                
                // 每次只提示一个字
                break;
            }
        }
        
        
        // 3.减分
        [self addScore:-800];
    }
    
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
    [self showTipViewWithTips:@"帮助，暂时就不做了，可以场外\n可以其他，自己想就行"];
}
- (IBAction)nextQuestion
{

    XYQuestion *question = nil;
    if (self.index == self.questions.count - 1) { // 已经是最后一题，给提示
        
        [self showTipViewWithTips:@"恭喜你通关\n5秒钟后为您重新开始"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.index = -1;
            [self nextQuestion];
        });
        

        return;
        
    }else {
        
        self.index ++;
        
        question = (XYQuestion *)self.questions[self.index];
    }
    
    
    
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
    if (self.index == (self.questions.count - 1)) {
        [self showTipViewWithTips:@"已到最后一题"];
    }
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
            
            // 设置剩余的 optionBtns 不可以点击
            [self.optionView.subviews makeObjectsPerformSelector:@selector(setUserInteractionEnabled:) withObject:@(NO)];
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
    
    // 4.此时恢复 optionBtns 的可用性
//    [self.optionView.subviews makeObjectsPerformSelector:@selector(setUserInteractionEnabled:) withObject:@(YES)];
    for (UIButton *btn in self.optionView.subviews) {
        btn.userInteractionEnabled = YES;
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
