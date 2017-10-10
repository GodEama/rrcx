//
//  YMPlayVoiceManager.h
//  YunMuFocus
//
//  Created by apple on 2017/4/12.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@protocol YMPlayVoiceManagerDelegate<NSObject>
@optional
-(void)updateTheIndexWith:(NSInteger)index;
-(void)getSongCurrentTime:(NSString *)currentTime andTotalTime:(NSString *)totalTime andProgress:(CGFloat)progress andTapCount:(NSInteger)tapCount;

@end




@interface YMPlayVoiceManager : NSObject
@property (nonatomic, strong) AVPlayer *player;
@property(nonatomic,assign)CGFloat volume;
@property (nonatomic,assign) BOOL isPlay;
@property(nonatomic,assign)NSInteger tapCount;
@property (nonatomic,weak) id<YMPlayVoiceManagerDelegate>delegate;
@property (nonatomic,copy)NSString * lastUrl;

/** 初始化 */
+ (instancetype)sharedInstance;
-(void)playWithArray:(NSArray *)voiceArray andIndexPath:(NSInteger)index;
//-(void)playWithVoiceModelArray:(NSArray *)voiceArray andIndexPath:(NSInteger)index;
-(void)playOneSongWithAddress:(NSString *)url;
-(void)exchangePlayerDelegateWith:(id<YMPlayVoiceManagerDelegate>)delegate andArray:(NSArray *)array andIndex:(NSInteger)index;
/**
 *  开始播放
 */
-(void)startPlay;
/**
 *  暂停播放
 */
-(void)puasePlay;
/**
 *  播放下一首
 */
-(void)nextSong;
/**
 *  播放上一首
 */
-(void)lastSong;
-(void)removeAllNotice;
@end
