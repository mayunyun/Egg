//
//  MYYRegisterViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/5.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYRegisterViewController.h"
#import "YZXTimeButton.h"
#define SendTime 60
#import "MYYRegisterSubmitViewController.h"
#import "MYYRegistAgreementViewController.h"

@interface MYYRegisterViewController ()<UITextFieldDelegate>
{
    UITextField* _phoneField;
    UITextField* _pwdField;
    UIButton* _agreeBtn;
    BOOL _isAgreeBtn;
    BOOL _ischeckPhoneTrue;
    NSString* _checkPhone;
    NSString* _SMGCode;
}
@property (nonatomic,strong) YZXTimeButton* sendMessageBtn;
@end

@implementation MYYRegisterViewController
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

- (void)creatUI{
    
    // 1.设置背景色
    UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    bgimage.userInteractionEnabled = YES;
    bgimage.image = [UIImage imageNamed:@"登录背景"];
    [self.view addSubview:bgimage];
    
    // 2.添加子视图
    
    UIImageView *logeimage = [[UIImageView alloc]initWithFrame:CGRectMake(mScreenWidth/2-30*MYWIDTH, mScreenHeight/6+30*MYWIDTH, 60*MYWIDTH, 30*MYWIDTH)];
    logeimage.image = [UIImage imageNamed:@"注册title"];
    [bgimage addSubview:logeimage];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(45*MYWIDTH, logeimage.bottom+80*MYWIDTH, mScreenWidth-90*MYWIDTH, 200*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.layer.cornerRadius = 10;
    [bgimage addSubview:bgview];
    
    UIImageView *userimage = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, 55*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    userimage.image = [UIImage imageNamed:@"用户名"];
    [bgview addSubview:userimage];
    
    _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(userimage.right+10*MYWIDTH, userimage.top-10*MYWIDTH, bgview.width-70*MYWIDTH, 40*MYWIDTH)];
    _phoneField.placeholder = @"请输入手机号码";
    _phoneField.delegate = self;
    _phoneField.backgroundColor = UIColorFromRGB(0xefefef);
    _phoneField.textAlignment = NSTextAlignmentCenter;
    _phoneField.font = [UIFont systemFontOfSize:14];
    [bgview addSubview:_phoneField];
    
    UIImageView *passimage = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, userimage.bottom + 50*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    passimage.image = [UIImage imageNamed:@"验证码"];
    [bgview addSubview:passimage];
    
    
    _pwdField = [[UITextField alloc]initWithFrame:CGRectMake(passimage.right+10*MYWIDTH,passimage.top-10*MYWIDTH,bgview.width-150*MYWIDTH,40*MYWIDTH)];
    _pwdField.delegate = self;
    _pwdField.backgroundColor = UIColorFromRGB(0xefefef);
    _pwdField.textAlignment = NSTextAlignmentCenter;
    _pwdField.font = [UIFont systemFontOfSize:14];
    _pwdField.placeholder = @"请输入验证码";
    [bgview addSubview:_pwdField];
    
    _sendMessageBtn = [[YZXTimeButton alloc]initWithFrame:CGRectMake(_pwdField.right+10*MYWIDTH, _pwdField.top, 70*MYWIDTH, 40*MYWIDTH)];
    _sendMessageBtn.backgroundColor = NavBarItemColor;
    [_sendMessageBtn setTitle:@"获取" forState:UIControlStateNormal];
    _sendMessageBtn.layer.cornerRadius = 0;
    _sendMessageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_sendMessageBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:_sendMessageBtn];
    
    UIButton* nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.frame = CGRectMake(bgview.left, bgview.bottom+25*MYWIDTH, bgview.width, 45*MYWIDTH);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = 5;
    nextBtn.backgroundColor = NavBarItemColor;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgimage addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreeBtn.frame = CGRectMake(nextBtn.left, nextBtn.bottom+10, 30, 30);
    [_agreeBtn setImage:[UIImage imageNamed:@"xieyi"] forState:UIControlStateNormal];
    [bgimage addSubview:_agreeBtn];
    _isAgreeBtn = YES;
    [_agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(_agreeBtn.right+5, nextBtn.bottom+10, 240, 35)];
    lab.font = [UIFont systemFontOfSize:14];
    lab.text = @"我已阅读并同意《注册协议》";
    lab.textColor = UIColorFromRGB(0xCCCCCC);
    [self changeTextColor:lab Txt:lab.text changeTxt:@"《注册协议》"];
    [bgimage addSubview:lab];
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreeTapGesture:)];
    lab.userInteractionEnabled = YES;
    [lab addGestureRecognizer:aTap];
    
    
    
    
}


#pragma mark 发送验证码
- (void)sendBtnClick:(YZXTimeButton*)sender
{
    if (!IsEmptyValue(_phoneField.text)&&[Command isMobileNumber:_phoneField.text]) {
        [self checkPhoneDataRequest];
    }else{
        [self showAlert:@"手机号格式不正确"];
    }
}
//改变某字符串的颜色
- (void)changeTextColor:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变颜色
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FFFFFF"] range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
}
- (void)agreeBtnClick:(UIButton*)sender
{
    _isAgreeBtn = !_isAgreeBtn;
    if (_isAgreeBtn) {
        [_agreeBtn setImage:[UIImage imageNamed:@"xieyi"] forState:UIControlStateNormal];
    }else{
        [_agreeBtn setImage:[UIImage imageNamed:@"noxieyi"] forState:UIControlStateNormal];
    }
}

#pragma mark 注册协议点击方法
- (void)agreeTapGesture:(UITapGestureRecognizer*)tap
{
    //点击注册协议
    MYYRegistAgreementViewController* vc = [[MYYRegistAgreementViewController alloc]init];
    [vc setTransVaule:^(BOOL status) {
        if (status) {
            _isAgreeBtn = YES;
            [_agreeBtn setImage:[UIImage imageNamed:@"xieyi"] forState:UIControlStateNormal];
        }else{
            _isAgreeBtn = NO;
            [_agreeBtn setImage:[UIImage imageNamed:@"noxieyi"] forState:UIControlStateNormal];
        }
    }];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
    
}

- (void)nextBtnClick:(UIButton*)sender{

    if (_ischeckPhoneTrue == YES&&_isAgreeBtn == YES&&[_pwdField.text isEqualToString:_SMGCode]) {
        if (!IsEmptyValue(_checkPhone)) {
            MYYRegisterSubmitViewController* vc = [[MYYRegisterSubmitViewController alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            vc.phone = _checkPhone;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        if ([_pwdField.text isEqualToString:@""]) {
            [self showAlert:@"验证码不能为空"];
        }else if (![_pwdField.text isEqualToString:_SMGCode]){
            [self showAlert:@"验证码不正确"];
        }else if (_isAgreeBtn == NO){
            [self showAlert:@"请同意《注册协议》"];
        }else if (_ischeckPhoneTrue == NO){
            [self customAlert:@"请填写正确手机号"];

        }
    }
}

//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField == _phoneField) {
//        if (!IsEmptyValue(_phoneField.text)&&[Command isMobileNumber:_phoneField.text]) {
//            
//        }else{
//            [self showAlert:@"手机号格式不正确"];
//        }
//    }else if (textField == _pwdField){
//    
//    }
//}

#pragma mark isExitsPhone手机号是否注册
- (void)checkPhoneDataRequest{
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",_phoneField.text]};
    [HTNetWorking postWithUrl:@"register?action=isExitsPhone" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"手机验证%@",str);
        if ([str rangeOfString:@"true"].location != NSNotFound) {
            _ischeckPhoneTrue = YES;
            if (_ischeckPhoneTrue == YES) {
                _checkPhone = _phoneField.text;
                _sendMessageBtn.recoderTime = @"yes";
                [_sendMessageBtn setKaishi:SendTime];
                [self getSMSCodeRequest];
            }
        }else if ([str rangeOfString:@"false"].location != NSNotFound){
            _ischeckPhoneTrue = NO;
            [self customAlert:@"手机已注册"];
        }else{
            _ischeckPhoneTrue = NO;
            [self customAlert:@"手机已注册"];
        }
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark 验证码请求
- (void)getSMSCodeRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",_phoneField.text]};
    [HTNetWorking postWithUrl:@"register?action=getSMSCode" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"验证码%@",str);
        _SMGCode = [Command replaceAllOthers:str];
    } fail:^(NSError *error) {
        
    }];

}

@end
