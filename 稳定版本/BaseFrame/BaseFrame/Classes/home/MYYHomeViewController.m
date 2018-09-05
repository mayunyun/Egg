//
//  MYYHomeViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/3/24.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYHomeViewController.h"
#import "SDCycleScrollView.h"//banner
#import "HomeIconsCollectionView.h"
#import "HomeHeaderTableViewCell.h"
#import "HomeYouLikeCollectionView.h"
#import "HomeLineCollectionView.h"
#import "MYYTypeDetailsViewController.h"
#import "MYYDetailsAndCommentViewController.h"
#import "HXSearchBar.h"
#import "HomeBannerModel.h"
#import "HomeTypeModel.h"
#import "HomeProNewModel.h"
#import "HomeFavorableModel.h"
#import "CommandModel.h"
#import "MYYHomeNoticeViewController.h"
#import "MYYMineRechargeViewController.h"
#import "MYYTypeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeController.h"
#import "MYYLoginViewController.h"
#import "MYYSaoMiaoLoginViewController.h"
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
@interface MYYHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UICollectionViewDelegate,UISearchBarDelegate>
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
@property (nonatomic,strong)HomeIconsCollectionView* iconsCollView;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView4;
@property (nonatomic,strong)HomeYouLikeCollectionView* youLikeCollView;
@property (nonatomic,strong)HomeLineCollectionView* lineCollView;
@end

@implementation MYYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self creatUI];
    [self dataRequest];
    [self versionRequest];
    
}

//- (void)creatNavUI{
//    UIButton* zbarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    zbarBtn.frame = CGRectMake(0, 0, 30, 30);
//    [zbarBtn setImage:[UIImage imageNamed:@"homezbar"] forState:UIControlStateNormal];
//    zbarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [zbarBtn addTarget:self action:@selector(leftNavBarClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:zbarBtn];
//    self.navigationItem.leftBarButtonItem = left;
//    UIView* navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width - 40, 30)];
//    navBarView.backgroundColor = [UIColor clearColor];
//    navBarView.layer.borderColor = [UIColor grayColor].CGColor;
//    navBarView.layer.borderWidth = 0.5;
//    navBarView.layer.masksToBounds = YES;
//    navBarView.layer.cornerRadius = 5;
//    
//    UIImageView* searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, (navBarView.height - 13)*0.5, 12, 13)];
//    searchImgView.image = [UIImage imageNamed:@"homesearch"];
//    [navBarView addSubview:searchImgView];
//    
//    UITextField* searchBarField = [[UITextField alloc]initWithFrame:CGRectMake(searchImgView.right+5, 0, navBarView.width - searchImgView.right - 5, 30)];
//    searchBarField.placeholder = @"搜你想要的";
//    [navBarView addSubview:searchBarField];
//    self.navigationItem.titleView = navBarView;
//}

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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 16;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        if (indexPath.row == 0) {
            return kScreen_Width*556/720;
        }else if (indexPath.row == 1){
//            return 210*kScreen_Width/714;
            return 100;
        }else if (indexPath.row == 9){
            return 290*kScreen_Width/714;
        }else if (indexPath.row == 6 || indexPath.row == 8 || indexPath.row == 11||indexPath.row == 13){//indexPath.row == 4 ||
            return 270*kScreen_Width/714;
        }else if (indexPath.row == 15){
            CGFloat cellHeight = 400*kScreen_Width/714;
            return [self array:_fomalProDataArray rowNum:2]*cellHeight;
        }else if (indexPath.row == 4 ||indexPath.row == 3){
            return 0;
        }else{
            return 44;
        }
    }else{
        return 44;
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    // 通过不同标识创建cell实例
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    HomeHeaderTableViewCell* headerCell = [tableView dequeueReusableCellWithIdentifier:@"HomeHeaderTableViewCellID"];
    if (!headerCell) {
        headerCell = [[[NSBundle mainBundle] loadNibNamed:@"HomeHeaderTableViewCell" owner:self options:nil]firstObject];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    headerCell.selectionStyle =UITableViewCellSelectionStyleNone;
    for (UIView* view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (tableView == _tbView) {
        if (indexPath.row == 0) {
            //banner
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
            self.cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width*556/720) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            self.cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            self.cycleScrollView2.currentPageDotColor = NavBarItemColor; // 自定义分页控件小圆标颜色
            [cell.contentView addSubview:self.cycleScrollView2];
            self.cycleScrollView2.imageURLStringsGroup = imagesURLStrings;

        }else if (indexPath.row == 1){
            //icon
            
            _iconsCollView = [[HomeIconsCollectionView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 100)];
            _iconsCollView.contentSize = CGSizeMake(mScreenWidth, 160);
            _iconsCollView.delegate = self;
            _iconsCollView.bounces = NO;
            _iconsCollView.scrollsToTop = NO;
            _iconsCollView.scrollEnabled = NO;
            _iconsCollView.userInteractionEnabled = YES;
            if (_typeDataArray.count == 5) {
                _iconsCollView.dataArr = _typeDataArray;
                [_iconsCollView reloadData];
            }
            [cell.contentView addSubview:_iconsCollView];
            _iconsCollView.backgroundColor = [UIColor clearColor];
        }else if (indexPath.row == 2){
            //公告
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 40)];
            label.text = @"公告：";
            label.textColor = [UIColor redColor];
            label.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:label];
            // 情景三：图片配文字
//            NSArray *titles = @[@"新建交流QQ群：185534916 ",
//                                @"感谢您的支持，如果下载的",
//                                @"如果代码在使用过程中出现问题",
//                                @"您可以发邮件到gsdios@126.com"
//                                ];
            NSMutableArray* titles = [[NSMutableArray alloc]init];
            if (!IsEmptyValue(_noticeDataArray)) {
                for (CommandModel* model in _noticeDataArray) {
                    [titles addObject:model.name];
                }
            }
            // 网络加载 --- 创建只上下滚动展示文字的轮播器
            // 由于模拟器的渲染问题，如果发现轮播时有一条线不必处理，模拟器放大到100%或者真机调试是不会出现那条线的
            self.cycleScrollView4 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(60, 0, kScreen_Width - 60, 40) delegate:self placeholderImage:nil];
            self.cycleScrollView4.titleLabelBackgroundColor = [UIColor whiteColor];
            self.cycleScrollView4.titleLabelTextColor = [UIColor blackColor];
            self.cycleScrollView4.scrollDirection = UICollectionViewScrollDirectionVertical;
            self.cycleScrollView4.onlyDisplayText = YES;
            
            NSMutableArray *titlesArray = [NSMutableArray new];
            [titlesArray addObjectsFromArray:titles];
            self.cycleScrollView4.titlesGroup = [titlesArray copy];
            
            [cell.contentView addSubview:self.cycleScrollView4];
            
            UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, kScreen_Width, 0.5)];
            line.backgroundColor = LineColor;
            [cell.contentView addSubview:line];
            CALayer *layer = [line layer];
            layer.borderColor = SecondBackGorundColor.CGColor;
            layer.borderWidth = .5f;
            
            
        }else if ( indexPath.row == 5 || indexPath.row == 7|| indexPath.row == 10 || indexPath.row == 12 || indexPath.row == 14){//indexPath.row == 3 ||
            //header
            NSArray* dataArray = @[@"0",@"1",@"2",@"新品推荐",@"4",@"特惠产品",@"6",@"活动套餐",@"8",@"9",@"热卖产品",@"11",@"猜你喜欢",@"13",@"普通精品",@"15"];
            headerCell.titleLabel.text = dataArray[indexPath.row];
            [headerCell setTransVaule:^(BOOL isClick) {
                MYYTypeDetailsViewController* vc = [[MYYTypeDetailsViewController alloc]init];
                if (indexPath.row == 5) {
                    vc.biaoshi = @"special";
                }else if (indexPath.row == 7){
                    vc.biaoshi = @"activity";
                }else if (indexPath.row == 10){
                    vc.biaoshi = @"hot";
                }else if (indexPath.row == 12){
                    vc.biaoshi = @"like";
                }else if (indexPath.row == 14){
                    vc.biaoshi = @"product";
                }
                [self.navigationController pushViewController:vc animated:YES];
            }];
            return headerCell;
        }else if (indexPath.row == 9){
            //蛋事新品
            // 情景二：采用网络图片实现
            NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
            if (!IsEmptyValue(_newProDataArray)) {
                for (HomeProNewModel* model in _newProDataArray) {
                    NSString *serverAddress = HTImgUrl;
                    NSString* imageurl = [NSString stringWithFormat:@"%@%@%@",serverAddress,model.folder,model.autoname];
                    [imagesURLStrings addObject:imageurl];
                }
            }
            // 网络加载 --- 创建带标题的图片轮播器
            self.cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreen_Width, 290*kScreen_Width/714) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            self.cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            self.cycleScrollView3.currentPageDotColor = NavBarItemColor; // 自定义分页控件小圆标颜色
            [cell.contentView addSubview:self.cycleScrollView3];
            self.cycleScrollView3.imageURLStringsGroup = imagesURLStrings;
            
        }else if ( indexPath.row == 6 || indexPath.row == 8 || indexPath.row == 11||indexPath.row == 13){//indexPath.row == 4 ||
            /*
             ,@"新品推荐",@"4",
             @"特惠产品",@"6",
             @"活动套餐",@"8",
             @"热卖产品",@"11",
             @"猜你喜欢",@"13",
             */
            CGFloat cellHight = 270*kScreen_Width/714;
            //横向滑动网格
            UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, cellHight)];
            scrollView.delegate = self;
            scrollView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:scrollView];
            _lineCollView = [[HomeLineCollectionView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, cellHight)];
            _lineCollView.delegate = self;
            _lineCollView.bounces = NO;
            _lineCollView.scrollsToTop = NO;
            _lineCollView.scrollEnabled = NO;
            _lineCollView.tag = 1000+indexPath.row;
            _lineCollView.userInteractionEnabled = YES;
            _lineCollView.backgroundColor = [UIColor clearColor];
            __weak typeof (self)weakself = self;
            [_lineCollView setTransVaule:^(HomeFavorableModel *model) {
                [Command isloginRequest:^(bool islogin) {
                    if (islogin) {
                        [weakself addCarRequest:model];
                    }else{
                        [weakself showAlertViewWithTitle:@"亲，加入购物车需要您登录！" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] buttonClick:^(UIAlertController *alertView, NSInteger buttonIndex) {
                            if (buttonIndex == 0) {
                                
                            }else if (buttonIndex == 1){
                                MYYLoginViewController* vc = [[MYYLoginViewController alloc]init];
                                vc.hidesBottomBarWhenPushed = YES;
                                [weakself.navigationController pushViewController:vc animated:YES];
                            }
                        }];
                    }
                }];
                
            }];
            switch (indexPath.row) {
                case 6:{
                    if (!IsEmptyValue(_favorableDataArray)) {
                        _lineCollView.dataArr = _favorableDataArray;
                        _lineCollView.frame = CGRectMake(0, 0, _favorableDataArray.count*(mScreenWidth/3+2), cellHight);
                        scrollView.contentSize = CGSizeMake(_favorableDataArray.count*(mScreenWidth/3+2), cellHight);
                        [_lineCollView reloadData];
                    }
                }break;
                case 8:{
                    if (!IsEmptyValue(_activeDataArray)) {
                        _lineCollView.dataArr = _activeDataArray;
                        _lineCollView.frame = CGRectMake(0, 0, _favorableDataArray.count*(mScreenWidth/3+2), cellHight);
                        scrollView.contentSize = CGSizeMake(_favorableDataArray.count*(mScreenWidth/3+2), cellHight);
                        [_lineCollView reloadData];
                    }
                }break;
                case 11:{
                    if (!IsEmptyValue(_hotProDataArray)) {
                        _lineCollView.dataArr = _hotProDataArray;
                        _lineCollView.frame = CGRectMake(0, 0, _hotProDataArray.count*(mScreenWidth/3+2), cellHight);
                        scrollView.contentSize = CGSizeMake(_hotProDataArray.count*(mScreenWidth/3+2), cellHight);
                        [_lineCollView reloadData];
                    }
                }break;
                case 13:{
                    if (!IsEmptyValue(_youLikeDataArray)) {
                        _lineCollView.dataArr = _youLikeDataArray;
                        _lineCollView.frame = CGRectMake(0, 0, _favorableDataArray.count*(mScreenWidth/3+2), cellHight);
                        scrollView.contentSize = CGSizeMake(_favorableDataArray.count*(mScreenWidth/3+2), cellHight);
                        [_lineCollView reloadData];
                    }
                }break;
//                case 4:{
//                    
//                }break;
                default:break;
            }
            [scrollView addSubview:_lineCollView];
        }else if (indexPath.row == 15){
            //纵向网格
            CGFloat cellHeight = 400*kScreen_Width/714;
            _youLikeCollView = [[HomeYouLikeCollectionView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, cellHeight)];
            _youLikeCollView.delegate = self;
            _youLikeCollView.bounces = NO;
            _youLikeCollView.scrollsToTop = NO;
            _youLikeCollView.scrollEnabled = NO;
            _youLikeCollView.userInteractionEnabled = YES;
            [cell.contentView addSubview:_youLikeCollView];
            _youLikeCollView.backgroundColor = [UIColor clearColor];
            __weak typeof (self) weakself = self;
            [_youLikeCollView setTransVaule:^(HomeFavorableModel *model) {

                [Command isloginRequest:^(bool islogin) {
                    if (islogin) {
                        [weakself addCarRequest:model];
                    }else{
                        [weakself showAlertViewWithTitle:@"亲，加入购物车需要您登录！" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] buttonClick:^(UIAlertController *alertView, NSInteger buttonIndex) {
                            if (buttonIndex == 0) {
                                
                            }else if (buttonIndex == 1){
                                MYYLoginViewController* vc = [[MYYLoginViewController alloc]init];
                                vc.hidesBottomBarWhenPushed = YES;
                                [weakself.navigationController pushViewController:vc animated:YES];
                            }
                        }];
                    }
                }];
            }];
            if (!IsEmptyValue(_fomalProDataArray)) {
                _youLikeCollView.dataArr = _fomalProDataArray;
                [_youLikeCollView reloadData];
                _youLikeCollView.frame = CGRectMake(0, 0, mScreenWidth, [self array:_fomalProDataArray rowNum:2]*cellHeight);
            }
        
        }
    }
    
    return cell;
}
- (NSInteger)array:(NSArray*)array rowNum:(NSInteger)index
{
    if (array.count == 0||array == nil || index == (NSInteger)nil ) {
        return 0;
    }else{
        if (array.count%index!=0) {
            return array.count/index+1;
        }else{
            return array.count/index;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYYTypeDetailsViewController* vc = [[MYYTypeDetailsViewController alloc]init];
    if (indexPath.row == 5) {
        vc.biaoshi = @"special";
    }else if (indexPath.row == 7){
        vc.biaoshi = @"activity";
    }else if (indexPath.row == 10){
        vc.biaoshi = @"hot";
    }else if (indexPath.row == 12){
        vc.biaoshi = @"like";
    }else if (indexPath.row == 14){
        vc.biaoshi = @"product";
    }
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark ---UIcollectionViewLayoutDelegate
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isKindOfClass:[HomeIconsCollectionView class]]) {
        return CGSizeMake(kScreen_Width/5, 210*kScreen_Width/714);
    }else if ([collectionView isKindOfClass:[HomeYouLikeCollectionView class]]){
        return CGSizeMake(kScreen_Width/2, 400*kScreen_Width/714);
    }else if ([collectionView isKindOfClass:[HomeLineCollectionView class]]){
        return CGSizeMake(kScreen_Width/3, 270*kScreen_Width/714);
    }
    else{
        return CGSizeMake(0, 0);
    }
}

//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isKindOfClass:[HomeIconsCollectionView class]]) {
        if (!IsEmptyValue(_typeDataArray)) {
//            MYYTypeViewController *orderVC = [self.tabBarController.viewControllers objectAtIndex:2];
            UINavigationController *temp = (UINavigationController *)[super.tabBarController.viewControllers objectAtIndex:1];
            MYYTypeViewController *orderVC = (MYYTypeViewController *)temp.topViewController;
            orderVC.controller = @"home";
            orderVC.row = [NSString stringWithFormat:@"%li",(long)indexPath.row];
            self.tabBarController.selectedIndex = 1;//跳转
        }
    }else if ([collectionView isKindOfClass:[HomeYouLikeCollectionView class]]){
        if (!IsEmptyValue(_fomalProDataArray)) {
            MYYDetailsAndCommentViewController* vc = [[MYYDetailsAndCommentViewController alloc]init];
            HomeFavorableModel* model = _fomalProDataArray[indexPath.row];
            vc.proid = [NSString stringWithFormat:@"%@",model.Id];
            vc.type = [NSString stringWithFormat:@"%@",model.type];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([collectionView isKindOfClass:[HomeLineCollectionView class]]){
        switch (collectionView.tag - 1000) {
            case 6:{
                if (!IsEmptyValue(_favorableDataArray)) {
                    MYYDetailsAndCommentViewController* vc = [[MYYDetailsAndCommentViewController alloc]init];
                    HomeFavorableModel* model = _favorableDataArray[indexPath.row];
                    vc.proid = [NSString stringWithFormat:@"%@",model.Id];
                    vc.type = [NSString stringWithFormat:@"%@",model.type];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }break;
            case 8:{
                if (!IsEmptyValue(_activeDataArray)) {
                    MYYDetailsAndCommentViewController* vc = [[MYYDetailsAndCommentViewController alloc]init];
                    HomeFavorableModel* model = _activeDataArray[indexPath.row];
                    vc.proid = [NSString stringWithFormat:@"%@",model.Id];
                    vc.type = [NSString stringWithFormat:@"%@",model.type];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }break;
            case 11:{
                if (!IsEmptyValue(_hotProDataArray)) {
                    MYYDetailsAndCommentViewController* vc = [[MYYDetailsAndCommentViewController alloc]init];
                    HomeFavorableModel* model = _hotProDataArray[indexPath.row];
                    vc.proid = [NSString stringWithFormat:@"%@",model.Id];
                    vc.type = [NSString stringWithFormat:@"%@",model.type];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }break;
            case 13:{
                if (!IsEmptyValue(_youLikeDataArray)) {
                    MYYDetailsAndCommentViewController* vc = [[MYYDetailsAndCommentViewController alloc]init];
                    HomeFavorableModel* model = _youLikeDataArray[indexPath.row];
                    vc.proid = [NSString stringWithFormat:@"%@",model.Id];
                    vc.type = [NSString stringWithFormat:@"%@",model.type];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }break;
            default:break;
        }

    }else{

    }
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
    [self newProDataRequest];
    [self noticeDataRequest];
    
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
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
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
            if (_typeDataArray.count<=5) {
                [_typeDataArray addObject:model];
            }
        }
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:NO];
        
    } fail:^(NSError *error) {
        
    }];
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
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:6 inSection:0];
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
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:8 inSection:0];
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
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:11 inSection:0];
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
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:13 inSection:0];
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
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:15 inSection:0];
        [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:NO];
        
    } fail:^(NSError *error) {
        
    }];
}
- (void)newProDataRequest{
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"mall/showproduct?action=indexPic"] refreshCache:YES params:nil success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"新品数据arr%@",array);
        [_newProDataArray removeAllObjects];
        for (NSDictionary* dict in array) {
            HomeProNewModel* model = [[HomeProNewModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            if ([model.status isEqualToString:@"new"]) {
                [_newProDataArray addObject:model];
            }
        }
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:9 inSection:0];
        [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:NO];
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)noticeDataRequest{
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"/notice?action=getNotice"] refreshCache:YES params:nil success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"公告数据arr%@",array);
        [_noticeDataArray removeAllObjects];
        for (NSDictionary* dict in array) {
            CommandModel* model = [[CommandModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_noticeDataArray addObject:model];
        }
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:NO];
        
    } fail:^(NSError *error) {
        
    }];
}
- (void)addCarRequest:(HomeFavorableModel*)model{
    /*
     /shoppingcart?action=addShoppingCart  添加购物车接口
     参数：proid,proname,price,count,type,specification
     */
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"price\":\"%@\",\"count\":\"%@\",\"type\":\"%@\",\"specification\":\"%@\"}",model.Id,model.proname,model.saleprice,@"1",model.type,model.specification]};
    [HTNetWorking postWithUrl:@"shoppingcart?action=addShoppingCart" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [Command customAlert:@"加入购物车成功"];
        }else if ([str rangeOfString:@"false"].location!=NSNotFound){
            [Command customAlert:@"删除购物车"];
        }
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
    MYYTypeDetailsViewController* vc = [[MYYTypeDetailsViewController alloc]init];
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
    MYYTypeDetailsViewController* vc = [[MYYTypeDetailsViewController alloc]init];
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
