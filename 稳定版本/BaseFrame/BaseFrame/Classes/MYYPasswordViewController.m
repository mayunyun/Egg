//
//  MYYPasswordViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/5.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYPasswordViewController.h"
#import "MYYPasswordSubmitViewController.h"
#import "YZXTimeButton.h"
#define SendTime 60
@interface MYYPasswordViewController ()<UITextFieldDelegate>{
    BOOL _ischeckPhoneTrue;
    NSString* _checkPhone;
    NSString* _SMGCode;
}
@property(nonatomic,strong)UITextField *textField1;

@property(nonatomic,strong)UITextField *textField2;

@property(nonatomic,strong)YZXTimeButton *messageBtn;//

@property(nonatomic,strong)UIButton *nestBtn;//
@end

@implementation MYYPasswordViewController

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
    self.textField1.keyboardType = UIKeyboardTypeNumberPad;
    self.textField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField1.layer.borderColor = [UIColor grayColor].CGColor;
    self.textField1.placeholder = @"请输入手机号";
    [self.textField1 setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:self.textField1];
    
    UILabel *xian1 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField1.frame)+1, mScreenWidth - 40, 1)];
    xian1.backgroundColor = UIColorFromRGB(0xefefef);
    [self.view addSubview:xian1];
    
   
    
    self.textField2 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.textField1.frame), CGRectGetMaxY(self.textField1.frame)+20, CGRectGetWidth(self.textField1.frame)-80, CGRectGetHeight(self.textField1.frame))];
    self.textField2.delegate = self;
    self.textField2.layer.cornerRadius = 5;
    self.textField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField2.layer.borderColor = [UIColor grayColor].CGColor;
    self.textField2.placeholder = @"请输入验证码";
    [self.textField2 setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:self.textField2];
    
    self.messageBtn = [[YZXTimeButton alloc]initWithFrame:CGRectMake(mScreenWidth-100, CGRectGetMaxY(self.textField1.frame)+10, 80, CGRectGetHeight(self.textField1.frame)+5)];
    [self.messageBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.messageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.messageBtn.layer.cornerRadius = 5;
    [self.messageBtn setBackgroundColor:NavBarItemColor];
    [self.messageBtn addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.messageBtn];
    
    UILabel *xian2 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField2.frame)+1, mScreenWidth - 40, 1)];
    xian2.backgroundColor = UIColorFromRGB(0xefefef);
    [self.view addSubview:xian2];
    
    self.nestBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField2.frame)+40, mScreenWidth-40, 45)];
    [self.nestBtn setTitle:@"下一步" forState:UIControlStateNormal];
    self.nestBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.nestBtn.layer.cornerRadius = 5;
    [self.nestBtn setBackgroundColor:NavBarItemColor];
    [self.nestBtn addTarget:self action:@selector(nestBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nestBtn];
    
   
}
- (void)nestBtnAction:(UIButton *)sender{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    if (_ischeckPhoneTrue == YES&&[self.textField2.text isEqualToString:_SMGCode]) {
        if (!IsEmptyValue(_checkPhone)) {
            MYYPasswordSubmitViewController *pwsVC = [[MYYPasswordSubmitViewController alloc]init];
            pwsVC.phone = _checkPhone;
            [self.navigationController pushViewController:pwsVC animated:YES];
        }
    }else{
        [self showAlert:@"手机号或验证码不正确"];
    }
}
//发送验证码
- (void)messageBtnAction:(UIButton *)sender{
    if (![Command isMobileNumber:self.textField1.text]) {
        [self customAlert:@"请输入正确手机号"];
        return;
    }
    if (!IsEmptyValue(self.textField1.text)) {
        [self checkPhoneRequest];
    }
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

#pragma mark 验证号码是否注册过
- (void)checkPhoneRequest{
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",self.textField1.text]};
    [HTNetWorking postWithUrl:@"register?action=isExitsPhone" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"检查手机%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            //此号码为没有注册
            _ischeckPhoneTrue = NO;
        }else{
            if (!IsEmptyValue([self tryToParseData:response])) {
                _ischeckPhoneTrue = YES;
                if (_ischeckPhoneTrue == YES) {
                    _checkPhone = self.textField1.text;
                    self.messageBtn.recoderTime = @"yes";
                    [self.messageBtn setKaishi:SendTime];
                    [self getSMSCodeRequest];
                }
            }
        }
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark 验证码请求
- (void)getSMSCodeRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",self.textField1.text]};
    [HTNetWorking postWithUrl:@"register?action=getSMSCode" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"验证码%@",str);
        _SMGCode = [Command replaceAllOthers:str];
    } fail:^(NSError *error) {
        
    }];
    
}

// 解析json数据
- (id)tryToParseData:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSArray class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSArray class]]){
            dic = nil;
        }
    }
    return dic;
}
@end
