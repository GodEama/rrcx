//
//  AudioPlayCell.m
//  AVAudioRecord
//
//  Created by Jax on 16/6/14.
//  Copyright © 2016年 Jax. All rights reserved.
//

#import "AudioPlayCell.h"



static NSString *const kAudioPlayCellIdentify = @"kAudioPlayCellIdentify";

@implementation AudioPlayCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    AudioPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:kAudioPlayCellIdentify];
    if (!cell) {
        cell = [[AudioPlayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAudioPlayCellIdentify];
        
    }
    return cell;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UILabel *fileNameLabel = [[UILabel alloc] init];
    fileNameLabel.frame    = CGRectMake(10, 5, 150, 30);
    fileNameLabel.font     = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:fileNameLabel];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.frame    = CGRectMake(10, 40, 150, 30);
    dateLabel.font     = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:dateLabel];
    
    UILabel *currentTimeLabel = [[UILabel alloc] init];
    currentTimeLabel.frame    = CGRectMake(KWidth - 120, 0, 100, 75);
    currentTimeLabel.font     = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:currentTimeLabel];
    
    UIButton *playButton = [[UIButton alloc] init];
    playButton.frame = CGRectMake((KWidth - 100) * 0.5, 70, 100, 0);
    [playButton setTitle:@"播放" forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.contentView addSubview:playButton];
    
    self.fileNameLabel    = fileNameLabel;
    self.dateLabel        = dateLabel;
    self.currentTimeLabel = currentTimeLabel;
    self.playButton       = playButton;
}

@end
