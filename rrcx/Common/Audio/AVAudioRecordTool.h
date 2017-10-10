//
//  AVAudioRecordTool.h
//  AVAudioRecord
//
//  Created by Jax on 16/6/13.
//  Copyright © 2016年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MeterLavel.h"

typedef void(^AudioRecordCompletionBlock)(BOOL);
typedef void(^AudioPlayCompletionBlock)(BOOL);

typedef void(^AudioRecordStopCompletionHandler)(BOOL);
typedef void(^AudioRecordSaveCompletionHandler)(BOOL, id);


@interface AVAudioRecordTool : NSObject

@property (nonatomic, strong) AVAudioPlayer   *audioPlayer;
@property (nonatomic, strong) AVAudioRecorder *audioRecord;
@property (nonatomic, copy  ) NSURL           *tempURL;
@property (nonatomic, copy  ) NSString        *recordFormattedCurrentTime;
@property (nonatomic, copy  ) NSString        *playFormattedCurrentTime;

@property (nonatomic, strong) AudioRecordCompletionBlock audioRecordCompletionBlock;
@property (nonatomic, strong) AudioPlayCompletionBlock   audioPlayCompletionBlock;

//  reocrd
- (BOOL)record;
- (void)pauseRecord;
- (void)stopRecord;

//  play
- (BOOL)isPlaying;
- (void)pausePlay;
- (void)stopPlay;
- (void)playBack:(NSURL *)url;

//  save record
- (NSString *)saveRecordingWithName:(NSString *)name;
- (void)stopWithCompletionHandler:(AudioRecordStopCompletionHandler)handler;

//  meter voice
- (MeterLavel *)meterLevel;

@end
