//
//  MYYTypeDetailsViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/3.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYTypeDetailsViewController.h"
#import "MYYTypeDetailsTableViewCell.h"
#import "HXSearchBar.h"
#import "MYYDetailsAndCommentViewController.h"
#import "HomeFavorableModel.h"
#import "MYYLoginViewController.h"
@interface MYYTypeDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray* _dataArray;
    //    MBProgressHUD* _hud;
    NSInteger _page;
    NSArray *_items;
    HXSearchBar *_search;//搜索

}
@property (nonatomic) NSInteger selectedIndex;

@property(strong,nonatomic)UITableView* tbView;

@end

@implementation MYYTypeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xececec);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _dataArray = [[NSMutableArray alloc]init];
    _page = 1;
    //    //进度HUD
    //    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    //设置模式
    //    _hud.mode = MBProgressHUDModeIndeterminate;
    //    //_hud.labelText = @"网络不给力，正在加载中...";
    //    [_hud showAnimated:YES];
    [self requestData];

    [self navigationItemButton];
    [self creatUI];
}
- (void)navigationItemButton{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0x444444)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"购物车"] style:UIBarButtonItemStylePlain target:self action:@selector(gouwuche)];
    [self.navigationItem.rightBarButtonItem setTintColor:UIColorFromRGB(0x444444)];
}
//搜索
- (UISearchBar *)searchview{
    if (_search == nil) {
        //加上 搜索栏
        _search = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 10, mScreenWidth - 100, 40)];
        _search.backgroundColor = [UIColor clearColor];
        _search.delegate = self;
        if (!IsEmptyValue(self.pronameLIKE)) {
            _search.text = self.pronameLIKE;
        }
        //输入框提示
        _search.placeholder = @"搜索你想要的东西";
        //光标颜色
        _search.cursorColor = [UIColor blackColor];
        //TextField
        _search.searchBarTextField.layer.cornerRadius = 4;
        _search.searchBarTextField.layer.masksToBounds = YES;
        _search.searchBarTextField.layer.borderColor = UIColorFromRGB(0xececec).CGColor;
        _search.searchBarTextField.layer.borderWidth = 1.0;
        
        //清除按钮图标
        _search.clearButtonImage = [UIImage imageNamed:@"demand_delete"];
        
        //去掉取消按钮灰色背景
        _search.hideSearchBarBackgroundImage = YES;
        [self.navigationItem setTitleView:_search];
    }
    return _search;
}
- (void)creatUI
{
    [self setInitialValue];
    [self setButtons];
    [self setButtonsFrames];
    [self searchview];

    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, mScreenWidth, mScreenHeight-40 - 64 - 45) style:UITableViewStylePlain];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    [_tbView registerNib:[UINib nibWithNibName:@"MYYTypeDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"MYYTypeDetailsTableViewCell"];
    //隐藏多余cell
    _tbView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_tbView];
    //     下拉刷新
    _tbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [_dataArray removeAllObjects];
        [self requestData];
        // 结束刷新
        [_tbView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tbView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self requestData];
        [_tbView.mj_footer endRefreshing];
        
    }];
    _tbView.mj_footer.hidden = YES;
}
#pragma mark - 三个有下划线的Button
- (void)setInitialValue
{
    self.selectedIndex = 0;
    [self selectButtonWithIndex:0];
}
- (void)selectButtonWithIndex:(NSInteger)index;
{
    CGFloat width = mScreenWidth/3;
    CGFloat height = 40;
    CGFloat underLineW = width - 2*10;
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        UIButton *button = (UIButton *)[self.view viewWithTag:1000+index];
        if (button != nil) button.selected = YES;
        
        UIView *underLine = [weakself.view viewWithTag:2000];
        if (underLine != nil) {
            underLine.frame = CGRectMake(index*width+10, height-2,
                                         underLineW, 2);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex) return;
    _selectedIndex = selectedIndex;
    [self selectButtonWithIndex:selectedIndex];
}

- (void)setButtons{
    _items= @[@"综合",@"销量",@"价格"];
    UIView *buttonview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 40)];
    buttonview.backgroundColor = [UIColor whiteColor];
    int i = 0;
    for (NSString *titleStr in _items) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = 1000+i;
        [button setTitle:titleStr forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xFF6347) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.selected = NO;
        [buttonview addSubview:button];
        if (i==0) {
            button.selected = YES;
        }
        i++;
    }
    
    UIView *underLine = [[UIView alloc] init];
    underLine.backgroundColor = UIColorFromRGB(0xFF6347);
    underLine.tag = 2000;
    underLine.layer.cornerRadius = 1;
    [buttonview addSubview:underLine];
    [self.view addSubview:buttonview];
}

- (void)setButtonsFrames
{
    CGFloat width = mScreenWidth/3;
    CGFloat height = 40;
    for (int i = 0; i < _items.count; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:1000+i];
        if (button != nil) button.frame = CGRectMake(i*width, 0, width, height);
    }
    
    UIView *underLine = [self.view viewWithTag:2000];
    CGFloat underLineW = width - 2*10;
    if (underLine != nil) {
        underLine.frame = CGRectMake(self.selectedIndex*underLineW + 10, height-2,
                                     underLineW, 2);
    }
}
- (void)buttonAction:(UIButton *)button
{
    NSInteger index = button.tag-1000;
    for (NSInteger i = 0; i < _items.count; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:1000+i];
        if (button != nil){
            if (!(index==i)) {
                button.selected = NO;
            }
        }
    }
    if (index == self.selectedIndex) return;
    self.selectedIndex = index;
    NSLog(@"%@",_items[index]);
    [self requestData];
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return _dataArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYYTypeDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYYTypeDetailsTableViewCell" forIndexPath:indexPath];
    if (!IsEmptyValue(_dataArray)) {
        cell.model = _dataArray[indexPath.row];
    }
    __weak typeof (self) weakself = self;
    [cell setTransVaule:^(HomeFavorableModel * model) {
        [weakself addCarRequest:model];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        MYYDetailsAndCommentViewController *details = [[MYYDetailsAndCommentViewController alloc]init];
        HomeFavorableModel* model = _dataArray[indexPath.row];
        details.proid = [NSString stringWithFormat:@"%@",model.Id];
        details.type = [NSString stringWithFormat:@"%@",model.type];
        details.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:details animated:YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 1)];
    header.backgroundColor = UIColorFromRGB(0xf0f0f0);
    return header;
}
#pragma mark - UISearchBar Delegate
//已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    HXSearchBar *sear = (HXSearchBar *)searchBar;
//    //取消按钮
//    sear.cancleButton.backgroundColor = [UIColor clearColor];
//    [sear.cancleButton setTitle:@"搜索" forState:UIControlStateNormal];
//    [sear.cancleButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    sear.cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"搜索" forState:UIControlStateNormal];
            [cancel setTitleColor:NavBarItemColor forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
}

//编辑文字改变的回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchText:%@",searchText);
}

//搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_search resignFirstResponder];// 放弃第一响应者
    
}

//取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_search resignFirstResponder];// 放弃第一响应者
    if (!IsEmptyValue(_search.text)) {
        self.controller = @"mine";
        [self requestData];
    }
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
    
}

- (void)requestData
{
    /*
     mall/showproduct?action=loadProductInfo
     */
    NSArray* array = @[@"zonghe",@"xiaoliang",@"jiage"];
    NSDictionary* params = [[NSDictionary alloc]init];
    if ([self.controller isEqualToString:@"special"]) {
        params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"specialid\":\"%@\",\"sorts\":\"%@\"}",self.specialid,array[self.selectedIndex]]};
    }else if ([self.controller isEqualToString:@"search"]){
        params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"pronameLIKE\":\"%@\",\"sorts\":\"%@\"}",self.pronameLIKE,array[self.selectedIndex]]};
        
    }else if ([self.controller isEqualToString:@"mine"]){
        params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"pronameLIKE\":\"%@\",\"sorts\":\"%@\"}",_search.text,array[self.selectedIndex]]};
    }else{
        params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"biaoshi\":\"%@\",\"sorts\":\"%@\"}",self.biaoshi,array[self.selectedIndex]]};
    }
    [HTNetWorking postWithUrl:@"mall/showproduct?action=loadProductInfo" refreshCache:YES  params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"产品列表%@",str);
        if (_page == 1) {
            [_dataArray removeAllObjects];
        }
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(dic[@"rows"])) {
            for (NSDictionary* dict in dic[@"rows"]) {
                HomeFavorableModel* model = [[HomeFavorableModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArray addObject:model];
            }
            [_tbView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
   
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)gouwuche{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:IsLogin] isEqualToString:@"1"]) {
        self.tabBarController.selectedIndex = 2;//跳转
    }else{
        NSArray *titleArray = @[@"确定"];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"进入购物车需要您登录！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
        for (NSString *str in titleArray) {
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                MYYLoginViewController* vc = [[MYYLoginViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [alert addAction:cancelAction];
        }
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)addCarRequest:(HomeFavorableModel*)model{
    [Command isloginRequest:^(bool islogin) {
        if (islogin) {
            /*
             /shoppingcart?action=addShoppingCart  添加购物车接口
             参数：proid,proname,price,count,type,specification
             */
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"price\":\"%@\",\"count\":\"%@\",\"type\":\"%@\",\"specification\":\"%@\"}",model.Id,model.proname,model.saleprice,@"1",model.type,model.specification]};
            [HTNetWorking postWithUrl:@"shoppingcart?action=addShoppingCart" refreshCache:YES params:params success:^(id response) {
                NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                if ([str rangeOfString:@"true"].location!=NSNotFound) {
                    [Command customAlert:@"加入购物车成功"];
                }else if ([str rangeOfString:@"false"].location!=NSNotFound){
                    [Command customAlert:@"删除购物车"];
                }
            } fail:^(NSError *error) {
                
            }];
        }else{
            NSArray *titleArray = @[@"确定"];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"亲，加入购物车需要您登录！" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:cancelAction];
            for (NSString *str in titleArray) {
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    MYYLoginViewController* vc = [[MYYLoginViewController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                [alert addAction:cancelAction];
            }
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
   
    
    
}

@end
