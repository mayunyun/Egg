//
//  MYYRegistAgreementViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/6/28.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYRegistAgreementViewController.h"

@interface MYYRegistAgreementViewController ()<UIWebViewDelegate>
{
    UIWebView* _webView;
    MBProgressHUD* _hud;
}


@end

@implementation MYYRegistAgreementViewController
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
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    
}

- (void)creatUI{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 10, kScreen_Width, kScreen_Height - 10 - 40)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSString* baseurl = [HTServerConfig getHTServerAddr];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@eggMatter/weixinpage/register/deal.html",baseurl]]]];
    
    UIButton* agreeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    agreeBtn.frame = CGRectMake(10, kScreen_Height - 35, 80, 30);
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    agreeBtn.backgroundColor = NavBarItemColor;
    agreeBtn.layer.masksToBounds = YES;
    agreeBtn.layer.cornerRadius = 5;
    [self.view addSubview:agreeBtn];
    [agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(kScreen_Width - 10 - 80, kScreen_Height - 35, 80, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = GrayTitleColor;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 5;
    [self.view addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)agreeBtnClick:(UIButton*)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (_transVaule) {
            _transVaule(YES);
        }
    }];
}

- (void)cancelBtnClick:(UIButton*)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (_transVaule) {
            _transVaule(NO);
        }
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [_hud hideAnimated:YES];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //    NSLog(@"webViewDidStartLoad");
    //进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
    [_hud showAnimated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nonnull NSError *)error
{
    //    NSLog(@"didFailLoadWithError===%@", error);
    
}





@end
