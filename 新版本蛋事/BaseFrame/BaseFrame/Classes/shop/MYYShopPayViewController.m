//
//  MYYShopPayViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/9.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYShopPayViewController.h"
#import "MYYMineRechargeViewController.h"
#import "Paydetail.h"
#import "RegistReferModel.h"
#import "MYYFaHuoViewController.h"
#import "MYYPayMentOrderViewController.h"

@interface MYYShopPayViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString* _balanceStr;
}
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation MYYShopPayViewController{
    UILabel       *_monlab;
    UIButton      *_AlipayBut;//支付宝
    UIButton      *_WeiXinBut;//微信
    UIButton      *_ZhangHuYuE;//账户余额支付
    UIButton      *_HuoDaoFK;//货到付款
}

- (UITableView *)TableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight-50)];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.scrollEnabled =NO; //设置tableview 不能滚动
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MYYShopOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MYYShopOrderTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)viewDidLoad {
    self.navigationItem.title = @"选择支付方式";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    [self TableView];
    [self fooderUIView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBase:) name:AliPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBase:) name:WXPayTrue object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self searchUserInfoRequest];
}

- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WXPayTrue object:nil];
}
- (void)fooderUIView{
    
    //
    UIView *viewal = [[UIView alloc]initWithFrame:CGRectMake(0, mScreenHeight-45-NavBarHeight, mScreenWidth, 45)];
    if ([[UIApplication sharedApplication] statusBarFrame].size.height>20) {
        viewal.frame = CGRectMake(0, mScreenHeight-45-NavBarHeight-34, mScreenWidth, 45);
    }
    viewal.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewal];
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 1)];
    xian.backgroundColor = UIColorFromRGB(0xefefef);
    [viewal addSubview:xian];
    UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(8, 12, 110, 20)];
    labe.text = @"需付款:";
    labe.textColor = UIColorFromRGB(0x666666);
    [viewal addSubview:labe];
    
    _monlab = [[UILabel alloc]initWithFrame:CGRectMake(110, 12, 200, 20)];
    _monlab.textColor = UIColorFromRGB(0xE41D24);
    _monlab.text = [NSString stringWithFormat:@"￥%@",self.payMoney];
    [viewal addSubview:_monlab];
    
    UIButton *monBut = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth - 100, 0, 100, 45)];
    [monBut setTitle:@"确定"forState:UIControlStateNormal];
    monBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [monBut setBackgroundColor:[UIColor orangeColor]];
    [monBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [monBut addTarget:self action:@selector(butGo:) forControlEvents:UIControlEventTouchUpInside];
    [viewal addSubview:monBut];
    
}
- (void)butGo:(UIButton *)but{
    NSLog(@"钱数%@,订单号%@",_payMoney,_orderId);
    if (_AlipayBut.selected == YES) {
        [Paydetail zhiFuBaoname:@"测试" titile:@"测试" price:_payMoney orderId:_orderId notice:@"0"];
    }else if (_WeiXinBut.selected == YES){////@"0.01"
        [Paydetail wxname:@"测试微信" titile:@"测试微信" price:_payMoney orderId:_orderId notice:@"0"];
    }else if(_ZhangHuYuE.selected == YES){
        [self zhanghuRequest];
    }else if (_HuoDaoFK.selected == YES){
        [self huodaoRequest];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 3;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    // 通过不同标识创建cell实例
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"余额"];
//            cell.textLabel.text = @"账户余额(可用余额￥0.00)";
            cell.textLabel.text = [NSString stringWithFormat:@"账户余额(可用余额￥%@)",_balanceStr];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, mScreenWidth, 1)];
            xian.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell.contentView addSubview:xian];
            if (_ZhangHuYuE == nil) {
                _ZhangHuYuE = [UIButton buttonWithType:UIButtonTypeCustom];
            }
            _ZhangHuYuE .frame = CGRectMake(mScreenWidth-50, 10, 30, 30);
            
            [_ZhangHuYuE setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
            [_ZhangHuYuE setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
            if (_HuoDaoFK.selected || _AlipayBut.selected || _WeiXinBut.selected) {
                _ZhangHuYuE.selected = NO;
            }else{
                _ZhangHuYuE.selected = YES;
            }
            [_ZhangHuYuE addTarget:self action:@selector(ZhangHuYuEButAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_ZhangHuYuE];
        }else if (indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"货到付款"];
            cell.textLabel.text = @"货到付款";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, mScreenWidth, 1)];
            xian.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell.contentView addSubview:xian];
            
            if (_HuoDaoFK == nil) {
                _HuoDaoFK = [UIButton buttonWithType:UIButtonTypeCustom];
            }
            _HuoDaoFK .frame = CGRectMake(mScreenWidth-50, 10, 30, 30);
            
            [_HuoDaoFK setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
            [_HuoDaoFK setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
            if (_ZhangHuYuE.selected || _AlipayBut.selected || _WeiXinBut.selected) {
                _HuoDaoFK.selected = NO;
            }else{
                _HuoDaoFK.selected = YES;
            }
            [_HuoDaoFK addTarget:self action:@selector(HuoDaoFKButAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_HuoDaoFK];
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            cell.imageView.image = [UIImage imageNamed:@"充值"];
            cell.textLabel.text = @"账户余额充值";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            
            UIButton * payBut = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth-80, 10, 50, 30)];
            [payBut setTitle:@"充值" forState:UIControlStateNormal];
            [payBut setTitleColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1] forState:UIControlStateNormal];
            payBut.titleLabel.font = [UIFont systemFontOfSize:13];
            [payBut addTarget:self action:@selector(goPayButAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:payBut];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"在线支付";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, mScreenWidth, 1)];
            xian.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell.contentView addSubview:xian];
        }else if (indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"支付宝"];
            cell.textLabel.text = @"支付宝";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, mScreenWidth, 1)];
            xian.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell.contentView addSubview:xian];
            
            if (_AlipayBut == nil) {
                _AlipayBut = [UIButton buttonWithType:UIButtonTypeCustom];
            }
            _AlipayBut .frame = CGRectMake(mScreenWidth-50, 10, 30, 30);
        
            [_AlipayBut setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
            [_AlipayBut setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
            if (_ZhangHuYuE.selected || _HuoDaoFK.selected || _WeiXinBut.selected) {
                _AlipayBut.selected = NO;
            }else{
                _AlipayBut.selected = YES;
            }
            [_AlipayBut addTarget:self action:@selector(AlipayButAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_AlipayBut];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"微信"];
            cell.textLabel.text = @"微信支付";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            
            if (_WeiXinBut == nil) {
                _WeiXinBut = [UIButton buttonWithType:UIButtonTypeCustom];
            }
            _WeiXinBut .frame = CGRectMake(mScreenWidth-50, 10, 30, 30);
            
            [_WeiXinBut setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
            [_WeiXinBut setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
            if (_ZhangHuYuE.selected || _AlipayBut.selected || _HuoDaoFK.selected) {
                _WeiXinBut.selected = NO;
            }else{
                _WeiXinBut.selected = YES;
            }
            [_WeiXinBut addTarget:self action:@selector(WeiXinButAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_WeiXinBut];
        }
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 10)];
    header.backgroundColor = UIColorFromRGB(0xf0f0f0);
    return header;
}

- (void)goPayButAction{
    MYYMineRechargeViewController* vc = [[MYYMineRechargeViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)AlipayButAction{
    _AlipayBut.selected = YES;
    _HuoDaoFK.selected = NO;
    _ZhangHuYuE.selected = NO;
    _WeiXinBut.selected = NO;
}
- (void)WeiXinButAction{
    _WeiXinBut.selected = YES;
    _HuoDaoFK.selected = NO;
    _AlipayBut.selected = NO;
    _ZhangHuYuE.selected = NO;

}
- (void)ZhangHuYuEButAction{
    _ZhangHuYuE.selected = YES;
    _HuoDaoFK.selected = NO;
    _AlipayBut.selected = NO;
    _WeiXinBut.selected = NO;

}
- (void)HuoDaoFKButAction{
    _HuoDaoFK.selected = YES;
    _ZhangHuYuE.selected = NO;
    _AlipayBut.selected = NO;
    _WeiXinBut.selected = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchUserInfoRequest{
/*
 /mallLogin?action=searchUserInfo"
 */
    [HTNetWorking postWithUrl:@"mallLogin?action=searchUserInfo" refreshCache:YES params:nil success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"账户余额%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            RegistReferModel* model = [[RegistReferModel alloc]init];
            [model setValuesForKeysWithDictionary:array[0]];
            _balanceStr = [NSString stringWithFormat:@"%@",model.balance];
        }
        [_tableView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
    
}

- (void)getLoadDataBase:(NSNotificationCenter*)notice{
    MYYFaHuoViewController* vc = [[MYYFaHuoViewController alloc]init];
    vc.mark = 1;
    vc.controller = @"pay";
    [self.navigationController pushViewController:vc animated:YES];
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
            MYYFaHuoViewController* vc = [[MYYFaHuoViewController alloc]init];
            vc.mark = 1;
            vc.controller = @"pay";
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self showAlert:str];
//                MYYPayMentOrderViewController* vc = [[MYYPayMentOrderViewController alloc]init];
//                vc.mark = 1;
//                vc.controller = @"pay";
//                [self.navigationController pushViewController:vc animated:YES];
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
            MYYFaHuoViewController* vc = [[MYYFaHuoViewController alloc]init];
            vc.mark = 1;
            vc.controller = @"pay";
            [self.navigationController pushViewController:vc animated:YES];
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

@end
