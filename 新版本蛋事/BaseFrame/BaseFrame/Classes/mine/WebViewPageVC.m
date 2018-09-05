//
//  WebViewPageVC.m
//  BaseFrame
//
//  Created by 钱龙 on 2018/4/3.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "WebViewPageVC.h"

@interface WebViewPageVC ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView * webView;

@end

@implementation WebViewPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL * url = [[NSURL alloc]initWithString:self.urlString];
    _webView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENHEIGHT)];
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}
//几个代理方法

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"webViewDidStartLoad");
    
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    
    NSLog(@"webViewDidFinishLoad");
    
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    
    NSLog(@"DidFailLoadWithError");
    
}

@end
