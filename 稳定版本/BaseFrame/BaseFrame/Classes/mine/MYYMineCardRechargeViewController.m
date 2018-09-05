//
//  MYYMineCardRechargeViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYMineCardRechargeViewController.h"
#import "RegistReferModel.h"

@interface MYYMineCardRechargeViewController ()<UITextFieldDelegate>
{
    UILabel* _moneyLabel;
    UITextField* _cardField;
    UIScrollView* _bgView;
}
@end

@implementation MYYMineCardRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self searchUserInfoRequest];
}

- (void)searchUserInfoRequest{
/*
 /mallLogin?action=searchUserInfo
 */
    [HTNetWorking postWithUrl:@"mallLogin?action=searchUserInfo" refreshCache:YES params:nil success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"账户余额%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            RegistReferModel* model = [[RegistReferModel alloc]init];
            [model setValuesForKeysWithDictionary:array[0]];
            _moneyLabel.text = [NSString stringWithFormat:@"%@",model.balance];
        }
        
    } fail:^(NSError *error) {
        
    }];
}
- (UIScrollView*)bgView{
    if (_bgView == nil) {
        _bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64- 40)];
        _bgView.backgroundColor = BackGorundColor;
        _bgView.contentSize = CGSizeMake(kScreen_Width, 714);
        _bgView.showsVerticalScrollIndicator = NO;
        _bgView.showsHorizontalScrollIndicator = NO;
        _bgView.bounces = NO;
        [self.view addSubview:_bgView];
    }
    return _bgView;
}
- (void)creatUI{
    self.view.backgroundColor = BackGorundColor;
    [self bgView];
    UIView* firstCell = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreen_Width, 50)];
    firstCell.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:firstCell];
    UIImageView* moneyImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    moneyImgView.image = [UIImage imageNamed:@"balance"];
    [firstCell addSubview:moneyImgView];
    UILabel* middleLabel = [[UILabel alloc]initWithFrame:CGRectMake(moneyImgView.right+5, 0, 80, firstCell.height)];
    middleLabel.font = [UIFont systemFontOfSize:15];
    middleLabel.text = @"当前余额：";
    [firstCell addSubview:middleLabel];
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(middleLabel.right, 0, kScreen_Width - 140, firstCell.height)];
    _moneyLabel.text = @"￥0.00";
    _moneyLabel.textColor = NavBarItemColor;
    _moneyLabel.font = [UIFont systemFontOfSize:15];
    [firstCell addSubview:_moneyLabel];
    
    UILabel* headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, firstCell.bottom, kScreen_Width - 20, 30)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = @"请输入充值卡信息";
    headerLabel.font = [UIFont systemFontOfSize:16];
    [_bgView addSubview:headerLabel];
    UIView* secondCell = [[UIView alloc]initWithFrame:CGRectMake(0, headerLabel.bottom, kScreen_Width, 50)];
    secondCell.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:secondCell];
    UILabel* sleftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, secondCell.height)];
    sleftLabel.text = @"充值卡号：";
    sleftLabel.font = [UIFont systemFontOfSize:14];
    sleftLabel.textColor = GrayTitleColor;
    [secondCell addSubview:sleftLabel];
    _cardField = [[UITextField alloc]initWithFrame:CGRectMake(sleftLabel.right, 5, kScreen_Width - 100, 40)];
    _cardField.delegate = self;
    _cardField.layer.cornerRadius = 5;
//    _cardField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _cardField.layer.borderColor = [UIColor grayColor].CGColor;
//    [_cardField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [secondCell addSubview:_cardField];
    
    
    UIButton* nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.frame = CGRectMake(10, secondCell.bottom+30, kScreen_Width - 20, 44);
    [nextBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = 5;
    nextBtn.backgroundColor = NavBarItemColor;
    [_bgView addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* noteTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, nextBtn.bottom+10, 80, 20)];
    noteTitleLabel.backgroundColor = [UIColor clearColor];
    noteTitleLabel.text = @"温馨提示：";
    noteTitleLabel.font = [UIFont systemFontOfSize:14];
    [_bgView addSubview:noteTitleLabel];
    UILabel* noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, noteTitleLabel.bottom+5, kScreen_Width - 20, 20)];
    noteLabel.backgroundColor = [UIColor clearColor];
    noteLabel.text = @"1.请认真核对充值卡号，以免发生资金损失！";
    noteLabel.textColor = [UIColor redColor];
    noteLabel.font = [UIFont systemFontOfSize:13];
    [_bgView addSubview:noteLabel];
    
    
}

- (void)nextBtnClick:(UIButton*)sender{
/*
 recharge?action=cardRecharge,    cardno
 */
    if (!IsEmptyValue(_cardField.text)) {
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"cardno\":\"%@\"}",_cardField.text]};
        [HTNetWorking postWithUrl:@"recharge?action=cardRecharge" refreshCache:YES  params:params success:^(id response) {
            NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"蛋事卡充值%@",str);
            if ([str rangeOfString:@"true"].location!=NSNotFound) {
                _cardField.text = @"";
                [self showAlert:@"蛋事卡充值成功"];
                [self searchUserInfoRequest];
            }else{
                [self showAlert:str];

            }
            
        } fail:^(NSError *error) {
            
        }];
        
    }else{
        [self showAlert:@"请填写充值卡号"];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}

@end
