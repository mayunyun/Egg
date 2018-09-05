//
//  ChildrenProcuctVC.m
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/14.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "ChildrenProcuctVC.h"
#import "ChildrenProductOneCell.h"
#import "ChildrenProductTwoCell.h"
#import "MYYTypeDetailsHeaderTableCell.h"
#import "MYYTypeDetailsCemmentTableViewCell.h"
#import "MYYTypeShangBiaoVIew.h"
#import "MYYTypeDetailsCollectionView.h"
#import "MYYDetailEveryoneModel.h"
#import "MYYDetailsWebModel.h"
#import "HomeBannerModel.h"
#import "MYYDetailProPicDetailModel.h"
#import "MYYLoginViewController.h"
#import "MYYDetailProCommentModel.h"
#import "MYYShopOrderViewController.h"
#import "MYYShopCarViewController.h"
#import "ProCommenPageVC.h"
@interface ChildrenProcuctVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate>
{
    NSMutableArray* _dataArray;
    MBProgressHUD* _hud;
    NSInteger _page;
    NSString* _salecount;
    NSMutableArray* _everyDataArray;
    MYYDetailsWebModel* _promodel;
    NSMutableArray* _imageArray;
    BOOL isCollection;
    NSMutableArray* _dataCommentArray;
}
@property (nonatomic,strong)UITableView* tbView;
@property (nonatomic,strong)MYYTypeShangBiaoVIew *ShangBiaoVIew;
@property (nonatomic,strong)MYYTypeDetailsCollectionView* detailsCollectionView;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView2;


@property (nonatomic,strong)UIImageView * headImg;
@property (nonatomic,strong)UIView * headView;
@end

@implementation ChildrenProcuctVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [[NSMutableArray alloc]init];
    _everyDataArray = [[NSMutableArray alloc]init];
    _promodel = [[MYYDetailsWebModel alloc]init];
    _imageArray = [[NSMutableArray alloc]init];
    _dataCommentArray = [[NSMutableArray alloc]init];
    _page = 1;
    self.count = [NSString stringWithFormat:@"1"];
    //    进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //    _hud.labelText = @"网络不给力，正在加载中...";
    [_hud showAnimated:YES];
    [self creatUI];
    [self imageUrlRequest];
    [self dataRequest];
    [self CommentRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBase:) name:IsLogin object:nil];
}
- (void)setUpView{
    _dataArray = [[NSMutableArray alloc]init];
    _everyDataArray = [[NSMutableArray alloc]init];
    _promodel = [[MYYDetailsWebModel alloc]init];
    _imageArray = [[NSMutableArray alloc]init];
    _dataCommentArray = [[NSMutableArray alloc]init];
    _page = 1;
    
    [self dataRequest];
    [self CommentRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBase:) name:IsLogin object:nil];
}
- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IsLogin object:nil];
}

- (void)creatUI
{
    if (_tbView==nil) {
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64-45) style:UITableViewStylePlain];
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.separatorStyle = NO;
        _tbView.showsVerticalScrollIndicator = NO;
        _tbView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:_tbView];
//        [self isCollectionRequest];
        //     下拉刷新
        _tbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            [_dataArray removeAllObjects];
            [self dataRequest];
            [self CommentRequest];
            // 结束刷新
            [_tbView.mj_header endRefreshing];
            
        }];
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        _tbView.mj_header.automaticallyChangeAlpha = YES;
        // 上拉刷新
        _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            _page ++ ;
            [self dataRequest];
            [_tbView.mj_footer endRefreshing];
            
        }];
        _tbView.mj_footer.hidden = YES;
    }
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        return 160;
    }else{
        return 142;
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString * stringCell = @"ChildrenProductOneCell";
        ChildrenProductOneCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        cell.model = _promodel;
        [cell setUpBlock:^(NSInteger count) {
            NSLog(@"打印的数量是%ld",count);
            self.count = [NSString stringWithFormat:@"%zd",count];
        }];
        [cell setDownBlock:^(NSInteger count) {
            NSLog(@"打印的数量是%ld",count);
            self.count = [NSString stringWithFormat:@"%zd",count];
        }];
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\"}",self.proid,self.type]};
        [HTNetWorking postWithUrl:@"collect?action=checkCollection" refreshCache:YES  params:params success:^(id response) {
            NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
            if ([str containsString:@"true"]) {
                
                [cell.collectionBtn setImage:[UIImage imageNamed:@"star_y"] forState:UIControlStateNormal];
            }else{
                
                [cell.collectionBtn setImage:[UIImage imageNamed:@"star_n"] forState:UIControlStateNormal];
            }
        } fail:^(NSError *error) {
            
        }];
        [cell setCollectionBlock:^{
            [self collectionProduct:cell];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString * stringCell = @"ChildrenProductTwoCell";
        ChildrenProductTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        if (_dataCommentArray.count != 0) {
            cell.model = _dataCommentArray[0];
        }
        [cell setSeeMoreBlock:^{
            [self canshuClick];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(void)collectionProduct:(ChildrenProductOneCell *)cell{
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\"}",self.proid,self.type]};
    [HTNetWorking postWithUrl:@"collect?action=addCollection" refreshCache:YES  params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str containsString:@"true"]) {
            [Command customAlert:@"收藏成功"];
//            cell.collectionBtn.selected = YES;
            [cell.collectionBtn setImage:[UIImage imageNamed:@"star_y"] forState:UIControlStateNormal];
        }else if([str containsString:@"false"]){
//            cell.collectionBtn.selected = NO;
            [Command customAlert:@"收藏失败"];
            [cell.collectionBtn setImage:[UIImage imageNamed:@"star_y"] forState:UIControlStateNormal];
        }else{
            NSString *str1 = [str substringFromIndex:1];
            NSString *str2 = [str1 substringToIndex:str1.length-1];
            [Command customAlert:str2];
            [cell.collectionBtn setImage:[UIImage imageNamed:@"star_y"] forState:UIControlStateNormal];
        }
    } fail:^(NSError *error) {
        
    }];
}
- (void)canshuClick{
    if (_headerTitleNumer) {
        _headerTitleNumer(2);
    }
}
- (NSInteger)array:(NSArray*)array rowNum:(NSInteger)index
{
    if (array.count == 0||array == nil || index == (NSInteger)nil ) {
        return 0;
    }else{
        if (array.count%index!=0) {
            return array.count/index+1;
        }else{
            return array.count/index;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        [_tbView deselectRowAtIndexPath:indexPath animated:NO];
    }
}


#pragma mark ---UIcollectionViewLayoutDelegate
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isKindOfClass:[MYYTypeDetailsCollectionView class]]) {
        return CGSizeMake(mScreenWidth/3, mScreenWidth/30*14);
    }
    else{
        return CGSizeMake(0, 0);
    }
}

//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isKindOfClass:[MYYTypeDetailsCollectionView class]]) {
        MYYDetailEveryoneModel* model = _everyDataArray[indexPath.row];
        
        if (_recommendBlock) {
            _recommendBlock(model.proid,model.type);
        }
    }
}

- (void)dataRequest{
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\"}",self.proid,self.type]};
    NSLog(@"%@",params);
    [HTNetWorking postWithUrl:@"mall/showproduct?action=productDetail" refreshCache:YES params:params success:^(id response) {
        //NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"详情%@",array);
        
        if (!IsEmptyValue(array)) {
            NSDictionary* dict = array[0];
            [_promodel setValuesForKeysWithDictionary:dict];
            [self countRequest];
            [self imageUrlRequest];
            [_tbView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}
- (void)countRequest{
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\"}",self.proid,self.type]};
    [HTNetWorking postWithUrl:@"mall/showproduct?action=getTotalMonthCount" refreshCache:YES params:params success:^(id response) {
        //NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSDictionary* dict = array[0];
        _salecount = [NSString stringWithFormat:@"%@",dict[@"count"]];
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:NO];
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)imageUrlRequest{
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\"}",self.proid,self.type]};
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"mall/showproduct?action=productPicDetail"] refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"图片%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        [_imageArray removeAllObjects];
        for (NSDictionary* dict in array) {
            HomeBannerModel* model = [[HomeBannerModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_imageArray addObject:model];
        }
        // 情景二：采用网络图片实现
        NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
        for (HomeBannerModel* model in _imageArray) {
            NSString *serverAddress = HTImgUrl;
            if (![model.autoname isEqualToString:@""]) {
                
                NSString* imageurl = [NSString stringWithFormat:@"%@%@%@",serverAddress,model.folder,model.autoname];
                [imagesURLStrings addObject:imageurl];
            }
            
        }
            // 网络加载 --- 创建带标题的图片轮播器
            self.cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreen_Width, 220*MYWIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
            self.cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            self.cycleScrollView2.currentPageDotColor = NavBarItemColor; // 自定义分页控件小圆标颜色
            self.cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
            _tbView.tableHeaderView = self.cycleScrollView2;
            [_tbView reloadData];
    } fail:^(NSError *error) {
        
    }];
    
}
//评论
- (void)CommentRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\"}",self.proid,self.type]};
    [HTNetWorking postWithUrl:@"evaulteManage?action=searchEvaluteNew" refreshCache:YES  params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"评价%@",str);
        if (!IsEmptyValue(array)) {
            for (NSDictionary* dict in array) {
                MYYDetailProCommentModel* model = [[MYYDetailProCommentModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataCommentArray addObject:model];
            }
            NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:NO];
        }
        
    } fail:^(NSError *error) {
        
    }];
}
- (void)isCollectionRequest{

    
    
}
- (void)addCarRequest{
    [Command isloginRequest:^(bool flag) {
        if (flag) {
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"price\":\"%@\",\"count\":\"%@\",\"type\":\"%@\",\"specification\":\"%@\"}",_promodel.proid,_promodel.proname,_promodel.proprice,self.count,self.type,_promodel.specification]};
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
            NSLog(@"登录失败");
            MYYLoginViewController* vc = [[MYYLoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    /*
     /shoppingcart?action=addShoppingCart  添加购物车接口
     参数：proid,proname,price,count,type,specification
     */
    
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"轮播%li",(long)index);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [Command isloginRequest:^(bool flag) {
        if (flag) {
            NSLog(@"登录成功");
            
        }else{
            NSLog(@"登录失败");
        }
    }];
}

- (void)getLoadDataBase:(NSNotificationCenter*)sender{
    
}

- (void)setButtonClick:(UIButton*)sender{
    [Command isloginRequest:^(bool islogin) {
        if (islogin) {
            [self addCarRequest];
        }else{
            [self pushtologin];
        }
    }];
}
//立即购买
- (void)payProClick:(UIButton*)sender{
    //NSLog(@"%@",_promodel.proid);
    [Command isloginRequest:^(bool flag) {
        if (flag) {
            
            MYYShopOrderViewController* vc = [[MYYShopOrderViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.proid = _promodel.proid;
            vc.proprice = _promodel.proprice;
            vc.type = self.type;
            vc.count = self.count;
            vc.proname = _promodel.proname;
            vc.specification = _promodel.specification;
            vc.next = 0;
            vc.xiaojicount = [_promodel.proprice intValue]*[self.count intValue];
            vc.Id = [NSString stringWithFormat:@"%@",_promodel.Id];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            NSLog(@"登录失败");
            [self pushtologin];
        }
    }];
    
}

- (void)pushtologin{
    NSArray *titleArray = @[@"确定"];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请您先进行登录！" message:nil preferredStyle:UIAlertControllerStyleAlert];
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

//提示弹出框
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
}

@end
