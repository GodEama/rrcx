//
//  CXMyCommentTableViewCell.m
//  rrcx
//
//  Created by 123 on 2017/9/28.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXMyCommentTableViewCell.h"
@interface CXMyCommentTableViewCell()
@property (nonatomic,strong) UIImageView * avatarImgView;
@property (nonatomic,strong) UILabel * nicknameLabel;
@property (nonatomic,strong) UIButton   * zanBtn;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UILabel * contentLab;
@property (nonatomic,strong) UIView * sourceView;
//@property (nonatomic,strong) UIImageView * hintImgView;
@property (nonatomic,strong) UILabel  * sourceTitleLab;



@end
@implementation CXMyCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setModel:(CXMyComment *)model{
    _model = model;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:User_avatar?:@""] placeholderImage:[UIImage imageNamed:@"头像"]];
    DLog(@">>>>>>>>>>%@",User_nick);
    self.nicknameLabel.text = [NSString stringWithFormat:@"%@",User_nick];
    self.timeLabel.text = model.add_time;
    self.contentLab.text = model.con;
    self.sourceTitleLab.text = model.source;
    [self.zanBtn setTitle:[model.num_up integerValue]>0?model.num_up:@"赞" forState:UIControlStateNormal];
    [self.zanBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}


-(void)initSubView{
    [self.contentView addSubview:self.avatarImgView];
    [self.contentView addSubview:self.nicknameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.contentLab];
    [self.contentView addSubview:self.zanBtn];
    [self.contentView addSubview:self.sourceView];
    [self.contentView addSubview:self.deleteBtn];
    [self.sourceView addSubview:self.sourceTitleLab];
//    [self.sourceView addSubview:self.hintImgView];
    
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.top.equalTo(self.contentView).offset(12);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.avatarImgView);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView.mas_right).offset(8);
        make.top.equalTo(self.avatarImgView);
        make.right.lessThanOrEqualTo(self.zanBtn.mas_left);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView.mas_right).offset(8);
        make.bottom.equalTo(self.avatarImgView.mas_bottom);
        make.right.lessThanOrEqualTo(self.zanBtn.mas_left);

    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView.mas_right).offset(8);
        make.right.equalTo(self.contentView).offset(-12);
        make.top.equalTo(self.avatarImgView.mas_bottom).offset(12);
    }];
    [self.sourceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView.mas_right).offset(8);
        make.right.equalTo(self.contentView).offset(-12);
        make.top.equalTo(self.contentLab.mas_bottom).offset(8);
        make.height.equalTo(@25);
    }];
    
//    [self.hintImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.sourceView).offset(-8);
//        make.centerY.equalTo(self.sourceView);
//        make.size.mas_equalTo(CGSizeMake(16, 16));
//    }];
    
    [self.sourceTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sourceView).offset(8);
        make.right.equalTo(self.sourceView).offset(-8);
        make.centerY.equalTo(self.sourceView);
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView.mas_right).offset(8);
        make.top.equalTo(self.sourceView.mas_bottom).offset(10).priorityLow();
        make.size.mas_equalTo(CGSizeMake(40, 18));
        make.bottom.equalTo(self.contentView).offset(-12);
    }];
    
    _avatarImgView.layer.masksToBounds = YES;
    _avatarImgView.layer.cornerRadius = 20;
    
    _sourceView.layer.masksToBounds = YES;
    _sourceView.layer.cornerRadius = 12.5;
    _sourceView.layer.borderWidth = 1;
    _sourceView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    self.deleteBtn.layer.masksToBounds = YES;
    self.deleteBtn.layer.cornerRadius = 9;
    self.deleteBtn.layer.borderWidth = 1;
    self.deleteBtn.layer.borderColor = BasicColor.CGColor;
    

}
-(UIImageView *)avatarImgView{
    if (!_avatarImgView) {
        _avatarImgView = [[UIImageView alloc] init];
    }
    return _avatarImgView;
}
-(UILabel *)nicknameLabel{
    if (!_nicknameLabel) {
        _nicknameLabel = [UILabel new];
        _nicknameLabel.font = [UIFont systemFontOfSize:16];
        _nicknameLabel.textColor = UIColorFromRGB(0x5a7cab);
        
    }
    return _nicknameLabel;
    
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = UIColorFromRGB(0x868686);
        
    }
    return _timeLabel;
}
-(UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.textColor= UIColorFromRGB(0x222222);
        _contentLab.font = [UIFont systemFontOfSize:14];
    }
    return _contentLab;
}
-(UIView *)sourceView{
    if (!_sourceView) {
        _sourceView = [UIView new];
        
    }
    return _sourceView;
}

-(UILabel *)sourceTitleLab{
    if (!_sourceTitleLab) {
        _sourceTitleLab = [UILabel new];
        _sourceTitleLab.font = [UIFont systemFontOfSize:12];
        _sourceTitleLab.textColor = UIColorFromRGB(0x5e5e5e);
    }
    return _sourceTitleLab;
}
//-(UIImageView *)hintImgView{
//    if (!_hintImgView) {
//        _hintImgView = [[UIImageView alloc] init];
//        _hintImgView.image = [UIImage imageNamed:@"arrow"];
//
//    }
//    return _hintImgView;
//}
-(UIButton *)zanBtn{
    if (!_zanBtn) {
        _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zanBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
        
    }
    return _zanBtn;
}
-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:BasicColor forState:UIControlStateNormal];
        [_deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    }
    return _deleteBtn;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
