//
//  MYYLoginViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/5.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYLoginViewController.h"
#import "MYYRegisterViewController.h"
#import "MYYPasswordViewController.h"//找回密码
#import "RegistReferModel.h"
@interface MYYLoginViewController ()<UITextFieldDelegate>


@property(nonatomic,strong)UITextField *textField1;

@property(nonatomic,strong)UITextField *textField2;

@property(nonatomic,strong)UIButton *loginBtn;//登录

@property(nonatomic,strong)UIButton *RegisterBtn;//注册

@property(nonatomic,strong)UIButton *PasswordBtn;//找回密码

@end

@implementation MYYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationItemButton];
    [self setupUI];
}
//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去除导航栏下方的横线
//    UINavigationBar *bar = [UINavigationBar appearance];
//    [bar setTranslucent:YES];
    self.navigationItem.title = @"";
    
    
    UIImage *image = [UIImage imageNamed:@"touming"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
    self.navigationController.navigationBar.translucent = YES;
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [Command isloginRequest:^(bool str) {
        if (str) {
            //登录成功
            [self.navigationController popViewControllerAnimated:NO];
        }
    }];
}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    NSLog(@"statusBar.backgroundColor--->%@",statusBar.backgroundColor);
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
- (void)navigationItemButton{
    NSLog(@"这个是个什么玩意%lu",self.next);
    if (self.next==1) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"touming"] style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xffffff)];

    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastViewController:)];
        [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xffffff)];
    }
}
- (void)backToLastViewController:(UIButton *)button
{
    //[Public hideLoadingView];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupUI
{
    // 1.设置背景色
    UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    bgimage.userInteractionEnabled = YES;
    bgimage.image = [UIImage imageNamed:@"登录背景"];
    [self.view addSubview:bgimage];
    
    // 2.添加子视图
    
    UIImageView *logeimage = [[UIImageView alloc]initWithFrame:CGRectMake(mScreenWidth/2-55*MYWIDTH, mScreenHeight/6, 110*MYWIDTH, 45*MYWIDTH)];
    logeimage.image = [UIImage imageNamed:@"登录pin"];
    [bgimage addSubview:logeimage];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(45*MYWIDTH, logeimage.bottom+80*MYWIDTH, mScreenWidth-90*MYWIDTH, 200*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.layer.cornerRadius = 10;
    [bgimage addSubview:bgview];
    
    UIImageView *userimage = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, 55*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    userimage.image = [UIImage imageNamed:@"用户名"];
    [bgview addSubview:userimage];

    self.textField1 = [[UITextField alloc]initWithFrame:CGRectMake(userimage.right+10*MYWIDTH, userimage.top-10*MYWIDTH, bgview.width-70*MYWIDTH, 40*MYWIDTH)];
    self.textField1.delegate = self;
    self.textField1.layer.cornerRadius = 2;
    self.textField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField1.backgroundColor = UIColorFromRGB(0xefefef);
    self.textField1.textAlignment = NSTextAlignmentCenter;
    self.textField1.placeholder = @"请输入账号";
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
    self.textField2.placeholder = @"请输入密码";
    [self.textField2 setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    self.textField2.secureTextEntry = YES;
    [bgview addSubview:self.textField2];
    
    
    self.loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(bgview.left, bgview.bottom+20*MYWIDTH, bgview.width, 45*MYWIDTH)];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    self.loginBtn.layer.cornerRadius = 5;
    [self.loginBtn setBackgroundColor:NavBarItemColor];
    [self.loginBtn addTarget:self action:@selector(LoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgimage addSubview:self.loginBtn];
    
    self.RegisterBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.loginBtn.left-10, CGRectGetMaxY(self.loginBtn.frame)+10, 60, 40)];
    [self.RegisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    self.RegisterBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.RegisterBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.RegisterBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [self.RegisterBtn setBackgroundColor:[UIColor clearColor]];
    [self.RegisterBtn addTarget:self action:@selector(RegisterAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgimage addSubview:self.RegisterBtn];
    
    self.PasswordBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.loginBtn.right - 90, CGRectGetMaxY(self.loginBtn.frame)+10, 90, 40)];
    [self.PasswordBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    self.PasswordBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.PasswordBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.PasswordBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [self.PasswordBtn setBackgroundColor:[UIColor clearColor]];
    [self.PasswordBtn addTarget:self action:@selector(PasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgimage addSubview:self.PasswordBtn];
}
- (void)LoginAction:(UIButton *)sender{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    if (!IsEmptyValue(self.textField1.text)&&!IsEmptyValue(self.textField2.text)) {
        [self loginDataRequest];
    }
}
//注册
- (void)RegisterAction:(UIButton *)sender{
    MYYRegisterViewController *registerViewController = [[MYYRegisterViewController alloc]init];
    registerViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerViewController animated:YES];
    
}
//找回密码
- (void)PasswordAction:(UIButton *)sender{
    MYYPasswordViewController *passwordViewController = [[MYYPasswordViewController alloc]init];
    passwordViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:passwordViewController animated:YES];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.textField1]) {
  
    }else{
        
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.textField1]) {
        
       
    }else{
        
    }
    
}

- (void)loginDataRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"accountname\":\"%@\",\"password\":\"%@\"}",self.textField1.text,self.textField2.text]};
    [HTNetWorking postWithUrl:@"mallLogin?action=checkMallLogin" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"登录数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if ([str rangeOfString:@"noEx"].location!=NSNotFound) {
            [Command customAlert:@"该手机号未被注册，请先注册"];
            return ;
        }
        if ([str rangeOfString:@"isstop"].location!=NSNotFound) {
            [Command customAlert:@"该手机号已被停用"];
            return ;
        }
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            [Command customAlert:@"账号或密码不正确"];
            return ;
        }
        if (!IsEmptyValue(array)) {
            NSDictionary* dict = array[0];
            RegistReferModel* model = [[RegistReferModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [[NSUserDefaults standardUserDefaults]setObject:model.phone forKey:USENAME];
            [[NSUserDefaults standardUserDefaults]setObject:model.name forKey:USERPHONE];
            [[NSUserDefaults standardUserDefaults]setObject:model.Id forKey:USERID];
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:IsLogin];
            [[NSUserDefaults standardUserDefaults]setObject:model.password forKey:PASSWORD];
            [[NSUserDefaults standardUserDefaults]setObject:model.accountname forKey:ACCOUNTNAME];
            
            NSArray *viewcontrollers=self.navigationController.viewControllers;
            if (viewcontrollers.count>1) {
                if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
                    //push方式
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else{
                //present方式
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } fail:^(NSError *error) {
        
    }];
}

@end
