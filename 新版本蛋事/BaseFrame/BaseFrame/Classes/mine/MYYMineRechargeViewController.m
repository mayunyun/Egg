//
//  MYYMineRechargeViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYMineRechargeViewController.h"
#import "MYYMineRechargeView.h"
#import "MYYMineOnlineRechrageViewController.h"
#import "MYYMineCardRechargeViewController.h"

@interface MYYMineRechargeViewController ()<MYYMineRechargeViewDelegate,UIScrollViewDelegate>
//头部的选项卡
@property(nonatomic,strong) MYYMineRechargeView *titleView;
//滚动条
@property(nonatomic,strong) UIScrollView *scrollView;
//大数组，子控制器的
@property(nonatomic,strong) NSMutableArray *childViews;

@end

@implementation MYYMineRechargeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置状态栏颜色
    [self setStatusBarBackgroundColor:UIColorFromRGB(0xFFA500)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastViewController:)];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xffffff)];
    
    //添加头部的view
    [self titleView];
    
    //添加scrollView
    [self scrollView];
    
    //添加各子控制器
    [self setupChildVcs];
    
}
- (void)backToLastViewController:(UIButton *)button
{
    //[Public hideLoadingView];
    [self.navigationController popViewControllerAnimated:YES];
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
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, mScreenWidth, mScreenHeight -64-40)];
        _scrollView.delegate=self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(3 * mScreenWidth, 0);
        _scrollView.bounces = NO;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}


- (MYYMineRechargeView *)titleView
{
    if(_titleView==nil)
    {
        _titleView =[MYYMineRechargeView new];
        _titleView.delegate=self;
        _titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
        [self.view addSubview:_titleView];
    }
    return _titleView;
}

#pragma mark 添加各子控制器
- (void)setupChildVcs
{
    //点菜控制器
    MYYMineOnlineRechrageViewController *foodVc =[MYYMineOnlineRechrageViewController new];
    [self addChildViewController:foodVc];
    [self.childViews addObject:foodVc.view];
    
    //评价控制器
    MYYMineCardRechargeViewController *detailsVc =[MYYMineCardRechargeViewController new];
    [self addChildViewController:detailsVc];
    [self.childViews addObject:detailsVc.view];
    
    
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
        }
        
        
    }
}


#pragma mark titleView的方法
- (void)titleView:(MYYMineRechargeView *)titleView scollToIndex:(NSInteger)tagIndex
{
    [_scrollView setContentOffset:CGPointMake(tagIndex * mScreenWidth, 0) animated:YES];
}


@end
