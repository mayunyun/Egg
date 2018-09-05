//
//  MYYCompleteOrderViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYCompleteOrderViewController.h"
#import "MYYMyOrterTableViewCell.h"
#import "MYYCoderCommentViewController.h"//评价

@interface MYYCompleteOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation MYYCompleteOrderViewController{
    
    NSInteger _page;
    UIView *bgview;
    UITextView *_textView;
    NSString *_intager;
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
    self.navigationItem.title = @"待评价";
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    _page=1;
    _intager = @"5";
    [self TableView];
    if (_mark == 1) {
        [self dataRequest];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"orderUpData" object:nil];
    }

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastViewController:)];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xffffff)];
}
- (void)backToLastViewController:(UIButton *)button
{
    //[Public hideLoadingView];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tongzhi:(NSNotification *)text{
    
    if ([text.userInfo[@"one"] integerValue] == 4) {
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
        cell.nextBut.tag = indexPath.row;
        [cell.nextBut addTarget:self action:@selector(commentBut:) forControlEvents:UIControlEventTouchUpInside];
        
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
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"orderstatus\":\"%@\"}",@"3"],@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"10"};
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


- (void)commentBut:(UIButton *)but{
//    MYYCoderCommentViewController *coder = [[MYYCoderCommentViewController alloc]init];
//    MYYMyOrderModel *model = _dataArr[but.tag];
//    NSMutableArray *prolist = [[NSMutableArray alloc]init];
//    for (NSDictionary *dic in model.orderprolist) {
//        MYYMyOrderClassModer *ClassModer=[[MYYMyOrderClassModer alloc]init];
//        [ClassModer setValuesForKeysWithDictionary:dic];
//        //追加数据
//        [prolist addObject:ClassModer];
//    }
//    coder.orderArr = prolist;
//
//    [self.navigationController pushViewController:coder animated:YES];
    [self setEvaulteSMAlertWithView:but.tag];

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
    [upbut addTarget:self action:@selector(butGo:) forControlEvents:UIControlEventTouchUpInside];
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
- (void)butGo:(UIButton *)but{
    
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
