//
//  YMPlayVoiceManager.m
//  YunMuFocus
//
//  Created by apple on 2017/4/12.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import "YMPlayVoiceManager.h"
#import <MediaPlayer/MediaPlayer.h>
@interface YMPlayVoiceManager ()
@property (nonatomic, strong) NSMutableDictionary *soundIDs;//音效
@property(nonatomic,retain)UIImageView *playerImage;//player的背景图片
@property(nonatomic,copy)NSArray *songArr;//歌曲的数组
@property(nonatomic,copy)NSArray *imageArr;//图片的数组

@property(nonatomic,retain)id timeObserver;//时间观察
@property(nonatomic,retain)AVPlayerItem *songItem;
@end
@implementation YMPlayVoiceManager
#define IOS_VERSION_10 (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max)?(YES):(NO) 
static YMPlayVoiceManager *_instance = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        _volume = 1;
        _lastUrl = @"";
        _tapCount = -1;
        _soundIDs = [NSMutableDictionary dictionary];
        _player = [[AVPlayer alloc] init];
        [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        if (IOS_VERSION_10) {
            self.player.automaticallyWaitsToMinimizeStalling = NO;
        }        
        
        // 支持后台播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        // 激活
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        // 开始监控
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    
    return self;
}
-(void)playWithArray:(NSArray *)voiceArray andIndexPath:(NSInteger)index{
    //初始化songItem和player
    _songArr = voiceArray;
    _tapCount = index;
    [self updateIndex];
    [self playerWithItem];
}
//-(void)playWithVoiceModelArray:(NSArray *)voiceArray andIndexPath:(NSInteger)index{
//    //初始化songItem和player
//    NSMutableArray * array = [NSMutableArray new];
//    for (YMDailyVoice * voice in voiceArray) {
//        [array addObject:voice.voice];
//    }
//    _songArr = array;
//    _tapCount = index;
//    [self updateIndex];
//    [self playerWithItem];
//}
-(void)playOneSongWithAddress:(NSString *)url{
    _songArr = @[url];
    _tapCount = 0;
    NSURL *voiceUrl=[NSURL URLWithString:url];
    _songItem=[AVPlayerItem playerItemWithURL:voiceUrl];
    [_player replaceCurrentItemWithPlayerItem:_songItem];
    
    _lastUrl = url;
    _isPlay = YES;
    [_player play];

    [self addNetDataStatusObserver];
    [self addAVPlayerStatusObserver];

}

#pragma mark---开始播放
-(void)startPlay
{
    if (self.player == nil) {
        return;
    }
    if (self.player.currentItem == nil) {
        return;
    }
     else {
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            _isPlay = YES;
            [_player play];
            [self configNowPlayingCenter];
        }
    }
    
}
#pragma mark---暂停播放
-(void)puasePlay
{
    
    if (self.player == nil) {
        return;
    }
    if (self.player.currentItem == nil) {
        return;
    }
    if (!self.player.rate) {
        return;
    } else {
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            _isPlay = NO;
            [_player pause];
        }
    }
    
    
}
#pragma mark----播放下一首
-(void)nextSong
{
    _tapCount++;
    if (_tapCount>=_songArr.count) {
        //_tapCount=0;
        _isPlay = NO;
        _tapCount = -1;
        _lastUrl =@"";
        [self updateIndex];
        return;
    }
    //替换songItem
    [self playerWithItem];
    //添加播放器状态的监听
    [self addAVPlayerStatusObserver];
    //添加数据缓存的监听
    [self addNetDataStatusObserver];
    [self configNowPlayingCenter];
    
}
-(void)updateIndex{
    if (_delegate && [_delegate respondsToSelector:@selector(updateTheIndexWith:)]) {
        
            [_delegate updateTheIndexWith:self.tapCount];
        
        
    }
}

-(void)exchangePlayerDelegateWith:(id<YMPlayVoiceManagerDelegate>)delegate andArray:(NSArray *)array andIndex:(NSInteger)index{
    if (_delegate) {
        if (_delegate && [_delegate respondsToSelector:@selector(updateTheIndexWith:)]) {
            
            [_delegate updateTheIndexWith:-1];
            _delegate = nil;
        }
    }
    _delegate = delegate;
    _songArr = array;
    _tapCount = index;
    [self updateIndex];
    [self playerWithItem];
    
}
#pragma mark---播放上一首
-(void)lastSong
{
    //移除所有监听
    [self removeAllNotice];
    _tapCount--;
    if (_tapCount<0) {
        _tapCount=_songArr.count-1;
    }
    NSLog(@"当前播放第%ld首歌",(long)_tapCount);
    //替换songItem
    [self playerWithItem];
    //添加播放器状态的监听
    [self addAVPlayerStatusObserver];
    //添加数据缓存的监听
    [self addNetDataStatusObserver];
    [self configNowPlayingCenter];
    [self updateIndex];
}
#pragma mark---根据点击次数切换songItem
-(void)playerWithItem
{
    NSString *urlStr=_songArr[_tapCount];
    if (![urlStr isEqualToString:_lastUrl]) {
        if (_player != nil && [_player currentItem] != nil){
            [self removeAllNotice];
        }
        NSURL *url=[NSURL URLWithString:urlStr];
        _songItem=[AVPlayerItem playerItemWithURL:url];
        [_player replaceCurrentItemWithPlayerItem:_songItem];
        
        _lastUrl = urlStr;
        //添加播放器状态的监听
        [self addAVPlayerStatusObserver];
        //添加数据缓存的监听
        [self addNetDataStatusObserver];
        [self configNowPlayingCenter];

        _isPlay = YES;
        [_player play];
        
    }else{
        [self startPlay];
    }
    [self addNetDataStatusObserver];
    [self addAVPlayerStatusObserver];
    
    
}
#pragma mark----设置player的volume
-(void)setPlayerVolume
{
    _player.volume=_volume;
}
#pragma mark----添加观察者获取当前时间,总共时间,进度
-(void)addTimeObserve
{
    __block  AVPlayerItem *songItem= _songItem;
    __block typeof(self) bself = self;
    _timeObserver=[_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //设置player的声音
        [bself setPlayerVolume];
        [bself configNowPlayingCenter];//控制中心
        
        //当前时间
        float current=CMTimeGetSeconds(time);
        //总共时间
        float total=CMTimeGetSeconds(songItem.duration);
        if (bself.player.currentItem) {
            total=CMTimeGetSeconds(bself.player.currentItem.duration);
        }
        //进度
        float progress=current/total;
        //将值传入知道delegate方法中
        if (_delegate&&[_delegate respondsToSelector:@selector(getSongCurrentTime:andTotalTime:andProgress:andTapCount:)]) {
             [bself.delegate getSongCurrentTime:[bself formatTime:current]  andTotalTime:[bself formatTime:total] andProgress:progress andTapCount:bself.tapCount];
        }
       
    }];
}
- (void)configNowPlayingCenter {
    // BASE_INFO_FUN(@"配置NowPlayingCenter");
    NSMutableDictionary * info = [NSMutableDictionary dictionary];
   
    // 设置持续时间（歌曲的总时间）
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.player.currentItem duration])] forKey:MPMediaItemPropertyPlaybackDuration];
    // 设置当前播放进度
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.player.currentItem currentTime])] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    //完成设置
    [[MPNowPlayingInfoCenter defaultCenter]setNowPlayingInfo:info];
}

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) { // 得到事件类型
                
            case UIEventSubtypeRemoteControlTogglePlayPause: // 暂停 ios6
                [self puasePlay]; // 调用你所在项目的暂停按钮的响应方法 下面的也是如此
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:  // 上一首
                [self lastSong];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack: // 下一首
                [self nextSong];
                break;
                
            case UIEventSubtypeRemoteControlPlay: //播放
                [self startPlay];
                break;
                
            case UIEventSubtypeRemoteControlPause: // 暂停 ios7
                [self puasePlay];
                break;
                
            default:
                break;
        }
    }
}




- (NSString *)currentTimeStr {
    //当前的播放进度
    NSTimeInterval current = CMTimeGetSeconds(self.player.currentItem.currentTime);
    return [self timeFormatted:(int)(current)];
}

- (NSString *)durationStr {
    //视频的总长度
    NSTimeInterval total = CMTimeGetSeconds(self.player.currentItem.duration);
    return [self timeFormatted:(int)(total)];
}

#pragma mark - tool

//时间转换
- (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60);
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
#pragma mark---移除时间观察者
-(void)removeTimeObserver
{
    if (_timeObserver) {
        [_player removeTimeObserver:_timeObserver];
        _timeObserver=nil;
    }
}
#pragma mark---float转00:00类型
- (NSString *)formatTime:(float)num{
    
    int sec =(int)num%60;
    int min =(int)num/60;
    if (num < 60) {
        return [NSString stringWithFormat:@"00:%02d",(int)num];
    }
    return [NSString stringWithFormat:@"%02d:%02d",min,sec];
}
#pragma mark----监听播放器的加载状态
-(void)addAVPlayerStatusObserver
{
    [_songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark----数据缓冲状态的监听
-(void)addNetDataStatusObserver
{
    [_songItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark----KVO方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //播放器缓冲状态
    if ([keyPath isEqualToString:@"status"]) {
        switch (_player.status) {
            case AVPlayerStatusUnknown:{
                DLog(@"未知状态，此时不能播放");
            }
                break;
            case AVPlayerStatusReadyToPlay:{
                DLog(@"准备完毕，可以播放");
                //添加时间的监听
                [self addTimeObserve];
                //添加播放完成的通知
                [self addPlayToEndObserver];
            }
                break;
            case AVPlayerStatusFailed:{
                DLog(@"加载失败，网络或者服务器出现问题");
            }
                break;
            default:
                break;
        }
    }
    //数据缓冲状态
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //缓冲时间的数组
        NSArray *array=_songItem.loadedTimeRanges;
        //本次缓冲的时间范围
        CMTimeRange timeRange=[array.firstObject CMTimeRangeValue];
        NSTimeInterval totalBuffer=CMTimeGetSeconds(timeRange.start)+CMTimeGetSeconds(timeRange.duration);//缓冲总长度
                NSLog(@"共缓冲%.2f",totalBuffer);
        DLog(@"缓冲总长度%.2f  播放长度：%.2f",totalBuffer,CMTimeGetSeconds(self.player.currentItem.currentTime)+5);
//        if (totalBuffer > CMTimeGetSeconds(self.player.currentItem.currentTime)+5){ // 缓存 大于 播放 当前时长+5
//            
//            if (_isPlay) { // 接着之前 播放时长 继续播放
//                [self.player play];
//            }
//        }else{
//            NSLog(@"等待播放，网络出现问题");
//        }
    }
    
}
#pragma mark---移除媒体加载状态的监听
-(void)removeAVPlayerObserver
{
    [_songItem removeObserver:self forKeyPath:@"status"];
}
#pragma mark---移除数据加载状态的监听
-(void)removeNetDataObserver
{
    [_songItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}
#pragma mark----播放完成后发送通知
-(void)addPlayToEndObserver
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_songItem];
}
#pragma mark---通知的方法
-(void)playFinished:(NSNotification *)notice
{
    NSLog(@"播放完成，自动进入下一首");
    //移除所有监听
    [self removeAllNotice];
    _lastUrl = @"";
    //播放下一首
    [self nextSong];
}
#pragma mark----移除通知
-(void)removePlayToEndNotice
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark-----移除所有监听
-(void)removeAllNotice
{
    //移除时间进度的监听
    _songItem = nil;
    [self removeTimeObserver];
    //移除播放完成的通知
    [self removePlayToEndNotice];
    //移除播放器状态的监听
    [self removeAVPlayerObserver];
    //移除数据缓存的监听
    [self removeNetDataObserver];
}
-(void)dealloc{
    @try {
        [self removeAllNotice];
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    @finally  {
        // Added to show finally works as well
    }
}

@end
