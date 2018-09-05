//
//  HomeIconCell.h
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/12.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeIconCell : UITableViewCell
@property (nonatomic,strong)void (^typeBtn1Block)();
@property (nonatomic,strong)void (^typeBtn2Block)();
@property (nonatomic,strong)void (^typeBtn3Block)();
@property (nonatomic,strong)void (^typeBtn4Block)();
@property (weak, nonatomic) IBOutlet UIButton *type1;
@property (weak, nonatomic) IBOutlet UIButton *type2;
@property (weak, nonatomic) IBOutlet UIButton *type3;
@property (weak, nonatomic) IBOutlet UIButton *type4;
@property (weak, nonatomic) IBOutlet UILabel *typeName1;
@property (weak, nonatomic) IBOutlet UILabel *typeName2;
@property (weak, nonatomic) IBOutlet UILabel *typeName3;
@property (weak, nonatomic) IBOutlet UILabel *typeName4;


@property(nonatomic,strong) NSMutableArray * typeArray;
@end
