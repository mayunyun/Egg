//
//  MYYSaoMiaoLoginViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/17.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYSaoMiaoLoginViewController.h"

@interface MYYSaoMiaoLoginViewController ()

@end

@implementation MYYSaoMiaoLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"确认登录";
}
- (IBAction)saomiaoLogin:(UIButton *)sender {
    /*
     mallLogin?action=saomaMallLogin
     */
    NSString* accountname= [[NSUserDefaults standardUserDefaults]objectForKey:ACCOUNTNAME];
    NSString* pwd = [[NSUserDefaults standardUserDefaults]objectForKey:PASSWORD];
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"accountname\":\"%@\",\"password\":\"%@\",\"uuid\":\"%@\"}",accountname,pwd,_uuid]};
    NSSLog(@"%@",params);
    [HTNetWorking postWithUrl:@"mallLogin?action=confirmLogin" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSSLog(@"登录数据%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self customAlert:@"登录失败"];
        }
    } fail:^(NSError *error) {
        
    }];

}
- (IBAction)cancel:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
