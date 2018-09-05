//
//  MYYMineAccountDetailViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/16.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYMineAccountDetailViewController.h"

@interface MYYMineAccountDetailViewController ()
{
    UITextField* _textField;
}

@end

@implementation MYYMineAccountDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置状态栏颜色
    [self setStatusBarBackgroundColor:UIColorFromRGB(0xFFA500)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self creatNavUI:self.controller];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI:self.controller];
}

- (void)creatNavUI:(NSString*)controller{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0x444444)];
    [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"保存" textColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    if ([controller integerValue] == 1) {
        self.title = @"我的账户";
    }else if ([controller integerValue] == 2){
        self.title = @"我的昵称";
    }else if ([controller integerValue] == 3){
        self.title = @"我的电话";
    }else if ([controller integerValue] == 4){
        self.title = @"修改密码";
    }
}

- (void)creatUI:(NSString*)controller{
    self.view.backgroundColor = BackGorundColor;
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreen_Width, 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, kScreen_Width - 20, 44)];
    if ([controller integerValue] == 1) {
        _textField.placeholder = @"请输入账户";
    }else if ([controller integerValue] == 2){
        _textField.placeholder = @"请输入姓名";
    }else if ([controller integerValue] == 3){
        _textField.placeholder = @"请输入电话";
    }else if ([controller integerValue] == 4){
        _textField.placeholder = @"请输入密码";
    }
    [bgView addSubview:_textField];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender{
    [self updataPersonalRequest];
}

- (void)updataPersonalRequest{
/*
 personal?action=updPersonalInfo
 */
    NSDictionary* params = [[NSDictionary alloc]init];
    if (!IsEmptyValue(_textField.text)) {
        if ([_controller integerValue] == 1) {
            params= @{@"data":[NSString stringWithFormat:@"{\"accountname\":\"%@\",\"biaoshi\":\"biaoshi\"}",_textField.text]};
        }else if ([_controller integerValue] == 2){
            params= @{@"data":[NSString stringWithFormat:@"{\"name\":\"%@\",\"biaoshi\":\"biaoshi\"}",_textField.text]};
        }else if ([_controller integerValue] == 3){
            params= @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\",\"biaoshi\":\"biaoshi\"}",_textField.text]};
        }else if ([_controller integerValue] == 4){
            params= @{@"data":[NSString stringWithFormat:@"{\"password\":\"%@\",\"biaoshi\":\"biaoshi\"}",_textField.text]};
        }
    }
    
    [HTNetWorking postWithUrl:@"personal?action=updPersonalInfo" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"修改个人信息%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            if (!IsEmptyValue(_textField.text)) {
                if ([_controller integerValue] == 1) {
                    [[NSUserDefaults standardUserDefaults]setObject:_textField.text forKey:ACCOUNTNAME];
                }else if ([_controller integerValue] == 2){
                    [[NSUserDefaults standardUserDefaults]setObject:_textField.text forKey:USENAME];
                }else if ([_controller integerValue] == 3){
                    [[NSUserDefaults standardUserDefaults]setObject:_textField.text forKey:USERPHONE];
                }else if ([_controller integerValue] == 4){
                    [[NSUserDefaults standardUserDefaults]setObject:_textField.text forKey:PASSWORD];
                }
            }
            
            [Command customAlert:@"修改个人信息成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
