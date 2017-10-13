//
//  CXBlogDetailHeaderTableViewCell.m
//  rrcx
//
//  Created by 123 on 2017/9/21.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXBlogDetailHeaderTableViewCell.h"
#import "SDPhotoBrowser.h"
@interface CXBlogDetailHeaderTableViewCell()<SDPhotoBrowserDelegate>
@property (nonatomic,strong) UIImageView * avatarImgView;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UILabel * contenLabel;
@property (nonatomic,strong) UIView  * conView;
@property (nonatomic,strong) UIButton * followBtn;
@property (nonatomic,strong) UIButton * avatarBtn;
@property (nonatomic,strong) UILabel * readCountLabel;

@end
@implementation CXBlogDetailHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
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
        [imgcell sd_setImageWithURL:[NSURL URLWithString:model] placeholderImage:[UIImage imageNamed:@"placeholder_blog"]];
        [self.conView addSubview:imgcell];
        if(imgArrs.count==1)
        {
            [imgcell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake((KWidth-35), (KWidth-35)/71*32));
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
        [self.conView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contenLabel.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(lastCell.mas_bottom);
        }];
 
        
    }else{
        
        [self.conView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contenLabel.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@1);
            
        }];
       
    }
}

-(void)setModel:(CXBlogDetailModel *)model{
    _model = model;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.authorInfo.member_avatar] placeholderImage:[UIImage imageNamed:@"placeholder_avatar"]];
    self.contenLabel.text = model.microblog_content;
    [self.nameLabel setText:model.authorInfo.member_nick];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.add_time];
    self.readCountLabel.text = [NSString stringWithFormat:@"%@ 阅读",model.num_look];
    [self setIsAttention:[model.ishits isEqualToString:@"1"]];

    [self createImgCell:model.images];
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
    [self.contentView addSubview:self.conView];
    [self.contentView addSubview:self.followBtn];
    [self.contentView addSubview:self.avatarBtn];
    [self.contentView addSubview:self.readCountLabel];
    
    [_avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    _avatarImgView.layer.masksToBounds = YES;
    _avatarImgView.layer.cornerRadius = 20;
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
    
    [_contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView.mas_left);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.avatarImgView.mas_bottom).offset(10);
    }];
    
    [_conView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView.mas_left);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contenLabel.mas_bottom).offset(10);
        make.height.equalTo(@(1));
    }];
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.avatarImgView);
        make.size.mas_equalTo(CGSizeMake(60, 25));
        
    }];
    [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView);
        make.top.equalTo(self.conView.mas_bottom).offset(10).priorityLow();
        make.bottom.equalTo(self.contentView).offset(-10).priorityHigh();
    }];
    
    
    self.followBtn.layer.masksToBounds = YES;
    self.followBtn.layer.cornerRadius = 2;
    
    
    [self.avatarBtn addTarget:self action:@selector(avatarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
    
    [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.followBtn.layer.borderWidth = 0.1;
    self.followBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [self.followBtn addTarget:self action:@selector(followBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
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




-(UIButton *)avatarBtn{
    if (!_avatarBtn) {
        _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _avatarBtn;
}
-(UIButton *)followBtn{
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _followBtn.backgroundColor = BasicColor;
        
    }
    return _followBtn;
}

-(UILabel *)readCountLabel{
    if (!_readCountLabel) {
        _readCountLabel = [UILabel new];
        _readCountLabel.font = [UIFont systemFontOfSize:12];
        _readCountLabel.textColor = UIColorFromRGB(0x797979);
    }
    return _readCountLabel;
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
