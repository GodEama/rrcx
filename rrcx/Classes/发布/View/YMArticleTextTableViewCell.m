//
//  YMArticleTextTableViewCell.m
//  YunMuFocus
//
//  Created by apple on 2017/4/17.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import "YMArticleTextTableViewCell.h"

@implementation YMArticleTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 8;}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
