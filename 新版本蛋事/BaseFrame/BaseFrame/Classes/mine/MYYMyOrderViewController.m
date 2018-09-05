//
//  MYYMyOrderViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYMyOrderViewController.h"
#import "MYYMyOrderSouSuoViewController.h"
@interface MYYMyOrderViewController ()

@end


@implementation MYYMyOrderViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置状态栏颜色
    [self setStatusBarBackgroundColor:UIColorFromRGB(0xFFA500)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    

}

- (NSMutableArray *)childViews
{
    if(_childViews==nil)
    {
        _childViews =[NSMutableArray array];
    }
    return _childViews;
}

- (UIScrollView *)scrollView
{
    if(_scrollView==nil)
    {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, mScreenWidth, mScreenHeight -104)];
        _scrollView.delegate=self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(5 * mScreenWidth, 0);
        _scrollView.bounces = NO;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}


- (MYYMyOrderHeaderTitleView *)titleView
{
    if(_titleView==nil)
    {
        _titleView =[MYYMyOrderHeaderTitleView new];
        _titleView.delegate=self;
        _titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
        [self.view addSubview:_titleView];
    }
    return _titleView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的订单";
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastViewController:)];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xffffff)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_ico2"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarToLastViewController:)];
    [self.navigationItem.rightBarButtonItem setTintColor:UIColorFromRGB(0xffffff)];
    
    //添加头部的view
    [self titleView];
    
    //添加scrollView
    [self scrollView];
    
    //添加各子控制器
    [self setupChildVcs];
    
}
- (void)rightBarToLastViewController:(UIButton *)button
{
    MYYMyOrderSouSuoViewController *vc = [[MYYMyOrderSouSuoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)backToLastViewController:(UIButton *)button
{
    //[Public hideLoadingView];
    if ([self.pay isEqualToString:@"pay"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark 添加各子控制器
- (void)setupChildVcs
{
    //全部控制器
    MYYAllOrderViewController *allVc =[MYYAllOrderViewController new];
    [self addChildViewController:allVc];
    [self.childViews addObject:allVc.view];
    
    //待付款控制器
    MYYPayMentOrderViewController *paymentVc =[MYYPayMentOrderViewController new];
    [self addChildViewController:paymentVc];
    [self.childViews addObject:paymentVc.view];
    
    //待发款控制器
    MYYFaHuoViewController *fahuoVc =[MYYFaHuoViewController new];
    [self addChildViewController:fahuoVc];
    [self.childViews addObject:fahuoVc.view];
    
    //待收货控制器
    MYYGoodsOrderViewController *goodsVc =[MYYGoodsOrderViewController new];
    [self addChildViewController:goodsVc];
    [self.childViews addObject:goodsVc.view];
    
    //待评价控制器
    MYYCompleteOrderViewController *completeVc =[MYYCompleteOrderViewController new];
    [self addChildViewController:completeVc];
    [self.childViews addObject:completeVc.view];
    
    for(int i=0;i<self.childViews.count;i++)
    {
        UIView *childV = self.childViews[i];
        CGFloat childVX = mScreenWidth * i ;
        childV.frame = CGRectMake(childVX, 0, mScreenWidth, self.view.frame.size.height - _titleView.frame.size.height);
        [_scrollView addSubview:childV];
        
    }
    
    
}


#pragma mark 滚动条
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.view endEditing:YES];
    
    
    if(scrollView==_scrollView)
    {
        if(_scrollView.contentOffset.x / mScreenWidth ==0)
        {
            [_titleView wanerSelected:0];
        }
        else if (_scrollView.contentOffset.x / mScreenWidth ==1)
        {
            [_titleView wanerSelected:1];
        }else if (_scrollView.contentOffset.x / mScreenWidth ==2)
        {
            [_titleView wanerSelected:2];
        }else if (_scrollView.contentOffset.x / mScreenWidth ==3)
        {
            [_titleView wanerSelected:3];
        }else if (_scrollView.contentOffset.x / mScreenWidth ==4)
        {
            [_titleView wanerSelected:4];
        }
        
    }
}

#pragma mark titleView的方法
- (void)titleView:(MYYMyOrderHeaderTitleView *)titleView scollToIndex:(NSInteger)tagIndex
{
    
    
    [_scrollView setContentOffset:CGPointMake(tagIndex * mScreenWidth, 0) animated:YES];
   
    NSString * str = [NSString stringWithFormat:@"%zd",tagIndex];
    NSDictionary *dict = @{@"one":str};
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"orderUpData" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
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
