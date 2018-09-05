//
//  MYYRegisterSubmitViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/5.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYRegisterSubmitViewController.h"
#import "RegistReferModel.h"
#import "ProvinceModel.h"

@interface MYYRegisterSubmitViewController ()<UITextFieldDelegate>
{
    UITextField* _phoneField;
    UITextField* _pwdField;
    UITextField* _againPwdField;
    
    
}
@end

@implementation MYYRegisterSubmitViewController

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
    
    [self creatUI];
}

- (void)creatUI
{
    // 1.设置背景色
    UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    bgimage.userInteractionEnabled = YES;
    bgimage.image = [UIImage imageNamed:@"登录背景"];
    [self.view addSubview:bgimage];
    
    // 2.添加子视图
    
    UIImageView *logeimage = [[UIImageView alloc]initWithFrame:CGRectMake(mScreenWidth/2-30*MYWIDTH, mScreenHeight/6+30*MYWIDTH, 60*MYWIDTH, 30*MYWIDTH)];
    logeimage.image = [UIImage imageNamed:@"注册title"];
    [bgimage addSubview:logeimage];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(45*MYWIDTH, logeimage.bottom+80*MYWIDTH, mScreenWidth-90*MYWIDTH, 260*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.layer.cornerRadius = 10;
    [bgimage addSubview:bgview];
    
    UIImageView *userimage = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, 55*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    userimage.image = [UIImage imageNamed:@"用户名"];
    [bgview addSubview:userimage];
    
    _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(userimage.right+10*MYWIDTH, userimage.top-10*MYWIDTH, bgview.width-70*MYWIDTH, 40*MYWIDTH)];
    _phoneField.placeholder = @"请填写您的用户名";
    _phoneField.delegate = self;
    _phoneField.backgroundColor = UIColorFromRGB(0xefefef);
    _phoneField.textAlignment = NSTextAlignmentCenter;
    _phoneField.font = [UIFont systemFontOfSize:14];
    [bgview addSubview:_phoneField];
    
    UIImageView *passimage = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, userimage.bottom + 45*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    passimage.image = [UIImage imageNamed:@"密码"];
    [bgview addSubview:passimage];
    
    _pwdField = [[UITextField alloc]initWithFrame:CGRectMake(passimage.right+10*MYWIDTH, passimage.top-10*MYWIDTH, bgview.width-70*MYWIDTH, 40*MYWIDTH)];
    _pwdField.placeholder = @"请输入登录密码";
    _pwdField.delegate = self;
    _pwdField.backgroundColor = UIColorFromRGB(0xefefef);
    _pwdField.textAlignment = NSTextAlignmentCenter;
    _pwdField.font = [UIFont systemFontOfSize:14];
    [bgview addSubview:_pwdField];
    
    UIImageView *passimage1 = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, passimage.bottom + 45*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    passimage1.image = [UIImage imageNamed:@"密码"];
    [bgview addSubview:passimage1];
    
    _againPwdField = [[UITextField alloc]initWithFrame:CGRectMake(passimage1.right+10*MYWIDTH, passimage1.top-10*MYWIDTH, bgview.width-70*MYWIDTH, 40*MYWIDTH)];
    _againPwdField.placeholder = @"请确认登录密码";
    _againPwdField.delegate = self;
    _againPwdField.backgroundColor = UIColorFromRGB(0xefefef);
    _againPwdField.textAlignment = NSTextAlignmentCenter;
    _againPwdField.font = [UIFont systemFontOfSize:14];
    [bgview addSubview:_againPwdField];
    
    UIButton* nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.frame = CGRectMake(bgview.left, bgview.bottom+25*MYWIDTH, bgview.width, 45*MYWIDTH);
    [nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = 5;
    nextBtn.backgroundColor = NavBarItemColor;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgimage addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}







- (void)nextBtnClick{
    if ([_phoneField.text isEqualToString:@""]) {
        [self showAlert:@"用户名不能为空"];
        return;
    }
    if ([_pwdField.text isEqualToString:@""]) {
        [self showAlert:@"登录密码不能为空"];
        return;
    }
    if(![_againPwdField.text isEqualToString:_pwdField.text]) {
        [self showAlert:@"两次输入的密码不一致"];
        return;
    }
    /*
     （custname，phone，name，accountname）此值都为电话号码，password（必填），isvalid="1"，score="0"，balance="0"，provinceid，cityid，areaid
     ，villageid，chargerid（负责人id）chargername（负责人名称），recommenderid（推荐人id），recommendername（推荐人名称）
     */
    
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"custname\":\"%@\",\"phone\":\"%@\",\"name\":\"%@\",\"accountname\":\"%@\",\"password\":\"%@\",\"isvalid\":\"1\",\"score\":\"0\",\"balance\":\"0\",\"provinceid\":\"\",\"cityid\":\"\",\"areaid\":\"\",\"villageid\":\"\",\"chargerid\":\"\",\"chargername\":\"\",\"recommenderid\":\"\",\"recommendername\":\"\"}",self.phone,self.phone,self.phone,self.phone,_pwdField.text]};
    NSLog(@"注册参数%@",params);
    [HTNetWorking postWithUrl:@"register?action=addCoustomer" refreshCache:YES showHUD:@"" params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            NSArray* array = self.navigationController.viewControllers;
            UIViewController *viewCtl = self.navigationController.viewControllers[array.count - 1 - 2];
            [self.navigationController popToViewController:viewCtl animated:YES];
        }else{
            [self customAlert:@"注册失败"];
        }
    } fail:^(NSError *error) {

    }];
}



@end
