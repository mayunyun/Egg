//
//  HomePageVC.m
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/12.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "HomePageVC.h"
#import "AllCategoryListViewController.h"
#import "AllProductPageVC.h"
#import "MYYShopCarViewController.h"
#import "SDCycleScrollView.h"//banner
#import "HomeListCell.h"
#import "HomeIconCell.h"
#import "HomeTypeModel.h"
#import "HomeIconsCollectionView.h"
#import "HomeHeaderTableViewCell.h"
#import "HomeYouLikeCollectionView.h"
#import "HomeLineCollectionView.h"
#import "MYYTypeDetailsViewController.h"
#import "ProductSearchPageVC.h"
#import "MYYDetailsAndCommentViewController.h"
#import "HXSearchBar.h"
#import "HomeBannerModel.h"
#import "HomeTypeModel.h"
#import "HomeProNewModel.h"
#import "HomeFavorableModel.h"
#import "CommandModel.h"
#import "MYYHomeNoticeViewController.h"
#import "MYYMineRechargeViewController.h"
#import "ProductDetailPageVC.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeController.h"
#import "MYYLoginViewController.h"
#import "MYYSaoMiaoLoginViewController.h"
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
@interface HomePageVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UICollectionViewDelegate,UISearchBarDelegate>
{
    NSString *_versionUrl;
    NSMutableArray* _dataArray;
    MBProgressHUD* _hud;
    HXSearchBar *_search;//搜索
    NSInteger _page;
    NSMutableArray* _bannerDataArray;
    NSMutableArray* _typeDataArray;
    NSMutableArray* _favorableDataArray;
    NSMutableArray* _activeDataArray;
    NSMutableArray* _hotProDataArray;
    NSMutableArray* _youLikeDataArray;
    NSMutableArray* _fomalProDataArray;
    NSMutableArray* _newProDataArray;
    NSMutableArray* _noticeDataArray;
}
@property (nonatomic,strong)UITableView* tbView;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView2;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView3;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView4;
@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [[NSMutableArray alloc]init];
    _bannerDataArray = [[NSMutableArray alloc]init];
    _typeDataArray = [[NSMutableArray alloc]initWithCapacity:5];
    _favorableDataArray = [[NSMutableArray alloc]init];
    _activeDataArray = [[NSMutableArray alloc]init];
    _hotProDataArray = [[NSMutableArray alloc]init];
    _youLikeDataArray = [[NSMutableArray alloc]init];
    _fomalProDataArray = [[NSMutableArray alloc]init];
    _newProDataArray = [[NSMutableArray alloc]init];
    _noticeDataArray = [[NSMutableArray alloc]init];
    _page = 1;
    
    //    进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //    _hud.labelText = @"网络不给力，正在加载中...";
    [_hud showAnimated:YES];
    //    [self creatNavUI];
    [self searchview];
    [self dataRequest];
    [self creatUI];
    [self versionRequest];
}
- (void)dataRequest{
    [_hud hideAnimated:YES];
    [self bannerRequestData];
    [self typeDataRequest];
    [self favorableDataRequest];
    [self activeDataRequest];
    [self hotProDataRequest];
    [self youLikeDataRequest];
    [self formalProDataRequest];
    
}
- (void)creatUI
{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64 - 44-5) style:UITableViewStylePlain];
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbView.delegate = self;
    _tbView.dataSource = self;
    [self.view addSubview:_tbView];
    
    //     下拉刷新
    _tbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [_dataArray removeAllObjects];
        [self dataRequest];
        // 结束刷新
        [_tbView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tbView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self dataRequest];
        [_tbView.mj_footer endRefreshing];
        
    }];
    _tbView.mj_footer.hidden = YES;
}
- (UISearchBar *)searchview{
    if (_search == nil) {
        UIButton* zbarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        zbarBtn.frame = CGRectMake(0, 0, 30, 30);
        [zbarBtn setImage:[UIImage imageNamed:@"homezbar"] forState:UIControlStateNormal];
        zbarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [zbarBtn addTarget:self action:@selector(leftNavBarClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:zbarBtn];
        self.navigationItem.leftBarButtonItem = left;
        
        UIButton* buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        buyBtn.frame = CGRectMake(0, 0, 30, 30);
        [buyBtn setImage:[UIImage imageNamed:@"icon-6"] forState:UIControlStateNormal];
        buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [buyBtn addTarget:self action:@selector(rightNavBarClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* right = [[UIBarButtonItem alloc]initWithCustomView:buyBtn];
        self.navigationItem.rightBarButtonItem = right;
        //加上 搜索栏
        _search = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 10, mScreenWidth - 100, 35)];
        _search.backgroundColor = [UIColor clearColor];
        _search.delegate = self;
        //输入框提示
        _search.placeholder = @"搜你想要的";
        //光标颜色
        _search.cursorColor = [UIColor blackColor];
        //TextField
        _search.searchBarTextField.layer.cornerRadius = 4;
        _search.searchBarTextField.layer.masksToBounds = YES;
        _search.searchBarTextField.layer.borderColor = [UIColor whiteColor].CGColor;
        _search.searchBarTextField.layer.borderWidth = 1.0;
        //清除按钮图标
        _search.clearButtonImage = [UIImage imageNamed:@"demand_delete"];
        
        //去掉取消按钮灰色背景
        _search.hideSearchBarBackgroundImage = YES;
        [self.navigationItem setTitleView:_search];
    }
    return _search;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120;
    }else{
        return 240-122.5+122.5*MYWIDTH+40;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * stringCell = @"HomeIconCell";
        HomeIconCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        if (_typeDataArray.count != 0) {
            cell.typeArray = _typeDataArray;
        }
        static HomeTypeModel * model;
        model = [[HomeTypeModel alloc]init];
        [cell setTypeBtn1Block:^{
            model = _typeDataArray[0];
            AllProductPageVC * vc = [[AllProductPageVC alloc]init];
            vc.typeId = [NSString stringWithFormat:@"%@",model.Id];
            vc.title = @"普通鸡蛋";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [cell setTypeBtn2Block:^{
            
            model = _typeDataArray[1];
            AllProductPageVC * vc = [[AllProductPageVC alloc]init];
            vc.typeId = [NSString stringWithFormat:@"%@",model.Id];
            vc.title = @"宝宝蛋";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [cell setTypeBtn3Block:^{
            
            model = _typeDataArray[2];
            AllProductPageVC * vc = [[AllProductPageVC alloc]init];
            vc.typeId = [NSString stringWithFormat:@"%@",model.Id];
            vc.title = @"土鸡蛋";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [cell setTypeBtn4Block:^{
            
            model = _typeDataArray[3];
            AllProductPageVC * vc = [[AllProductPageVC alloc]init];
            vc.typeId = [NSString stringWithFormat:@"%@",model.Id];
            vc.title = @"笨鸡蛋";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        static NSString * stringCell = @"HomeListCell";
        HomeListCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        cell.ViewController = self;
        cell.favorableString = @"特惠产品";
        if (_favorableDataArray.count != 0) {
            cell.favorableArray = _favorableDataArray;
        }
        [cell setMoreBtnBlock:^{
            AllProductPageVC * vc = [[AllProductPageVC alloc]init];
            vc.title = @"特惠产品";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        cell.proImg1.layer.cornerRadius = 2.f;
        cell.proImg1.layer.borderWidth = 1.f;
        cell.proImg1.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.proImg2.layer.cornerRadius = 2.f;
        cell.proImg2.layer.borderWidth = 1.f;
        cell.proImg2.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2){
        static NSString * stringCell = @"HomeListCell";
        HomeListCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        cell.ViewController = self;
        cell.favorableString = @"活动产品";
        if (_activeDataArray.count != 0) {
            cell.favorableArray = _activeDataArray;
        }
        [cell setMoreBtnBlock:^{
            AllProductPageVC * vc = [[AllProductPageVC alloc]init];
            vc.title = @"活动产品";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        cell.proImg1.layer.cornerRadius = 2.f;
        cell.proImg1.layer.borderWidth = 1.f;
        cell.proImg1.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.proImg2.layer.cornerRadius = 2.f;
        cell.proImg2.layer.borderWidth = 1.f;
        cell.proImg2.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 3){
        static NSString * stringCell = @"HomeListCell";
        HomeListCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        cell.ViewController = self;
        cell.favorableString = @"热卖产品";
        if (_hotProDataArray.count != 0) {
            cell.favorableArray = _hotProDataArray;
        }
        [cell setMoreBtnBlock:^{
            AllProductPageVC * vc = [[AllProductPageVC alloc]init];
            vc.title = @"热卖产品";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        cell.proImg1.layer.cornerRadius = 2.f;
        cell.proImg1.layer.borderWidth = 1.f;
        cell.proImg1.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.proImg2.layer.cornerRadius = 2.f;
        cell.proImg2.layer.borderWidth = 1.f;
        cell.proImg2.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 4){
        static NSString * stringCell = @"HomeListCell";
        HomeListCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        cell.ViewController = self;
        cell.favorableString = @"猜你喜欢";
        if (_youLikeDataArray.count != 0) {
            cell.favorableArray = _youLikeDataArray;
        }
        [cell setMoreBtnBlock:^{
            AllProductPageVC * vc = [[AllProductPageVC alloc]init];
            vc.title = @"猜你喜欢";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        cell.proImg1.layer.cornerRadius = 2.f;
        cell.proImg1.layer.borderWidth = 1.f;
        cell.proImg1.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.proImg2.layer.cornerRadius = 2.f;
        cell.proImg2.layer.borderWidth = 1.f;
        cell.proImg2.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString * stringCell = @"HomeListCell";
        HomeListCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        cell.ViewController = self;
        if (_fomalProDataArray.count != 0) {
            cell.favorableArray = _fomalProDataArray;
        }
        [cell setMoreBtnBlock:^{
            AllProductPageVC * vc = [[AllProductPageVC alloc]init];
            vc.title = @"普通产品";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        cell.favorableString = @"普通产品";
        cell.proImg1.layer.cornerRadius = 2.f;
        cell.proImg1.layer.borderWidth = 1.f;
        cell.proImg1.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.proImg2.layer.cornerRadius = 2.f;
        cell.proImg2.layer.borderWidth = 1.f;
        cell.proImg2.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)rightNavBarClick:(UIButton *)sender{
    MYYShopCarViewController *shopCartVC = [[MYYShopCarViewController alloc] init];
    [self.navigationController pushViewController:shopCartVC animated:YES];
}
- (void)leftNavBarClick:(UIButton*)sender{
    [Command isloginRequest:^(bool str) {
        if (str) {
            //登录成功
            [self initWithQRCodeController];
        }else{
            //登录失败
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录后才可以进行扫描" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                MYYLoginViewController* vc = [[MYYLoginViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
    
}
//扫一扫
- (void)initWithQRCodeController{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusDenied){
        if (IS_VAILABLE_IOS8) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相机权限受限" message:@"请在iPhone的\"设置->隐私->相机\"选项中,允许\"蛋事\"访问您的相机." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([self canOpenSystemSettingView]) {
                    [self systemSettingView];
                }
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"相机权限受限" message:@"请在iPhone的\"设置->隐私->相机\"选项中,允许\"拇指营销\"访问您的相机." delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
            [alert show];
        }
        
        return;
    }
    
    QRCodeController *qrcodeVC = [[QRCodeController alloc] init];
    qrcodeVC.view.alpha = 0;
    [qrcodeVC setDidReceiveBlock:^(NSString *result) {
        NSSLog(@"%@", result);
        //        if ([result isEqualToString:@"login"]){
        [self saomaloginRequest:(result)];
        
        //        }
    }];
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [del.window.rootViewController addChildViewController:qrcodeVC];
    [del.window.rootViewController.view addSubview:qrcodeVC.view];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        qrcodeVC.view.alpha = 1;
    } completion:^(BOOL finished) {
    }];
    
}
//扫描登录
- (void)saomaloginRequest:(NSString*)uuid{
    /*
     mallLogin?action=saomaMallLogin
     */
    NSString* accountname= [[NSUserDefaults standardUserDefaults]objectForKey:ACCOUNTNAME];
    NSString* pwd = [[NSUserDefaults standardUserDefaults]objectForKey:PASSWORD];
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"accountname\":\"%@\",\"password\":\"%@\",\"uuid\":\"%@\"}",accountname,pwd,uuid]};
    NSSLog(@">>><<<%@",params);
    [HTNetWorking postWithUrl:@"mallLogin?action=saomaMallLogin" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSSLog(@">>>%@",str);
        
        if ([str rangeOfString:@"false"].location!=NSNotFound){
            [Command customAlert:@"提示用户不存在"];
        }else{
            MYYSaoMiaoLoginViewController *login = [[MYYSaoMiaoLoginViewController alloc]init];
            login.hidesBottomBarWhenPushed = YES;
            login.uuid = uuid;
            [self.navigationController pushViewController:login animated:YES];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (cycleScrollView == self.cycleScrollView2) {
        //        NSLog(@"---点击了专题第%ld张图片", (long)index);
        if (!IsEmptyValue(_bannerDataArray)&&_bannerDataArray.count>index) {
            MYYTypeDetailsViewController* vc = [[MYYTypeDetailsViewController alloc]init];
            HomeBannerModel* model = _bannerDataArray[index];
            if (!IsEmptyValue(model.Id)) {
                vc.controller = @"special";
                vc.specialid = [NSString stringWithFormat:@"%@",model.Id];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else if (cycleScrollView == self.cycleScrollView3){
        //        NSLog(@"---点击了新品第%ld张图片", (long)index);
        if (!IsEmptyValue(_newProDataArray)&&_newProDataArray.count>index) {
            MYYTypeDetailsViewController* vc = [[MYYTypeDetailsViewController alloc]init];
            vc.biaoshi = @"new";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (cycleScrollView == self.cycleScrollView4){
        //        NSLog(@"---点击了公告第%ld张图片", (long)index);
        if (!IsEmptyValue(_noticeDataArray)&&_noticeDataArray.count>index) {
            MYYHomeNoticeViewController* noticeVC = [[MYYHomeNoticeViewController alloc]init];
            CommandModel* model = _noticeDataArray[index];
            noticeVC.noticeid = [NSString stringWithFormat:@"%@",model.Id];
            noticeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:noticeVC animated:YES];
        }
    }
}
- (void)favorableDataRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"biaoshi\":\"special\",\"sorts\":\"zonghe\"}"]};
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"mall/showproduct?action=loadProductInfo"] refreshCache:YES params:params success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"特惠数据arr%@",array);
        [_favorableDataArray removeAllObjects];
        for (NSDictionary* dict in array) {
            HomeFavorableModel* model = [[HomeFavorableModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_favorableDataArray addObject:model];
        }
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:NO];
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)activeDataRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"biaoshi\":\"activity\",\"sorts\":\"zonghe\"}"]};
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"mall/showproduct?action=loadProductInfo"] refreshCache:YES params:params success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"活动数据arr%@",array);
        [_activeDataArray removeAllObjects];
        for (NSDictionary* dict in array) {
            HomeFavorableModel* model = [[HomeFavorableModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_activeDataArray addObject:model];
        }
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:NO];
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)hotProDataRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"biaoshi\":\"hot\",\"sorts\":\"zonghe\"}"]};
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"mall/showproduct?action=loadProductInfo"] refreshCache:YES params:params success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"热卖数据arr%@",array);
        [_hotProDataArray removeAllObjects];
        for (NSDictionary* dict in array) {
            HomeFavorableModel* model = [[HomeFavorableModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_hotProDataArray addObject:model];
        }
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:3];
        [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:NO];
        
    } fail:^(NSError *error) {
        
    }];
}
- (void)youLikeDataRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"biaoshi\":\"like\",\"sorts\":\"zonghe\"}"]};
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"mall/showproduct?action=loadProductInfo"] refreshCache:YES params:params success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"猜你喜欢数据arr%@",array);
        [_youLikeDataArray removeAllObjects];
        for (NSDictionary* dict in array) {
            HomeFavorableModel* model = [[HomeFavorableModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_youLikeDataArray addObject:model];
        }
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:4];
        [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:NO];
        
    } fail:^(NSError *error) {
        
    }];
}
- (void)formalProDataRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"biaoshi\":\"product\",\"sorts\":\"zonghe\"}"]};
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"mall/showproduct?action=loadProductInfo"] refreshCache:YES params:params success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"正常数据arr%@",array);
        [_fomalProDataArray removeAllObjects];
        for (NSDictionary* dict in array) {
            HomeFavorableModel* model = [[HomeFavorableModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            if (_fomalProDataArray.count<4) {
                [_fomalProDataArray addObject:model];
            }
        }
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:5];
        [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:NO];
        
    } fail:^(NSError *error) {
        
    }];
}
- (void)typeDataRequest{
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"mall/showproduct?action=getProductTress"] refreshCache:YES params:nil success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"分类数据arr%@",array);
        [_typeDataArray removeAllObjects];
        for (NSDictionary* dict in array) {
            HomeTypeModel* model = [[HomeTypeModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            if (_typeDataArray.count<=3) {
                [_typeDataArray addObject:model];
            }
        }
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:NO];
        
    } fail:^(NSError *error) {
        
    }];
}
- (void)bannerRequestData{
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"mall/showproduct?action=subjectPic"] refreshCache:YES params:nil success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"专题返回arr%@",array);
        [_bannerDataArray removeAllObjects];
        for (NSDictionary* dict in array) {
            HomeBannerModel* model = [[HomeBannerModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_bannerDataArray addObject:model];
        }
        // 情景二：采用网络图片实现
        NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
        for (HomeBannerModel* model in _bannerDataArray) {
            NSString *serverAddress = HTImgUrl;
            if (![model.phoneautoname isEqualToString:@""]) {
                
                NSString* imageurl = [NSString stringWithFormat:@"%@%@%@",serverAddress,model.folder,model.phoneautoname];
                [imagesURLStrings addObject:imageurl];
            }
            
        }
        // 网络加载 --- 创建带标题的图片轮播器
        self.cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreen_Width, 200) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        self.cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.cycleScrollView2.currentPageDotColor = NavBarItemColor; // 自定义分页控件小圆标颜色
        self.cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
        UIImageView * wyView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.cycleScrollView2.height-30, ScreenWidth, 40)];
        wyView.image = [UIImage imageNamed:@"wanyue"];
        [self.cycleScrollView2 addSubview:wyView];
        self.tbView.tableHeaderView = self.cycleScrollView2;
        [_tbView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark - UISearchBar Delegate
//已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //    HXSearchBar *sear = (HXSearchBar *)searchBar;
    //    //取消按钮
    //    sear.cancleButton.backgroundColor = [UIColor clearColor];
    //    [sear.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    //    [sear.cancleButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    //    sear.cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"搜索" forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
}

//编辑文字改变的回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchText:%@",searchText);
}

//搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_search resignFirstResponder];// 放弃第一响应者
    ProductSearchPageVC * vc = [[ProductSearchPageVC alloc]init];
    if (!IsEmptyValue(_search.text)) {
        vc.controller = @"search";
        vc.pronameLIKE = _search.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
}

//取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_search resignFirstResponder];// 放弃第一响应者
    ProductSearchPageVC* vc = [[ProductSearchPageVC alloc]init];
    if (!IsEmptyValue(_search.text)) {
        vc.controller = @"search";
        vc.pronameLIKE = _search.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
}

/**
 *  是否可以打开设置页面
 *
 */
- (BOOL)canOpenSystemSettingView {
    if (IS_VAILABLE_IOS8) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

/**
 *  跳到系统设置页面
 */
- (void)systemSettingView {
    if (IS_VAILABLE_IOS8) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


#pragma mark -－－－－－－－－－－－－－－ 版本更新－－－－－－－－－－－－－－－－－－－－－－－－－－－
//版本更新
- (void)versionRequest{
    /*lxpub/app/version?
     
     action=getVersionInfo
     project=lx
     联祥           applelianxiang
     京新           applejingxin
     易软通         appleyiruantong
     华抗           applehuakang
     济南智圣医疗    applejnzsyl
     圣地宝         applesdb
     康普善         applekps
     金易销         applejyx
     中抗           applezk
     */
    NSString *project;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    NSLog(@"app名字%@",appName);
    
    if ([appName isEqualToString:@"徒河食品"]) {
        project = @"appletuheshipin";
    }
    if ([appName isEqualToString:@"华抗药业"]) {
        project = @"applehuakang";
    }
    if ([appName isEqualToString:@"京新药业"]) {
        project = @"applejingxin";
    }
    if ([appName isEqualToString:@"中抗药业"]) {
        project = @"applezk";
    }
    if ([appName isEqualToString:@"联祥网络"]) {
        project = @"applelianxiang";
    }
    if ([appName isEqualToString:@"金易销"]) {
        project = @"applejyx";
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@:8004/lxpub/app/version",Ver_Address];
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    NSDictionary *parameters = @{@"action":@"getVersionInfo",@"project":[NSString stringWithFormat:@"%@",@"appledanshi"]};
    
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:parameters success:^(id response) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"版本信息:%@",dic);
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDic));
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        NSLog(@"当前版本号%@",appVersion);
        NSString *version = dic[@"app_version"];
        NSString *nessary = dic[@"app_necessary"];
        NSLog(@"请求版本号%@",appVersion);
        _versionUrl = dic[@"app_url"];
        //[self showAlert];
        if ([version isEqualToString:appVersion]) {
            
        }else if(![version isEqualToString:appVersion]){
            if ([nessary isEqualToString:@"0"]) {
                
                [self showAlert];
            }else if([nessary isEqualToString:@"1"]){
                
                [self showAlert1];
            }
        }
    } fail:^(NSError *error) {
        NSLog(@"更新检测请求失败");
    }];
    
    //    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
    //    }];
}
//选择更新
- (void)showAlert{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                    message:@"发现新版本，是否马上更新？"
                                                   delegate:self
                                          cancelButtonTitle:@"以后再说"
                                          otherButtonTitles:@"下载", nil];
    alert.tag = 10001;
    [alert show];
    
}
//强制更新
- (void)showAlert1{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                    message:@"发现新版本，是否马上更新？"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"下载", nil];
    alert.tag = 10002;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 拼接url 防止读取缓存
    NSString *sign = [NSString stringWithFormat:@"%zi",[self getRandomNumber:1 to:1000]];
    if (alertView.tag==10001) {
        if (buttonIndex==1) {
            NSString *str = [NSString stringWithFormat:@"itms-services://?v=%@&action=download-manifest&url=%@",sign,_versionUrl];
            //            NSString *str1 = @"https://www.pgyer.com/lOJg";//http://www.pgyer.com/CxLm
            //            NSURL *url = [NSURL URLWithString:str1];
            NSURL *url = [NSURL URLWithString:str];
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
        
    }else if (alertView.tag == 10002){
        
        if (buttonIndex == 0) {
            
            NSString *str = [NSString stringWithFormat:@"itms-services://?v=%@&action=download-manifest&url=%@",sign,_versionUrl];
            
            //            NSString *str1 = @"https://www.pgyer.com/lOJg";
            //            NSURL *url = [NSURL URLWithString:str1];
            
            NSURL *url = [NSURL URLWithString:str];
            [[UIApplication sharedApplication]openURL:url];
            
        }
    }else if (alertView.tag == 10003){
        if (buttonIndex == 1) {
            if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            }
        }
    }
}

-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}
@end
