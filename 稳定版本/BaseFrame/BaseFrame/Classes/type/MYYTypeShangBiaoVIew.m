//
//  MYYTypeShangBiaoVIew.m
//  BaseFrame
//
//  Created by apple on 17/5/4.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYTypeShangBiaoVIew.h"

@implementation MYYTypeShangBiaoVIew

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self createUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)createUI{
    NSArray *arr = @[@"品牌企业",@"安全优质",@"快速高效",@"贴心服务"];
    
    
    for (int i = 0; i < [arr count]; i++) {
        UIImageView *image = [[UIImageView alloc]init];
        [image setImage:[UIImage imageNamed:arr[i]]];
        image.frame = CGRectMake(mScreenWidth/4*i+5, (50-30*MYWIDTH)/2, mScreenWidth/4-10, 30*MYWIDTH);
        [self addSubview:image];
        
//        UILabel *TitleLable= [[UILabel alloc]initWithFrame:CGRectMake(mScreenWidth/4*i+30, 10, mScreenWidth/4-30, 30)];
//        TitleLable.textColor = UIColorFromRGB(0x333333);
//        TitleLable.textAlignment = NSTextAlignmentLeft;
//        TitleLable.font = [UIFont systemFontOfSize:13];
//        TitleLable.backgroundColor = [UIColor whiteColor];
//        TitleLable.text= arr[i];
//        [self addSubview:TitleLable];
    }
    UILabel *backview1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, mScreenWidth, 10)];
    backview1.backgroundColor = UIColorFromRGB(0xececec);
    [self addSubview:backview1];
    
    UILabel *titleLab= [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 100, 30)];
    titleLab.textColor = UIColorFromRGB(0x333333);
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.text= @"产品参数";
    [self addSubview:titleLab];
    
    UILabel *backview2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, mScreenWidth, 10)];
    backview2.backgroundColor = UIColorFromRGB(0xececec);
    [self addSubview:backview2];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
