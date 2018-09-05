//
//  MYYAddManageViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/11.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYAddManageViewController.h"
#import "MYYAddManageTableViewCell.h"
#import "MYYAddAddrViewController.h"
#import "MYYMinesearchAddressModel.h"
#import "MYYLoginViewController.h"
@interface MYYAddManageViewController ()<UITableViewDelegate,UITableViewDataSource,MYYAddManageTableViewCellDelegate>
{
    NSMutableArray* _dataArray;
    NSInteger _page;
    
}
@property (nonatomic,strong)UITableView* tbView;
@end

@implementation MYYAddManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _page = 1;
    self.title = @"地址管理";
    
    UIButton* right = [UIButton buttonWithType:UIButtonTypeSystem];
    right.frame = CGRectMake(0, 0, 50, 30);
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right setTitle:@"添加" forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:14];
    [right addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastViewController:)];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xffffff)];
    [self creatUI];
}
- (void)backToLastViewController:(UIButton *)button
{
    //[Public hideLoadingView];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self searchAddressRequest];

    //设置状态栏颜色
    [self setStatusBarBackgroundColor:UIColorFromRGB(0xFFA500)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
}


- (void)creatUI{
    self.view.backgroundColor = BackGorundColor;
    [self tbView];
}

- (void)nextBtnClick:(UIButton*)sender{
    [Command isloginRequest:^(bool flag) {
        if (flag) {
            
            MYYAddAddrViewController* vc = [[MYYAddAddrViewController alloc]init];
            vc.typeAddr = typeAddAddress;
            if (!IsEmptyValue(_dataArray)) {
                MYYMinesearchAddressModel* model =_dataArray[0];
                vc.addrModel = model;
            }
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            NSLog(@"登录失败");
            MYYLoginViewController* vc = [[MYYLoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}

- (UITableView*)tbView{
    if (_tbView == nil) {
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64 - 45) style:UITableViewStylePlain];
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.showsVerticalScrollIndicator = NO;
        _tbView.showsHorizontalScrollIndicator = NO;
        _tbView.backgroundColor = UIColorFromRGB(0xefefef);
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tbView];
        //    //隐藏多余cell
        _tbView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        //下拉刷新
        _tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            if (!IsEmptyValue(_dataArray)) {
                [_dataArray removeAllObjects];
            }
            [self searchAddressRequest];
            [_tbView.mj_header endRefreshing];
            
        }];
    }
    return _tbView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 10)];
    view.backgroundColor = UIColorFromRGB(0xefefef);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        return 130;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    MYYAddManageTableViewCell* mycell = [tableView dequeueReusableCellWithIdentifier:@"MYYAddManageTableViewCellID"];
    if (!mycell) {
        mycell = [[[NSBundle mainBundle]loadNibNamed:@"MYYAddManageTableViewCell" owner:self options:nil] firstObject];
    }
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)) {
            MYYMinesearchAddressModel* model =_dataArray[indexPath.section];
            mycell.model = model;
        }
        mycell.delegate = self;
        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
        return mycell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tbView) {
        if ([self.controller integerValue]  == 1) {
            if (!IsEmptyValue(_dataArray)) {
                MYYMinesearchAddressModel* model =_dataArray[indexPath.section];
                if (_transVaule) {
                    _transVaule(model);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }

    }
}

- (void)searchAddressRequest{
/*
 /myorder?action=searchAddress
 */
    [_dataArray removeAllObjects];
    [HTNetWorking postWithUrl:@"myorder?action=searchAddress" refreshCache:YES params:nil success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];

        if (!IsEmptyValue(array)) {
            for (NSDictionary* dict in array) {
                MYYMinesearchAddressModel* model = [[MYYMinesearchAddressModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
//                if (!IsEmptyValue(model.address)) {
//
//                }
                [_dataArray addObject:model];
            }
            [_tbView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)defaultBtnClick:(id)sender Id:(NSString *)Id{
    /*
     /mallAddressManage?action=updCustAddressDefault
     id
     */
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%@\"}",Id]};
    [HTNetWorking postWithUrl:@"mallAddressManage?action=updCustAddressDefault" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
//            [self customAlert:@"设置默认"];
            _page = 1;
            [self searchAddressRequest];
        }else if([str rangeOfString:@"false"].location!=NSNotFound){
            [self customAlert:@"设置失败"];
        }
    } fail:^(NSError *error) {
        
    }];
    
}
- (void)editBtnClick:(id)sender model:(MYYMinesearchAddressModel *)model{
    MYYAddAddrViewController* vc = [[MYYAddAddrViewController alloc]init];
    vc.addrModel = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)deleteBtnClick:(id)sender model:(MYYMinesearchAddressModel *)model{
    if (_dataArray.count>1) {
        if ([[NSString stringWithFormat:@"%@",model.isdefault] integerValue] == 1) {
            [self customAlert:@"请先设定其他地址为默认地址，再进行删除操作！"];
        }else{
            /*
             mallAddressManage?action=delCustAddress
             */
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"addressid\":\"%@\"}",model.Id]};
            [HTNetWorking postWithUrl:@"mallAddressManage?action=delCustAddress" refreshCache:YES params:params success:^(id response) {
                NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                if ([str rangeOfString:@"true"].location!=NSNotFound) {
                    //            [self customAlert:@"删除成功"];
                    _page = 1;
                    [self searchAddressRequest];
                }else if([str rangeOfString:@"false"].location!=NSNotFound){
                    [self customAlert:@"删除失败"];
                }
            } fail:^(NSError *error) {
                
            }];
        }
    }else{
        [self customAlert:@"请先设定其他地址为默认地址，再进行删除操作！"];
    }
}




@end
