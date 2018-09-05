//
//  HomeListCell.m
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/12.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeListCell.h"
#import "HomeFavorableModel.h"
#import "ProductDetailPageVC.h"
@implementation HomeListCell
{
    HomeFavorableModel * _FomalModel;
    HomeFavorableModel * _FomalModel1;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)moreBtnClicked:(UIButton *)sender {
    if (_moreBtnBlock) {
        self.moreBtnBlock();
    }
}

-(void)setFavorableString:(NSString *)favorableString{
    _favorableString = favorableString;
    self.sectionTitle.text = favorableString;
}

-(void)setFavorableArray:(NSMutableArray *)favorableArray{
    NSString* url = HTImgUrl;
    _favorableArray = favorableArray;
    _FomalModel = [[HomeFavorableModel alloc]init];
    _FomalModel = _favorableArray[0];
    _proName1.text = _FomalModel.proname;
    _proImg1.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(proImgTap1)];
    [_proImg1 addGestureRecognizer:tap1];
    [_proImg1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",url,@"productimages",_FomalModel.autoname]] placeholderImage:[UIImage imageNamed:@""]];
    if (favorableArray.count > 1) {
        _FomalModel1 = [[HomeFavorableModel alloc]init];
        _FomalModel1 = _favorableArray[1];
        _proName2.text = _FomalModel1.proname;
        _proImg2.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(proImgTap2)];
        [_proImg2 addGestureRecognizer:tap2];
        [_proImg2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",url,@"productimages",_FomalModel1.autoname]] placeholderImage:[UIImage imageNamed:@""]];
    }
}
-(void)proImgTap1{
    ProductDetailPageVC * vc = [[ProductDetailPageVC alloc]init];
    _FomalModel = [[HomeFavorableModel alloc]init];
    _FomalModel = _favorableArray[0];
    vc.type = _FomalModel.type;
    vc.proid = _FomalModel.Id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.ViewController.navigationController pushViewController:vc animated:YES];
}
-(void)proImgTap2{
    ProductDetailPageVC * vc = [[ProductDetailPageVC alloc]init];
    _FomalModel = [[HomeFavorableModel alloc]init];
    _FomalModel = _favorableArray[1];
    vc.type = _FomalModel.type;
    vc.proid = _FomalModel.Id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.ViewController.navigationController pushViewController:vc animated:YES];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
