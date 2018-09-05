//
//  ProductSearchPageVC.m
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/17.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "ProductSearchPageVC.h"
#import "HXSearchBar.h"
#import "MYYDetailsAndCommentViewController.h"
#import "HomeFavorableModel.h"
#import "MYYLoginViewController.h"
#import "MerchantCollectionViewCell.h"
#import "ProductDetailPageVC.h"
#import "AllProModel.h"
@interface ProductSearchPageVC ()<UICollectionViewDataSource , UICollectionViewDelegate,UISearchBarDelegate>
{
    //    MBProgressHUD* _hud;
    NSInteger _page;
    NSArray *_items;
    HXSearchBar *_search;//搜索
}
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *goosdCollectionArr;
@property (strong, nonatomic) UICollectionViewFlowLayout * flowLayout;
@end

@implementation ProductSearchPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xececec);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _page = 1;
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
    [self requestData];
    [self registrationCell];
    [self setInitialValue];
    [self setButtons];
    [self setButtonsFrames];
    [self searchview];
    self.allProCollectionView.collectionViewLayout = self.flowLayout;
    self.allProCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page ++ ;
        [self requestData];
        [self.allProCollectionView.mj_footer endRefreshing];
    }];
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
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goosdCollectionArr.count;
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MerchantCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MerchantCollectionViewCell" forIndexPath:indexPath];
    cell.model = _goosdCollectionArr[indexPath.item];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductDetailPageVC * vc = [[ProductDetailPageVC alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
//懒加载
-(UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout =[[UICollectionViewFlowLayout alloc]init];
        
        self.flowLayout.minimumLineSpacing      = 8;
        self.flowLayout.minimumInteritemSpacing = 8;
        self.flowLayout.itemSize =CGSizeMake(([UIScreen mainScreen].bounds.size.width-10)/2, 202);
        self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 8, 0);
    }
    return _flowLayout;
}
-(void)registrationCell{
    [self.allProCollectionView registerNib:[UINib nibWithNibName:@"MerchantCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MerchantCollectionViewCell"];
}

-(NSMutableArray *)goosdCollectionArr{
    if (!_goosdCollectionArr) {
        _goosdCollectionArr = [NSMutableArray array];
    }
    return _goosdCollectionArr;
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


#pragma mark - UISearchBar Delegate
//已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {

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
            [_goosdCollectionArr removeAllObjects];
        }
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(dic[@"rows"])) {
            for (NSDictionary* dict in dic[@"rows"]) {
                AllProModel* model = [[AllProModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.goosdCollectionArr addObject:model];
            }
            [self.allProCollectionView reloadData];
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
