//
//  AVAudioRecordTool.m
//  AVAudioRecord
//
//  Created by Jax on 16/6/13.
//  Copyright © 2016年 Jax. All rights reserved.
//

#import "AVAudioRecordTool.h"
#import "NSString+Extension.h"
#import "MeterTable.h"
#import "lame.h"
@interface AVAudioRecordTool() <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) MeterTable *meterTable;
@property (nonatomic, assign) BOOL isStopRecorde;
@end

@implementation AVAudioRecordTool

- (instancetype)init {
    if (self = [super init]) {
        
        /**
         1.音频格式
         AVFormatIDKey 键定义了写入内容的音频格式(coreAudioType.h)
         kAudioFormatLinearPCM 文件大 高保真
         kAudioFormatMPEG4AAC 显著压缩文件，并保证高质量的音频内容
         kAudioFormatAppleIMA4 显著压缩文件，并保证高质量的音频内容
         kAudioFormatiLBC
         kAudioFormatULaw
         
         2.采样率
         AVSampleRateKey 用于定义音频的采样率
         采样率越高 内容质量越高 相应文件越大
         标准采样率8000 16000 22050 44100(CD采样率)
         
         3.通道数
         AVNumberOfChannelsKey
         设值为1:意味着使用单声道录音
         设值为2:意味着使用立体声录制
         除非使用外部硬件进行录制，一般是用单声道录制
         
         */
        
        NSString *tempDirectory   = NSTemporaryDirectory();
        NSString *filePath        = [tempDirectory stringByAppendingPathComponent:@"audio.caf"];
        NSURL *fileURL            = [NSURL fileURLWithPath:filePath];
        self.tempURL              = fileURL;
        NSDictionary *settingDict = @{
                                      AVFormatIDKey  :  @(kAudioFormatLinearPCM),
                                      AVSampleRateKey : @(8000.0f),
                                      AVNumberOfChannelsKey :@2,
                                      AVEncoderBitDepthHintKey : @16,
                                      AVEncoderAudioQualityKey : @(AVAudioQualityMedium)
                                      };
        NSError *error            = nil;
        self.audioRecord          = [[AVAudioRecorder alloc] initWithURL:fileURL settings:settingDict error:&error];
        if (self.audioRecord) {
            self.audioRecord.delegate        = self;
            self.audioRecord.meteringEnabled = YES;
            [self.audioRecord prepareToRecord];
        }
        _meterTable = [[MeterTable alloc] init];
        
    }
    return self;
}
- (void)audio_PCMtoMP3With:(NSString *)mp3Path and:(NSString *)sourcePath
{
    
    NSString *cafFilePath = [sourcePath substringFromIndex:7];
    
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3Path error:nil])
    {
        NSLog(@"删除");
    }
    
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3Path cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 8000.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        
//        if([fileManager removeItemAtPath:cafFilePath error:nil])
//        {
//            NSLog(@"删除");
//        }
    }
}
- (void)conventToMp3With:(NSString *)savePath and:(NSString *)sourcePath {
    
    NSString*cafFilePath = sourcePath;
    
    NSString*mp3FilePath = savePath;
    
    @try{
        
        int read, write;
        
        FILE*pcm =fopen([cafFilePath cStringUsingEncoding:NSASCIIStringEncoding],"rb");
        
        FILE*mp3 =fopen([mp3FilePath cStringUsingEncoding:NSASCIIStringEncoding],"wb");
        
        const int PCM_SIZE = 8192;
        
        const int MP3_SIZE = 8192;
        
        short int pcm_buffer[PCM_SIZE * 2];
        
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame =lame_init();
        
        lame_set_num_channels(lame,1);//设置1为单通道，默认为2双通道
        
        lame_set_in_samplerate(lame, 44100.0);//11025.0
        
        //lame_set_VBR(lame, vbr_default);
        
        lame_set_brate(lame,32);
        
        lame_set_mode(lame,3);
        
        lame_set_quality(lame,2);
        
        lame_init_params(lame);
        
        long curpos;
        
        BOOL isSkipPCMHeader =NO;
        
        do{
            
            curpos =ftell(pcm);
            
            long startPos =ftell(pcm);
            
            fseek(pcm, 0,SEEK_END);
            
            long endPos =ftell(pcm);
            
            long length = endPos - startPos;
            
            fseek(pcm, curpos,SEEK_SET);
            
            if(length > PCM_SIZE * 2 *sizeof(short int)) {
                
                if(!isSkipPCMHeader) {
                    
                    //Uump audio file header, If you do not skip file header
                    
                    //you will heard some noise at the beginning!!!
                    
                    fseek(pcm, 4 * 1024,SEEK_SET);
                    
                    isSkipPCMHeader =YES;
                    
                }
                
                read = (int)fread(pcm_buffer, 2 *sizeof(short int), PCM_SIZE, pcm);
                
                write =lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                
                fwrite(mp3_buffer, write, 1, mp3);
                
            }
            
            else{
                
                [NSThread sleepForTimeInterval:0.05];
                
            }
            
        }while(!self.isStopRecorde);
        
        read = (int)fread(pcm_buffer, 2 *sizeof(short int), PCM_SIZE, pcm);
        
        write =lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
        
        lame_close(lame);
        
        fclose(mp3);
        
        fclose(pcm);
        
        //self.isFinishConvert = YES;
        
    }
    
    @catch(NSException *exception) {
        
        //DWDLog(@"%@", [exception description]);
        
    }
    
    @finally{
        
        //DWDLog(@"convert mp3 finish!!!");
        NSFileManager* fileManager=[NSFileManager defaultManager];
        if([fileManager removeItemAtPath:cafFilePath error:nil])
        {
            NSLog(@"删除");
        }
    }
    
}

#pragma mark - record

- (BOOL)record {
    //[self start];
    return [self.audioRecord record];
}
-(NSString*)getmp3SavePath1{
    
    NSString*urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject];
    
    urlStr=[urlStr stringByAppendingPathComponent:@"mp3.mp3"];
    
    return urlStr;
    
}
-(void)start{
    [self.audioRecord record];
    self.isStopRecorde = NO;
        NSString * mp3Path = [self getmp3SavePath1];
        NSString * sourcePath = [self.audioRecord.url.absoluteString substringFromIndex:7];
        [self conventToMp3With:mp3Path and:sourcePath];
    
    
    
    
}
- (void)pauseRecord {
    [self.audioRecord pause];
}

- (void)stopRecord {
    [self.audioRecord stop];
    self.isStopRecorde = YES;
}

- (void)stopWithCompletionHandler:(AudioRecordStopCompletionHandler)handler {
    self.audioRecordCompletionBlock = handler;
    [self.audioRecord stop];
    self.isStopRecorde = YES;
}

- (NSString *)recordFormattedCurrentTime {
    NSUInteger time = (NSUInteger)self.audioRecord.currentTime;
    return [self formatterTime:time];
}

#pragma mark - play

- (BOOL)isPlaying {
    return self.audioPlayer.isPlaying;
}

- (void)pausePlay {
    return [self.audioPlayer pause];
}

- (void)stopPlay {
    [self.audioPlayer stop];
}

- (void)playBack:(NSURL *)url {
    if (self.audioPlayer) {
        [self.audioPlayer play];
    } else {
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.audioPlayer.delegate = self;
        if (self.audioPlayer) {
            [self.audioPlayer play];
        }
    }
}

- (NSString *)playFormattedCurrentTime {
    NSUInteger time = (NSUInteger)self.audioPlayer.currentTime;
    return [self formatterTime:time];
}

#pragma mark - save audio file

- (NSString *)saveRecordingWithName:(NSString *)name {
    NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
    NSString *filename = [NSString stringWithFormat:@"%@-%f.mp3", name, timestamp];
    NSString *document = [NSString documentDirectory];
    NSString *savePath = [document stringByAppendingPathComponent:filename];
    NSURL *sourceURL = self.audioRecord.url;
//    NSURL *saveURL = [NSURL fileURLWithPath:savePath];
    [self audio_PCMtoMP3With:savePath and:sourceURL.absoluteString];
//   NSError *error = nil;
//    BOOL success = [[NSFileManager defaultManager] copyItemAtURL:[NSURL URLWithString:[self getmp3SavePath1]] toURL:saveURL error:&error];
//    if (success) {
//        [self.audioRecord prepareToRecord];
//    } else {
//        NSLog(@"saveRecordingWithName failured: %@", error);
//    }
    return filename;
}

#pragma mark - delegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (self.audioRecordCompletionBlock) {
        self.audioRecordCompletionBlock(flag);
    }}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.audioPlayCompletionBlock) {
        self.audioPlayCompletionBlock(flag);
    }
}

#pragma  mark - voice meter

- (MeterLavel *)meterLevel {
    
    [self.audioRecord updateMeters];
    
    CGFloat avgPower    = [self.audioRecord averagePowerForChannel:0];
    CGFloat peakPower   = [self.audioRecord peakPowerForChannel:0];
    CGFloat linearLevel = [self.meterTable valueForPower:avgPower];
    CGFloat peakLevel   = [self.meterTable valueForPower:peakPower];

    return [MeterLavel levelsWithLevel:linearLevel peakLevel:peakLevel];
    
}

#pragma mark - other

- (NSString *)formatterTime:(NSUInteger)time {
    NSInteger hours = (time / 3600);
    NSInteger minutes = (time / 60) % 60;
    NSInteger seconds = time % 60;
    
    NSString *format = @"%02i:%02i:%02i";
    return [NSString stringWithFormat:format, hours, minutes, seconds];
}














@end
