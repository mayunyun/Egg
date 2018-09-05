//
//  MYYTypeViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/3/24.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYTypeViewController.h"
#import "MYYTypeCell.h"
#import "HXSearchBar.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeController.h"
#import "MYYLoginViewController.h"
#import "MYYSaoMiaoLoginViewController.h"
#import "MYYTypeDetailsViewController.h"
@interface MYYTypeViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
//    MBProgressHUD* _hud;
    NSInteger _page;
    HXSearchBar *_search;//搜索
    NSString *_folder;

}
@property(nonatomic,strong) UITableView *leftTableView;
@property(nonatomic,strong) UITableView *rightTableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *itemsdataArray;
@end

@implementation MYYTypeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([_controller isEqualToString:@"home"]) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[_row integerValue] inSection:0];
        if (_dataArray.count>0) {
            [self.leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            MYYTypeModel *model = _dataArray[indexPath.row];
            [self requestDataRightTableView:model.id];
        }
        
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    _dataArray = [[NSMutableArray alloc]init];
    _itemsdataArray = [[NSMutableArray alloc]init];
    
    [self requestDataLeftTableView];
    [self creatUI];
    
}
- (UITableView *)leftTableView{
    if (_leftTableView == nil) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth/4, mScreenHeight-110)];
        _leftTableView.backgroundColor = UIColorFromRGB(0xefefef);
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        //隐藏多余cell
        _leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.view addSubview:_leftTableView];
    }
    return _leftTableView;
}
- (UITableView *)rightTableView{
    if (_rightTableView == nil){
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(mScreenWidth/4, 0, mScreenWidth/4*3, mScreenHeight-110)];
        _rightTableView.backgroundColor = [UIColor whiteColor];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.separatorStyle = NO;
        [_rightTableView registerNib:[UINib nibWithNibName:@"MYYTypeCell" bundle:nil] forCellReuseIdentifier:@"MYYTypeCell"];
        [self.view addSubview:_rightTableView];
        //     下拉刷新
        _rightTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            [_itemsdataArray removeAllObjects];
            NSIndexPath* indexPath = [_leftTableView indexPathForSelectedRow];
            if (!IsEmptyValue(_dataArray)) {
                MYYTypeModel *model = _dataArray[indexPath.row];
                [self requestDataRightTableView:model.id];
            }
            // 结束刷新
            [_rightTableView.mj_header endRefreshing];
            
        }];
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        _rightTableView.mj_header.automaticallyChangeAlpha = YES;
    }
    return _rightTableView;
}
- (UISearchBar *)searchview{
    if (_search == nil) {

//        self.navigationItem.leftBarButtonItem = nil;
        UIButton* zbarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        zbarBtn.frame = CGRectMake(0, 0, 30, 30);
        [zbarBtn setImage:[UIImage imageNamed:@"homezbar"] forState:UIControlStateNormal];
        zbarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [zbarBtn addTarget:self action:@selector(leftNavBarClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:zbarBtn];
        self.navigationItem.leftBarButtonItem = left;
        //加上搜索栏
        _search = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 10, mScreenWidth - 100, 40)];
        _search.backgroundColor = [UIColor clearColor];
        _search.delegate = self;
        //输入框提示
        _search.placeholder = @"搜索你想要的";
        //光标颜色
        _search.cursorColor = [UIColor blackColor];
        //TextField
        _search.searchBarTextField.layer.cornerRadius = 4;
        _search.searchBarTextField.layer.masksToBounds = YES;
        _search.searchBarTextField.layer.borderColor = UIColorFromRGB(0xececec).CGColor;
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
    [HTNetWorking postWithUrl:@"mallLogin?action=saomaMallLogin" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            
            MYYSaoMiaoLoginViewController *login = [[MYYSaoMiaoLoginViewController alloc]init];
            login.hidesBottomBarWhenPushed = YES;
            login.uuid = uuid;
            [self.navigationController pushViewController:login animated:YES];
            
        }else if ([str rangeOfString:@"false"].location!=NSNotFound){
            [Command customAlert:@"提示用户不存在"];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}
- (void)creatUI
{
    [self leftTableView];
    [self rightTableView];
    [self searchview];

//    //     下拉刷新
//    _rightTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _page = 1;
//        [_dataArray removeAllObjects];
//        [self requestData];
//        // 结束刷新
//        [_rightTableView.mj_header endRefreshing];
//        
//    }];
//    
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    _rightTableView.mj_header.automaticallyChangeAlpha = YES;
//    // 上拉刷新
//    _rightTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        _page ++ ;
//        [self requestData];
//        [_rightTableView.mj_footer endRefreshing];
//        
//    }];
//    _rightTableView.mj_footer.hidden = YES;
}

#pragma mark dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (!(_dataArray.count == 0) && tableView==_leftTableView) {
        return _dataArray.count;
    }
    else if ((!(_itemsdataArray.count == 0)) && tableView==_rightTableView){
        
        if (_itemsdataArray.count) {
            if ([_itemsdataArray count]%3) {
                return [_itemsdataArray count]/3+1;
            }else{
                return [_itemsdataArray count]/3;
            }
        }
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (tableView == self.leftTableView) {
        
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = selectedBackgroundView;
        cell.backgroundColor = UIColorFromRGB(0xefefef);
        if (!(_dataArray.count == 0)) {
            MYYTypeModel *model = _dataArray[indexPath.row];;
            cell.textLabel.text = model.name;
        }
        cell.textLabel.frame = CGRectMake(0, 0, mScreenWidth/4, mScreenWidth/8);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.highlightedTextColor = [UIColor redColor];
        [cell.textLabel setTextColor:UIColorFromRGB(0x333333)];
        return cell;

    } else if (tableView == self.rightTableView){
        
        MYYTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYYTypeCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.viewControlle = self;
        if (_itemsdataArray.count) {
            
            if (indexPath.row == [_itemsdataArray count]/3 && [_itemsdataArray count]%3 == 1) {

                MYYTypeItemsModel *itemsModel0 = _itemsdataArray[indexPath.row*3];

                cell.titleName1.text = itemsModel0.proname;
                cell.titleName2.text = @"";
                cell.titleName3.text = @"";
                
                NSString *imageUrl = [NSString stringWithFormat:@"%@/%@%@",HTImgUrl,_folder,itemsModel0.autoname];
                [cell.image1 sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
                cell.image2.hidden = YES;
                cell.image3.hidden = YES;
                
                cell.typeBut1.tag = indexPath.row*3;
                [cell.typeBut1 addTarget:self action:@selector(typeBut1Click:) forControlEvents:UIControlEventTouchUpInside];
                cell.typeBut2.hidden = YES;
                cell.typeBut3.hidden = YES;
                
            }else if (indexPath.row == [_itemsdataArray count]/3 && [_itemsdataArray count]%3 == 2){
                MYYTypeItemsModel *itemsModel0 = _itemsdataArray[indexPath.row*3];
                MYYTypeItemsModel *itemsModel1 = _itemsdataArray[indexPath.row*3+1];

                cell.titleName1.text = itemsModel0.proname;
                cell.titleName2.text = itemsModel1.proname;
                cell.titleName3.text = @"";
                
                NSString *imageUrl1 = [NSString stringWithFormat:@"%@/%@%@",HTImgUrl,_folder,itemsModel0.autoname];
                NSString *imageUrl2 = [NSString stringWithFormat:@"%@/%@%@",HTImgUrl,_folder,itemsModel1.autoname];

                [cell.image1 sd_setImageWithURL:[NSURL URLWithString:imageUrl1]];
                cell.image2.hidden = NO;
                [cell.image2 sd_setImageWithURL:[NSURL URLWithString:imageUrl2]];
                cell.image3.hidden = YES;
                
                cell.typeBut1.tag = indexPath.row*3;
                
                [cell.typeBut1 addTarget:self action:@selector(typeBut1Click:) forControlEvents:UIControlEventTouchUpInside];
                cell.typeBut2.hidden = NO;
                cell.typeBut2.tag = indexPath.row*3+1;
                [cell.typeBut2 addTarget:self action:@selector(typeBut1Click:) forControlEvents:UIControlEventTouchUpInside];
                cell.typeBut3.hidden = YES;
            }else{

                MYYTypeItemsModel *itemsModel0 = _itemsdataArray[indexPath.row*3];
                MYYTypeItemsModel *itemsModel1 = _itemsdataArray[indexPath.row*3+1];
                MYYTypeItemsModel *itemsModel2 = _itemsdataArray[indexPath.row*3+2];
                NSLog(@"%@  %zd",_itemsdataArray,indexPath.row);

                cell.titleName1.text = itemsModel0.proname;
                cell.titleName2.text = itemsModel1.proname;
                cell.titleName3.text = itemsModel2.proname;
                
                NSString *imageUrl1 = [NSString stringWithFormat:@"%@/%@%@",HTImgUrl,_folder,itemsModel0.autoname];
                NSString *imageUrl2 = [NSString stringWithFormat:@"%@/%@%@",HTImgUrl,_folder,itemsModel1.autoname];
                NSString *imageUrl3 = [NSString stringWithFormat:@"%@/%@%@",HTImgUrl,_folder,itemsModel2.autoname];

                [cell.image1 sd_setImageWithURL:[NSURL URLWithString:imageUrl1]];
                cell.image2.hidden = NO;
                [cell.image2 sd_setImageWithURL:[NSURL URLWithString:imageUrl2]];
                cell.image3.hidden = NO;
                [cell.image3 sd_setImageWithURL:[NSURL URLWithString:imageUrl3]];
                
                cell.typeBut1.tag = indexPath.row*3;
                [cell.typeBut1 addTarget:self action:@selector(typeBut1Click:) forControlEvents:UIControlEventTouchUpInside];
                cell.typeBut2.hidden = NO;
                cell.typeBut2.tag = indexPath.row*3+1;
                [cell.typeBut2 addTarget:self action:@selector(typeBut1Click:) forControlEvents:UIControlEventTouchUpInside];
                cell.typeBut3.hidden = NO;
                cell.typeBut3.tag = indexPath.row*3+2;
                [cell.typeBut3 addTarget:self action:@selector(typeBut1Click:) forControlEvents:UIControlEventTouchUpInside];

            }
        }
        
        return cell;

    }
    
    return cell;
}
- (void)typeBut1Click:(UIButton *)but{
   
    MYYTypeItemsModel *itemsmodel = _itemsdataArray[but.tag];
    MYYDetailsAndCommentViewController *details = [[MYYDetailsAndCommentViewController alloc]init];
    details.proid = [NSString stringWithFormat:@"%@",itemsmodel.id];
    details.type = [NSString stringWithFormat:@"%@",itemsmodel.type];
    details.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:details animated:YES];
}
#pragma mark delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_leftTableView)
    {
        return mScreenWidth/8;
    }
    else
    {
        return 100;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //左边tableView
    if(tableView==_leftTableView)
    {
        if (!(_dataArray.count == 0)) {
            MYYTypeModel *model = _dataArray[indexPath.row];
            [self requestDataRightTableView:model.id];
        }

    }
    
    else
    {
        [_rightTableView deselectRowAtIndexPath:indexPath animated:NO];
        
    }
}


- (void)requestDataLeftTableView
{
    
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"%@",Type_URL] refreshCache:YES params:nil success:^(id response) {
        
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"分类返回arr%@",array);
        //建立模型
        for (NSDictionary*dic in array) {
            MYYTypeModel *model=[[MYYTypeModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            //追加数据
            [_dataArray addObject:model];
            _folder = model.folder;

        }

        [self requestDataRightTableView:[array[0] objectForKey:@"id"]];
        NSIndexPath * selIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.leftTableView selectRowAtIndexPath:selIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
    } fail:^(NSError *error) {
        
    }];
}
- (void)requestDataRightTableView:(NSString *)ageid
{
    if (_itemsdataArray == nil) {
        _itemsdataArray = [[NSMutableArray alloc]init];
    }else{
        [_itemsdataArray removeAllObjects];
    }

     NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"protypeidother\":\"%@\",\"sorts\":\"%@\"}",ageid,@"zonghe"]};
    [HTNetWorking postWithUrl:@"mall/showproduct?action=loadProductInfo" refreshCache:YES params:params success:^(id response) {
        
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //NSSLog(@">>>>%@",array);
        //建立模型
        for (NSDictionary*dic in array) {
            MYYTypeItemsModel *model=[[MYYTypeItemsModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            //追加数据
            [self.itemsdataArray addObject:model];
        }
        [_rightTableView reloadData];

    } fail:^(NSError *error) {
        
    }];
    
}

//取消cell分割线空白部分
-(void)viewDidLayoutSubviews {
    
    if ([_leftTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_leftTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([_leftTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_leftTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
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

@end
