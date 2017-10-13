//
//  CXShareTableViewCell.m
//  rrcx
//
//  Created by 123 on 2017/9/1.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXShareTableViewCell.h"
@interface CXShareTableViewCell()<CAAnimationDelegate>
@property(nonatomic,strong) UIImageView *avatarImgView;
//@property(nonatomic,strong) UIButton *nameShowBtn;
//@property(nonatomic,strong) UILabel *subShowLable;
@property(nonatomic,strong) YYLabel *titleLabel;
//@property(nonatomic,strong) UILabel *readcountLable;
@property(nonatomic,strong) UIView  *fengLineView;
@property(nonatomic,strong) YHButton *watchBtn;
@property(nonatomic,strong) YHButton *zangBtn;
@property(nonatomic,strong) YHButton *commentBtn;
//@property(nonatomic,strong) UIView   *sectionFengView;
@property(nonatomic,strong) UIView   *imgView;
@property(nonatomic,strong) UIImageView *zangPlusImg;
@property(nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UIView * bottomSeparatorView;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UIButton * avatarBtn;
@property (nonatomic,strong) UILabel * lengthLabel;

@end
@implementation CXShareTableViewCell

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

-(void)setModelDataWith:(CXArticle*)model
{
    self.titleLabel.text = model.title;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.member_avatar] placeholderImage:[UIImage imageNamed:@"placeholder_avatar"]];
    self.nameLabel.text = model.member_nick;
    [self.watchBtn setTitle:model.num_look forState:UIControlStateNormal];
    self.timeLabel.text = model.add_time;
    [self removeOldView];

    if ([model.type integerValue] == 2) {
        //视频
        if (!([model.video_detail[@"isExists"] integerValue] == 0)) {
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
        else{
            self.lengthLabel.hidden = YES;
        }
       
    }
    else if ([model.type integerValue] == 1){
        
        if (model.cover_images.count) {
            [self createImgCell:model.cover_images];

        }
        _lengthLabel.hidden = NO;
        self.lengthLabel.text = [NSString stringWithFormat:@" %@ 图 ",model.num_images];
    }
    else{
        _lengthLabel.hidden = YES;
        if (model.cover_images.count) {
            [self createImgCell:model.cover_images];
            
        }

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
                make.size.mas_equalTo(CGSizeMake((KWidth-35), (KWidth-35)/71*40));
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
        self.lengthLabel.hidden = YES;
    }
    
    
}

-(void)imgViewClick:(UITapGestureRecognizer*)tapGesture
{
//    NSMutableArray *imgLists=[NSMutableArray new];
//    for (Large_Image_List *lModel in _model.large_image_list) {
//        [imgLists addObject:lModel.url];
//    }
//    
//    
//    
//    NSInteger tag=tapGesture.view.tag;
//    if([self.delegate respondsToSelector:@selector(clickImgShow:imgS:)]){
//        [self.delegate clickImgShow:tag-1000 imgS:imgLists];
//    }
    
}





+(NSString*)shortShow:(NSNumber*)count
{
    long result;
    long num=[count longValue];
    if(num>=10000){
        result=num/10000;
        return [NSString stringWithFormat:@"%ld万",result];
    }else{
        result=num;
        return  [NSString stringWithFormat:@"%ld",result];
    }
}

-(void)initSubView{
    [self.contentView addSubview:self.avatarImgView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.fengLineView];
//    [self.contentView addSubview:self.zangBtn];
//    [self.contentView addSubview:self.commentBtn];
//    [self.contentView addSubview:self.sectionFengView];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.optionBtn];

    [self.contentView addSubview:self.watchBtn];
    [self.contentView addSubview:self.bottomSeparatorView];
    [self.contentView addSubview:self.avatarBtn];
    [self.contentView addSubview:self.lengthLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.optionBtn.mas_left).offset(-10);
        make.top.equalTo(self.contentView).offset(10);
    }];
    [_optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@1);
        
    }];
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10).priorityHigh();
        make.size.mas_equalTo(CGSizeMake(36, 36)).priorityHigh();
        make.top.equalTo(self.imgView.mas_bottom).offset(5);

        
    }];
    _avatarImgView.layer.masksToBounds = YES;
    _avatarImgView.layer.cornerRadius = 18;
    
    [self.avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView);
        make.top.equalTo(self.avatarImgView);
        make.size.equalTo(self.avatarImgView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgView.mas_right).offset(8);
        make.centerY.equalTo(self.avatarImgView.mas_centerY);
    }];
    
    
    
    [self.watchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 36));
        make.right.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.avatarImgView.mas_centerY);
        
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.watchBtn.mas_left).offset(-20);
        make.centerY.equalTo(self.avatarImgView.mas_centerY);
    }];
    [self.lengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imgView).offset(-28);
        make.bottom.equalTo(self.imgView).offset(-8);
        make.height.greaterThanOrEqualTo(@28);
    }];
//    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo(self.zangBtn);
//        make.right.equalTo(self.zangBtn.mas_left);
//        make.top.equalTo(self.zangBtn);
//        
//    }];
//    [self.watchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo(self.zangBtn);
//        make.right.equalTo(self.commentBtn.mas_left);
//        make.top.equalTo(self.zangBtn);
//        
//    }];
    [_bottomSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.avatarImgView.mas_bottom).offset(2);
        make.height.equalTo(@5);
        make.bottom.equalTo(self.contentView).priorityHigh();
    }];
    [self.optionBtn addTarget:self action:@selector(optionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.avatarBtn addTarget:self action:@selector(avatarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.lengthLabel.layer.masksToBounds = YES;
    self.lengthLabel.layer.cornerRadius = 4;

}

-(void)optionBtnClick{
    if (self.optionBtnClickBlock) {
        self.optionBtnClickBlock();
    }
}






-(void)avatarBtnClick{
    if (self.avatarClickBlock) {
        self.avatarClickBlock();
    }
}
-(void)setIsSelf:(BOOL)isSelf{
    _isSelf = isSelf;
    self.optionBtn.hidden = !isSelf;
}

-(void)zangPlayAnimation{
    
    [_zangBtn setImage:[UIImage imageNamed:@"comment_like_icon_press"] forState:UIControlStateNormal];
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
            self.zangBtn.transform = CGAffineTransformMakeScale(1.3f, 1.3f); // 放大
        }];
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
            self.zangBtn.transform = CGAffineTransformMakeScale(0.8f, 0.8f); // 放小
        }];
        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
            self.zangBtn.transform = CGAffineTransformMakeScale(1.0f, 1.0f); //恢复原样
        }];
    } completion:nil];
    
    
    self.zangPlusImg.alpha=1;
    self.zangPlusImg.frame=CGRectMake(66, 0, 15, 15);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = 1.5;
    animation.rotationMode = kCAAnimationRotateAuto;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(66, 8)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(66, -6)];
    animation.delegate = self;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.values=@[value1,value2];
    [self.zangPlusImg.layer addAnimation:animation forKey:nil];
    
    
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    
    self.zangPlusImg.alpha=0;
    
}
-(UIImageView *)avatarImgView{
    if(!_avatarImgView){
        _avatarImgView=[UIImageView new];
        _avatarImgView.tag=1111;
        _avatarImgView.layer.cornerRadius=36/2;
        _avatarImgView.layer.masksToBounds=YES;
        _avatarImgView.layer.borderWidth=0.5;
        _avatarImgView.layer.borderColor=[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1].CGColor;
        
    }
    return _avatarImgView;
}

//-(UIButton *)nameShowBtn{
//    if(!_nameShowBtn){
//        _nameShowBtn=[UIButton new];
//        [_nameShowBtn setTitle:@"测试" forState:UIControlStateNormal];
//        _nameShowBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
//        [_nameShowBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _nameShowBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        
//        
//        
//    }
//    return _nameShowBtn;
//}
//-(UILabel *)subShowLable{
//    if(!_subShowLable){
//        _subShowLable=[UILabel new];
//        _subShowLable.text=@"xx小时前 . 主持人";
//        _subShowLable.font=[UIFont systemFontOfSize:12];
//        _subShowLable.textColor=[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1];
//        
//    }
//    return _subShowLable;
//}


-(YYLabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel=[YYLabel new];
        _titleLabel.numberOfLines=0;
        _titleLabel.font=[UIFont systemFontOfSize:16];
        _titleLabel.textColor=UIColorFromRGB(0x333333);
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.preferredMaxLayoutWidth = KWidth-30;
        
    }
    return _titleLabel;
    
}
//-(UILabel *)readcountLable{
//    if(!_readcountLable){
//        _readcountLable=[UILabel new];
//        _readcountLable.font=[UIFont systemFontOfSize:12];
//        _readcountLable.textColor=[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1];
//    }
//    return _readcountLable;
//    
//}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor=[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1];
    }
    return _nameLabel;
}

-(UIView  *)fengLineView{
    if(!_fengLineView){
        _fengLineView=[UIView new];
        _fengLineView.backgroundColor=[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
        
    }
    return _fengLineView;
    
}
-(YHButton *)watchBtn{
    if(!_watchBtn){
        _watchBtn=[YHButton new];
        [_watchBtn setImage:[UIImage imageNamed:@"eyes"] forState:UIControlStateNormal];
        [_watchBtn setTitle:@"1.8万" forState:UIControlStateNormal];
        [_watchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _watchBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        _watchBtn.imageRect=CGRectMake(100/2-35, 6, 24, 24);
        _watchBtn.titleRect=CGRectMake(100/2-10, 9, 60, 16);
//        [_watchBtn addTarget:self action:@selector(zangAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _watchBtn;
    
}
-(YHButton *)commentBtn{
    if(!_commentBtn){
        _commentBtn=[YHButton new];
        [_commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_commentBtn setTitle:@"100" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _commentBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        _commentBtn.imageRect=CGRectMake(100/2-35, 6, 24, 24);
        _commentBtn.titleRect=CGRectMake(100/2-10, 9, 60, 16);
    }
    return _commentBtn;
}
-(YHButton*)zangBtn{
    if(!_zangBtn){
        _zangBtn=[YHButton new];
        [_zangBtn setImage:[UIImage imageNamed:@"fabulous"] forState:UIControlStateNormal];
        [_zangBtn setTitle:@"101" forState:UIControlStateNormal];
        [_zangBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _zangBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        _zangBtn.imageRect=CGRectMake(100/2-35, 6, 24, 24);
        _zangBtn.titleRect=CGRectMake(100/2-10, 9, 60, 16);
    }
    return _zangBtn;
}
//-(UIView *)sectionFengView{
//    if(!_sectionFengView){
//        _sectionFengView=[UIView new];
//        _sectionFengView.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
//        
//    }
//    return _sectionFengView;
//}

-(UIView  *)imgView
{
    if(!_imgView){
        _imgView=[UIView new];
        _imgView.backgroundColor=[UIColor clearColor];
    }
    return _imgView;
}
-(UIImageView *)zangPlusImg{
    if(!_zangPlusImg){
        _zangPlusImg=[UIImageView new];
        _zangPlusImg.image=[UIImage imageNamed:@"add_all_dynamic"];
        _zangPlusImg.alpha=0;
    }
    return _zangPlusImg;
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
    }
    return _timeLabel;
}
-(UIButton *)avatarBtn{
    if (!_avatarBtn) {
        _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _avatarBtn;
}
-(UIButton *)optionBtn{
    if (!_optionBtn) {
        _optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_optionBtn setImage:[UIImage imageNamed:@"option"] forState:UIControlStateNormal];
    }
    return _optionBtn;
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
