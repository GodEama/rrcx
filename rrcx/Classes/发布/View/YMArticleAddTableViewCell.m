//
//  YMArticleAddTableViewCell.m
//  YunMuFocus
//
//  Created by apple on 2017/4/17.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import "YMArticleAddTableViewCell.h"

@implementation YMArticleAddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textBtn.layer.masksToBounds = YES;
    _textBtn.layer.cornerRadius = 4;
    _imgBtn.layer.masksToBounds = YES;
    _imgBtn.layer.cornerRadius = 4;
    
    _TypeView.layer.masksToBounds = YES;
    _TypeView.layer.cornerRadius = 20;
    _TypeView.layer.borderWidth = 1;
    _TypeView.layer.borderColor = RGB(238, 239, 240).CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
