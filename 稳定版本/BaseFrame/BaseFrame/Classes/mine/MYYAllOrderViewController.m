//
//  MYYAllOrderViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYAllOrderViewController.h"
#import "MYYMyOrterTableViewCell.h"
#import "MYYMyOrderModel.h"
#import "MYYCoderCommentViewController.h"//评价
#import "MYYShopPayViewController.h"
@interface MYYAllOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;


@end

@implementation MYYAllOrderViewController{
    NSMutableArray *_prolistArr;
    NSInteger _page;

}

- (UITableView *)TableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight-104)];
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
    self.view.backgroundColor = [UIColor whiteColor];
    _prolistArr = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    _page=1;
    [self dataRequest];
    [self TableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"orderUpData" object:nil];
}
- (void)tongzhi:(NSNotification *)text{
    if ([text.userInfo[@"one"] integerValue] == 0) {
        _page = 1;
        [self dataRequest];
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderUpData" object:nil];
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
//    return 190;
    if (_dataArr.count) {
        MYYMyOrderModel *model = _dataArr[indexPath.row];
        NSInteger count = 0;
        if (!IsEmptyValue(_prolistArr)) {
            for (NSArray* arr in _prolistArr) {
                if (!IsEmptyValue(arr)) {
                    MYYMyOrderClassModer* classModel = arr[0];
                    if ([[NSString stringWithFormat:@"%@",model.Id] integerValue] == [[NSString stringWithFormat:@"%@",classModel.orderid] integerValue]) {
                        count = arr.count;
                        
                    }
                }
            }
        }
        return 120 + count*70;
    }
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYYMyOrterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYYMyOrterTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArr.count) {
        MYYMyOrderModel *model = _dataArr[indexPath.row];
    
        [cell configModel:model];
        cell.cancelBut.tag = [model.Id integerValue];
        [cell.cancelBut addTarget:self action:@selector(allcancelButClick:) forControlEvents:UIControlEventTouchUpInside];//删除订单
        
        objc_setAssociatedObject(cell.nextBut, "indexpath", [NSString stringWithFormat:@"%zd",indexPath.row], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(cell.nextBut, "orderstatus", model.orderstatus, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [cell.nextBut addTarget:self action:@selector(allButClick:) forControlEvents:UIControlEventTouchUpInside];

        if (!IsEmptyValue(_prolistArr)) {
            for (NSArray* arr in _prolistArr) {
                if (!IsEmptyValue(arr)) {
                    MYYMyOrderClassModer* classModel = arr[0];
                    if ([[NSString stringWithFormat:@"%@",model.Id] integerValue] == [[NSString stringWithFormat:@"%@",classModel.orderid] integerValue]) {
                         cell.prolistArr = arr;
                        
                    }
                }
            }
        }
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

    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderstatus\":\"%@\"}",@""],@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"10"};
    [HTNetWorking postWithUrl:@"myorder?action=searchMyOrder" refreshCache:YES params:params success:^(id response) {
        //NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = [dict objectForKey:@"rows"];
        NSLog(@"%@",array);
        if (!IsEmptyValue(array)) {
            for (NSDictionary*dic in array) {
                MYYMyOrderModel *model=[[MYYMyOrderModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [_dataArr addObject:model];
                [self dataOrder:model.Id];
            }
        }
        [_tableView reloadData];

    } fail:^(NSError *error) {
        
    }];
}
- (void)dataOrder:(NSString *)strid{
    
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderid\":\"%@\"}",strid]};
    [HTNetWorking postWithUrl:@"myorder?action=searchMyOrderDetail" refreshCache:YES params:params success:^(id response) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            for (NSDictionary*dic in array) {
                MYYMyOrderClassModer *model=[[MYYMyOrderClassModer alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [arr addObject:model];
            }
            [_prolistArr addObject:arr];

        }
        [_tableView reloadData];

    } fail:^(NSError *error) {
        
    }];
}
- (void)allButClick:(UIButton *)seader{
    NSString *first = objc_getAssociatedObject(seader, "indexpath");
    NSString *second = objc_getAssociatedObject(seader, "orderstatus");
    
    switch ([second intValue]) {//0待付款 1 待发货 2 待收货 3待评价 4订单完成
        case 0:{
            [self allnextPayBut:[first integerValue]];
            
            break;
        }
        case 1:{
        
            break;
        }
        case 2:{
            [self allshouHuoButClick:[first integerValue]];
            break;
        }
        case 3:{
            [self allcommentBut:[first integerValue]];
    
            break;
        }
            
        default:
            break;
    }

}
//去付款
- (void)allnextPayBut:(NSInteger )seader{
    MYYMyOrderModel *model = _dataArr[seader];

    MYYShopPayViewController *shopPay = [[MYYShopPayViewController alloc]init];
    shopPay.payMoney = [NSString stringWithFormat:@"%@",model.totalmoney];
    shopPay.orderId = [NSString stringWithFormat:@"%@",model.orderno];
    shopPay.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopPay animated:YES];
}
//取消订单
- (void)allcancelButClick:(UIButton *)seader{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您确定要取消订单" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%zd\"}",seader.tag]};
        NSLog(@"%@",params);
        [HTNetWorking postWithUrl:@"myorder?action=deleteOrder" refreshCache:YES params:params success:^(id response) {
            NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
            if ([str rangeOfString:@"true"].location!=NSNotFound) {
                [self showAlert:@"取消订单成功"];
                _page = 1;
                [self dataRequest];
            }
        } fail:^(NSError *error) {
            
        }];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
//确认收货
- (void)allshouHuoButClick:(NSInteger)seader{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认收货" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        MYYMyOrderModel *model = _dataArr[seader];
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%@\"}",model.Id]};
        NSLog(@"%@",params);
        [HTNetWorking postWithUrl:@"myorder?action=confirmOrder" refreshCache:YES params:params success:^(id response) {
            NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
            if ([str rangeOfString:@"true"].location!=NSNotFound) {
                [self showAlert:@"已经完成收货"];
                _page = 1;
                [self dataRequest];
            }
        } fail:^(NSError *error) {
            
        }];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
//评论
- (void)allcommentBut:(NSInteger )but{
    MYYCoderCommentViewController *coder = [[MYYCoderCommentViewController alloc]init];

    MYYMyOrderModel *model = _dataArr[but];
    if (!IsEmptyValue(_prolistArr)) {
        for (NSArray* arr in _prolistArr) {
            if (!IsEmptyValue(arr)) {
                MYYMyOrderClassModer* classModel = arr[0];
                if ([[NSString stringWithFormat:@"%@",model.Id] integerValue] == [[NSString stringWithFormat:@"%@",classModel.orderid] integerValue]) {
                    coder.orderArr = arr;
                    [self.navigationController pushViewController:coder animated:YES];
                }
            }
        }
    }
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
