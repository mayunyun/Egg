//
//  MYYMyOrterClassTableViewCell.m
//  BaseFrame
//
//  Created by apple on 17/5/15.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYMyOrterClassTableViewCell.h"

@implementation MYYMyOrterClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.headerImage.layer.cornerRadius = 5;
    self.headerImage.clipsToBounds = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
