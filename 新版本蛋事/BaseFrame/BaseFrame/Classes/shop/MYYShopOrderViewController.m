//
//  MYYShopOrderViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/9.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYShopOrderViewController.h"
#import "MYYShopOrderTableViewCell.h"
#import "MYYShopOrderModel.h"
#import "MYYShopAddrModel.h"
#import "MYYAddManageViewController.h"
#import "MYYMinesearchAddressModel.h"
#import "JVShopcartBrandModel.h"
#import "MYYLoginViewController.h"
#import "Paydetail.h"
#import "MYYFaHuoViewController.h"
#import "MYYMyOrderViewController.h"
@interface MYYShopOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) MYYShopAddrModel* addrModel;
@property (nonatomic,strong)NSString* payMoney;
@property (nonatomic,strong)NSString* orderId;
@end

@implementation MYYShopOrderViewController{
    
    UILabel        *_monlab;
    NSMutableArray* _dataArray;//订单商品
    UIView *bgview;

    NSString *_pay;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置状态栏颜色
    [self setStatusBarBackgroundColor:UIColorFromRGB(0xFFA500)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barTintColor = NavBarItemColor;
    
}
- (UITableView *)TableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight-NavBarHeight)];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MYYShopOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MYYShopOrderTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)viewDidLoad {
    _addrModel = [[MYYShopAddrModel alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"确认订单";
    self.view.backgroundColor = [UIColor whiteColor];
    _pay = @"0";
    [super viewDidLoad];
    [self TableView];
    [self fooderUIView];
    [self dataRequest];
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
    labe.text = @"实付金额:";
    labe.textColor = UIColorFromRGB(0x666666);
    [viewal addSubview:labe];
    
    _monlab = [[UILabel alloc]initWithFrame:CGRectMake(110, 12, 200, 20)];
    _monlab.textColor = UIColorFromRGB(0xE41D24);
    if (_next==0) {
        _monlab.text = [NSString stringWithFormat:@"￥%.2f",[_proprice floatValue]*[_count intValue]];
    }else{
        _monlab.text = [NSString stringWithFormat:@"￥%.2f",self.xiaojicount];
    }
    [viewal addSubview:_monlab];
    
    UIButton *monBut = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth - 100, 0, 100, 45)];
    [monBut setTitle:@"提交订单"forState:UIControlStateNormal];
    monBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [monBut setBackgroundColor:[UIColor orangeColor]];
    [monBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [monBut addTarget:self action:@selector(butwhihGo:) forControlEvents:UIControlEventTouchUpInside];
    [viewal addSubview:monBut];
    
}
//地址
- (UIView *)addressView{

    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 90*MYWIDTH)];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(8, 25, 30, 30)];
    image.image = [UIImage imageNamed:@"icon_location"];
    [view addSubview:image];
    UIImageView *imageyou = [[UIImageView alloc]initWithFrame:CGRectMake(mScreenWidth-30, 27.5, 25, 25)];
    imageyou.image = [UIImage imageNamed:@"iconfont-arrow"];
    [view addSubview:imageyou];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(45*MYWIDTH, 10*MYWIDTH, 240*MYWIDTH, 20*MYWIDTH)];
    name.text = [NSString stringWithFormat:@"收货人:%@",_addrModel.custname];
    NSLog(@"收货人%@",_addrModel.custname);
    name.font = [UIFont systemFontOfSize:15*MYWIDTH];
    name.textColor = UIColorFromRGB(0x333333);
    [view addSubview:name];
    
    UILabel *phonelab = [[UILabel alloc]initWithFrame:CGRectMake(45*MYWIDTH, name.bottom+5, 220*MYWIDTH, 20*MYWIDTH)];
    phonelab.text = [NSString stringWithFormat:@"%@",_addrModel.phone];
    phonelab.textAlignment = NSTextAlignmentLeft;
    if (IsEmptyValue(_addrModel.phone)) {
        phonelab.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USERPHONE]];
    }
    phonelab.font = [UIFont systemFontOfSize:15*MYWIDTH];
    phonelab.textColor = UIColorFromRGB(0x333333);
    [view addSubview:phonelab];
    
    UILabel *addressLab = [[UILabel alloc]initWithFrame:CGRectMake(45*MYWIDTH, phonelab.bottom, mScreenWidth-60*MYWIDTH, 30*MYWIDTH)];
    addressLab.text = [NSString stringWithFormat:@"收货地址:%@  %@%@%@%@",_addrModel.province,_addrModel.city,_addrModel.area,_addrModel.village,_addrModel.address];
    addressLab.textAlignment = NSTextAlignmentLeft;
    if (IsEmptyValue(_addrModel.province)) {
        addressLab.text = @"收货地址:";
    }
    addressLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    addressLab.numberOfLines = 0;
    addressLab.textColor = UIColorFromRGB(0x666666);
    [view addSubview:addressLab];
    
    UIImageView *xian = [[UIImageView alloc]initWithFrame:CGRectMake(0, 88*MYWIDTH, mScreenWidth, 2)];
    xian.image = [UIImage imageNamed:@"组"];
    [view addSubview:xian];
    
    return view;
}

- (UIView *)xiaojiView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 50)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 30)];
    lab.text = @"商品小计";
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = UIColorFromRGB(0x333333);
    [view addSubview:lab];
    
    UILabel *pay = [[UILabel alloc]initWithFrame:CGRectMake(mScreenWidth-90, 10, 80, 30)];
    
    if (_next==0) {
        pay.text = [NSString stringWithFormat:@"￥%.2f",[_proprice floatValue]*[_count intValue]];
    }else{
        pay.text = [NSString stringWithFormat:@"￥%.2f",self.xiaojicount];
    }
    pay.font = [UIFont systemFontOfSize:13];
    pay.textAlignment = NSTextAlignmentRight;
    pay.textColor = UIColorFromRGB(0x333333);
    [view addSubview:pay];
    return view;
}
#pragma mark 订单提交
- (void)butwhihGo:(UIButton *)but{
    [Command isloginRequest:^(bool flag) {
        if (flag) {
            if (IsEmptyValue(_addrModel.cityid)||IsEmptyValue(_addrModel.areaid)||IsEmptyValue(_addrModel.villageid)) {
                [self showAlert:@"请完善您详细的收货地址"];
                return ;
            }
            /*
             订单提交：/myorder?action=addMyOrder   参数：custid，custname，custphone，custaddress，totalcount，totalmoney，provinceid，cityid,areaid,villageid  字表
             proid，proname,specification,price,count,money,type
             */
            NSMutableString* mustr = [[NSMutableString alloc]init];
            NSInteger totalcount = 0;
            CGFloat totalmoney = 0.0;
            int i = 0;
            
            if (self.next == 1) {//数据来自购物车
                for (MYYShopOrderModel* model in _dataArray) {
                    JVShopcartBrandModel *brandmodel = _dataArr[i];
                    i++;
                    NSString* str = [NSString stringWithFormat:@"{\"table\":\"pro_order_detail\",\"proid\":\"%@\",\"proname\":\"%@\",\"specification\":\"%@\",\"price\":\"%@\",\"count\":\"%zd\",\"money\":\"%.2f\",\"type\":\"%@\"},",model.proid,model.proname,model.specification,model.price,brandmodel.count,[model.price floatValue]*brandmodel.count,model.type];
                    [mustr appendString:str];
                    totalcount += [[NSString stringWithFormat:@"%zd",brandmodel.count] integerValue];
                    totalmoney += [[NSString stringWithFormat:@"%.2f",[model.price floatValue]*brandmodel.count] floatValue];
                }
            }else if (self.next == 0){//数据来自商品立即购买
                
                NSString* str = [NSString stringWithFormat:@"{\"table\":\"pro_order_detail\",\"proid\":\"%@\",\"proname\":\"%@\",\"specification\":\"%@\",\"price\":\"%@\",\"count\":\"%@\",\"money\":\"%.2f\",\"type\":\"%@\"},",self.proid,self.proname,self.specification,self.proprice,self.count,[self.proprice floatValue]*[self.count integerValue],self.type];
                [mustr appendString:str];
                totalcount = [[NSString stringWithFormat:@"%@",self.count] integerValue];
                totalmoney = [[NSString stringWithFormat:@"%.2f",[self.proprice floatValue]*[self.count integerValue]] floatValue];
            }
            NSString* prostr = mustr;
            if (prostr.length!=0) {
                NSRange range = {0,prostr.length - 1};
                prostr = [prostr substringWithRange:range];
            }
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"table\":\"pro_order\",\"custid\":\"%@\",\"custname\":\"%@\",\"custphone\":\"%@\",\"custaddress\":\"%@\",\"totalcount\":\"%@\",\"totalmoney\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"villageid\":\"%@\",\"proList\":[%@]}",_addrModel.custid,_addrModel.custname,_addrModel.phone,_addrModel.address,[NSString stringWithFormat:@"%li",(long)totalcount],[NSString stringWithFormat:@"%.2f",totalmoney],_addrModel.provinceid,_addrModel.cityid,_addrModel.areaid,_addrModel.villageid,prostr]};
            
            NSLog(@"%@",params);
            [HTNetWorking postWithUrl:@"myorder?action=addMyOrder" refreshCache:YES showHUD:@"" params:params success:^(id response) {
                NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                NSLog(@"提交订单返回数据%@",str);
                if (!IsEmptyValue(str)) {
                    if ([str rangeOfString:@"false"].location!=NSNotFound) {
                        
                    }else{
                        NSString*string =@"orderno:";
                        NSString*money = @"totalmoney:";
                        NSRange range = [str rangeOfString:string];//匹配得到的下标
                        NSRange range1 = [str rangeOfString:money];
                        NSLog(@"rang:%@\n,range1%@",NSStringFromRange(range),NSStringFromRange(range1));
                        NSRange noRange = NSMakeRange(range.location+range.length, range1.location - range.location - range.length);
                        NSRange mRange = NSMakeRange(range1.location+range1.length, str.length - 1 - range1.location - range1.length);
                        NSString* nostr = [str substringWithRange:noRange];//截取范围类的字符串
                        NSString* moneystr = [str substringWithRange:mRange];
                        NSLog(@"截取的值为：%@,%@",nostr,moneystr);
                        //[Command customAlert:@"加入订单成功"];
                        self.payMoney = [NSString stringWithFormat:@"%.2f",totalmoney];
                        self.orderId = [NSString stringWithFormat:@"%@",nostr];
                        
                        [self setSMAlertWithView];
                    }
                }
                
            } fail:^(NSError *error) {
                
            }];

            
        }else{
            NSLog(@"登录失败");
            MYYLoginViewController* vc = [[MYYLoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return _dataArray.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*MYWIDTH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90*MYWIDTH;
    }else{
        if (indexPath.row == _dataArray.count) {
            return 50*MYWIDTH;
        }else{
             return 110;
        }
    }
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        [cell.contentView addSubview:[self addressView]];
    }else{
       if (indexPath.row ==_dataArray.count){
            cell.textLabel.text = @"商家配送";
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
        }else{
            MYYShopOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYYShopOrderTableViewCell" forIndexPath:indexPath];
            if (!IsEmptyValue(_dataArray)) {
                MYYShopOrderModel *model = _dataArray[indexPath.row];
                JVShopcartBrandModel *brandmodel = _dataArr[indexPath.row];
                [cell setDataCount:[self.count integerValue] WithModel:model gouWuCheModel:brandmodel];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        MYYAddManageViewController *addmanage = [[MYYAddManageViewController alloc]init];
        addmanage.controller = @"1";
        [addmanage setTransVaule:^(MYYMinesearchAddressModel * model) {
            
            _addrModel.custname = model.custname;
            _addrModel.phone = model.phone;
            _addrModel.province = model.province;
            _addrModel.city = model.city;
            _addrModel.area = model.area;
            _addrModel.address = model.address;
            _addrModel.custid = model.custid;
            _addrModel.provinceid = model.provinceid;
            _addrModel.cityid = model.cityid;
            _addrModel.village = model.village;
            _addrModel.areaid = model.areaid;
            _addrModel.villageid = model.villageid;
            [_tableView reloadData];
        }];
        [self.navigationController pushViewController:addmanage animated:YES];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 10)];
    header.backgroundColor = UIColorFromRGB(0xf0f0f0);
    return header;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 40;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
    
}

- (void)dataRequest{
    NSDictionary* addrparams = @{@"data":[NSString stringWithFormat:@"{\"id\":\"\"}"]};
    [HTNetWorking postWithUrl:@"myorder?action=searchAddressMnew" refreshCache:YES params:addrparams success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSSLog(@"默认地址请求%@",str);
        if (!IsEmptyValue(array)) {
            NSDictionary* dict = array[0];
            [_addrModel setValuesForKeysWithDictionary:dict];
        }
        [_tableView reloadData];
    } fail:^(NSError *error) {
        NSLog(@"默认地址请求失败");
    }];
    //
    NSDictionary* params;
    if (self.next == 1) {//数据来自购物车
        NSString *gouwucheID = [[NSString alloc]init];

        NSLog(@"%@",self.dataArr);
        for (JVShopcartBrandModel *brandModel in self.dataArr) {
            gouwucheID = [gouwucheID stringByAppendingFormat:@"%@,",brandModel.id];
        }
        params = @{@"data":[NSString stringWithFormat:@"{\"shoppingcardids\":\"%@\"}", [gouwucheID substringToIndex:[gouwucheID length]- 1]]};
    }else if (self.next == 0){//数据来自商品立即购买
        self.Id = [Command convertNull:self.Id];
        params = @{@"data":[NSString stringWithFormat:@"{\"type\":\"%@\",\"proid\":\"%@\",\"shoppingcardids\":\"%@\",\"count\":\"%@\",\"id\":\"%@\"}",self.type,self.proid,@"",self.count,self.Id]};
    }
    NSLog(@"%@",params);


    [HTNetWorking postWithUrl:@"myorder?action=searchProDetai" refreshCache:YES params:params success:^(id response) {
       // NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@">>>>%@",str);

        if (!IsEmptyValue(array)) {
            NSLog(@"%@",array);
            //建立模型
            for (NSDictionary*dic in array) {
                MYYShopOrderModel *model=[[MYYShopOrderModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [_dataArray addObject:model];
            }

        }
        [_tableView reloadData];
    } fail:^(NSError *error) {
        NSLog(@"购物车请求失败");
    }];
}
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
//        jxt_showAlertTwoButton(@"提示", @"您确定使用余额支付吗", @"取消", ^(NSInteger buttonIndex) {
//
//        }, @"确定", ^(NSInteger buttonIndex) {
//
//
//
//
//        });
        
        
    }else if (button.tag == 551){//支付宝支付
        UIImageView *image = [bgview viewWithTag:116];
        image.image = [UIImage imageNamed:@"选中"];
        _pay = @"1";
//        jxt_showAlertTwoButton(@"提示", @"您确定使用支付宝支付吗", @"取消", ^(NSInteger buttonIndex) {
//
//        }, @"确定", ^(NSInteger buttonIndex) {
//
//        });
        
        
    }else if (button.tag == 552){//微信支付
        UIImageView *image = [bgview viewWithTag:117];
        image.image = [UIImage imageNamed:@"选中"];
        _pay = @"2";
//        jxt_showAlertTwoButton(@"提示", @"您确定使用微信支付吗", @"取消", ^(NSInteger buttonIndex) {
//
//        }, @"确定", ^(NSInteger buttonIndex) {
//
//
//
//        });
    }else if (button.tag == 553){//货到付款
        UIImageView *image = [bgview viewWithTag:118];
        image.image = [UIImage imageNamed:@"选中"];
        _pay = @"3";
        //        jxt_showAlertTwoButton(@"提示", @"您确定使用余额支付吗", @"取消", ^(NSInteger buttonIndex) {
        //
        //        }, @"确定", ^(NSInteger buttonIndex) {
        //
        //
        //
        //        });
    }
    
}
- (void)butGo:(UIButton *)but{
    [SMAlert hide:NO];
    NSLog(@"钱数%@,订单号%@",_payMoney,_orderId);
    if ([_pay isEqualToString:@"1"]) {
        [Command customAlert:@"功能建设中"];
//        [Paydetail zhiFuBaoname:@"测试" titile:@"测试" price:_payMoney orderId:_orderId notice:@"0"];
    }else if ([_pay isEqualToString:@"2"]){////@"0.01"
        [Command customAlert:@"功能建设中"];
//        [Paydetail wxname:@"测试微信" titile:@"测试微信" price:_payMoney orderId:_orderId notice:@"0"];
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
//            MYYFaHuoViewController* vc = [[MYYFaHuoViewController alloc]init];
//            vc.mark = 1;
//            vc.controller = @"pay";
//            [self.navigationController pushViewController:vc animated:YES];
            MYYMyOrderViewController* vc = [[MYYMyOrderViewController alloc]init];
            //            vc.mark = 1;
            vc.pay = @"pay";
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
//            MYYFaHuoViewController* vc = [[MYYFaHuoViewController alloc]init];
//            vc.mark = 1;
//            vc.controller = @"pay";
//            [self.navigationController pushViewController:vc animated:YES];
            
            MYYMyOrderViewController* vc = [[MYYMyOrderViewController alloc]init];
//            vc.mark = 1;
            vc.pay = @"pay";
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
