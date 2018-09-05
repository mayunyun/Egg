//
//  HomeIconCell.m
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/12.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeIconCell.h"
#import "HomeTypeModel.h"
@implementation HomeIconCell
{
    HomeTypeModel*_typeModel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)typeBtn1Clicked:(UIButton *)sender {
    if (_typeBtn1Block) {
        self.typeBtn1Block();
    }
}
- (IBAction)typeBtn2Clicked:(UIButton *)sender {
    if (_typeBtn2Block) {
        self.typeBtn2Block();
    }
}
- (IBAction)typeBtn3Clicked:(UIButton *)sender {
    if (_typeBtn3Block) {
        self.typeBtn3Block();
    }
}
- (IBAction)typeBtn4Clicked:(UIButton *)sender {
    if (_typeBtn4Block) {
        self.typeBtn4Block();
    }
}

-(void)setTypeArray:(NSMutableArray *)typeArray{
    NSString* url = HTImgUrl;
    _typeArray = typeArray;
    _typeModel = [[HomeTypeModel alloc]init];
    _typeModel = typeArray[0];
    _typeName1.text = _typeModel.name;
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@",url,_typeModel.folder,_typeModel.autoname]);
    [_type1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",url,_typeModel.folder,_typeModel.autoname]]
                   forState:UIControlStateNormal
                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                      
                      [_type1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",url,_typeModel.folder,_typeModel.autoname]]
                                     forState:UIControlStateSelected];
                      
                  }];

    _typeModel = [[HomeTypeModel alloc]init];
    _typeModel = typeArray[1];
    
    _typeName2.text = _typeModel.name;
    [_type2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",url,_typeModel.folder,_typeModel.autoname]]
                   forState:UIControlStateNormal
                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                      
                      [_type2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",url,_typeModel.folder,_typeModel.autoname]]
                                     forState:UIControlStateSelected];
                      
                  }];
    
    _typeModel = [[HomeTypeModel alloc]init];
    _typeModel = typeArray[2];
    
    _typeName3.text = _typeModel.name;
    [_type3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",url,_typeModel.folder,_typeModel.autoname]]
                   forState:UIControlStateNormal
                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                      
                      [_type3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",url,_typeModel.folder,_typeModel.autoname]]
                                     forState:UIControlStateSelected];
                      
                  }];
    
    _typeModel = [[HomeTypeModel alloc]init];
    _typeModel = typeArray[3];
    
    _typeName4.text = _typeModel.name;
    [_type4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",url,_typeModel.folder,_typeModel.autoname]]
                   forState:UIControlStateNormal
                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                      
                      [_type4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",url,_typeModel.folder,_typeModel.autoname]]
                                     forState:UIControlStateSelected];
                      
                  }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
