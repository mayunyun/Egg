//
//  MYYMyOrterTableViewCell.m
//  BaseFrame
//
//  Created by apple on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYMyOrterTableViewCell.h"
#import "MYYMyOrterClassTableViewCell.h"
@interface MYYMyOrterTableViewCell ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tbView;
}

@end
@implementation MYYMyOrterTableViewCell{
    MYYMyOrderModel *_model;
}

- (void)configModel:(MYYMyOrderModel *)model{
    _model = model;
    [_cancelBut.layer setCornerRadius:5];
    [_cancelBut.layer setBorderColor:UIColorFromRGB(0x666666).CGColor];
    [_cancelBut.layer setBorderWidth:0.5];
    [_cancelBut.layer setMasksToBounds:YES];
    [_cancelBut setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [_cancelBut setBackgroundColor:[UIColor whiteColor]];

    
    [_nextBut.layer setCornerRadius:5];
    [_nextBut.layer setBorderColor:[UIColor orangeColor].CGColor];
    [_nextBut.layer setBorderWidth:0.5];
    [_nextBut.layer setMasksToBounds:YES];
    [_nextBut setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_nextBut setBackgroundColor:[UIColor whiteColor]];
    switch ([model.orderstatus intValue]) {//0待付款 1 待发货 2 待收货 3待评价 4订单完成
        case 0:{
            _ordelState.text = @"待付款";
            [_nextBut setTitle:@"去付款" forState:UIControlStateNormal];
            [_nextBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_nextBut setBackgroundColor:[UIColor orangeColor]];
            _cancelBut.hidden = NO;
            _nextBut.hidden = NO;
            break;
        }
        case 1:{
            _ordelState.text = @"待发货";
//            [_nextBut setTitle:@"确认收货" forState:UIControlStateNormal];
            _nextBut.hidden = YES;
            _cancelBut.hidden = YES;
            break;
        }
        case 2:{
            _ordelState.text = @"待收货";
            [_nextBut setTitle:@"确认收货" forState:UIControlStateNormal];
            _cancelBut.hidden = YES;
            _nextBut.hidden = NO;
            break;
        }
        case 3:{
            _ordelState.text = @"待评价";
            [_nextBut setTitle:@"去评价" forState:UIControlStateNormal];
            _cancelBut.hidden = YES;
            _nextBut.hidden = NO;
            break;
        }
            
        default:{
            _ordelState.text = @"已完成";
            [_nextBut setTitle:@"已完成" forState:UIControlStateNormal];
            _cancelBut.hidden = YES;
            _nextBut.hidden = NO;
        }
            break;
    }
    
    _ordernoLab.text = [NSString stringWithFormat:@"订单号：%@",model.orderno];
    
    _timeLab.text = [NSString stringWithFormat:@"%@",model.createtime];
    
    _hejiLab.text = [NSString stringWithFormat:@"共%@件商品、合计:￥%@",model.totalcount,model.totalmoney];
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, _prolistArr.count*70) style:UITableViewStylePlain];
    _tbView.userInteractionEnabled = NO;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbView.bounces = NO;
    _tbView.delegate = self;
    _tbView.rowHeight = 70;
    _tbView.dataSource = self;
    [self.bgView addSubview:_tbView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.bgView setFrame:CGRectMake(self.bgView.left, self.bgView.top, self.bgView.width, 70*_prolistArr.count)];
    self.bgHeight.constant = 70*_prolistArr.count;
    [_tbView setFrame:CGRectMake(0, 0, mScreenWidth, _prolistArr.count*70)];
    [_tbView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!IsEmptyValue(_prolistArr)) {
        return _prolistArr.count;
    }else{
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYYMyOrterClassTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MYYMyOrterClassTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MYYMyOrterClassTableViewCell" owner:self options:nil].firstObject;
    }
//    MYYMyOrderClassModer* model = [[MYYMyOrderClassModer alloc]init];
//    [model setValuesForKeysWithDictionary:_prolistArr[indexPath.row]];
    MYYMyOrderClassModer* model = _prolistArr[indexPath.row];
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",HTImgUrl,@"productimages",model.autoname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
    cell.titleLab.text = [NSString stringWithFormat:@"%@",model.proname];
    cell.moneyLab.text = [NSString stringWithFormat:@"￥%@",model.price];
    cell.countLab.text = [NSString stringWithFormat:@"x%@",model.count];
    [cell setNeedsLayout];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
