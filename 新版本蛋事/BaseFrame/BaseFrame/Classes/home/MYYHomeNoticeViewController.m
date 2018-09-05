//
//  MYYHomeNoticeViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/9.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYHomeNoticeViewController.h"

@interface MYYHomeNoticeViewController ()<UIWebViewDelegate>
{
    UIWebView* _webView;
    CGFloat _documentHeight;
    MBProgressHUD* _hud;
}
@end

@implementation MYYHomeNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公告";
   
    [self creatUI];
    [self dataRequest];
    
}

- (void)creatUI{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(10, 10, kScreen_Width - 20, kScreen_Height - 64 - 10)];
    _webView.delegate = self;
    [self.view addSubview:_webView];

    

}

- (void)dataRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"id\":\"%@\"}",self.noticeid]};
    [HTNetWorking postWithUrl:@"notice?action=getNoticeDetail" refreshCache:YES params:params success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            NSDictionary* dict = array[0];
            //在此处加载webView的原因是：不能在tableViewcell中加载网页那样会造成因为cellForRowAtIndexPath和webViewDidFinishLoad代理互相调用引起的内存泄漏。
            NSString* linkCss = @"<style type=\"text/css\"> img {"
            "width:100%;"
            "height:auto;"
            "}"
            "</style>";
            NSString* baseurl = HTImgUrl;//[HTServerConfig getHTServerAddr];
            NSString* imageurl = [self replaceAllOthers:baseurl];
            if (!IsEmptyValue(dict[@"note"])) {
                [_webView loadHTMLString:[NSString stringWithFormat:@"%@%@",dict[@"note"],linkCss] baseURL:[NSURL URLWithString:imageurl]];
            }
        }
    } fail:^(NSError *error) {
        
    }];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth,oldheight;"
     "var maxwidth=300;"// 图片宽度
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "myimg.width = maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    CGFloat documentHeight= [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
//    NSLog(@"webView的高度-----%f",documentHeight);
    _documentHeight = documentHeight;
    _webView.scrollView.contentSize = CGSizeMake(kScreen_Width - 20, documentHeight);
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

//请求到的是字符串需要处理一下
- (NSString *)replaceAllOthers:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"/danshi1" withString:@""];
    return returnString;
}


@end
