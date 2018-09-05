//
//  MYYTypeCell.h
//  BaseFrame
//
//  Created by apple on 17/5/3.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYYDetailsAndCommentViewController.h"
@interface MYYTypeCell : UITableViewCell
@property (strong, nonatomic)UIViewController *viewControlle;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage1;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage2;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage3;
@property (weak, nonatomic) IBOutlet UILabel *titleName1;
@property (weak, nonatomic) IBOutlet UILabel *titleName2;
@property (weak, nonatomic) IBOutlet UILabel *titleName3;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;

@property (weak, nonatomic) IBOutlet UIButton *typeBut1;
@property (weak, nonatomic) IBOutlet UIButton *typeBut2;
@property (weak, nonatomic) IBOutlet UIButton *typeBut3;

@end
