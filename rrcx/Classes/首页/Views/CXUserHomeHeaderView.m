//
//  CXUserHomeHeaderView.m
//  rrcx
//
//  Created by 123 on 2017/9/8.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXUserHomeHeaderView.h"
#import "UIButton+WebCache.h"
#import "SDPhotoBrowser.h"
@interface CXUserHomeHeaderView()<SDPhotoBrowserDelegate>
@end
@implementation CXUserHomeHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    _avatarBtn.layer.masksToBounds = YES;
    _avatarBtn.layer.cornerRadius = _avatarBtn.mj_w/2;
    
    _followBtn.layer.masksToBounds = YES;
    _followBtn.layer.cornerRadius = 4;
    _followBtn.layer.shadowOffset = CGSizeMake(0, 2);
    _followBtn.layer.shadowColor  = [UIColor grayColor].CGColor;
  
    
}
- (IBAction)lookAvatar:(id)sender {
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.isFormWebImage = YES;

    browser.currentImageIndex = 0;
    //    browser.sourceImagesContainerView = self.conView;
    browser.imageCount = 1;
    browser.delegate = self;
    [browser show];
}

-(void)layoutSubviews{
    self.frame = CGRectMake(0, 0, KWidth, 251);
}

-(void)setMember_nick:(NSString *)member_nick{
    _member_nick = member_nick;
    self.nicknameLabel.text = member_nick.length>0?member_nick:@"未设置";
    
}
-(void)setMember_focus:(NSString *)member_focus{
    _member_focus = member_focus;
    self.followCountLab.text = member_focus;
}
-(void)setMember_follows:(NSString *)member_follows{
    _member_follows = member_follows;
    self.fansCountLab.text = member_follows;
}

-(void)imgViewClick:(UITapGestureRecognizer*)tapGesture
{
    
    
}
#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    
//    NSString *imageName = self.member_avatar;
    NSURL *url = [NSURL URLWithString:self.member_avatar];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [UIImage imageNamed:@"placeholder_avatar" ];
}




-(void)setMember_avatar:(NSString *)member_avatar{
    _member_avatar = member_avatar;
    [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:member_avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_avatar"]];
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


- (IBAction)followBtnClick:(id)sender {
   
    [CXHomeRequest attentionUserWithParameters:@{@"action":self.isAttention?@2:@1,@"member_id":_member_id} success:^(id response) {
        if ([response[@"code"] integerValue] == 0) {
            if (_isAttention) {
                [self setIsAttention:NO];
            }
            else{
                [self setIsAttention:YES];
            }
        }
        else{
            [Message showMiddleHint:response[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
}


-(void)setIsAttention:(BOOL)isAttention{
    _isAttention = isAttention;
    if (isAttention) {
        [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.followBtn setTitleColor:RGB(22, 22, 22) forState:UIControlStateNormal];
        self.followBtn.layer.borderWidth = 0.5;
        self.followBtn.layer.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
        self.followBtn.backgroundColor = [UIColor whiteColor];

    }
    else{
        [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.followBtn.layer.borderWidth = 0.1;
        self.followBtn.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.followBtn.backgroundColor = BasicColor;

    }
    
}








@end
