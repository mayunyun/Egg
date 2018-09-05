//
//  MYYShopCarViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/3/24.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYShopCarViewController.h"
#import "JVShopcartTableViewProxy.h"
#import "JVShopcartBottomView.h"
#import "JVShopcartCell.h"
#import "JVShopcartHeaderView.h"
#import "JVShopcartFormat.h"
#import "Masonry.h"
#import "JVShopcartBrandModel.h"
#import "MYYShopOrderViewController.h"
#import "MYYLoginViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface MYYShopCarViewController ()<JVShopcartFormatDelegate>
@property (nonatomic, strong) UITableView *shopcartTableView;   /**< 购物车列表 */
@property (nonatomic, strong) JVShopcartBottomView *shopcartBottomView;    /**< 购物车底部视图 */
@property (nonatomic, strong) JVShopcartTableViewProxy *shopcartTableViewProxy;    /**< tableView代理 */
@property (nonatomic, strong) JVShopcartFormat *shopcartFormat;    /**< 负责购物车逻辑处理 */
@property (nonatomic, strong) UIButton *editButton;    /**< 编辑按钮 */

@property (nonatomic, strong) UIView *backView;//空购物车View

@property (nonatomic, strong) NSArray *gouwuchearr;//购物车
@property (nonatomic, assign) float xiaojiCount;//小计

@end

@implementation MYYShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _gouwuchearr = [[NSArray alloc]init];

    [Command isloginRequest:^(bool str) {
        if (str) {
            //登录成功
            [self addSubview];
            [self layoutSubview];
            [self requestShopcartListData];
        }else{
            //登录失败
            //[self addkongView];
            MYYLoginViewController *login = [[MYYLoginViewController alloc]init];
//            login.next = 1;
//            login.fd_interactivePopDisabled = YES;
            [self.navigationController pushViewController:login animated:NO];

        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置状态栏颜色
    [self setStatusBarBackgroundColor:UIColorFromRGB(0xFFA500)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

//    [Command isloginRequest:^(bool str) {
//        if (str) {
//            //登录成功
//            //self.backView.hidden = YES;
//            [self addSubview];
//            [self layoutSubview];
//            [self requestShopcartListData];
//
//        }else{
//            //登录失败
////            [_shopcartTableView removeFromSuperview];
////            [_shopcartBottomView removeFromSuperview];
////            self.backView.hidden = NO;
////            if (self.backView==nil) {
////                [self addkongView];
////            }
//            MYYLoginViewController *login = [[MYYLoginViewController alloc]init];
////            login.next = 1;
////            login.fd_interactivePopDisabled = YES;
//            [self.navigationController pushViewController:login animated:NO];
//        }
//    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
//购物车为空
- (void)addkongView{
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    self.backView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(mScreenWidth/2-30, mScreenHeight/7*2, 60, 60)];
    image.image = [UIImage imageNamed:@"空购物车"];
    [self.backView addSubview:image];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame)+10, mScreenWidth, 20)];
    lab.text = @"您的购物车还是空的";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = UIColorFromRGB(0x333333);
    lab.font = [UIFont systemFontOfSize:14];
    [self.backView addSubview:lab];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth/2-50, CGRectGetMaxY(lab.frame)+10, 100, 30)];
    [but.layer setCornerRadius:3];
    [but.layer setBorderColor:UIColorFromRGB(0x666666).CGColor];
    [but.layer setBorderWidth:0.5];
    [but.layer setMasksToBounds:YES];
    [but setTitle:@"首页逛逛" forState:UIControlStateNormal];
    [but setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [but setBackgroundColor:[UIColor clearColor]];
    [but addTarget:self action:@selector(homeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:but];
    
    [self.view addSubview:self.backView];
}
- (void)homeClick{
    self.tabBarController.selectedIndex = 0;
}
- (void)requestShopcartListData {
    [self.shopcartFormat requestShopcartProductList];//购物车数据
}

#pragma mark JVShopcartFormatDelegate
//购物车
- (void)shopcartFormatRequestProductListDidSuccessWithArray:(NSMutableArray *)dataArray nsarry:(NSArray *)arr{
    self.shopcartTableViewProxy.dataArray = dataArray;
    [self.shopcartTableView reloadData];
}
- (void)shopcartFormatAccountForTotalPrice:(float)totalPrice totalCount:(NSInteger)totalCount isAllSelected:(BOOL)isAllSelected {
    [self.shopcartBottomView configureShopcartBottomViewWithTotalPrice:totalPrice totalCount:totalCount isAllselected:isAllSelected];
    self.xiaojiCount = totalPrice;
    NSLog(@"%f",totalPrice);
    self.shopcartTableViewProxy.xiaojiCount = totalPrice;
    
    [self.shopcartTableView reloadData];
}
- (void)shopcartFormatSettleForSelectedProducts:(NSArray *)selectedProducts {
    _gouwuchearr = selectedProducts;
}

- (void)shopcartFormatWillDeleteSelectedProducts:(NSArray *)selectedProducts {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"确认要删除这%ld个宝贝吗？", selectedProducts.count] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.shopcartFormat deleteSelectedProducts:selectedProducts];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)shopcartFormatHasDeleteAllProducts {
    
}

#pragma mark getters

- (UITableView *)shopcartTableView {
    if (_shopcartTableView == nil){
        _shopcartTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _shopcartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_shopcartTableView registerClass:[JVShopcartCell class] forCellReuseIdentifier:@"JVShopcartCell"];
        _shopcartTableView.showsVerticalScrollIndicator = NO;
        _shopcartTableView.delegate = self.shopcartTableViewProxy;
        _shopcartTableView.dataSource = self.shopcartTableViewProxy;
//        _shopcartTableView.rowHeight = 120;
//        _shopcartTableView.sectionFooterHeight = 5;
        _shopcartTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _shopcartTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    }
    return _shopcartTableView;
}

- (JVShopcartTableViewProxy *)shopcartTableViewProxy {
    if (_shopcartTableViewProxy == nil){
        _shopcartTableViewProxy = [[JVShopcartTableViewProxy alloc] init];
        _shopcartTableViewProxy.viewController = self;
        __weak __typeof(self) weakSelf = self;
        _shopcartTableViewProxy.shopcartProxyProductSelectBlock = ^(BOOL isSelected, NSIndexPath *indexPath){
            [weakSelf.shopcartFormat selectProductAtIndexPath:indexPath isSelected:isSelected];
        };
        
        _shopcartTableViewProxy.shopcartProxyBrandSelectBlock = ^(BOOL isSelected){
            [weakSelf.shopcartFormat selectBrandAtSectionisSelected:isSelected];
        };
        
        _shopcartTableViewProxy.shopcartProxyChangeCountBlock = ^(NSInteger count, NSIndexPath *indexPath){
            [weakSelf.shopcartFormat changeCountAtIndexPath:indexPath count:count];
        };
        
        _shopcartTableViewProxy.shopcartProxyDeleteBlock = ^(NSIndexPath *indexPath){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认要删除这个宝贝吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.shopcartFormat deleteProductAtIndexPath:indexPath];
            }]];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        };
        
        _shopcartTableViewProxy.shopcartProxyStarBlock = ^(NSIndexPath *indexPath){
            [weakSelf.shopcartFormat starProductAtIndexPath:indexPath];
        };
    }
    return _shopcartTableViewProxy;
}

- (JVShopcartBottomView *)shopcartBottomView {
    if (_shopcartBottomView == nil){
        _shopcartBottomView = [[JVShopcartBottomView alloc] init];
        
        __weak __typeof(self) weakSelf = self;
        _shopcartBottomView.shopcartBotttomViewAllSelectBlock = ^(BOOL isSelected){
            [weakSelf.shopcartFormat selectAllProductWithStatus:isSelected];
        };
        
        //结算
        _shopcartBottomView.shopcartBotttomViewSettleBlock = ^(){
            [weakSelf.shopcartFormat settleSelectedProducts];
            MYYShopOrderViewController *orderView = [[MYYShopOrderViewController alloc]init];
            orderView.hidesBottomBarWhenPushed = YES;
            orderView.dataArr = weakSelf.gouwuchearr;
            orderView.xiaojicount = weakSelf.xiaojiCount;
            orderView.next = 1;
            [weakSelf.navigationController pushViewController:orderView animated:YES];
        };
        //收藏
//        _shopcartBottomView.shopcartBotttomViewStarBlock = ^(){
//            [weakSelf.shopcartFormat starSelectedProducts];
//        };
        //删除
        _shopcartBottomView.shopcartBotttomViewDeleteBlock = ^(){
            [weakSelf.shopcartFormat beginToDeleteSelectedProducts];
        };
    }
    return _shopcartBottomView;
}

- (JVShopcartFormat *)shopcartFormat {
    if (_shopcartFormat == nil){
        _shopcartFormat = [[JVShopcartFormat alloc] init];
        _shopcartFormat.delegate = self;
    }
    return _shopcartFormat;
}

- (UIButton *)editButton {
    if (_editButton == nil){
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.frame = CGRectMake(0, 0, 40, 40);
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitle:@"完成" forState:UIControlStateSelected];
        [_editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_editButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (void)editButtonAction {
    self.editButton.selected = !self.editButton.isSelected;
    [self.shopcartBottomView changeShopcartBottomViewWithStatus:self.editButton.isSelected];
    
    [self.shopcartTableViewProxy changeShopcarTableViewWithStatus:self.editButton.isSelected];
    [_shopcartTableView reloadData];
}

- (void)addSubview {
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
    self.navigationItem.rightBarButtonItem = editBarButtonItem;
    
    [self.view addSubview:self.shopcartTableView];
    [self.view addSubview:self.shopcartBottomView];
}

- (void)layoutSubview {
    [self.shopcartTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.shopcartBottomView.mas_top);
    }];
    
    [self.shopcartBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view).with.offset(-1);
    }];
}

@end
