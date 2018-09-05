//
//  ProductDetailPageVC.m
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/14.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "ProductDetailPageVC.h"
#import "MYYDetailsTitleView.h"
#import "ChildrenProcuctVC.h"
#import "MYYDetailsViewController.h"
#import "MYYCommentViewController.h"
#import "ProCommenPageVC.h"
#import "MYYLoginViewController.h"
@interface ProductDetailPageVC()<MYYDetailsTitleViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    ChildrenProcuctVC *_foodVc;
    MYYDetailsViewController * _detailsVc;
    ProCommenPageVC *_commentVc;
    UITextField* _countField;
    UIButton* _addBtn;
    UIButton* _reduceBtn;
    
}
//头部的选项卡
@property(nonatomic,strong) MYYDetailsTitleView *titleView;

//滚动条
@property(nonatomic,strong) UIScrollView *scrollView;

//大数组，子控制器的
@property(nonatomic,strong) NSMutableArray *childViews;


@end

@implementation ProductDetailPageVC

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
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight-TabbarHeight-50)];
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
- (MYYDetailsTitleView *)titleView
{
    if(_titleView==nil)
    {
        _titleView =[MYYDetailsTitleView new];
        _titleView.delegate=self;
        _titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
        [self.navigationItem setTitleView:_titleView];
        
    }
    return _titleView;
}
//在页面出现的时候就将黑线隐藏起来
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = NO;
    //设置状态栏颜色
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

//在页面消失的时候就让navigationbar还原样式
-(void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"";
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0x333333)];
    //添加头部的view
    [self titleView];
    //添加scrollView
    [self scrollView];
    //添加各子控制器
    [self setupChildVcs:self.proid type:self.type];
    [self shopButtonView];
}


#pragma mark 添加各子控制器
- (void)setupChildVcs:(NSString *)proid type:(NSString *)type;
{
    //点菜控制器
    _foodVc =[ChildrenProcuctVC new];
    _foodVc.proid = proid;
    _foodVc.type = type;
    [self addChildViewController:_foodVc];
    [self.childViews addObject:_foodVc.view];
    __weak typeof (UIScrollView*)weakscrollView = _scrollView;
    __weak typeof (MYYDetailsTitleView*)weaktitleView = _titleView;
    [_foodVc setTransVaule:^(BOOL isClick) {
        [weakscrollView setContentOffset:CGPointMake(2 * mScreenWidth, 0) animated:YES];
        [weaktitleView wanerSelected:2];
    }];
    
    void(^headerTitleNumer)(NSInteger integer) = ^(NSInteger integer){
        [_titleView wanerSelected:integer];
        [_scrollView setContentOffset:CGPointMake(integer * mScreenWidth, 0) animated:YES];
        
    };
    _foodVc.headerTitleNumer = headerTitleNumer;
    void(^recommendBlock)(NSString *proid,NSString *type) = ^(NSString *proid,NSString *type){
        [self setupViewChildViews:proid type:type];
    };
    _foodVc.recommendBlock = recommendBlock;
    //评价控制器
    _detailsVc =[MYYDetailsViewController new];
    _detailsVc.proid = proid;
    _detailsVc.type = type;
    [self addChildViewController:_detailsVc];
    [self.childViews addObject:_detailsVc.view];
    
    //商家控制器
    _commentVc =[ProCommenPageVC new];
    _commentVc.proid = proid;
    _commentVc.type = type;
    [self addChildViewController:_commentVc];
    [self.childViews addObject:_commentVc.view];
    
    
    for(int i=0;i<self.childViews.count;i++)
    {
        UIView *childV = self.childViews[i];
        CGFloat childVX = mScreenWidth * i ;
        childV.frame = CGRectMake(childVX, 0, mScreenWidth, self.view.frame.size.height - _titleView.frame.size.height);
        [_scrollView addSubview:childV];
        
    }
}
- (void)setupViewChildViews:(NSString *)proid type:(NSString *)type{
    
    _foodVc.proid = proid;
    _foodVc.type = type;
    [_foodVc setUpView];
    //评价控制器
    _detailsVc.proid = proid;
    _detailsVc.type = type;
    [_detailsVc setUpViewDetails];
    //商家控制器
    _commentVc.proid = proid;
    _commentVc.type = type;
//    [_commentVc setUpViewComment];
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
- (void)titleView:(MYYDetailsTitleView *)titleView scollToIndex:(NSInteger)tagIndex
{
    [_scrollView setContentOffset:CGPointMake(tagIndex * mScreenWidth, 0) animated:YES];
}


- (void)gouwuche{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:IsLogin] isEqualToString:@"1"]) {
        if (self.tabBarController.selectedIndex == 2) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            self.tabBarController.selectedIndex = 2;//跳转
        }
    }else{
        NSArray *titleArray = @[@"确定"];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"进入购物车需要您登录！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
        for (NSString *str in titleArray) {
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                MYYLoginViewController* vc = [[MYYLoginViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [alert addAction:cancelAction];
        }
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)shopButtonView{
//    UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(0, mScreenHeight-45-TabbarHeight, mScreenWidth, 0.5)];
//    xian.backgroundColor = UIColorFromRGB(0x999999);
//    [self.view addSubview:xian];
    UIButton *goShop = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth/2, mScreenHeight-50-NavBarHeight, mScreenWidth/2, 50)];
    [goShop setTitle:@"立刻购买" forState:UIControlStateNormal];
    goShop.titleLabel.font = [UIFont systemFontOfSize:16];
    [goShop setBackgroundColor:UIColorFromRGB(0xFF0000)];
    [goShop addTarget:self action:@selector(goShopping:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goShop];
    NSLog(@"--------%.2d",TabbarHeight);
    UIButton *Shopcar = [[UIButton alloc]initWithFrame:CGRectMake(0, mScreenHeight-50-NavBarHeight, mScreenWidth/2, 50)];
    [Shopcar setTitle:@"加入购物车" forState:UIControlStateNormal];
    Shopcar.titleLabel.font = [UIFont systemFontOfSize:16];
    [Shopcar setBackgroundColor:UIColorFromRGB(0xFFB500)];
    [Shopcar addTarget:self action:@selector(Shopcaring:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Shopcar];

}
- (void)goShopping:(UIButton*)sender{
    
    [_foodVc payProClick:sender];
    
}
- (void)Shopcaring:(UIButton*)sender{
    [_foodVc setButtonClick:sender];
}
@end
