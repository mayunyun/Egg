//
//  AllCategoryListViewController.m
//  categories
//
//  Created by 贺心元 on 2017/7/4.
//  Copyright © 2017年 ichina. All rights reserved.
//

#import "AllCategoryListViewController.h"
#import "AllCateItemCell.h"
#import "AllCateItemHeaderView.h"
#import "AllCateItemFooterView.h"
#import "AllProductPageVC.h"
#import "CategoryListModel.h"
#import "ProductDetailPageVC.h"
#import "MYYTypeModel.h"
#import "MYYTypeItemsModel.h"

static NSString *reuseID = @"itemCell";
static NSString *sectionHeaderID = @"sectionHeader";
static NSString *sectionFooterID = @"sectionFooter";

@interface AllCategoryListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UIGestureRecognizerDelegate>


@property (nonatomic, strong) NSMutableArray *cacheArr;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation AllCategoryListViewController
{
    NSMutableArray * tuArr;
    NSMutableArray * putongArr;
    NSMutableArray * benArr;
    NSMutableArray * youjiArr;
    NSMutableArray * babyArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部分类";
    self.view.backgroundColor = [UIColor whiteColor];
    tuArr = [NSMutableArray new];
    putongArr = [NSMutableArray new];
    benArr = [NSMutableArray new];
    youjiArr = [NSMutableArray new];
    babyArr = [NSMutableArray new];
    [self setupCollectionView];
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置状态栏颜色
    [self setStatusBarBackgroundColor:UIColorFromRGB(0xFFA500)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setupCollectionView {
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    UIView * allProView = [[UIView alloc]initWithFrame:CGRectMake(0, statusBarFrame.size.height, ScreenWidth, 60)];
    allProView.backgroundColor = UIColorFromRGB(0xEDEEEF);
    [self.view addSubview:allProView];
    UILabel * allLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 40)];
    allLabel.text = @"   全部产品";
    allLabel.userInteractionEnabled = YES;
    allLabel.textColor = [UIColor blackColor];
    allLabel.backgroundColor = [UIColor whiteColor];
    allLabel.font = [UIFont systemFontOfSize:15];
    [allProView addSubview:allLabel];
    UIImageView * rightArrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-24, 22, 10, 18)];
    rightArrow.image = [UIImage imageNamed:@"right-arrow"];
    [allProView addSubview:rightArrow];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scanMore)];
    [allLabel addGestureRecognizer:tap];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREENWIDTH - 4.0)/ 2, 50);
    layout.minimumLineSpacing = 4;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeMake((SCREENWIDTH - 4.0), 40);
    layout.footerReferenceSize = CGSizeMake((SCREENWIDTH - 4.0), 0.1);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, allProView.bottom, SCREENWIDTH, SCREENHEIGHT-allProView.bottom ) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[AllCateItemCell class] forCellWithReuseIdentifier:reuseID];
    [_collectionView registerClass:[AllCateItemHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID];
    [_collectionView registerClass:[AllCateItemFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sectionFooterID];
}
-(void)scanMore{
    NSLog(@"点击查看全部商品");
    AllProductPageVC * VC = [[AllProductPageVC alloc]init];
    VC.title = @"全部产品";
    VC.typeId = @"all";
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)reloadData
{
    [HTNetWorking postWithUrl:@"/mall/showproduct?action=getProductTypesforPhone" refreshCache:YES params:nil success:^(id response) {
        
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //NSSLog(@">>>>%@",array);
        //建立模型
        for (NSMutableDictionary *dic in array){
            CategoryListModel *model = [[CategoryListModel alloc] initWithDictionary:dic];
            
            [self.dataArray addObject:model];
        }
        [_collectionView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
    
}
- (BOOL)isHidden:(NSString *)name
{
    for (NSString *str in self.cacheArr){
        if ([str isEqualToString:name]) {
            return YES;
        }
    }
    
    return NO;
}




#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    CategoryListModel *model = _dataArray[section];
    
//    if (model.shopCategoryList.count > 8 && model.isHidden == YES) {
//        return 8;
//    }
    return model.prolist.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AllCateItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    CategoryListModel *model = _dataArray[indexPath.section];
    SecondaryCateModel *itemModel = [[SecondaryCateModel alloc] initWithDictionary:model.prolist[indexPath.row]];

//    SecondaryCateModel *itemModel = model.prolist[indexPath.row];
    cell.cateModel = itemModel;
    
        [cell.titleLabel setHidden:NO];
        [cell.icon setHidden:YES];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        AllCateItemHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID forIndexPath:indexPath];
        AllProductPageVC * vc = [[AllProductPageVC alloc]init];
        CategoryListModel *model = _dataArray[indexPath.section];
        headerView.title = model.typename;
        [headerView setMoreBtnBlck:^{
            vc.typeId = [NSString stringWithFormat:@"%@",model.typeid];
            NSLog(@"********%@",model.typeid);
            vc.title = [NSString stringWithFormat:@"%@",model.typename];
            
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        return headerView;
    }else if (kind == UICollectionElementKindSectionFooter){
        
        AllCateItemFooterView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sectionFooterID forIndexPath:indexPath];
        
        return footView;
    }
    else {
        return nil;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 0, 5, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailPageVC * vc = [[ProductDetailPageVC alloc]init];
    CategoryListModel *model = _dataArray[indexPath.section];
    SecondaryCateModel *itemModel = [[SecondaryCateModel alloc] initWithDictionary:model.prolist[indexPath.row]];
        if (itemModel.pid) {
            NSLog(@"%@%@",itemModel.proname,itemModel.type);
        }
    vc.proid = itemModel.pid;
    vc.type = itemModel.type;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSMutableArray *)cacheArr
{
    if (!_cacheArr) {
        _cacheArr = [NSMutableArray arrayWithContentsOfFile:ISHIDDEN_PATH];
        if (!_cacheArr) {
            _cacheArr = [NSMutableArray array];
        }
    }
    return _cacheArr;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
