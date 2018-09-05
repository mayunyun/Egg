//
//  MYYMineOnlineRechrageViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYMineOnlineRechrageViewController.h"
#import "MYYMineOnlineTableViewCell.h"
#import "Paydetail.h"
@interface MYYMineOnlineRechrageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton* _AlipayBut;
    UIButton* _WeiXinBut;
    
}
@property (nonatomic,strong)UITableView* tbView;
@property (nonatomic,strong)UIScrollView* bgView;
@end

@implementation MYYMineOnlineRechrageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self bgView];
    [self tbView];
    UIButton* nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.frame = CGRectMake(10, _tbView.bottom+50, kScreen_Width - 20, 44);
    [nextBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    nextBtn.backgroundColor = NavBarItemColor;
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = 5;
    [_bgView addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (UIScrollView*)bgView{
    if (_bgView == nil) {
        _bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64- 40)];
        _bgView.backgroundColor = BackGorundColor;
        _bgView.contentSize = CGSizeMake(kScreen_Width, 714);
        _bgView.showsVerticalScrollIndicator = NO;
        _bgView.showsHorizontalScrollIndicator = NO;
        _bgView.bounces = NO;
        [self.view addSubview:_bgView];
    }
    return _bgView;
}

- (UITableView*)tbView{
    if (_tbView == nil) {
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 30*2+45*2+110) style:UITableViewStylePlain];
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.showsVerticalScrollIndicator = NO;
        _tbView.showsHorizontalScrollIndicator = NO;
        _tbView.scrollEnabled =NO; //设置tableview 不能滚动
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_bgView addSubview:_tbView];
    }
    return _tbView;
}
#pragma mark 确认支付
- (void)nextBtnClick:(UIButton*)sender{
    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    MYYMineOnlineTableViewCell* cell = [_tbView cellForRowAtIndexPath:reloadIndexPath];
    [cell.moneyField resignFirstResponder];
    NSString* money;
    if (cell.selectBtn1.selected) {
        money = @"100";
    }else if (cell.selectBtn2.selected) {
        money = @"300";
    }else if (cell.selectBtn3.selected) {
        money = @"500";
    }else if (cell.selectBtn4.selected) {
        money = @"1000";
    }else if (!IsEmptyValue(cell.moneyField.text)){
        money = cell.moneyField.text;
    }else{
        [self showAlert:@"请选择充值金额"];
        return;
    }
    NSLog(@"充值金额%@",money);
    if (_AlipayBut.selected == YES) {
        if (!IsEmptyValue(money)) {
            [self rechrageOrderRequest:@"ZF" money:money];
        }
    }else if (_WeiXinBut.selected == YES){
        if (!IsEmptyValue(money)) {
            [self rechrageOrderRequest:@"WX" money:money];
        }
    }
}

#pragma mark uitableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 110;
    }else if (indexPath.section == 1){
        return 44;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    MYYMineOnlineTableViewCell* chargeCell = [tableView dequeueReusableCellWithIdentifier:@"MYYMineOnlineTableViewCellID"];
    if (!chargeCell) {
        chargeCell = [[[NSBundle mainBundle]loadNibNamed:@"MYYMineOnlineTableViewCell" owner:self options:nil] firstObject];
    }
    
    if (indexPath.section == 0&&indexPath.row == 0) {
        
        chargeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return chargeCell;
    }
    if (indexPath.section == 1&&indexPath.row == 0){
        cell.imageView.image = [UIImage imageNamed:@"支付宝"];
        cell.textLabel.text = @"支付宝";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, mScreenWidth, 1)];
        xian.backgroundColor = UIColorFromRGB(0xf0f0f0);
        [cell.contentView addSubview:xian];
        
        _AlipayBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _AlipayBut .frame = CGRectMake(mScreenWidth-50, 10, 30, 30);
        
        [_AlipayBut setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
        [_AlipayBut setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
        _AlipayBut.selected = YES;
        [_AlipayBut addTarget:self action:@selector(AlipayButAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:_AlipayBut];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (indexPath.section == 1&&indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"微信"];
        cell.textLabel.text = @"微信支付";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        
        _WeiXinBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _WeiXinBut .frame = CGRectMake(mScreenWidth-50, 10, 30, 30);
        
        [_WeiXinBut setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
        [_WeiXinBut setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
        _WeiXinBut.selected = NO;
        [_WeiXinBut addTarget:self action:@selector(WeiXinButAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:_WeiXinBut];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray* array = @[@"选择充值金额",@"选择支付方式"];
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
    view.backgroundColor = BackGorundColor;
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, view.width - 20, view.height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = array[section];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)AlipayButAction:(UIButton*)sender{
    _WeiXinBut.selected = _AlipayBut.selected;
    _AlipayBut.selected = !_AlipayBut.selected;

}

- (void)WeiXinButAction:(UIButton*)sender{
    _AlipayBut.selected = _WeiXinBut.selected;
    _WeiXinBut.selected = !_WeiXinBut.selected;
}

- (void)rechrageOrderRequest:(NSString*)biaoshi money:(NSString*)money{
/*
 recharge?action=phonegetCharge
 */
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"biaoshi\":\"%@\"}",biaoshi]};
    [HTNetWorking postWithUrl:@"recharge?action=phonegetCharge" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"获取微信充值单号%@",str);
        NSString* orderno = [Command replaceAllOthers:str];
        if ([biaoshi isEqualToString:@"WX"]) {
            [Paydetail wxname:[NSString stringWithFormat:@"在线充值%@元",money] titile:@"充值" price:money orderId:orderno notice:@"1"];
        }else if ([biaoshi isEqualToString:@"ZF"]){
            [Paydetail zhiFuBaoname:[NSString stringWithFormat:@"在线充值%@元",money] titile:@"充值" price:money orderId:orderno notice:@"1"];
        }
        
    } fail:^(NSError *error) {
        
    }];
}


@end
