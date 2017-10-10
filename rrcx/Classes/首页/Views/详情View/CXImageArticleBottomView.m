//
//  CXImageArticleBottomView.m
//  rrcx
//
//  Created by 123 on 2017/9/28.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXImageArticleBottomView.h"

@implementation CXImageArticleBottomView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubview];
    }
    return self;
}

-(void)setupSubview{
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.lineView];
    [self addSubview:self.bgView];
    
    [self addSubview:self.collectBtn];
    [self addSubview:self.shareBtn];
    [self addSubview:self.penImageView];
    [self addSubview:self.writeLab];
    [self addSubview:self.commentBtn];
    [self addSubview:self.commentListBtn];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@1);
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareBtn.mas_left).offset(-20);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.commentListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.collectBtn.mas_left).offset(-20);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self.commentListBtn.mas_left).offset(-20);
        make.top.equalTo(self).offset(6);
        make.bottom.equalTo(self).offset(-7);
    }];
    
    [self.penImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(18);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    [self.writeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.penImageView.mas_right);
        make.centerY.equalTo(self.bgView);
        
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.top.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView);
    }];
    
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 18;
//    self.bgView.layer.borderWidth = 1;
//    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.shareBtn setImage:[UIImage imageNamed:@"share-w"] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:@"collection-w"] forState:UIControlStateNormal];
    [self.penImageView setImage:[UIImage imageNamed:@"comment-w"]];
    self.writeLab.text = @"写评论...";
}

-(void)setIsCollected:(BOOL)isCollected{
    _isCollected = isCollected;
    [self.collectBtn setImage:[UIImage imageNamed:isCollected?@"collection-w":@"collection-h"] forState:UIControlStateNormal];
}



-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = RGB(24,24,24);
    }
    return _bgView;
}

-(UILabel *)writeLab{
    if (!_writeLab) {
        _writeLab = [UILabel new];
        //        _writeLab.text = @"写评论...";
        _writeLab.textColor = [UIColor whiteColor];
        _writeLab.font = [UIFont systemFontOfSize:12];
    }
    return _writeLab;
    
}

-(UIImageView *)penImageView{
    if (!_penImageView) {
        _penImageView = [[UIImageView alloc] init];
        
    }
    return _penImageView;
}

-(UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _commentBtn;
}

-(UIButton *)collectBtn{
    if (!_collectBtn ) {
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return _collectBtn;
}
-(UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return _shareBtn;
}
-(UIButton *)commentListBtn{
    if (!_commentListBtn) {
        _commentListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentListBtn setImage:[UIImage imageNamed:@"comment_message"] forState:UIControlStateNormal];
    }
    return _commentListBtn;
}
@end
