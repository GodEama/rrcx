//
//  YMArticleConCollectionViewCell.h
//  YunMuFocus
//
//  Created by apple on 2017/4/17.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMArticleConCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImg;
@property (weak, nonatomic) IBOutlet UIImageView *conImg;
@property (nonatomic, assign) BOOL isSelected;
@end
