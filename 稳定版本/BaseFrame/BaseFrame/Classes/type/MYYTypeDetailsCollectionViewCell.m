//
//  MYYTypeDetailsCollectionViewCell.m
//  BaseFrame
//
//  Created by apple on 17/5/4.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYTypeDetailsCollectionViewCell.h"

@implementation MYYTypeDetailsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.imgView.layer.cornerRadius = 5;
    self.imgView.clipsToBounds = YES;
}
@end
