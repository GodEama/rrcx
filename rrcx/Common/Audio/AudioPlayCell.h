//
//  AudioPlayCell.h
//  AVAudioRecord
//
//  Created by Jax on 16/6/14.
//  Copyright © 2016年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioPlayCell : UITableViewCell

@property (nonatomic, strong) UILabel  *fileNameLabel;
@property (nonatomic, strong) UILabel  *dateLabel;
@property (nonatomic, strong) UILabel  *currentTimeLabel;
@property (nonatomic, strong) UIButton *playButton;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
