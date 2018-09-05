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
@property(nonatomic,strong)UILabel *titleLabel1;

@property(nonatomic,strong)UILabel *titleLabel2;

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [Command isloginRequest:^(bool str) {
        if (str) {
            //登录成功
            [self.navigationController popViewControllerAnimated:NO];
        }
    }];
}

- (void)navigationItemButton{
    self.navigationItem.title = @"登录";
    if (self.next==1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xffffff)];

    }
}

- (void)setupUI
{
    // 1.设置背景色
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // 2.添加子视图
    self.titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 40, 25)];
    self.titleLabel1.textColor = UIColorFromRGB(0x333333);
    self.titleLabel1.textAlignment = NSTextAlignmentCenter;
    self.titleLabel1.font = [UIFont systemFontOfSize:15];
    self.titleLabel1.text = @"登录";
    [self.view addSubview:self.titleLabel1];

    self.textField1 = [[UITextField alloc]initWithFrame:CGRectMake(70, 80, mScreenWidth-90, 30)];
    self.textField1.delegate = self;
    self.textField1.layer.cornerRadius = 5;
    self.textField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField1.layer.borderColor = [UIColor grayColor].CGColor;
    self.textField1.placeholder = @"请输入账号";
    [self.textField1 setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:self.textField1];
    
    UILabel *xian1 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField1.frame)+1, mScreenWidth - 40, 1)];
    xian1.backgroundColor = UIColorFromRGB(0xefefef);
    [self.view addSubview:xian1];
    
    self.titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField1.frame)+20, 40, 25)];
    self.titleLabel2.textColor = UIColorFromRGB(0x333333);
    self.titleLabel2.textAlignment = NSTextAlignmentCenter;
    self.titleLabel2.font = [UIFont systemFontOfSize:15];
    self.titleLabel2.text = @"密码";
    [self.view addSubview:self.titleLabel2];

    self.textField2 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.textField1.frame), CGRectGetMaxY(self.textField1.frame)+20, CGRectGetWidth(self.textField1.frame), CGRectGetHeight(self.textField1.frame))];
    self.textField2.delegate = self;
    self.textField2.layer.cornerRadius = 5;
    self.textField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField2.layer.borderColor = [UIColor grayColor].CGColor;
    self.textField2.placeholder = @"请输入密码";
    [self.textField2 setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    self.textField2.secureTextEntry = YES;
    [self.view addSubview:self.textField2];
    
    UILabel *xian2 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField2.frame)+1, mScreenWidth - 40, 1)];
    xian2.backgroundColor = UIColorFromRGB(0xefefef);
    [self.view addSubview:xian2];
    
    self.loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField2.frame)+40, mScreenWidth-40, 45)];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.loginBtn.layer.cornerRadius = 5;
    [self.loginBtn setBackgroundColor:NavBarItemColor];
    [self.loginBtn addTarget:self action:@selector(LoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    
    self.RegisterBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.loginBtn.frame)+10, 60, 40)];
    [self.RegisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    self.RegisterBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.RegisterBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.RegisterBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [self.RegisterBtn setBackgroundColor:[UIColor whiteColor]];
    [self.RegisterBtn addTarget:self action:@selector(RegisterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.RegisterBtn];
    
    self.PasswordBtn = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth - 90, CGRectGetMaxY(self.loginBtn.frame)+10, 60, 40)];
    [self.PasswordBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    self.PasswordBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.PasswordBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.PasswordBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [self.PasswordBtn setBackgroundColor:[UIColor whiteColor]];
    [self.PasswordBtn addTarget:self action:@selector(PasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.PasswordBtn];
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
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            [Command customAlert:@"账号或密码不正确"];
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
