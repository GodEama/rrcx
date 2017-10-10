//
//  CXArticleHeaderView.m
//  rrcx
//
//  Created by 123 on 2017/9/19.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXArticleHeaderView.h"
@interface CXArticleHeaderView()<UIWebViewDelegate>

@property (nonatomic,strong)UILabel * titleLab;
@property (nonatomic,strong)UILabel * nicknameLabel;
@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)UIImageView * avatarImgView;
@property (nonatomic,strong)UIButton * avatarBtn;
@property (nonatomic,strong)UIButton    * followBtn;
@property (nonatomic,strong)UIWebView   * webView;
@property (nonatomic,strong)UIButton    * zanBtn;
@property (nonatomic,strong)UIButton    * downBtn;
@property (nonatomic,strong)UILabel * readCountLabel;
@end
@implementation CXArticleHeaderView


-(void)layoutSubviews{
    [self addSubview:self.titleLab];
    [self addSubview:self.timeLabel];
    [self addSubview:self.nicknameLabel];
    [self addSubview:self.avatarImgView];
    [self addSubview:self.avatarBtn];
    [self addSubview:self.followBtn];
    [self addSubview:self.webView];
    [self addSubview:self.zanBtn];
    //[self addSubview:self.downBtn];
    [self addSubview:self.readCountLabel];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(10);
        
    }];
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.top.equalTo(self.titleLab.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView);
        make.right.equalTo(self.avatarImgView);
        make.top.equalTo(self.avatarImgView);
        make.bottom.equalTo(self.avatarImgView);
    }];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView.mas_right).offset(10);
        make.top.equalTo(self.avatarImgView);
        make.right.equalTo(self).offset(-10);
        
        
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nicknameLabel);
        make.right.lessThanOrEqualTo(self.followBtn);
        make.bottom.equalTo(self.avatarImgView);
    }];
    
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self.avatarImgView);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.timeLabel).offset(16);
        make.height.equalTo(@1).priorityLow();
    }];
    
    [self.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX).offset(-20);
        make.top.equalTo(self.webView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(90, 25));
    }];
//    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_centerX).offset(20);
//        make.top.equalTo(self.webView.mas_bottom).offset(10);
//        make.size.mas_equalTo(CGSizeMake(90, 25));
//    }];
    [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.top.equalTo(self.zanBtn.mas_bottom).offset(10);
    }];
    self.followBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.avatarImgView.layer.masksToBounds = YES;
    self.avatarImgView.layer.cornerRadius = 20;
    self.followBtn.layer.masksToBounds = YES;
    self.followBtn.layer.cornerRadius = 2;
    self.zanBtn.layer.masksToBounds = YES;
    self.zanBtn.layer.cornerRadius = 12.5;
    self.zanBtn.layer.borderWidth = 1;
    self.zanBtn.layer.borderColor  = RGB(237, 237, 239).CGColor;
//    self.downBtn.layer.masksToBounds = YES;
//    self.downBtn.layer.cornerRadius = 12.5;
//    self.downBtn.layer.borderWidth = 1;
//    self.downBtn.layer.borderColor  = RGB(237, 237, 239).CGColor;
    [self.avatarBtn addTarget:self action:@selector(avatarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.followBtn addTarget:self action:@selector(followBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)avatarBtnClick{
    if (self.lookAuthorHomeBlock) {
        self.lookAuthorHomeBlock();
    }
}
-(void)followBtnClick{
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
    } failure:^(NSError *error) {
        
    }];
}

-(void)setIsAttention:(BOOL)isAttention{
    _isAttention = isAttention;
    if (isAttention) {
        self.followBtn.backgroundColor = [UIColor whiteColor];
        [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        self.followBtn.layer.borderWidth = 1;
        self.followBtn.layer.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
    }
    else{
        self.followBtn.backgroundColor = BasicColor;
        [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
        self.followBtn.layer.borderWidth = 0.1;
        self.followBtn.layer.backgroundColor = [UIColor clearColor].CGColor;
    }
    
}
-(void)setModel:(CXArticleDetailModel *)model{
    _model = model;
    self.titleLab.text = model.title;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.authorInfo.member_avatar] placeholderImage:nil];
    
    self.nicknameLabel.text = model.authorInfo.member_nick;
    self.timeLabel.text = model.add_time;
    [self.followBtn setBackgroundColor:BasicColor];
    [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.contenturl]]];
    [self.zanBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
    [self.zanBtn setTitle:model.num_up forState:UIControlStateNormal];
    [self.zanBtn setTitleColor:UIColorFromRGB(0x797979) forState:UIControlStateNormal];
    
    [self.downBtn setImage:[UIImage imageNamed:@"tread"] forState:UIControlStateNormal];
    [self.downBtn setTitle:model.num_down forState:UIControlStateNormal];
    [self.downBtn setTitleColor:UIColorFromRGB(0x797979) forState:UIControlStateNormal];

    self.readCountLabel.text = [model.num_look stringByAppendingString:@"阅读"];
}



-(void)webViewDidFinishLoad:(UIWebView *)webView{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.timeLabel).offset(16);
        make.height.equalTo(@(actualSize.height));
    }];
    if (actualSize.height > 10) {
        if (self.setViewHeightBlock) {
            self.setViewHeightBlock(actualSize.height);
        }
    }
    
}




-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont boldSystemFontOfSize:18];
        _titleLab.textColor = UIColorFromRGB(0x2d2d2d);
        _titleLab.numberOfLines = 0;
    }
    return _titleLab;
}
-(UIImageView *)avatarImgView{
    if (!_avatarImgView) {
        _avatarImgView = [[UIImageView alloc] init];
    }
    return _avatarImgView;
}

-(UIButton *)avatarBtn{
    if (!_avatarBtn) {
        _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _avatarBtn;
    
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = UIColorFromRGB(0x797979);
        
    }
    return _timeLabel;
}
-(UILabel *)nicknameLabel{
    if (!_nicknameLabel) {
        _nicknameLabel = [UILabel new];
        _nicknameLabel.font = [UIFont systemFontOfSize:14];
        _nicknameLabel.textColor = UIColorFromRGB(0x2d2d2d);
    }
    return _nicknameLabel;
}


-(UIButton *)followBtn{
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return _followBtn;
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        [_webView sizeThatFits:CGSizeZero];
    }
    return _webView;

}

-(UIButton *)zanBtn{
    if (!_zanBtn) {
        _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return _zanBtn;

}
-(UIButton *)downBtn{
    if (!_downBtn) {
        _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _downBtn;
}

-(UILabel *)readCountLabel{
    if (!_readCountLabel) {
        _readCountLabel = [UILabel new];
        _readCountLabel.font = [UIFont systemFontOfSize:12];
        _readCountLabel.textColor  =UIColorFromRGB(0x797979);
    }
    return _readCountLabel;
}

@end
