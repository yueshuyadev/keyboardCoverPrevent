//
//  ViewController.m
//  keyboardPreventFromCover
//
//  Created by 陈中宝 on 16/1/2.
//  Copyright © 2016年 陈中宝. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat height = self.view.bounds.size.height;
    CGFloat width = self.view.bounds.size.width;
    
    UILabel *prompt = [[UILabel alloc] init];
    prompt.frame = CGRectMake(10, 50, width - 20, 100);
    prompt.text = @"点击编辑文本框，试试看防遮挡\n点击空白区域可以退出文本框编辑";
    prompt.numberOfLines = 0;
    [self.view addSubview:prompt];
    
    
    UITextField *inputView = [[UITextField alloc] init];
    
    inputView.frame = CGRectMake(10, height - 50 - 10.f, 200, 50);
    inputView.placeholder = @"编辑，防遮挡";
    [self.view addSubview:inputView];
    inputView.borderStyle = UITextBorderStyleRoundedRect;
    inputView.returnKeyType = UIReturnKeyDone;
    inputView.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}



@end
