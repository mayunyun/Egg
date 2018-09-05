//
//  MYYCommentViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/4.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYCommentViewController.h"
#import "MYYCommentTableViewCell.h"
#import "MYYDetailProCommentModel.h"
#import "LEOStarView.h"

#define BaseBtnSelectColor UIColorFromRGB(0xff6f00)
#define BaseBtnFomalColor UIColorFromRGB(0xfce4d2)
@interface MYYCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tbView;
    NSMutableArray* _tabBtnArray;
    NSMutableArray* _dataCommentArray;
    NSInteger _page;
    NSString* _tabFlag;
    UIView* _bgView;
}
@end

@implementation MYYCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = BackGorundColor;
    _tabBtnArray = [NSMutableArray arrayWithCapacity:4];
    _dataCommentArray = [[NSMutableArray alloc]init];
    _page = 1;
    _tabFlag = @"";
    [self dataRequest];
    [self dataButtonevaluate];
    [self creatEmptyUI];
    
    UIButton* topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    topBtn.frame = CGRectMake(kScreen_Width - 80, kScreen_Height - 64 - 44 - 80, 70, 70);
    [topBtn setImage:[UIImage imageNamed:@"prodetailTotop"] forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    topBtn.layer.masksToBounds = YES;
    topBtn.layer.cornerRadius = 35;
    [self.view addSubview:topBtn];
}
- (void)setUpViewComment{
    _dataCommentArray = [[NSMutableArray alloc]init];

    [self dataRequest];
    [self dataButtonevaluate];

}
- (void)creatEmptyUI{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreen_Width, 380)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake((_bgView.width - 100)*0.5, (_bgView.height - 100)*0.5, 100, 100)];
    imgView.image = [UIImage imageNamed:@"prodetailComment"];
    [_bgView addSubview:imgView];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake((_bgView.width - 120)*0.5, imgView.bottom, 120, 30)];
    label.text = @"暂无评价信息";
    label.textColor = GrayTitleColor;
    label.font = [UIFont systemFontOfSize:1];
    label.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:label];
    _bgView.hidden = YES;
}

- (void)creatUI{
    
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kScreen_Width, kScreen_Height - 64 - 44 - 44) style:UITableViewStylePlain];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.scrollsToTop = YES;
    //隐藏多余cell
    _tbView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tbView];
    
    //     下拉刷新
    _tbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [_dataCommentArray removeAllObjects];
        [self dataRequest];
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

}
#pragma mark tabBtn标签的点击事件
- (void)tabBtnClick:(UIButton*)sender
{
    _page = 1;
    if (sender == _tabBtnArray[0]) {
        _tabFlag = @"";
    }else if (sender == _tabBtnArray[1]){
        _tabFlag = @"good";
    }else if (sender == _tabBtnArray[2]){
        _tabFlag = @"middle";
    }else if (sender == _tabBtnArray[3]){
        _tabFlag = @"bad";
    }
    [self dataRequest];
    for (UIButton* btn in _tabBtnArray) {
        if (sender == btn) {
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            sender.backgroundColor = BaseBtnSelectColor;
        }else{
            [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            btn.backgroundColor = BaseBtnFomalColor;
        }
    }
}

- (void)topBtnClick:(UIButton*)sender{
    [_tbView setContentOffset:CGPointMake(0,0) animated:YES];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize strSize = CGSizeMake(0, 0);
    if (!IsEmptyValue(_dataCommentArray)) {
        MYYDetailProCommentModel* model = _dataCommentArray[indexPath.section];
        strSize= [model.comments boundingRectWithSize:CGSizeMake(kScreen_Width - 20, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if (IsEmptyValue(model.comments)) {
            return 60;
        }
    }
    return strSize.height+75;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataCommentArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    MYYCommentTableViewCell* commentCell = [tableView dequeueReusableCellWithIdentifier:@"MYYCommentTableViewCellID"];
    if (!commentCell) {
        commentCell = [[[NSBundle mainBundle]loadNibNamed:@"MYYCommentTableViewCell" owner:nil options:nil]firstObject];
    }
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataCommentArray)) {
            MYYDetailProCommentModel* model = _dataCommentArray[indexPath.section];
//            commentCell.titleLabel.text = [NSString stringWithFormat:@"%@",model.custname];
//            commentCell.contentLabel.text = [NSString stringWithFormat:@"%@",model.comments];
//            commentCell.dateLabel.text = [NSString stringWithFormat:@"%@",model.createtime];
//            commentCell.headerimg.text = [NSString stringWithFormat:@"V%@",model.scores];
            //NSSLog(@"%@",model.scores);
            LEOStarView *LEDstar;
            if (LEDstar == nil) {
                LEDstar = [[LEOStarView alloc]initWithFrame:CGRectMake(0, 0, 60, 10)];
            }
            LEDstar.markType = EMarkTypeDecimal;
            LEDstar.currentPercent =  [model.scores floatValue]/5;
            LEDstar.starCount = 5;
            LEDstar.userInteractionEnabled = NO;
            [commentCell.scoreView addSubview:LEDstar];
            //        self.starView.markComplete = ^(CGFloat score){
            //            //点击的时候才会有的返回值
            //            self.scoreLabel.text = [NSString stringWithFormat:@"%.1f分",score];
            //        };
        }

       CGSize strSize = [commentCell.contentLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width - 20, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
//        commentCell.contentLabelHeight.constant = strSize.height;
        commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return commentCell;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
//tableview头部跟随滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 40;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
    
}
#warning mark self.type
- (void)dataRequest{
    //good,middle,bad
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\",\"flag\":\"%@\"}",self.proid,self.type,_tabFlag]};
    //NSSLog(@"%@",params);
    [HTNetWorking postWithUrl:@"evaulteManage?action=searchEvalute" refreshCache:YES  params:params success:^(id response) {
        //NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSDictionary* diction = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //NSSLog(@"评价%@",diction);
        if (_page == 1) {
            [_dataCommentArray removeAllObjects];
        }
        if (!IsEmptyValue([diction objectForKey:@"rows"])) {
            for (NSDictionary* dict in [diction objectForKey:@"rows"]) {
                MYYDetailProCommentModel* model = [[MYYDetailProCommentModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataCommentArray addObject:model];
            }
        }
        if (_dataCommentArray.count == 0) {
            _bgView.hidden = NO;
        }
        [_tbView reloadData];

    } fail:^(NSError *error) {
        
    }];
    
}
- (void)dataButtonevaluate{
    NSDictionary* paramsss = @{@"params":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\"}",self.proid,self.type]};
    //NSSLog(@"%@",params);
    [HTNetWorking postWithUrl:@"evaulteManage?action=evalutecount&table=evaluate" refreshCache:YES  params:paramsss success:^(id response) {
        //NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //NSSLog(@"评价%@",array);
        [self setEvaluateButtongood:[array[0] objectForKey:@"good"] middle:[array[0] objectForKey:@"middle"] bad:[array[0] objectForKey:@"bad"]];
        
    } fail:^(NSError *error) {
        
    }];
}
- (void)setEvaluateButtongood:(NSString *)good middle:(NSString *)middle bad:(NSString *)bad{
    UIView* tabView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    tabView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tabView];
    NSArray* titleBtnArray = @[@"全部",[NSString stringWithFormat:@"好评(%@)",good]
,[NSString stringWithFormat:@"中评(%@)",middle],[NSString stringWithFormat:@"差评(%@)",bad]];
    for (int i = 0; i < titleBtnArray.count; i++) {
        UIButton* totalBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        totalBtn.frame = CGRectMake(10+(60+5)*i, 10, 60, 30);
        [totalBtn setTitle:titleBtnArray[i] forState:UIControlStateNormal];
        totalBtn.layer.masksToBounds = YES;
        totalBtn.layer.cornerRadius = 10;
        [tabView addSubview:totalBtn];
        [_tabBtnArray addObject:totalBtn];
        [totalBtn addTarget:self action:@selector(tabBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [totalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            totalBtn.backgroundColor = BaseBtnSelectColor;
        }else{
            [totalBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            totalBtn.backgroundColor = BaseBtnFomalColor;
        }
    }
}
@end
