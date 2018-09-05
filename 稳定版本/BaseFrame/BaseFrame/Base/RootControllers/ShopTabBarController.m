//
//  ShopTabBarController.m
//  PingChuan
//
//  Created by kongdezhi on 15/7/23.
//  Copyright (c) 2015年 三米科技. All rights reserved.
//

#import "HomePageVC.h"
#import "AllCategoryListViewController.h"
#import "MinePageVC.h"

#import "ShopTabBarController.h"
//#import "MYYHomeViewController.h"

#import "MYYShopCarViewController.h"
#import "MYYMineViewController.h"

@interface ShopTabBarController ()

@end

@implementation ShopTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
//    [self preferredStatusBarStyle];
    [self initVC];
    

}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)initVC{

    HomePageVC *shopMainVC   = [[HomePageVC alloc] init];
    UINavigationController *mainNav     = [[UINavigationController alloc] initWithRootViewController:shopMainVC];
    mainNav.viewControllers             = @[shopMainVC];
    mainNav.tabBarItem.enabled          = YES;
    shopMainVC.tabBarItem.image         = [UIImage imageNamed:@"icon-1"];
    UINavigationBar *bar                = self.navigationController.navigationBar;
    bar.barTintColor = [UIColor redColor];
    shopMainVC.title = @"首页";
    // [shopMainVC.leftButton addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    
    //
    
    AllCategoryListViewController *smallMarketPublishVC = [[AllCategoryListViewController alloc] init];
    UINavigationController *publishNav = [[UINavigationController alloc] initWithRootViewController:smallMarketPublishVC];
    publishNav.viewControllers  = @[smallMarketPublishVC];
    publishNav.tabBarItem.enabled = YES;
    smallMarketPublishVC.tabBarItem.image = [UIImage imageNamed:@"icon-3"];
    smallMarketPublishVC.title = @"分类";
    
    
    //
//    MYYShopCarViewController *shopCartVC = [[MYYShopCarViewController alloc] init];
//    UINavigationController *shopCartNav = [[UINavigationController alloc] initWithRootViewController:shopCartVC];
//    shopCartNav.viewControllers = @[shopCartVC];
//    shopCartNav.tabBarItem.enabled = YES;
//    shopCartVC.tabBarItem.image = [UIImage imageNamed:@"icon-5"];
//    shopCartVC.title = @"购物车";
    
    
    //我的
    MinePageVC *smallMarketMyVC = [[MinePageVC alloc] init];
    UINavigationController *myNav = [[UINavigationController alloc] initWithRootViewController:smallMarketMyVC];
    myNav.viewControllers = @[smallMarketMyVC];
    myNav.tabBarItem.enabled = YES;
    smallMarketMyVC.tabBarItem.image = [UIImage imageNamed:@"icon-7"];
    smallMarketMyVC.title = @"我的";
    
    NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:mainNav,publishNav,myNav,nil];
    self.viewControllers = list;
    //标题默认颜色
    UIColor *normalColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       normalColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    //标题选择时的高亮颜色
    UIColor *titleHighlightedColor = TabBarColor;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    //
    NSArray *imgArray = @[@"icon-1",
                          @"icon-3",
//                          @"icon-5",
                          @"icon-7"];
    NSArray *selectImgArray =   @[@"icon-2",
                                  @"icon-4",
//                                  @"icon-6",
                                  @"icon-8"];
    
    for (int i = 0; i < 3; i++) {
        UIViewController *vc = list[i];
        vc.tabBarItem.tag = i;
        
        NSString *imageStr = imgArray[i];
        NSString *selectImageStr = selectImgArray[i];
        if (IOS7) {
            //渲染模式
            vc.tabBarItem.image = [[UIImage imageNamed:imageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        } else {
            //            [vc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:selectImageStr] withFinishedUnselectedImage:[UIImage imageNamed:imageStr]];
            vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:selectImageStr] selectedImage:[UIImage imageNamed:imageStr]];
        }
    }

}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (viewController.tabBarItem.tag==0) {
        NSLog(@"0000");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"home" object:self];
    }
    if (viewController.tabBarItem.tag==1) {
        NSLog(@"1111");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"care" object:self];
    }
    if (viewController.tabBarItem.tag==2) {
        NSLog(@"2222");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"car" object:self];
    }
    if (viewController.tabBarItem.tag==3) {
        NSLog(@"3333");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"my" object:self];
    }
}
//禁止tab多次点击
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UIViewController *tbselect=tabBarController.selectedViewController;
    if([tbselect isEqual:viewController]){
        return NO;
    }
    return YES;
}

//- (void)netWork
//{
//    if (![NetWorkHelper isConnectedToNetwork]) {
//        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请检查网络原因" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//        
//        [NSTimer scheduledTimerWithTimeInterval:1.5f
//                                         target:self
//                                       selector:@selector(timerFireMethod:)
//                                       userInfo:promptAlert
//                                        repeats:YES];
//        [promptAlert show];
//    }
//}
//提示弹出框
//- (void)timerFireMethod:(NSTimer*)theTimer
//{
//    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
//    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
//    promptAlert = NULL;
//}


@end
