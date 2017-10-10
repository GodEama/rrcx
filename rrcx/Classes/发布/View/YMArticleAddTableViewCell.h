//
//  YMArticleAddTableViewCell.h
//  YunMuFocus
//
//  Created by apple on 2017/4/17.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMArticleAddTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *TypeView;
@property (weak, nonatomic) IBOutlet UIButton *textBtn;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
