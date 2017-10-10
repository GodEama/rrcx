//
//  YMArticleConCollectionViewCell.m
//  YunMuFocus
//
//  Created by apple on 2017/4/17.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import "YMArticleConCollectionViewCell.h"

@implementation YMArticleConCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    [_selectImg setImage:[UIImage imageNamed:isSelected?@"photo_sel_previewVc":@"photo_def_previewVc.png"]];
    _conImg.clipsToBounds = YES;
}
@end
