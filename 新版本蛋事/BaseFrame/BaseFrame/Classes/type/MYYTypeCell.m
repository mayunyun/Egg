//
//  MYYTypeCell.m
//  BaseFrame
//
//  Created by apple on 17/5/3.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYTypeCell.h"

@implementation MYYTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.headerImage1.layer.cornerRadius = 5;
    self.headerImage1.clipsToBounds = YES;
    
    self.headerImage2.layer.cornerRadius = 5;
    self.headerImage2.clipsToBounds = YES;
    
    self.headerImage3.layer.cornerRadius = 5;
    self.headerImage3.clipsToBounds = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
