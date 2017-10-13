//
//  CXMyCollectTableViewCell.m
//  rrcx
//
//  Created by 123 on 2017/9/27.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXMyCollectTableViewCell.h"
@interface CXMyCollectTableViewCell ()
@property(nonatomic,strong) YYLabel *titleLabel;
@property(nonatomic,strong) UIView  *fengLineView;
@property (nonatomic,strong) UIView * imgView;
@property (nonatomic,strong) UIView * bottomSeparatorView;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UIView * videoView;
@property (nonatomic,strong) UIImageView * videoImgView;
@property (nonatomic,strong) UILabel * videoTimeLabel;
@property (nonatomic,strong) UILabel * imageCountLabel;
@property (nonatomic,strong) UILabel * lengthLabel;

@end
@implementation CXMyCollectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)setModel:(CXArticle *)model{
    _model = model;
    self.titleLabel.text = model.title;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@   %@评论    %@",model.member_nick,model.num_comment,model.add_time];
    if ([model.type integerValue] == 2) {
        //视频
        NSString * coverImgUrl = model.video_detail[@"CoverURL"];
        [self createImgCell:@[coverImgUrl]];
        _lengthLabel.hidden = NO;
        
        NSInteger duration = [model.video_detail[@"Duration"] integerValue];
        NSInteger hour = duration/3600;
        NSInteger minute = (duration%3600)/60;
        NSInteger second = (duration%3600)%60;
        if (hour >0) {
            self.lengthLabel.text = [NSString stringWithFormat:@" %02ld:%02ld:%02ld ",hour,minute,second];
        }
        else{
            self.lengthLabel.text = [NSString stringWithFormat:@" %02ld:%02ld ",minute,second];
        }
    }
    else if ([model.type integerValue] == 1){
        [self createImgCell:model.cover_images];
        _lengthLabel.hidden = NO;
        self.lengthLabel.text = [NSString stringWithFormat:@" %@ 图 ",model.num_images];
    }
    else{
        _lengthLabel.hidden = YES;
        [self createImgCell:model.cover_images];
        
    }
    
}
-(void)removeOldView{
    for (UIView *view in [self.imgView subviews]) {
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
        imgcell.tag=1000+i;
        imgcell.userInteractionEnabled=YES;
//        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewClick:)];
//        [imgcell addGestureRecognizer:tapGesture];
        //        [imgcell sd_setImageWithURL:[NSURL URLWithString:model]];
        imgcell.contentMode = UIViewContentModeScaleAspectFill;
        imgcell.clipsToBounds = YES;
        
        [self.imgView addSubview:imgcell];
        if(imgArrs.count==1)
        {
            [imgcell sd_setImageWithURL:[NSURL URLWithString:model] placeholderImage:[UIImage imageNamed:@"placeholder_articleCover"]];

            [imgcell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake((KWidth-35), (KWidth-35)/71*32));
                NSInteger width= i==1? (KWidth-35)/2+space:0;
                make.left.equalTo(self.contentView).offset(15+width);
                make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            }];
        }
        else if (imgArrs.count == 2)
        {
            [imgcell sd_setImageWithURL:[NSURL URLWithString:model] placeholderImage:[UIImage imageNamed:@"placeholder_blog"]];

            [imgcell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake((KWidth-35)/2, (KWidth-35)/2));
                NSInteger width= i==1? (KWidth-35)/2+space:0;
                make.left.equalTo(self.contentView).offset(15+width);
                make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            }];
        }
        else{
            [imgcell sd_setImageWithURL:[NSURL URLWithString:model] placeholderImage:[UIImage imageNamed:@"placeholder_blog"]];

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
                make.top.equalTo(self.titleLabel.mas_bottom).offset(8+(line*(imgWidth+space)));
            }];
        }
        lastCell=imgcell;
    }
    if(lastCell)
    {

        
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(lastCell.mas_bottom);
        }];
      
        
    }else{
        
      
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@1);
            
        }];
       
    }
    
    
}

-(void)initSubViews{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.bottomSeparatorView];
//    [self.contentView addSubview:self.videoView];
//    [self.videoView addSubview:self.videoImgView];
//    [self.contentView addSubview:self.videoTimeLabel];
    [self.contentView addSubview:self.lengthLabel];

    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(12);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10).priorityHigh();
        make.top.equalTo(self.imgView.mas_bottom).offset(8);
        
        
    }];
    [_bottomSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(8);
        make.height.equalTo(@10);
        make.bottom.equalTo(self.contentView).priorityHigh();
    }];
    [self.lengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imgView).offset(-28);
        make.bottom.equalTo(self.imgView).offset(-8);
        make.height.greaterThanOrEqualTo(@28);
    }];
    self.lengthLabel.layer.masksToBounds = YES;
    self.lengthLabel.layer.cornerRadius = 4;
    
}

-(YYLabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel=[YYLabel new];
        _titleLabel.numberOfLines=0;
        _titleLabel.font=[UIFont systemFontOfSize:15];
        _titleLabel.textColor=[UIColor blackColor];
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.preferredMaxLayoutWidth = KWidth-30;
        
    }
    return _titleLabel;
    
}



-(UIView  *)fengLineView{
    if(!_fengLineView){
        _fengLineView=[UIView new];
        _fengLineView.backgroundColor=[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
        
    }
    return _fengLineView;
    
}



-(UIView  *)imgView
{
    if(!_imgView){
        _imgView=[UIView new];
        _imgView.backgroundColor=[UIColor clearColor];
    }
    return _imgView;
}


-(UIView *)bottomSeparatorView{
    if (!_bottomSeparatorView) {
        _bottomSeparatorView = [UIView new];
        _bottomSeparatorView.backgroundColor = RGB(237, 238, 239);
    }
    return _bottomSeparatorView;
}
-(UILabel *)timeLabel{
    
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = RGB(144, 144, 144);
    }
    return _timeLabel;
}

-(UIView *)videoView{
    if (!_videoView) {
        _videoView = [[UIView alloc] init];
    }
    return _videoView;
}
-(UIImageView *)videoImgView{
    if (!_videoImgView) {
        _videoImgView = [[UIImageView alloc] init];
    }
    return _videoImgView;
}
-(UILabel *)videoTimeLabel{
    if (!_videoTimeLabel) {
        _videoTimeLabel = [UILabel new];
        _videoTimeLabel.backgroundColor = RGBA(0, 0, 0, 0.7);
        _videoTimeLabel.textColor = [UIColor whiteColor];
        _videoTimeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _videoTimeLabel;
}

-(UILabel *)imageCountLabel{
    if (!_imageCountLabel) {
        _imageCountLabel = [UILabel new];
        _imageCountLabel.backgroundColor = RGBA(0, 0, 0, 0.7);
        _imageCountLabel.textColor = [UIColor whiteColor];
        _imageCountLabel.font = [UIFont systemFontOfSize:12];
    }
    return _imageCountLabel;
}
-(UILabel *)lengthLabel{
    if (!_lengthLabel) {
        _lengthLabel = [UILabel new];
        _lengthLabel.backgroundColor = RGBA(0, 0, 0, 0.7f);
        _lengthLabel.textColor = [UIColor whiteColor];
        _lengthLabel.font = [UIFont systemFontOfSize:14];
        _lengthLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _lengthLabel;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
