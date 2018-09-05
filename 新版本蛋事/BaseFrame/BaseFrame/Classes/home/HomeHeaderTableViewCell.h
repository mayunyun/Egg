//
//  HomeHeaderTableViewCell.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/3.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHeaderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *moreBtn;
- (IBAction)moreBtnClick:(id)sender;
//block声明
@property (nonatomic, copy) void (^transVaule)(BOOL isClick);

@end
