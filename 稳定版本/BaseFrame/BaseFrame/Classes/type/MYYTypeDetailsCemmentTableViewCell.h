//
//  MYYTypeDetailsCemmentTableViewCell.h
//  BaseFrame
//
//  Created by apple on 17/5/4.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOStarView.h"

@interface MYYTypeDetailsCemmentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIButton *totleBtn;
- (IBAction)totalBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerLab;
@property (weak, nonatomic) IBOutlet LEOStarView *starView;
@property (nonatomic,copy) void (^transVaule)(BOOL isClick);
@property (weak, nonatomic) IBOutlet UILabel *evaluateLab;

@end
