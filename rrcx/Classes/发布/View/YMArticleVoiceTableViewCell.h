//
//  YMArticleVoiceTableViewCell.h
//  YunMuFocus
//
//  Created by apple on 2017/4/17.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMArticleVoiceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UISlider *voiceSlider;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (nonatomic, copy) void(^voiceBtnClickBlock)(NSString * url);
@property (nonatomic, copy) NSString * voiceSource;

@property (weak, nonatomic) IBOutlet UILabel *voiceNameLabel;

@end
