//
//  CXArticleDetailHeader.m
//  rrcx
//
//  Created by 123 on 2017/9/21.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXArticleDetailHeader.h"
#import "UIButton+WebCache.h"
@implementation CXArticleDetailHeader
-(void)awakeFromNib{
    [super awakeFromNib];
    _avatarBtn.layer.masksToBounds = YES;
    _avatarBtn.layer.cornerRadius = 20;
    _followBtn.layer.masksToBounds = YES;
    _followBtn.layer.cornerRadius = 2;
    _zanBtn.layer.masksToBounds = YES;
    _zanBtn.layer.cornerRadius = 12.5;
    _zanBtn.layer.borderWidth = 1;
    _zanBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.followBtn.backgroundColor = BasicColor;
    [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
    [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.followBtn.layer.borderWidth = 0.1;
    self.followBtn.layer.borderColor = [UIColor clearColor].CGColor;
}

-(void)setModel:(CXArticleDetailModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:model.authorInfo.member_avatar] forState:UIControlStateNormal placeholderImage:nil];
    self.nicknameLabel.text = model.authorInfo.member_nick;
    self.timeLabel.text = model.add_time;
    [self.followBtn setBackgroundColor:BasicColor];
    [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
    self.detailWebView.scrollView.scrollEnabled = NO;
    [self.detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.contenturl]]];
    [self.zanBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
    [self.zanBtn setTitle:model.num_up forState:UIControlStateNormal];
    [self.zanBtn setTitleColor:UIColorFromRGB(0x797979) forState:UIControlStateNormal];
    
    [self setIsAttention:[model.ishits isEqualToString:@"1"]];
    [self setIsLike:[model.islike isEqualToString:@"1"]];
    self.lookCountLab.text = [model.num_look stringByAppendingString:@"阅读"];
    self.commentCountLabel.text = [NSString stringWithFormat:@"评论 %@",model.num_comment];
}

- (IBAction)avatarBtnClick:(id)sender {
    if (self.lookAuthorHomeBlock) {
        self.lookAuthorHomeBlock();
    }
}

- (IBAction)folloeBtnClick:(id)sender {
    BOOL isAttention = [_model.ishits isEqualToString:@"0"];
    [CXHomeRequest attentionUserWithParameters:@{@"action":isAttention?@1:@2,@"member_id":_model.authorInfo.member_id} success:^(id response) {
        if ([response[@"code"] integerValue] == 0) {
            if ([_model.ishits isEqualToString:@"0"]) {
                _model.ishits = @"1";
                [self setIsAttention:YES];
            }
            else{
                _model.ishits = @"0";
                [self setIsAttention:NO];
            }
        }
        else{
            [Message showMiddleHint:response[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)zanBtnClick:(id)sender {
    BOOL like = [_model.islike isEqualToString:@"1"];
    [CXHomeRequest zanArticle:@{@"id":_model.ID,@"action":like?@"down":@"up"} success:^(id response) {
        if ([response[@"code"] integerValue] == 0) {
            if ([_model.islike isEqualToString:@"0"]) {
                _model.islike = @"1";
                NSInteger num_up = [_model.num_up integerValue];

                _model.num_up = [NSString stringWithFormat:@"%ld",num_up+1];

                [self setIsLike:YES];
            }
            else{
                _model.islike = @"0";
                NSInteger num_up = [_model.num_up integerValue];
                if (num_up > 1) {
                    _model.num_up = [NSString stringWithFormat:@"%ld",num_up-1];
                }
                else{
                    _model.num_up = @"0";
                }
                
                [self setIsLike:NO];
            }
        }
        else{
            [Message showMiddleHint:response[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];

}
-(void)setIsLike:(BOOL)isLike{
    _isLike = isLike;
    
    if (isLike) {
        [_zanBtn setImage:[UIImage imageNamed:@"praise-a"] forState:UIControlStateNormal];
        _zanBtn.layer.borderColor = BasicColor.CGColor;
        [_zanBtn setTitleColor:BasicColor forState:UIControlStateNormal];
        [_zanBtn setTitle:_model.num_up forState:UIControlStateNormal];
    }
    else{
        [_zanBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
        _zanBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [_zanBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_zanBtn setTitle:_model.num_up forState:UIControlStateNormal];

    }
}


-(void)setIsAttention:(BOOL)isAttention{
    _isAttention = isAttention;
    if (isAttention) {
        self.followBtn.backgroundColor = [UIColor whiteColor];
        [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.followBtn setTitleColor:RGB(44, 44, 44) forState:UIControlStateNormal];
        self.followBtn.layer.borderWidth = 1;
        self.followBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    }
    else{
        self.followBtn.backgroundColor = BasicColor;
        [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.followBtn.layer.borderWidth = 0.1;
        self.followBtn.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
}
@end
