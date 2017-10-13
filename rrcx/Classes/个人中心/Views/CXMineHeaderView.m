//
//  CXMineHeaderView.m
//  rrcx
//
//  Created by 123 on 2017/9/4.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXMineHeaderView.h"

@implementation CXMineHeaderView


-(void)layoutSubviews{
    self.clipsToBounds = YES;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.mj_w/2;
}



- (IBAction)avatarClick:(id)sender {
    
    if (self.avatarClickBlock) {
        self.avatarClickBlock();
    }
}
- (IBAction)fansBtnClick:(id)sender {
    if (self.fansClickBlock) {
        self.fansClickBlock();
    }
}

- (IBAction)focusBtnClick:(id)sender {
    
    if (self.focusClickBlock) {
        self.focusClickBlock();
    }
}

- (IBAction)visitorBtnClick:(id)sender {
    if (self.visitorClickBlock) {
        self.visitorClickBlock();
    }
    
}
-(void)setMember_nick:(NSString *)member_nick{
    _member_nick = member_nick;
    self.nicknameLabel.text = member_nick.length>0?member_nick:@"未设置";
    
}
-(void)setMember_focus:(NSString *)member_focus{
    _member_focus = member_focus;
    self.attentionCountLab.text = member_focus;
}
-(void)setMember_follows:(NSString *)member_follows{
    _member_follows = member_follows;
    self.fansCountLab.text = member_follows;
}

-(void)setMember_visitor:(NSString *)member_visitor{
    _member_visitor = member_visitor;
    self.visitCountLab.text = member_visitor;
}

-(void)setMember_avatar:(NSString *)member_avatar{
    _member_avatar = member_avatar;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:member_avatar] placeholderImage:[UIImage imageNamed:@"icon"]];
}









@end
