//
//  MYYMineViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/3/24.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYMineViewController.h"
#import "MYYLoginViewController.h"
#import "MYYMineRechargeViewController.h"
#import "MYYMyOrderViewController.h"
#import "MYYAddManageViewController.h"
#import "MYYMineCollectViewController.h"
#import "MYYMineHistoryViewController.h"
#import "MYYMineRechrageManageViewController.h"
#import "MYYMineAccountViewController.h"
#import "MYYPayMentOrderViewController.h"
#import "MYYFaHuoViewController.h"
#import "MYYGoodsOrderViewController.h"
#import "MYYCompleteOrderViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "RegistReferModel.h"
#import "WXApi.h"
#import "LSActionView.h"


@interface MYYMineViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
{
    NSMutableArray* _dataArray;
    NSInteger _page;
    UIButton* _inView;
    UILabel* _nameLabel;
    NSString* _balanceStr;
    UIButton * orderBut;
    UIButton * payBut;
    UIView *view1;//订单4个button
    UIView *view2;//4个button
    UIView *view3;//1个button
}
@property (nonatomic,strong)UITableView* tbView;
@end

@implementation MYYMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    self.navigationController.delegate = self;

    [self creatUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置状态栏颜色
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    [Command isloginRequest:^(bool str) {
        if (str) {
            //登录成功
            [self dataRequest];
        }else{
            //登录失败
            MYYLoginViewController *login = [[MYYLoginViewController alloc]init];
            login.next = 1;
            login.fd_interactivePopDisabled = YES;
            [self.navigationController pushViewController:login animated:NO];
        }
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
}
- (void)creatUI
{
    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 140)];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"矩形24"]];
    
    _inView = [UIButton buttonWithType:UIButtonTypeCustom];
    _inView.frame = CGRectMake(18, 47, 60, 60);
    _inView.backgroundColor = [UIColor whiteColor];
    [_inView setImage:[UIImage imageNamed:@"默认头像"] forState:UIControlStateNormal];
    _inView.layer.masksToBounds = YES;
    _inView.layer.cornerRadius = 30;
    [headerView addSubview:_inView];
    [_inView addTarget:self action:@selector(accountBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, kScreen_Width - 120, 30)];
    _nameLabel.text = @"未登录";
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:_nameLabel];
    
    UIButton* acountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    acountBtn.frame = CGRectMake(100, _nameLabel.bottom+5, 60, 20);
    [acountBtn setTitle:@"我的账户" forState:UIControlStateNormal];
    [acountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    acountBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    acountBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:acountBtn];
    [acountBtn addTarget:self action:@selector(accountBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* right = [[UIImageView alloc]initWithFrame:CGRectMake(acountBtn.right, acountBtn.top + 2, acountBtn.height - 4, acountBtn.height - 4)];
    right.image = [UIImage imageNamed:@"iconfont-arrow"];
    [headerView addSubview:right];
    
    
    
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, mScreenWidth, mScreenHeight+20) style:UITableViewStylePlain];
    _tbView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    _tbView.delegate = self;
    _tbView.dataSource = self;
    [self.view addSubview:_tbView];
    _tbView.tableHeaderView = headerView;
    
    _tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [_dataArray removeAllObjects];
        [self dataRequest];
        [_tbView.mj_header endRefreshing];
    }];

    _tbView.mj_header.automaticallyChangeAlpha = YES;
    _tbView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        _page++;
        [self dataRequest];
        [_tbView.mj_footer endRefreshing];
        
    }];
    _tbView.mj_footer.hidden = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        return 3;
    }
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *titleArr = @[@"我的订单",@"我的资产",@"我的工具"];
    if (indexPath.row==0) {
        cell.textLabel.text = titleArr[indexPath.section];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        if (indexPath.section == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            
            if (orderBut == nil) {
                orderBut = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth-100, 0, 80, 40)];
            }
            [orderBut setTitle:@"查看全部订单" forState:UIControlStateNormal];
            [orderBut setTitleColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1] forState:UIControlStateNormal];
            orderBut.titleLabel.font = [UIFont systemFontOfSize:12];
            [orderBut addTarget:self action:@selector(orderButAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:orderBut];
        }
    }else{
        if (indexPath.section==0) {
            NSArray *Arr = @[@"待付款",@"待发货",@"待收货",@"待评价"];
            if (view1 == nil) {
                view1 = [self numerButton:Arr tag:600];
            }
            [cell.contentView addSubview:view1];
        }else if (indexPath.section==1){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            cell.imageView.image = [UIImage imageNamed:@"余额"];
//            cell.textLabel.text = @"账户余额:￥1888";
            if (!IsEmptyValue(_balanceStr)) {
                cell.textLabel.text = [NSString stringWithFormat:@"账户余额：￥%@",_balanceStr];
            }else{
                cell.textLabel.text = @"账户余额：￥";
            }
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            if (payBut == nil) {
                payBut = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth-90, 0, 60, 80)];
            }
            [payBut setTitle:@"立即充值" forState:UIControlStateNormal];
            [payBut setTitleColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1] forState:UIControlStateNormal];
            payBut.titleLabel.font = [UIFont systemFontOfSize:13];
            [payBut addTarget:self action:@selector(goPayButAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:payBut];
        }else{
            if (indexPath.row==1) {
                NSArray *Arr = @[@"我的收藏",@"我的足迹",@"地址管理",@"充值记录"];
                if (view2 == nil) {
                    view2 = [self numerButton:Arr tag:700];
                }
                [cell.contentView addSubview:view2];
            }else if(indexPath.row==2){
                NSArray *Arr = @[@"客服电话",@"蛋事论坛"];
                if (view3 == nil) {
                    view3 = [self numerButton:Arr tag:800];
                }
                [cell.contentView addSubview:view3];
            }
            
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 40;
    }
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==2){
        return 0.01;
    }
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 10)];
    footer.backgroundColor = UIColorFromRGB(0xf0f0f0);
    return footer;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)dataRequest{
    /*
     personal?action=getPersonalInfo
     */
    [HTNetWorking postWithUrl:@"personal?action=getPersonalInfo" refreshCache:YES params:nil success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"用户信息%@",str);
        
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            RegistReferModel* model = [[RegistReferModel alloc]init];
            [model setValuesForKeysWithDictionary:array[0]];
            NSString* baseurl = HTImgUrl;
            [_inView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",baseurl,model.folder,model.autoname]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像"]];
            _nameLabel.text = [NSString stringWithFormat:@"%@",model.accountname];
            _balanceStr = [NSString stringWithFormat:@"%@",model.balance];
            [_tbView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}
- (void)goPayButAction{
    MYYMineRechargeViewController* vc = [[MYYMineRechargeViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (UIView *)numerButton:(NSArray*)arr tag:(NSInteger)tag{
    
    UIView *backview;
    if (backview == nil) {
        backview = [[UIView alloc]init];
        backview.frame = CGRectMake(0, 0, mScreenWidth, 80);
    }
    for (int i=0; i<arr.count; i++) {
        UIButton *but;
        if (but==nil) {
            but = [[UIButton alloc]initWithFrame:CGRectMake(((mScreenWidth-320)/4+80)*i, 0, 80, 80)];
        }
        but.tag = tag+i;
        [but setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
        [but setTitle:arr[i] forState:UIControlStateNormal];
        [but setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
        [but setTitleEdgeInsets:UIEdgeInsetsMake(but.imageView.frame.size.height+5 ,-but.imageView.frame.size.width+10, 0,0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [but setImageEdgeInsets:UIEdgeInsetsMake(-15, (80-but.imageView.frame.size.width)/2,0, 0)];//图片距离右边框距离减少图片的宽度，其它不边
        but.titleLabel.font = [UIFont systemFontOfSize:12];
        [but addTarget:self action:@selector(logisticsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [backview addSubview:but];
    }
    return backview;
}
- (void)logisticsButtonAction:(UIButton *)sender{
    switch (sender.tag) {
        case 600:{//待付款
            MYYPayMentOrderViewController *order = [[MYYPayMentOrderViewController alloc]init];
            order.hidesBottomBarWhenPushed = YES;
            order.mark=1;
            [self.navigationController pushViewController:order animated:YES];
            break;
        }
        case 601:{//待发货
            MYYFaHuoViewController *fahuo = [[MYYFaHuoViewController alloc]init];
            fahuo.hidesBottomBarWhenPushed = YES;
            fahuo.mark=1;
            [self.navigationController pushViewController:fahuo animated:YES];
            break;
        }
        case 602:{//待收货
            MYYGoodsOrderViewController *GoodsOrde = [[MYYGoodsOrderViewController alloc]init];
            GoodsOrde.hidesBottomBarWhenPushed = YES;
            GoodsOrde.mark=1;
            [self.navigationController pushViewController:GoodsOrde animated:YES];
            break;
        }
        case 603:{//待评价
            MYYCompleteOrderViewController *Complete = [[MYYCompleteOrderViewController alloc]init];
            Complete.hidesBottomBarWhenPushed = YES;
            Complete.mark=1;
            [self.navigationController pushViewController:Complete animated:YES];
            break;
        }
        case 700:{//我的收藏
            MYYMineCollectViewController* vc = [[MYYMineCollectViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 701:{//我的足迹
            MYYMineHistoryViewController* vc = [[MYYMineHistoryViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 702:{//地址管理
            MYYAddManageViewController* vc = [[MYYAddManageViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 703:{//充值记录
            MYYMineRechrageManageViewController* vc = [[MYYMineRechrageManageViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 800:{//客服电话
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定拨打电话：13922897782吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:13922897782"]];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        }
        case 801:{//充值记录
            [self wxlogin];
            break;
        }
        default:
            break;
    }
}

- (void)accountBtnClick{
    
    [Command isloginRequest:^(bool str) {
        if (str) {
            //登录成功
            MYYMineAccountViewController* vc = [[MYYMineAccountViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            //登录失败
            MYYLoginViewController *login = [[MYYLoginViewController alloc]init];
            login.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:login animated:YES];
        }
    }];
    
    
}

//查看全部订单
- (void)orderButAction{
    MYYMyOrderViewController *log = [[MYYMyOrderViewController alloc]init];
    log.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:log animated:YES];

}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    NSLog(@"statusBar.backgroundColor--->%@",statusBar.backgroundColor);
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)wxlogin{
    NSArray* images = @[@"shareweixin",@"sharemoments"];
    NSArray* titles = @[@"分享到好友",@"分享到朋友圈"];
    
    WXMediaMessage* message = [WXMediaMessage message];
    message.title = @"论坛分享";
    message.description = @"";
    [message setThumbImage:[UIImage imageNamed:@"eggmatter"]];
    WXWebpageObject* webpage = [WXWebpageObject object];
    webpage.webpageUrl = @"http://shequ.yunzhijia.com/thirdapp/forum/network/59375a9ee4b0e77e827dd98a";
    message.mediaObject = webpage;
    
    [[LSActionView sharedActionView] showWithImages:images
                                             titles:titles
                                        actionBlock:^(NSInteger index) {
                                            NSLog(@"Action trigger at %ld:", (long)index);
                                            if (index == 0) {
                                                //                                                WXSceneSession
                                                
                                                if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
                                                {
                                                    SendMessageToWXReq* req = [[SendMessageToWXReq alloc]init];
                                                    req.bText = NO;
                                                    req.message = message;
                                                    req.scene = WXSceneSession;
                                                    [WXApi sendReq:req];
                                                }
                                                else
                                                {
                                                    UIAlertView* aleartView = [[UIAlertView alloc]initWithTitle:@"您没有安装微信客户端" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                    [aleartView show];
                                                }
                                            }else if (index == 1){
                                                if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
                                                {
                                                    //                                            WXSceneTimeline
                                                    SendMessageToWXReq* req = [[SendMessageToWXReq alloc]init];
                                                    req.bText = NO;
                                                    req.message = message;
                                                    req.scene = WXSceneTimeline;
                                                    [WXApi sendReq:req];
                                                }
                                                else
                                                {
                                                    UIAlertView* aleartView = [[UIAlertView alloc]initWithTitle:@"您没有安装微信客户端" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                    [aleartView show];
                                                }
                                                
                                            }
                                        }];
}

@end
