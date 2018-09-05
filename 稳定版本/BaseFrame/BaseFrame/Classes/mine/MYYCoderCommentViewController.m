//
//  MYYCoderCommentViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYCoderCommentViewController.h"
#import "MYYCoderCommentTableViewCell.h"
#import "MYYMyOrderClassModer.h"

@interface MYYCoderCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView* tableView;

@end

@implementation MYYCoderCommentViewController{
    NSString *_orderStr;//订单的产品
    NSString *_starNum;
}

- (UITableView *)TableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight-64-45)];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF0F0F0);
    self.navigationItem.title = @"评论";
    [self creatUI];
    [self TableView];
}
- (void)creatUI{
    
    //
    UIView *viewal = [[UIView alloc]initWithFrame:CGRectMake(0, mScreenHeight-45-64, mScreenWidth, 45)];
    viewal.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewal];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 150, 30)];
    lable.text = @"最多可输入200字评论！";
    lable.textColor = UIColorFromRGB(0x333333);
    lable.font = [UIFont systemFontOfSize:13];
    [viewal addSubview:lable];
    
    UIButton *monBut = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth - 100, 0, 100, 45)];
    [monBut setTitle:@"提交评价"forState:UIControlStateNormal];
    monBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [monBut setBackgroundColor:[UIColor orangeColor]];
    [monBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [monBut addTarget:self action:@selector(butnext) forControlEvents:UIControlEventTouchUpInside];
    [viewal addSubview:monBut];
}

- (void)butnext{
    NSLog(@"%@",_orderArr);
    MYYMyOrderClassModer* model = _orderArr[0];
    NSString *orderid = [NSString stringWithFormat:@"%@",model.orderid];
    
    NSMutableString* mustr = [[NSMutableString alloc]init];
    int i=0;
    for (MYYMyOrderClassModer* model in _orderArr) {
        UITextView *text = [self.view viewWithTag:2000+i];
        UILabel *lab = [self.view viewWithTag:2500+i];
        NSString* str = [NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"type\":\"%@\",\"comments\":\"%@\",\"scores\":\"%@\"},",model.proid,model.proname,model.type,[Command convertNull:text.text],lab.text];
        if ([text.text isEqualToString:@"不想说点什么？"]) {
            str = [NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"type\":\"%@\",\"comments\":\"%@\",\"scores\":\"%@\"},",model.proid,model.proname,model.type,@"",lab.text];
        }
        [mustr appendString:str];
        i++;
    }
    NSString* prostr = mustr;
    if (prostr.length!=0) {
        NSRange range = {0,prostr.length - 1};
        prostr = [prostr substringWithRange:range];
    }
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"evaluteList\":[%@],\"orderid\":\"%@\"}",prostr,orderid]};
    
    NSLog(@"%@",params);
    [HTNetWorking postWithUrl:@"evaulteManage?action=addEvaulte" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [self showAlert:@"评论成功"];
            NSDictionary *dict = @{@"one":@"4"};
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"orderUpData" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSError *error) {
        
    }];
    
}
//字典转字符串
+ (NSString*)dictionaryToJson:(NSMutableDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _orderArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MYYCoderCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell= [[MYYCoderCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MYYMyOrderClassModer* model = _orderArr[indexPath.row];
    [cell.headerview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",HTImgUrl,@"productimages",model.autoname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
    cell.describeLab.text = [NSString stringWithFormat:@"%@",model.proname];
    cell.textView.tag = indexPath.row+2000;
    cell.intager.tag = indexPath.row +2500;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
