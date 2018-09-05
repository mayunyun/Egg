//
//  HomeListCell.h
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/12.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeListCell : UITableViewCell
@property(nonatomic,strong)void (^moreBtnBlock)();

@property (weak, nonatomic) IBOutlet UIImageView *saleImg1;
@property (weak, nonatomic) IBOutlet UIImageView *saleImg2;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIImageView *proImg1;
@property (weak, nonatomic) IBOutlet UIImageView *proImg2;
@property (weak, nonatomic) IBOutlet UILabel *proName1;
@property (weak, nonatomic) IBOutlet UILabel *proName2;
@property (weak, nonatomic) IBOutlet UILabel *sectionTitle;

@property(nonatomic,strong) NSMutableArray * favorableArray;

@property(nonatomic,strong) NSString * favorableString;
@property(nonatomic,strong) UIViewController * ViewController;

@end
