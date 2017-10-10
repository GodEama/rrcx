//
//  YMArticleVoiceTableViewCell.m
//  YunMuFocus
//
//  Created by apple on 2017/4/17.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import "YMArticleVoiceTableViewCell.h"

@implementation YMArticleVoiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 8;
}
-(void)setVoiceSource:(NSString *)voiceSource{
    _voiceSource = voiceSource;
}

- (IBAction)playBtnClick:(id)sender {
    if (self.voiceBtnClickBlock) {
        self.voiceBtnClickBlock(_voiceSource);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
