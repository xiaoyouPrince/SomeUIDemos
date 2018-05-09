//  代码地址：https://github.com/xiaoyouPrince/SomeUIDemos
//  Blog地址：http://xiaoyouPrince.com/
//
//  ViewController.m
//  ContactDemo
//
//  Created by 渠晓友 on 2018/5/8.
//
//  Copyright © 2018年 xiaoyouPrince. All rights reserved.
//


/*
 1. 头文件
 2. 集成代理
 3. 创建创建选择联系人的控制器并弹出
 4. 实现代理方法
    4.1取消选择
    4.2选择联系人(内部处理联系人数据)
 */

#import "ViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface ViewController ()<CNContactPickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneTF;


@end

@implementation ViewController


- (IBAction)chooseContact:(id)sender{
    
    // 1.创建选择联系人的控制器
    CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
    // 2.设置代理
    contactVc.delegate = self;
    // 3.弹出控制器
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:contactVc animated:YES completion:nil];
    
}


// 实现代理方法
// 1.点击取消按钮调用的方法
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    NSLog(@"取消选择联系人");
}
// 2.当选中某一个联系人时会执行该方法
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    // 1.获取联系人的姓名
    NSString *lastname = contact.familyName;
    NSString *firstname = contact.givenName;
    NSLog(@"1%@1 %@", lastname, firstname);
    
    // 2.获取联系人的电话号码(此处获取的是该联系人的第一个号码,也可以遍历所有的号码)
    NSArray *phoneNums = contact.phoneNumbers;
    CNLabeledValue *labeledValue;
    
    // 2.1这里需要单独处理一下通讯录中<我>的电话
    if (phoneNums.count) {
        labeledValue = phoneNums[0];
    }else
    {
        // 这里应该拿到自己电话号码，这里没法获取<CTSettingCopyMyPhoneNumber()这种私有API无法上架>
        CNPhoneNumber *phoneNumer = [CNPhoneNumber phoneNumberWithStringValue:@"请手动输入本机号码"];
        labeledValue = [[CNLabeledValue alloc] initWithLabel:@"无法获取" value:phoneNumer];
    }
    
    CNPhoneNumber *phoneNumer = labeledValue.value;
    NSString *phoneNumber = phoneNumer.stringValue;
    NSLog(@"%@", phoneNumber);
    // 本实例中由于要考虑，通讯录中直接添加过来的，所以自己去除一下(182-1203-0974)和(182 1203 0974)这种类型的
    if ([phoneNumber containsString:@"-"]) {
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    if ([phoneNumber containsString:@" "]) {
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    NSString *userName = [NSString stringWithFormat:@"%@ %@", lastname, firstname];
    if ([userName containsString:@" "]) {
        userName = [userName stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    
    self.userNameTF.text = userName;
    self.userPhoneTF.text = phoneNumber;
    
}



@end
