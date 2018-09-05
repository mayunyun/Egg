//
//  MYYCoderCommentTableViewCell.h
//  BaseFrame
//
//  Created by apple on 17/5/12.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYYCoderCommentTableViewCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic, strong)UIImageView *headerview;
@property (nonatomic, strong)UILabel *describeLab;
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UILabel *intager;//通过tag传值

@end
