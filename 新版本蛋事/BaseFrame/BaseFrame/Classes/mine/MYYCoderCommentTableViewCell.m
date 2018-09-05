//
//  MYYCoderCommentTableViewCell.m
//  BaseFrame
//
//  Created by apple on 17/5/12.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYCoderCommentTableViewCell.h"

@implementation MYYCoderCommentTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self viewCreate];
    }
    return self;
}

-(void)viewCreate{
    _intager = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _intager.text = @"0";
    [self addSubview:_intager];
    UIView *oneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 200)];
    oneView.backgroundColor = [UIColor whiteColor];
    [self addSubview:oneView];
    UILabel *xian = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 10)];
    xian.backgroundColor = UIColorFromRGB(0xF0F0F0);
    [self addSubview:xian];
    
    _headerview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 40, 40)];
    _headerview.image = [UIImage imageNamed:@"01.png"];
    [oneView addSubview:_headerview];
    _describeLab = [[UILabel alloc]initWithFrame:CGRectMake(65, 20, kScreen_Width - 65 - 160, 40)];
    _describeLab.text = @"描述相符";
    _describeLab.textColor = [UIColor blackColor];
    _describeLab.font = [UIFont systemFontOfSize:14];
    [oneView addSubview:_describeLab];
    
    UIView *buttonView = [self commentButton];
    buttonView.frame = CGRectMake(130, 25, 150, 30);
    [oneView addSubview:buttonView];
    
    UILabel *xian1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, mScreenWidth, 1)];
    xian1.backgroundColor = UIColorFromRGB(0xF0F0F0);
    [oneView addSubview:xian1];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 80, mScreenWidth-20, 90)];
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont fontWithName:@"Arial"size:14.0];
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.text = @"不想说点什么？";
    _textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    _textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    _textView.scrollEnabled = YES;//是否可以拖动
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [oneView addSubview:_textView];
}
//将要进入编辑模式
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([_textView.text isEqualToString:@"不想说点什么？"]) {
        _textView.text = @"";
    }
    return YES;
}
//描述相符
- (UIView *)commentButton{
    UIView *backview = [[UIView alloc]init];
    for (int i=0; i<5; i++) {
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0+30*i, 0, 30, 30)];
        but.tag = 200+i;
        [but setImage:[UIImage imageNamed:@"星星2"] forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:@"星星1"] forState:UIControlStateSelected];
        but.selected = YES;
        [but addTarget:self action:@selector(SelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [backview addSubview:but];
    }
    return backview;
}
- (void)SelectButtonAction:(UIButton *)sender{
    for (int i=0; i<5; i++) {
        UIButton *but = [self viewWithTag:200+i];
        but.selected = NO;
    }
    for (int i=0; i<sender.tag-200+1; i++) {
        UIButton *but = [self viewWithTag:200+i];
        but.selected = YES;
    }
    _intager.text = [NSString stringWithFormat:@"%zd",sender.tag-199];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
