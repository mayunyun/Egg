//
//  MYYMineRechrageManageViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/15.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYMineRechrageManageViewController.h"
#import "MYYMineRechrageModel.h"
#import "MineRechargeTableViewCell.h"

@interface MYYMineRechrageManageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* _dataArray;
    NSInteger _page;
}
@property (nonatomic,strong)UITableView* tbView;
@end

@implementation MYYMineRechrageManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _page = 1;
    [self creatUI];
    [self dataRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)creatUI
{
    self.title = @"充值记录";
    [self tbView];
}

- (UITableView*)tbView{
    if (_tbView == nil) {
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.showsVerticalScrollIndicator = YES;
        _tbView.showsHorizontalScrollIndicator = YES;
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbView.rowHeight = 50;
        [self.view addSubview:_tbView];
        //下拉刷新
        _tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            if (!IsEmptyValue(_dataArray)) {
                [_dataArray removeAllObjects];
            }
            [self dataRequest];
            [_tbView.mj_header endRefreshing];
            
        }];
        //
        _tbView.mj_header.automaticallyChangeAlpha = YES;
        //
        _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _page ++;
            [self dataRequest];
            [_tbView.mj_footer endRefreshing];
        }];

    }
    return _tbView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    MineRechargeTableViewCell* mycell = [tableView dequeueReusableCellWithIdentifier:@"MineRechargeTableViewCellID"];
    if (!mycell) {
        mycell = [[[NSBundle mainBundle]loadNibNamed:@"MineRechargeTableViewCell" owner:self options:nil]firstObject];
    }
    
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)) {
            MYYMineRechrageModel* model = _dataArray[indexPath.row];
            mycell.model = model;
        }
        
        return mycell;
    }
    return cell;
}


- (void)dataRequest{
    /*
     recharge?action=recharge_record
     */
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"20"};
    [HTNetWorking postWithUrl:@"recharge?action=recharge_record" refreshCache:YES  params:params success:^(id response) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"订单充值查询%@",dic);
        if (_page == 1) {
            [_dataArray removeAllObjects];
        }
        if (!IsEmptyValue(dic[@"rows"])) {
            for (NSDictionary* dict in dic[@"rows"])  {
                MYYMineRechrageModel* model = [[MYYMineRechrageModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArray addObject:model];
            }
            [_tbView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}


@end
