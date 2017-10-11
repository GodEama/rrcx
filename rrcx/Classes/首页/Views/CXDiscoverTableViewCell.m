//
//  CXDiscoverTableViewCell.m
//  rrcx
//
//  Created by 123 on 2017/9/1.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXDiscoverTableViewCell.h"
#import "SDPhotoBrowser.h"
@interface CXDiscoverTableViewCell()<SDPhotoBrowserDelegate>
@property (nonatomic,strong) UIImageView * avatarImgView;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UILabel * contenLabel;
@property (nonatomic,strong) UIView  * conView;
@property (nonatomic,strong) UIView  * lineView;
@property (nonatomic,strong) YHButton* watchBtn;
@property (nonatomic,strong) YHButton* commentBtn;
@property (nonatomic,strong) UIButton* downBtn;
@property (nonatomic,strong) UIView * bottomSeparatorView;
@property (nonatomic,strong) UIButton * avatarBtn;

@end
@implementation CXDiscoverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self initSubView];
    }
    return self;
}
-(void)setModel:(CXFind *)model{
    _model = model;
    [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.member_avatar] placeholderImage:[UIImage imageNamed:@"avatar"]];
    _nameLabel.text = model.member_nick;
    _timeLabel.text = model.add_time;
    _contenLabel.text = model.microblog_content;
    [self.watchBtn setTitle:[NSString stringWithFormat:@"%ld",model.num_look] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld",model.num_comment] forState:UIControlStateNormal];
    [self.zanBtn setTitle:[NSString stringWithFormat:@"%ld",model.num_up] forState:UIControlStateNormal];
    [self.zanBtn setImage:[UIImage imageNamed:[model.islike integerValue] == 0?@"fabulous":@"zan"] forState:UIControlStateNormal];
    if (model.images.count) {
        [self createImgCell:model.images];

    }
}

-(void)removeOldView{
    for (UIView *view in [self.conView subviews]) {
        if([view isKindOfClass:[UIImageView class]])
        {
            if(view.tag!=1111)
                [ view removeFromSuperview];
        }
    }
}



// 动态创建image cell

-(void)createImgCell:(NSArray*)imgArrs{
    
    [self removeOldView];
    
    UIImageView *lastCell=nil;
    NSInteger space=5;//间距
    for (int i=0;i<imgArrs.count; i++) {
        
        NSString *model=imgArrs[i];
        UIImageView *imgcell=[UIImageView new];
        imgcell.contentMode = UIViewContentModeScaleAspectFill;
        imgcell.clipsToBounds = YES;

        imgcell.tag=1000+i;
        imgcell.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewClick:)];
        [imgcell addGestureRecognizer:tapGesture];
        //        [imgcell sd_setImageWithURL:[NSURL URLWithString:model]];
        [imgcell sd_setImageWithURL:[NSURL URLWithString:model] placeholderImage:nil];
        [self.conView addSubview:imgcell];
        if(imgArrs.count==1)
        {
            [imgcell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake((KWidth-35), (KWidth-35)/71*40));
                NSInteger width= i==1? (KWidth-35)/2+space:0;
                make.left.equalTo(self.contentView).offset(15+width);
                make.top.equalTo(self.contenLabel.mas_bottom).offset(8);
            }];
        }
        else if (imgArrs.count == 2)
        {
            [imgcell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake((KWidth-35)/2, (KWidth-35)/2));
                NSInteger width= i==1? (KWidth-35)/2+space:0;
                make.left.equalTo(self.contentView).offset(15+width);
                make.top.equalTo(self.contenLabel.mas_bottom).offset(8);
            }];
        }
        else{
            [imgcell mas_makeConstraints:^(MASConstraintMaker *make) {
                
                // 计算每个cell的上 左间距
                NSInteger imgWidth=(KWidth-35)/3;
                NSInteger xLeft= i<3? i:i%3;
                NSInteger line=0;
                if(i<3)
                    line=0;
                else if(i>=3&&i<6)
                    line=1;
                
                else if(i>=6&&i<9)
                    line=2;
                
                make.size.mas_equalTo(CGSizeMake(imgWidth, imgWidth));
                make.left.equalTo(self.contentView).offset(15+(xLeft*(imgWidth+space)));
                make.top.equalTo(self.contenLabel.mas_bottom).offset(8+(line*(imgWidth+space)));
            }];
        }
        lastCell=imgcell;
    }
    if(lastCell)
    {
        //        [self.readcountLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(self.avatarImgView);
        //            make.top.equalTo(lastCell.mas_bottom).offset(10);
        //
        //        }];
        
        [self.conView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contenLabel.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(lastCell.mas_bottom);
        }];
        //        [self.avatarImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(self.contentView).offset(10);
        //            make.size.mas_equalTo(CGSizeMake(36, 36));
        //            make.top.equalTo(self.imgView.mas_bottom).offset(5);
        //            make.bottom.equalTo(@(-10)).priorityHigh();
        //
        //        }];
        
    }else{
        
        
        //        [self.readcountLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(self.avatarImgView);
        //            make.top.equalTo(self.contentLable.mas_bottom).offset(10);
        //
        //        }];
        
        
        [self.conView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contenLabel.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@1);
            
        }];
        //        [self.avatarImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(self.contentView).offset(10);
        //            make.size.mas_equalTo(CGSizeMake(36, 36));
        //            make.top.equalTo(self.imgView).offset(5);
        //            make.bottom.equalTo(@(-10)).priorityHigh();
        //            
        //        }];
    }
    
    
}

-(void)imgViewClick:(UITapGestureRecognizer*)tapGesture
{
    UIView *imageView = tapGesture.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag - 1000;
    browser.sourceImagesContainerView = self.conView;
    browser.imageCount = self.model.images.count;
    browser.delegate = self;
    [browser show];

}

-(void)initSubView{
    [self.contentView addSubview:self.avatarImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.contenLabel];
    [self.contentView addSubview:self.downBtn];
    [self.contentView addSubview:self.conView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.watchBtn];
    [self.contentView addSubview:self.commentBtn];
    [self.contentView addSubview:self.zanBtn];
    [self.contentView addSubview:self.bottomSeparatorView];
    [self.contentView addSubview:self.avatarBtn];
    
    [_avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];
    _avatarImgView.layer.masksToBounds = YES;
    _avatarImgView.layer.cornerRadius = 17;
    [_avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView);
        make.top.equalTo(self.avatarImgView);
        make.size.mas_equalTo(self.avatarImgView);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView.mas_right).offset(10);
        make.top.equalTo (self.contentView).offset(12);
        
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
    }];
    [_downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.avatarImgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
   
    
    [_contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView.mas_left);
        make.right.equalTo(self.downBtn.mas_right);
        make.top.equalTo(self.avatarImgView.mas_bottom).offset(10);
    }];
    
    [_conView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView.mas_left);
        make.right.equalTo(self.downBtn.mas_right);
        make.top.equalTo(self.contenLabel.mas_bottom).offset(10);
        make.height.equalTo(@(1));
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.conView.mas_bottom).offset(10);
        make.left.equalTo(self.avatarImgView);
        make.right.equalTo(self.downBtn);
        make.height.equalTo(@1);
        
    }];
    
    [_watchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(2);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.contenLabel.bounds)/3, 30)).priorityHigh();
    }];
    
    
    [_zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.watchBtn);
        make.right.equalTo(self.contentView.mas_right).offset(-50);
        make.size.equalTo(self.watchBtn).priorityHigh();
        
    }];
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.watchBtn);
        make.centerX.equalTo(self.contentView);
        make.size.equalTo(self.watchBtn).priorityHigh();
        
    }];
    [_bottomSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.watchBtn.mas_bottom).offset(2);
        make.height.equalTo(@5);
        make.bottom.equalTo(self.contentView).priorityHigh();
    }];
    
    
    [self.avatarBtn addTarget:self action:@selector(avatarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.downBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    [self.zanBtn addTarget:self action:@selector(zanBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)avatarBtnClick{
    if (self.avatarBtn) {
        self.avatarClickBlock();
    }
}

-(void)moreAction{
    if (self.moreActionBlock) {
        self.moreActionBlock();
    }
}

-(void)zanBtnClick{
    if (self.zanBtnClickBlock) {
        self.zanBtnClickBlock();
    }
}

-(UIImageView *)avatarImgView{
    if (!_avatarImgView) {
        _avatarImgView = [[UIImageView alloc] init];
        
        
    }
    return _avatarImgView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = RGB(255, 141, 83);
        _nameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nameLabel;
}
-(UILabel *)timeLabel{

    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = RGB(185, 185, 185);
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}
-(UIButton *)downBtn{
    if (!_downBtn) {
        _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    }
    return _downBtn;
}
-(UILabel *)contenLabel{
    if (!_contenLabel) {
        _contenLabel = [UILabel new];
        _contenLabel.numberOfLines = 0;
        _contenLabel.font = [UIFont systemFontOfSize:14];
        _contenLabel.textColor = RGB(12, 12, 12);
    }
    
    return _contenLabel;
}

-(UIView *)conView{
    if (!_conView) {
        _conView = [UIView new];
        _conView.backgroundColor = [UIColor clearColor];
    }
    return _conView;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = RGB(242, 243, 244);
    }
    return _lineView;
}
-(YHButton *)watchBtn{
    if (!_watchBtn) {
        _watchBtn = [YHButton new];
        [_watchBtn setImage:[UIImage imageNamed:@"eyes"] forState:UIControlStateNormal];
        [_watchBtn setTitle:@"1.8万" forState:UIControlStateNormal];
        [_watchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _watchBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        _watchBtn.imageRect=CGRectMake(100/2-35, 6, 24, 24);
        _watchBtn.titleRect=CGRectMake(100/2-10, 9, 60, 16);
    }
    return _watchBtn;
}
-(YHButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [YHButton new];
        [_commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_commentBtn setTitle:@"1.8万" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _commentBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        _commentBtn.imageRect=CGRectMake(100/2-35, 6, 24, 24);
        _commentBtn.titleRect=CGRectMake(100/2-10, 9, 60, 16);
    }
    return _commentBtn;
}
-(YHButton *)zanBtn{
    if (!_zanBtn) {
        _zanBtn = [YHButton new];
        [_zanBtn setImage:[UIImage imageNamed:@"fabulous"] forState:UIControlStateNormal];
        [_zanBtn setTitle:@"1.8万" forState:UIControlStateNormal];
        [_zanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _zanBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        _zanBtn.imageRect=CGRectMake(100/2-35, 6, 24, 24);
        _zanBtn.titleRect=CGRectMake(100/2-10, 9, 60, 16);
    }
    return _zanBtn;
}
-(UIView *)bottomSeparatorView{
    if (!_bottomSeparatorView) {
        _bottomSeparatorView = [UIView new];
        _bottomSeparatorView.backgroundColor = RGB(237, 238, 239);
    }
    return _bottomSeparatorView;
}
-(UIButton *)avatarBtn{
    if (!_avatarBtn) {
        _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _avatarBtn;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}




#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{

    NSString *imageName = self.model.images[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.conView.subviews[index];
    return imageView.image;
}


@end
