//
//  YMArticleConTableViewCell.h
//  YunMuFocus
//
//  Created by apple on 2017/4/17.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMArticleConTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
