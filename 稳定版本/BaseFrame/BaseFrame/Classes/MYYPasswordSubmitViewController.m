//
//  MYYPasswordSubmitViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/5.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYPasswordSubmitViewController.h"

@interface MYYPasswordSubmitViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *textField1;

@property(nonatomic,strong)UITextField *textField2;

@property(nonatomic,strong)UIButton *nextBtn;//提交

@end

@implementation MYYPasswordSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationItemButton];
    [self setupUI];
    
}
- (void)navigationItemButton{
    self.navigationItem.title = @"找回登录密码";
}

- (void)setupUI
{
    // 1.设置背景色
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // 2.添加子视图
    
    self.textField1 = [[UITextField alloc]initWithFrame:CGRectMake(20, 80, mScreenWidth-40, 30)];
    self.textField1.delegate = self;
    self.textField1.layer.cornerRadius = 5;
    self.textField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField1.layer.borderColor = [UIColor grayColor].CGColor;
    self.textField1.placeholder = @"请输入登录密码";
    self.textField1.secureTextEntry = YES;
    [self.textField1 setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:self.textField1];
    
    UILabel *xian1 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField1.frame)+1, mScreenWidth - 40, 1)];
    xian1.backgroundColor = UIColorFromRGB(0xefefef);
    [self.view addSubview:xian1];
    
   
    
    self.textField2 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.textField1.frame), CGRectGetMaxY(self.textField1.frame)+20, CGRectGetWidth(self.textField1.frame), CGRectGetHeight(self.textField1.frame))];
    self.textField2.delegate = self;
    self.textField2.layer.cornerRadius = 5;
    self.textField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField2.layer.borderColor = [UIColor grayColor].CGColor;
    self.textField2.placeholder = @"请输入再次密码";
    [self.textField2 setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    self.textField2.secureTextEntry = YES;
    [self.view addSubview:self.textField2];
    
    UILabel *xian2 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField2.frame)+1, mScreenWidth - 40, 1)];
    xian2.backgroundColor = UIColorFromRGB(0xefefef);
    [self.view addSubview:xian2];
    
    self.nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField2.frame)+40, mScreenWidth-40, 45)];
    [self.nextBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.nextBtn.layer.cornerRadius = 5;
    [self.nextBtn setBackgroundColor:NavBarItemColor];
    [self.nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
    
   
}
- (void)nextBtnAction:(UIButton *)sender{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    if ([self.textField1.text isEqualToString:self.textField2.text]&&!IsEmptyValue(self.phone)) {
        if ([Command isPassword:self.textField1.text]) {
            [self replacePwdRequest];
        }else{
            [self customAlert:@"密码位数6-20位"];
        }
    }else{
        [self customAlert:@"请输入相同的密码"];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.textField1]) {
        
    }else{
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.textField1]) {
        
        if(![Command isPassword:self.textField1.text]){
            [self showAlert:@"密码应该是6-20位"];
        }
    }else{
        if (![self.textField1.text isEqualToString:self.textField2.text]) {
            [self showAlert:@"密码两次输入不一致"];
        }
    }
    
}


- (void)replacePwdRequest{
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"password\":\"%@\",\"phone\":\"%@\"}",self.textField1.text,self.phone]};
    [HTNetWorking postWithUrl:@"register?action=upPassword" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
//            NSLog(@"重置成功");
            NSArray* array = self.navigationController.viewControllers;
            UIViewController *viewCtl = self.navigationController.viewControllers[array.count - 1 - 2];
            [self.navigationController popToViewController:viewCtl animated:YES];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

@end
