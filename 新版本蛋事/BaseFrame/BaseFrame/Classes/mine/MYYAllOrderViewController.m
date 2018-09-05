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
#import "Paydetail.h"
#import "MYYMyOrderClassModer.h"

@interface MYYAllOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSString* payMoney;
@property (nonatomic,strong)NSString* orderId;

@end

@implementation MYYAllOrderViewController{
    NSInteger _page;
    UIView *bgview;
    NSString *_pay;
    UITextView *_textView;
    NSString *_intager;
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
    
    [super viewDidLoad];
    _page=1;
    _intager = @"5";
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
        [cell.cancelBut addTarget:self action:@selector(allcancelButClick:) forControlEvents:UIControlEventTouchUpInside];//删除订单
        
        objc_setAssociatedObject(cell.nextBut, "indexpath", [NSString stringWithFormat:@"%zd",indexPath.row], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(cell.nextBut, "orderstatus", model.orderstatus, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [cell.nextBut addTarget:self action:@selector(allButClick:) forControlEvents:UIControlEventTouchUpInside];

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

    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderstatus\":\"%@\"}",@""],@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"10"};
    [HTNetWorking postWithUrl:@"myorder?action=searchMyOrderNEW" refreshCache:YES params:params success:^(id response) {
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
            }
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
        case 4:{
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
    self.payMoney = [NSString stringWithFormat:@"%@",model.totalmoney];
    self.orderId = [NSString stringWithFormat:@"%@",model.orderno];
//
//    MYYShopPayViewController *shopPay = [[MYYShopPayViewController alloc]init];
//    shopPay.payMoney = [NSString stringWithFormat:@"%@",model.totalmoney];
//    shopPay.orderId = [NSString stringWithFormat:@"%@",model.orderno];
//    shopPay.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:shopPay animated:YES];
    [self setSMAlertWithView];
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
//    MYYCoderCommentViewController *coder = [[MYYCoderCommentViewController alloc]init];
//
//    MYYMyOrderModel *model = _dataArr[but];
//
//    NSMutableArray *prolist = [[NSMutableArray alloc]init];
//    for (NSDictionary *dic in model.orderprolist) {
//        MYYMyOrderClassModer *ClassModer=[[MYYMyOrderClassModer alloc]init];
//        [ClassModer setValuesForKeysWithDictionary:dic];
//        //追加数据
//        [prolist addObject:ClassModer];
//    }
//    coder.orderArr = prolist;
//    [self.navigationController pushViewController:coder animated:YES];
    
    [self setEvaulteSMAlertWithView:but];

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

- (void)setEvaulteSMAlertWithView:(NSInteger)inter{
    
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor clearColor]];
    
    
    bgview = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 0, mScreenWidth-60*MYWIDTH, 300*MYWIDTH)];
    bgview.backgroundColor = [UIColor clearColor];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth-60*MYWIDTH, 230*MYWIDTH)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.cornerRadius = 10;
    [bgview addSubview:view1];
    
    UIView *buttonView = [self commentButton];
    buttonView.frame = CGRectMake((view1.width-200*MYWIDTH)/2, 15*MYWIDTH, 200*MYWIDTH, 40*MYWIDTH);
    [view1 addSubview:buttonView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(25*MYWIDTH, buttonView.bottom+15*MYWIDTH, view1.width-50*MYWIDTH, view1.bottom-buttonView.bottom-40*MYWIDTH)];
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont fontWithName:@"Arial"size:14.0];
    _textView.delegate = self;
    _textView.backgroundColor = BackGorundColor;
    _textView.text = @"请填写评价";
    _textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    _textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    _textView.scrollEnabled = YES;//是否可以拖动
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [view1 addSubview:_textView];
    
    UIButton *upbut = [[UIButton alloc]initWithFrame:CGRectMake(0, 250*MYWIDTH, bgview.width, 50*MYWIDTH)];
    upbut.layer.cornerRadius = 10;
    upbut.backgroundColor = NavBarItemColor;
    [upbut setTitle:@"提交" forState:UIControlStateNormal];
    upbut.tag = inter;
    [upbut addTarget:self action:@selector(addEvaultebutGo:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:upbut];
    [SMAlert showCustomView:bgview];
    [SMAlert hideCompletion:^{
        
    }];
}
//将要进入编辑模式
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([_textView.text isEqualToString:@"请填写评价"]) {
        _textView.text = @"";
    }
    return YES;
}
- (UIView *)commentButton{
    UIView *backview = [[UIView alloc]init];
    for (int i=0; i<5; i++) {
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0+40*MYWIDTH*i, 0, 40*MYWIDTH, 40*MYWIDTH)];
        but.tag = 200+i;
        [but setImage:[UIImage imageNamed:@"star_n"] forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:@"star_y"] forState:UIControlStateSelected];
        but.selected = YES;
        [but addTarget:self action:@selector(SelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [backview addSubview:but];
    }
    return backview;
}
- (void)SelectButtonAction:(UIButton *)sender{
    for (int i=0; i<5; i++) {
        UIButton *but = [bgview viewWithTag:200+i];
        but.selected = NO;
    }
    for (int i=0; i<sender.tag-200+1; i++) {
        UIButton *but = [bgview viewWithTag:200+i];
        but.selected = YES;
    }
    _intager = [NSString stringWithFormat:@"%zd",sender.tag-199];
}
- (void)addEvaultebutGo:(UIButton *)but{
    
    [SMAlert hide:NO];
    MYYMyOrderModel *model = _dataArr[but.tag];
    
    NSMutableArray *prolist = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in model.orderprolist) {
        MYYMyOrderClassModer *ClassModer=[[MYYMyOrderClassModer alloc]init];
        [ClassModer setValuesForKeysWithDictionary:dic];
        //追加数据
        [prolist addObject:ClassModer];
    }
    
    NSMutableString* mustr = [[NSMutableString alloc]init];
    int i=0;
    for (MYYMyOrderClassModer* model in prolist) {
        
        NSString* str = [NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"type\":\"%@\",\"comments\":\"%@\",\"scores\":\"%@\"},",model.proid,model.proname,model.type,[Command convertNull:_textView.text],_intager];
        if ([_textView.text isEqualToString:@"请填写评价"]) {
            str = [NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"type\":\"%@\",\"comments\":\"%@\",\"scores\":\"%@\"},",model.proid,model.proname,model.type,@"",_intager];
        }
        [mustr appendString:str];
        i++;
    }
    NSString* prostr = mustr;
    if (prostr.length!=0) {
        NSRange range = {0,prostr.length - 1};
        prostr = [prostr substringWithRange:range];
    }
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"evaluteList\":[%@],\"orderid\":\"%@\"}",prostr,model.Id]};
    
    NSLog(@"%@",params);
    [HTNetWorking postWithUrl:@"evaulteManage?action=addEvaulte" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [self showAlert:@"评论成功"];
            [self dataRequest];
        }else{
            [self showAlert:@"评论失败"];
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
