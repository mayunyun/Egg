//
//  AllProductPageVC.m
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/13.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "AllProductPageVC.h"
#import "MerchantCollectionViewCell.h"
#import "ProductDetailPageVC.h"
#import "AllProModel.h"
@interface AllProductPageVC ()<UICollectionViewDataSource , UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *goosdCollectionArr;
@property (strong, nonatomic) UICollectionViewFlowLayout * flowLayout;
@end

@implementation AllProductPageVC
{
     NSInteger _page;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置状态栏颜色
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0x333333)];

    _page = 1;
    UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 6, 128, 32)];
    img.image = [UIImage imageNamed:@"tit"];
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, img.width, img.height)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = self.title;
    [img addSubview:title];
    self.navigationItem.titleView = img;
    [self registrationCell];
    if ([self.biaoshi isEqualToString:@"lunbo"]) {
        [self requestBannerType];//点击轮播跳转的页面请求
    }else{
        if ([self.sorts isEqualToString:@""]) {
            
        }else{
            if (![[NSString stringWithFormat:@"%@",self.typeId] isEqualToString:@""]) {
                NSLog(@"到底哪里来的妖孽%@",[NSString stringWithFormat:@"%@",self.typeId]);
                [self requestData];
            }else{
                [self requestBannerType:self.sorts biaoshi:self.biaoshi];
            }
        }
        
    }
    self.allProCollectionView.collectionViewLayout = self.flowLayout;
    self.allProCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self requestData];
        [self.allProCollectionView.mj_footer endRefreshing];
        
    }];
}
-(void)requestBannerType:(NSString *)sorts biaoshi:(NSString *)biaoshhi{
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"6",@"params":[NSString stringWithFormat:@"{\"biaoshi\":\"%@\",\"sorts\":\"%@\"}",biaoshhi,sorts]};
    [HTNetWorking postWithUrl:@"/mall/showproduct?action=loadProductInfo" refreshCache:YES params:params success:^(id response) {
        NSDictionary* diction = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (_page == 1) {
            [_goosdCollectionArr removeAllObjects];
            
        }
        if (!IsEmptyValue([diction objectForKey:@"rows"])) {
            for (NSDictionary* dict in [diction objectForKey:@"rows"]) {
                AllProModel* model = [[AllProModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_goosdCollectionArr addObject:model];
            }
        }
        [self.allProCollectionView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
}
-(void)requestBannerType{
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"6",@"params":[NSString stringWithFormat:@"{\"specialid\":\"%@\",\"sorts\":\"%@\"}",self.typeId,self.sorts]};
    [HTNetWorking postWithUrl:@"/mall/showproduct?action=loadProductInfo" refreshCache:YES params:params success:^(id response) {
        NSDictionary* diction = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (_page == 1) {
            [_goosdCollectionArr removeAllObjects];
            
        }
        if (!IsEmptyValue([diction objectForKey:@"rows"])) {
            for (NSDictionary* dict in [diction objectForKey:@"rows"]) {
                AllProModel* model = [[AllProModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_goosdCollectionArr addObject:model];
            }
        }
        [self.allProCollectionView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
}
-(void)requestData{
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"6",@"params":[NSString stringWithFormat:@"{\"getprotypeid\":\"%@\"}",self.typeId]};
    [HTNetWorking postWithUrl:@"/mall/showproduct?action=loadProductInfoByPara" refreshCache:YES params:params success:^(id response) {
        NSDictionary* diction = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (_page == 1) {
            [_goosdCollectionArr removeAllObjects];
            
        }
        if (!IsEmptyValue([diction objectForKey:@"rows"])) {
            for (NSDictionary* dict in [diction objectForKey:@"rows"]) {
                AllProModel* model = [[AllProModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_goosdCollectionArr addObject:model];
            }
        }
        [self.allProCollectionView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
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
    AllProModel * model = _goosdCollectionArr[indexPath.item];
    ProductDetailPageVC * vc = [[ProductDetailPageVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = model.type;
    vc.proid = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}
//懒加载
-(UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout =[[UICollectionViewFlowLayout alloc]init];
        
        self.flowLayout.minimumLineSpacing      = 8;
        self.flowLayout.minimumInteritemSpacing = 8;
        self.flowLayout.itemSize =CGSizeMake(([UIScreen mainScreen].bounds.size.width-16)/2, 202);
        self.flowLayout.sectionInset = UIEdgeInsetsMake(8, 4, 0, 4);
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

@end
