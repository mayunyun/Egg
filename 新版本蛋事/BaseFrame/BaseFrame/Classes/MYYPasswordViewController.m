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
    userimage.image = [UIImage imageNamed:@"用户名"];
    [bgview addSubview:userimage];
    
    _textField1 = [[UITextField alloc]initWithFrame:CGRectMake(userimage.right+10*MYWIDTH, userimage.top-10*MYWIDTH, bgview.width-70*MYWIDTH, 40*MYWIDTH)];
    _textField1.placeholder = @"请输入手机号码";
    _textField1.delegate = self;
    _textField1.backgroundColor = UIColorFromRGB(0xefefef);
    _textField1.textAlignment = NSTextAlignmentCenter;
    _textField1.font = [UIFont systemFontOfSize:14];
    [bgview addSubview:_textField1];
    
    UIImageView *passimage = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, userimage.bottom + 50*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    passimage.image = [UIImage imageNamed:@"验证码"];
    [bgview addSubview:passimage];
    
    
    _textField2 = [[UITextField alloc]initWithFrame:CGRectMake(passimage.right+10*MYWIDTH,passimage.top-10*MYWIDTH,bgview.width-150*MYWIDTH,40*MYWIDTH)];
    _textField2.delegate = self;
    _textField2.backgroundColor = UIColorFromRGB(0xefefef);
    _textField2.textAlignment = NSTextAlignmentCenter;
    _textField2.font = [UIFont systemFontOfSize:14];
    _textField2.placeholder = @"请输入验证码";
    [bgview addSubview:_textField2];
    
    _messageBtn = [[YZXTimeButton alloc]initWithFrame:CGRectMake(_textField2.right+10*MYWIDTH, _textField2.top, 70*MYWIDTH, 40*MYWIDTH)];
    _messageBtn.backgroundColor = NavBarItemColor;
    [_messageBtn setTitle:@"获取" forState:UIControlStateNormal];
    _messageBtn.layer.cornerRadius = 0;
    _messageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_messageBtn addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:_messageBtn];
    
    UIButton* nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.frame = CGRectMake(bgview.left, bgview.bottom+25*MYWIDTH, bgview.width, 45*MYWIDTH);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = 5;
    nextBtn.backgroundColor = NavBarItemColor;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgimage addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nestBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
   
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
