//
//  CXCommentTableViewCell.m
//  rrcx
//
//  Created by 123 on 2017/9/21.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXCommentTableViewCell.h"
@interface CXCommentTableViewCell()
@property (nonatomic,strong) UIImageView * avatarImgView;
@property (nonatomic,strong) UILabel * nicknamelabel;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UIButton * commentBtn;
@property (nonatomic,strong) UILabel * detailLab;
@property (nonatomic,strong) UIButton * avatarBtn;




@end

@implementation CXCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)initSubview{
    [self.contentView addSubview:self.avatarImgView];
    [self.contentView addSubview:self.nicknamelabel];
    [self.contentView addSubview:self.detailLab];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.commentBtn];
    [self.contentView addSubview:self.zanBtn];
    [self.contentView addSubview:self.avatarBtn];
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView);
        make.top.equalTo(self.avatarImgView);
        make.size.mas_equalTo(self.avatarImgView);
    }];
    [self.nicknamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView.mas_right).offset(8);
        make.top.equalTo(self.avatarImgView);
        
    }];
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nicknamelabel);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.nicknamelabel.mas_bottom).offset(10);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nicknamelabel);
        make.top.equalTo(self.detailLab.mas_bottom).offset(8).priorityLow();
        make.bottom.equalTo(self.contentView).offset(-10).priorityHigh();
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right);
        make.centerY.equalTo(self.timeLabel);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    [self.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.nicknamelabel);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        
    }];
    
    self.avatarImgView.layer.masksToBounds = YES;
    self.avatarImgView.layer.cornerRadius = 20;
    [self.avatarBtn addTarget:self action:@selector(avatarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.zanBtn addTarget:self action:@selector(zanComment) forControlEvents:UIControlEventTouchUpInside];
    [self.commentBtn addTarget:self action:@selector(replayComment) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)avatarBtnClick{
    if (self.avatarBtnClickBlock) {
        self.avatarBtnClickBlock();
    }
}
-(void)zanComment{
    if (self.zanCommentBlock) {
        self.zanCommentBlock();
    }

}
-(void)replayComment{
    if (self.replyCommentClickBlock) {
        self.replyCommentClickBlock();
    }
}

-(void)setCommentModel:(CXComment *)commentModel{
    _commentModel = commentModel;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:commentModel.member_avatar] placeholderImage:[UIImage imageNamed:@"placeholder_avatar"]];
    self.nicknamelabel.text = commentModel.member_nick;
    self.detailLab.text = commentModel.con;
    [self.zanBtn setTitle:commentModel.num_up forState:UIControlStateNormal];
    [self.timeLabel setText:[NSString stringWithFormat:@"%@ .",commentModel.add_time]];
    if ([commentModel.num_comment integerValue]>0) {
        [self.commentBtn setTitle:[NSString stringWithFormat:@"%@回复",commentModel.num_comment] forState:UIControlStateNormal];
        [self.commentBtn setBackgroundColor:RGB(245, 245, 245)];
    }
    else{
        [self.commentBtn setBackgroundColor:[UIColor clearColor]];
        [self.commentBtn setTitle:@"回复" forState:UIControlStateNormal];
    }
    [self setIsLike:[commentModel.islike isEqualToString:@"1"]];
    
}

-(void)setIsLike:(BOOL)isLike{
    _isLike = isLike;
    if (isLike) {
        [_zanBtn setImage:[UIImage imageNamed:@"praise-a"] forState:UIControlStateNormal];
        [_zanBtn setTitleColor:BasicColor forState:UIControlStateNormal];
    }
    else{
        [_zanBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
        [_zanBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}
-(void)setNum_up:(NSInteger)num_up{
    _num_up = num_up;
    [_zanBtn setTitle:[NSString stringWithFormat:@"%ld",num_up>=0?num_up:0] forState:UIControlStateNormal];
    
}

-(UIImageView *)avatarImgView{
    if (!_avatarImgView) {
        _avatarImgView = [[UIImageView alloc] init];
        
    }
    return _avatarImgView;
}
-(UILabel *)nicknamelabel{
    if (!_nicknamelabel) {
        _nicknamelabel = [UILabel new];
        _nicknamelabel.font = [UIFont systemFontOfSize:14];
        _nicknamelabel.textColor = RGB(0, 56, 125);
        
    }
    return _nicknamelabel;

}

-(UILabel *)detailLab{
    if (!_detailLab) {
        _detailLab = [UILabel new];
        _detailLab.textColor = RGB(28, 28, 29);
        _detailLab.font = [UIFont systemFontOfSize:14];
        _detailLab.numberOfLines = 0;
    }
    return _detailLab;
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = RGB(112, 112, 112);
    }
    return _timeLabel;
}
-(UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setTitle:@"回复" forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_commentBtn setTitleColor:RGB(112, 112, 112) forState:UIControlStateNormal];
    }
    return _commentBtn;
}

-(UIButton *)zanBtn{
    if (!_zanBtn) {
        _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zanBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
        _zanBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_zanBtn setTitleColor:RGB(112, 112, 112) forState:UIControlStateNormal];
    }
    return _zanBtn;
}


-(UIButton *)avatarBtn{
    if (!_avatarBtn) {
        _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return _avatarBtn;
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
