//
//  MYYFaHuoViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYFaHuoViewController.h"
#import "MYYMyOrterTableViewCell.h"
@interface MYYFaHuoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation MYYFaHuoViewController{
    
    NSInteger _page;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置状态栏颜色
    [self setStatusBarBackgroundColor:UIColorFromRGB(0xFFA500)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
}

- (UITableView *)TableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight-104)];
        if (self.mark==1) {
            _tableView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight-64);
        }
        _tableView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MYYMyOrterTableViewCell" bundle:nil] forCellReuseIdentifier:@"MYYMyOrterTableViewCell"];
        [self.view addSubview:_tableView];
        //下拉刷新
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            if (!IsEmptyValue(_dataArr)) {
                [_dataArr removeAllObjects];
            }
            [self dataRequest];
            [_tableView.mj_header endRefreshing];
            
        }];
        //
        _tableView.mj_header.automaticallyChangeAlpha = YES;
        //
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _page ++;
            [self dataRequest];
            [_tableView.mj_footer endRefreshing];
        }];
    }
    return _tableView;
}
- (void)viewDidLoad {
    self.navigationItem.title = @"待发货";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    _page=1;
    [self TableView];
    if (_mark == 1) {
        [self dataRequest];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"orderUpData" object:nil];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastViewController:)];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xffffff)];
}

- (void)tongzhi:(NSNotification *)text{
    
    if ([text.userInfo[@"one"] integerValue] == 2) {
        _page = 1;
        [self dataRequest];
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderUpData" object:nil];
}

- (void)backToLastViewController:(UIButton *)button{
    
    
    if ([self.controller isEqualToString:@"pay"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_prolistArr.count>indexPath.row) {
//        NSArray* prolist = _prolistArr[indexPath.row];
//        return 120 + prolist.count*70;
//    }
    if (_dataArr.count) {
        MYYMyOrderModel *model = _dataArr[indexPath.row];
        return 130 + [model.orderprolist count]*70;
    }
    return 130;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYYMyOrterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYYMyOrterTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArr.count) {
        MYYMyOrderModel *model = _dataArr[indexPath.row];
        [cell configModel:model];
        
        NSMutableArray *prolist = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in model.orderprolist) {
            MYYMyOrderClassModer *ClassModer=[[MYYMyOrderClassModer alloc]init];
            [ClassModer setValuesForKeysWithDictionary:dic];
            //追加数据
            [prolist addObject:ClassModer];
        }
        cell.prolistArr = prolist;
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)dataRequest{
    if (_dataArr==nil) {
        _dataArr = [[NSMutableArray alloc]init];
    }else{
        if (_page == 1) {
            [_dataArr removeAllObjects];
        }
    }
    
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderstatus\":\"%@\"}",@"1"],@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"10"};
    [HTNetWorking postWithUrl:@"myorder?action=searchMyOrderNEW" refreshCache:YES params:params success:^(id response) {
        //NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = [dict objectForKey:@"rows"];
        NSLog(@"待发货%@",array);
        if (!IsEmptyValue(array)) {
            for (NSDictionary*dic in array) {
                MYYMyOrderModel *model=[[MYYMyOrderModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [_dataArr addObject:model];
            }
        }
        [_tableView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
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
