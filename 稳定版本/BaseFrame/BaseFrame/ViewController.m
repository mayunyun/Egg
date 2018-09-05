//
//  ViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/3/2.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    MBProgressHUD* _hud;
}
/**
 *  videos数组
 */
@property (strong, nonatomic) NSMutableArray *videosData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



#pragma mark - getter
- (NSMutableArray *)videosData
{
    return HT_LAZY(_videosData, @[].mutableCopy);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
