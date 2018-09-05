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

//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去除导航栏下方的横线
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setTranslucent:YES];
    self.navigationItem.title = @"";
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIImage *image = [UIImage imageNamed:@"touming"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];

}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    NSLog(@"statusBar.backgroundColor--->%@",statusBar.backgroundColor);
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
- (void)backToLastViewController:(UIButton *)button
{
    //[Public hideLoadingView];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastViewController:)];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xffffff)];
    
    [self setupUI];
}

- (void)setupUI
{
    // 1.设置背景色
    UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    bgimage.userInteractionEnabled = YES;
    bgimage.image = [UIImage imageNamed:@"登录背景"];
    [self.view addSubview:bgimage];
    
    // 2.添加子视图
    
    UIImageView *logeimage = [[UIImageView alloc]initWithFrame:CGRectMake(mScreenWidth/2-30*MYWIDTH, mScreenHeight/6+30*MYWIDTH, 60*MYWIDTH, 30*MYWIDTH)];
    logeimage.image = [UIImage imageNamed:@"找回title"];
    [bgimage addSubview:logeimage];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(45*MYWIDTH, logeimage.bottom+80*MYWIDTH, mScreenWidth-90*MYWIDTH, 200*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.layer.cornerRadius = 10;
    [bgimage addSubview:bgview];
    
    UIImageView *userimage = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, 55*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    userimage.image = [UIImage imageNamed:@"密码"];
    [bgview addSubview:userimage];
    
    self.textField1 = [[UITextField alloc]initWithFrame:CGRectMake(userimage.right+10*MYWIDTH, userimage.top-10*MYWIDTH, bgview.width-70*MYWIDTH, 40*MYWIDTH)];
    self.textField1.delegate = self;
    self.textField1.layer.cornerRadius = 2;
    self.textField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField1.backgroundColor = UIColorFromRGB(0xefefef);
    self.textField1.textAlignment = NSTextAlignmentCenter;
    self.textField1.placeholder = @"请输入新密码";
    [self.textField1 setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [bgview addSubview:self.textField1];
    
    UIImageView *passimage = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, userimage.bottom + 50*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    passimage.image = [UIImage imageNamed:@"密码"];
    [bgview addSubview:passimage];
    
    
    self.textField2 = [[UITextField alloc]initWithFrame:CGRectMake(passimage.right+10*MYWIDTH,passimage.top-10*MYWIDTH,bgview.width-70*MYWIDTH,40*MYWIDTH)];
    self.textField2.delegate = self;
    self.textField2.layer.cornerRadius = 2;
    self.textField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField2.backgroundColor = UIColorFromRGB(0xefefef);
    self.textField2.textAlignment = NSTextAlignmentCenter;
    self.textField2.placeholder = @"请确认密码";
    [self.textField2 setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    self.textField2.secureTextEntry = YES;
    [bgview addSubview:self.textField2];
    
    
    self.nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(bgview.left, bgview.bottom+25*MYWIDTH, bgview.width, 45*MYWIDTH)];
    [self.nextBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.nextBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    self.nextBtn.layer.cornerRadius = 5;
    [self.nextBtn setBackgroundColor:NavBarItemColor];
    [self.nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgimage addSubview:self.nextBtn];
    
   
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
