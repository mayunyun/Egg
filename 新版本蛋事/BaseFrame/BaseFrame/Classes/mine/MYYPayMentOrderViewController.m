//
//  MYYPayMentOrderViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYPayMentOrderViewController.h"
#import "MYYMyOrterTableViewCell.h"
#import "MYYShopPayViewController.h"
#import "Paydetail.h"

@interface MYYPayMentOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSString* payMoney;
@property (nonatomic,strong)NSString* orderId;
@end

@implementation MYYPayMentOrderViewController{
    NSInteger _page;
    UIView *bgview;
    NSString *_pay;
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
    self.navigationItem.title = @"待付款";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    _page=1;
    [self TableView];
    [self dataRequest];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"orderUpData" object:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastViewController:)];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xffffff)];
}
- (void)backToLastViewController:(UIButton *)button
{
    //[Public hideLoadingView];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tongzhi:(NSNotification *)text{
    
    if ([text.userInfo[@"one"] integerValue] == 1) {
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
        cell.cancelBut.tag = [model.Id integerValue];
        [cell.cancelBut addTarget:self action:@selector(cancelButClick:) forControlEvents:UIControlEventTouchUpInside];

        NSMutableArray *prolist = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in model.orderprolist) {
            MYYMyOrderClassModer *ClassModer=[[MYYMyOrderClassModer alloc]init];
            [ClassModer setValuesForKeysWithDictionary:dic];
            //追加数据
            [prolist addObject:ClassModer];
        }
        cell.prolistArr = prolist;
        
        cell.nextBut.tag = 5000+indexPath.row;
        [cell.nextBut addTarget:self action:@selector(nextButClick:) forControlEvents:UIControlEventTouchUpInside];
        
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
    
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderstatus\":\"%@\"}",@"0"],@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"10"};
    [HTNetWorking postWithUrl:@"myorder?action=searchMyOrderNEW" refreshCache:YES params:params success:^(id response) {
        //NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = [dict objectForKey:@"rows"];
        //NSLog(@"%@",array);
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

//取消订单
- (void)cancelButClick:(UIButton *)seader{
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

- (void)nextButClick:(UIButton*)sender{
    if (!IsEmptyValue(_dataArr)&&_dataArr.count>sender.tag-5000) {
        MYYMyOrderModel *model = _dataArr[sender.tag - 5000];
        self.payMoney = [NSString stringWithFormat:@"%@",model.totalmoney];
        self.orderId = [NSString stringWithFormat:@"%@",model.orderno];
        [self setSMAlertWithView];
    }

}
//
//支付方式弹框
- (void)setSMAlertWithView{
    
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor clearColor]];
    
    
    bgview = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 0, mScreenWidth-60*MYWIDTH, 300*MYWIDTH)];
    bgview.backgroundColor = [UIColor clearColor];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth-60*MYWIDTH, 240*MYWIDTH)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.cornerRadius = 10;
    [bgview addSubview:view1];
    
    for (int i=0; i<3; i++) {
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 60*MYWIDTH+60*MYWIDTH*i, bgview.width-60*MYWIDTH, 1)];
        xian.backgroundColor = UIColorFromRGB(0xefefef);
        [view1 addSubview:xian];
    }
    NSArray *imageArr = @[@"选中",@"未选中",@"未选中",@"未选中"];
    for (int i=0; i<imageArr.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(45*MYWIDTH, 20*MYWIDTH+i*60*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
        imageview.image = [UIImage imageNamed:imageArr[i]];
        imageview.tag = 115+i;
        [view1 addSubview:imageview];
    }
    NSArray *imageArr1 = @[@"余额支付",@"支付宝支付",@"微信支付",@"货到付款支付"];
    for (int i=0; i<imageArr1.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(bgview.width/3, 15*MYWIDTH+i*60*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
        imageview.image = [UIImage imageNamed:imageArr1[i]];
        [view1 addSubview:imageview];
    }
    NSArray *titleArr = @[@"余额支付",@"支付宝支付",@"微信支付",@"货到付款"];
    for (int i=0; i<titleArr.count; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(bgview.width/2-10, 15*MYWIDTH+i*60*MYWIDTH, 200, 30*MYWIDTH)];
        lab.text = titleArr[i];
        lab.font = [UIFont systemFontOfSize:15*MYWIDTH];
        lab.textColor = UIColorFromRGB(0x333333);
        [view1 addSubview:lab];
    }
    for (int i=0; i<4; i++) {
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, i*60*MYWIDTH, bgview.width, 60*MYWIDTH)];
        but.tag = 550+i;
        [but addTarget:self action:@selector(zhifuButClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview:but];
    }
    
    UIButton *upbut = [[UIButton alloc]initWithFrame:CGRectMake(0, 250*MYWIDTH, bgview.width, 50*MYWIDTH)];
    upbut.layer.cornerRadius = 10;
    upbut.backgroundColor = NavBarItemColor;
    [upbut setTitle:@"确定" forState:UIControlStateNormal];
    [upbut addTarget:self action:@selector(butGo:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:upbut];
    [SMAlert showCustomView:bgview];
    [SMAlert hideCompletion:^{
        
    }];
}
- (void)zhifuButClicked:(UIButton *)button{
    UIImageView *image = [bgview viewWithTag:115];
    image.image = [UIImage imageNamed:@"未选中"];
    UIImageView *image1 = [bgview viewWithTag:116];
    image1.image = [UIImage imageNamed:@"未选中"];
    UIImageView *image2 = [bgview viewWithTag:117];
    image2.image = [UIImage imageNamed:@"未选中"];
    UIImageView *image3 = [bgview viewWithTag:118];
    image3.image = [UIImage imageNamed:@"未选中"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (button.tag == 550) {//余额支付
        UIImageView *image = [bgview viewWithTag:115];
        image.image = [UIImage imageNamed:@"选中"];
        _pay = @"0";
        
        
        
    }else if (button.tag == 551){//支付宝支付
        UIImageView *image = [bgview viewWithTag:116];
        image.image = [UIImage imageNamed:@"选中"];
        _pay = @"1";
        
        
    }else if (button.tag == 552){//微信支付
        UIImageView *image = [bgview viewWithTag:117];
        image.image = [UIImage imageNamed:@"选中"];
        _pay = @"2";
        
    }else if (button.tag == 553){//货到付款
        UIImageView *image = [bgview viewWithTag:118];
        image.image = [UIImage imageNamed:@"选中"];
        _pay = @"3";
    }
    
}
- (void)butGo:(UIButton *)but{
    [SMAlert hide:NO];
    
    NSLog(@"钱数%@,订单号%@",_payMoney,_orderId);
    if ([_pay isEqualToString:@"1"]) {
        [Paydetail zhiFuBaoname:@"测试" titile:@"测试" price:_payMoney orderId:_orderId notice:@"0"];
    }else if ([_pay isEqualToString:@"2"]){////@"0.01"
        [Paydetail wxname:@"测试微信" titile:@"测试微信" price:_payMoney orderId:_orderId notice:@"0"];
    }else if([_pay isEqualToString:@"0"]){
        [self zhanghuRequest];
    }else if ([_pay isEqualToString:@"3"]){
        [self huodaoRequest];
    }
    
}
- (void)zhanghuRequest{
    /*
     zhifubao?action=yueZhiFu
     */
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderno\":\"%@\"}",self.orderId]};
    [HTNetWorking postWithUrl:@"zhifubao?action=yueZhiFu" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"余额支付%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            UIAlertController* aleart = [UIAlertController alertControllerWithTitle:@"提示" message:@"订单提交成功，请等待发货" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dataRequest];
            }];
            [aleart addAction:action1];
            [self presentViewController:aleart animated:YES completion:nil];
        }else{
            [self showAlert:str];
            
        }
    } fail:^(NSError *error) {
        
    }];
    
}

- (void)huodaoRequest{
    /*
     zhifubao?action=xianXiaZhiFu
     */
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderno\":\"%@\"}",self.orderId]};
    [HTNetWorking postWithUrl:@"zhifubao?action=xianXiaZhiFu" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"线下支付%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            UIAlertController* aleart = [UIAlertController alertControllerWithTitle:@"提示" message:@"订单提交成功，请等待发货" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dataRequest];
            }];
            [aleart addAction:action1];
            [self presentViewController:aleart animated:YES completion:nil];
            
        }else{
            [self showAlert:str];
            //            MYYPayMentOrderViewController* vc = [[MYYPayMentOrderViewController alloc]init];
            //            vc.mark = 1;
            //            vc.controller = @"pay";
            //            [self.navigationController pushViewController:vc animated:YES];
        }
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
