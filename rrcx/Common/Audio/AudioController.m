//
//  AudioController.m
//  AVAudioRecord
//
//  Created by Jax on 16/6/13.
//  Copyright © 2016年 Jax. All rights reserved.
//

#import "AudioController.h"
#import <AVFoundation/AVFoundation.h>
#import "AVAudioRecordTool.h"
#import "AudioDataModel.h"
#import "AudioPlayCell.h"
#import "MeterView.h"
#import "NSString+Extension.h"
#import "AVAudioSession+Extension.h"

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
//#define kScreenWidth [UIScreen  mainScreen].bounds.size.width
//#define kScreenHeigth [UIScreen mainScreen].bounds.size.height

static NSString *const kAudioArchivePath     = @"kAudioArchivePath";
static NSInteger const kTagForCoverTableView = 1000;
static NSInteger const kTagForCoverTop       = 1001;
static NSInteger const kTagForCoverBottom    = 1002;
static CGFloat const kAnimateDuration        = 0.2f;

@interface AudioController () <UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate, UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView      *recordView;
@property (nonatomic, strong) UILabel     *recordCurrentTimeLabel;
@property (nonatomic, strong) UILabel     *playCurrentTimeLabel;
@property (nonatomic, strong) UIButton    *startButton;
@property (nonatomic, strong) UIButton    *playButton;
@property (nonatomic, strong) UIButton    *finishButton;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) MeterView   *meterView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CADisplayLink *meterTimer;

@property (nonatomic, strong) AVAudioRecordTool *recordTool;
@property (nonatomic, strong) AVAudioPlayer     *selfPlayer;
@property (strong, nonatomic) NSTimer           *recordTimer;
@property (strong, nonatomic) NSTimer           *playTimer;
@property (strong, nonatomic) NSIndexPath       *selectedIndexPath;

@property (nonatomic, strong) NSMutableArray *audioDatasArray;
@property (nonatomic, copy  ) NSString       *fileTotalTime;
@property (nonatomic, strong) NSMutableArray *showsArray;
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, copy)   NSString * selectedAudioPath;
@property (nonatomic, strong) AudioDataModel *audioDataModel;
@end

@implementation AudioController

#pragma mark - lazy load

- (NSMutableArray *)audioDatasArray {
    if (!_audioDatasArray) {
        NSData *data = [NSData dataWithContentsOfURL:[self archiveURL]];
        if (!data) {
            _audioDatasArray = [NSMutableArray array];
            
        } else {
            _audioDatasArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSInteger count = _audioDatasArray.count;
            for (int i = 0; i < count; i ++) {
                [self.showsArray addObject:@0];
            }
        }
    }
    return _audioDatasArray;
}

- (NSMutableArray *)showsArray {
    if (!_showsArray) {
        _showsArray = [NSMutableArray array];
    }
    return _showsArray;
}

#pragma mark - view life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.recordTool           = [[AVAudioRecordTool alloc] init];
   
    [self setupViews];
    
    [self setupTableView];
    _lastIndex = -1;
    //[self getMp3File];
    
}

- (void)setupViews {
    self.title = @"选择录音";
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(SaveAudioRecord)];
    NSDictionary *attrsDic=@{
                             NSForegroundColorAttributeName:BasicColor,
                             NSFontAttributeName:[UIFont systemFontOfSize:16],
                             };
    [rightItem setTitleTextAttributes:attrsDic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *recordView         = [[UIView alloc] init];
    recordView.backgroundColor = [UIColor blackColor];
    recordView.frame           = CGRectMake(0, -295 + 128, KWidth, 355);
    [self.view addSubview:recordView];
    self.recordView            = recordView;
    
    MeterView *meterView = [[MeterView alloc] init];
    meterView.frame      = CGRectMake(0, 60, KWidth, 140);
    [self.recordView addSubview:meterView];
    self.meterView       = meterView;
    
    UILabel *recordCurrentTimeLabel      = [[UILabel alloc] init];
    recordCurrentTimeLabel.frame         = CGRectMake(0, CGRectGetMaxY(meterView.frame), KWidth, 45);
    recordCurrentTimeLabel.textColor     = [UIColor whiteColor];
    recordCurrentTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:recordCurrentTimeLabel];
    self.recordCurrentTimeLabel          = recordCurrentTimeLabel;
    
    UILabel *playCurrentTimeLabel      = [[UILabel alloc] init];
    playCurrentTimeLabel.frame         = CGRectMake(0, CGRectGetMaxY(meterView.frame), KWidth, 45);
    playCurrentTimeLabel.textColor     = [UIColor whiteColor];
    playCurrentTimeLabel.textAlignment = NSTextAlignmentCenter;
    playCurrentTimeLabel.hidden        = YES;
    [self.view addSubview:playCurrentTimeLabel];
    self.playCurrentTimeLabel          = playCurrentTimeLabel;
    
    UILabel *tempFileLabel  = [[UILabel alloc] init];
    tempFileLabel.frame     = CGRectMake(10, CGRectGetMaxY(recordCurrentTimeLabel.frame), KWidth, 25);
    tempFileLabel.text      = @"新录音";
    tempFileLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:tempFileLabel];
    
    UILabel *nowLabel  = [[UILabel alloc] init];
    nowLabel.frame     = CGRectMake(10, CGRectGetMaxY(tempFileLabel.frame), KWidth, 25);
    nowLabel.text      = [self stringFromDate:[NSDate date]];
    nowLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:nowLabel];
    
    UIButton *startButton = [[UIButton alloc] init];
    startButton.frame     = CGRectMake((KWidth - 60) * 0.5, CGRectGetMaxY(nowLabel.frame), 60, 60);
    [startButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [recordView addSubview:startButton];
    [startButton addTarget:self action:@selector(startButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.startButton      = startButton;
    
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(nowLabel.frame), 60, 60)];
    self.playButton      = playButton;
    [playButton setTitle:@"播放" forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.view addSubview:playButton];
    
    UIButton *finishButton = [[UIButton alloc] initWithFrame:CGRectMake(KWidth - 30 - 60, CGRectGetMaxY(nowLabel.frame), 60, 60)];
    self.finishButton      = finishButton;
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.view addSubview:finishButton];
    
    [self.playButton addTarget:self action:@selector(palyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.finishButton addTarget:self action:@selector(finishButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titlelabel      = [[UILabel alloc] init];
    titlelabel.frame         = CGRectMake(0, 28, KWidth, 30);
    titlelabel.textColor     = [UIColor whiteColor];
    titlelabel.text          = @"语音备忘录";
    titlelabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel          = titlelabel;
    [self.view addSubview:titlelabel];
}
-(void)SaveAudioRecord{
    
    if (_delegate&&[_delegate respondsToSelector:@selector(audioController:savePath:andFileName:)]) {
        [_delegate audioController:self savePath:_selectedAudioPath andFileName:_audioDataModel.title];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
- (void)setupTableView {
    CGFloat frameY = CGRectGetMaxY(self.recordView.frame);
    CGRect tableFrame = CGRectMake(0, frameY, KWidth, KHeight - frameY);
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - record play save

#pragma mark record

- (void)startButtonClicked:(UIButton *)sender {
    
    self.playCurrentTimeLabel.hidden   = YES;
    self.recordCurrentTimeLabel.hidden = NO;
    
    [self removeViewForCoverTableView];
    
    [AVAudioSession setCategory:AVAudioSessionCategoryRecord];
    
    self.titleLabel.text = @"录制";
    
    [self animateView];

    sender.selected = !sender.selected;
    if (sender.selected) {
        [self setPlayAndFinishStatus:NO];
        [self startMeterTimer];
        [self startRecordTimer];
        [self.recordTool record];
    } else {
        [self setPlayAndFinishStatus:YES];
        [self stopMeterTimer];
        [self stopRecordTimer];
        [self.recordTool pauseRecord];
    }
}

- (void)setPlayAndFinishStatus:(BOOL)status {
    self.playButton.enabled   = status;
    self.finishButton.enabled = status;
}

- (void)addViewCoverTableView {
    UIView *view = [[UIView alloc] init];
    view.tag = kTagForCoverTableView;
    view.frame = self.tableView.frame;
    view.backgroundColor = [UIColor colorWithRed:223 green:223 blue:223 alpha:0.8];
    [self.view addSubview:view];
}

- (void)removeViewForCoverTableView {
    NSArray *subViews = self.view.subviews;
    for (UIView *view in subViews) {
        if (view.tag == kTagForCoverTableView) {
            [view removeFromSuperview];
            break;
        }
    }
}

- (void)animateView {
    
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.recordView.frame = CGRectMake(0, 0, KWidth, 355);
        CGFloat frameY = CGRectGetMaxY(self.recordView.frame);
        self.tableView.frame = CGRectMake(0, frameY, KWidth, KHeight - frameY);
        
        self.playButton.hidden = NO;
        self.finishButton.hidden = NO;
        
        self.playButton.enabled = NO;
        self.finishButton.enabled = NO;
    } completion:^(BOOL finished) {
        [self addViewCoverTableView];
    }];

}

- (void)startRecordTimer {
    [self.recordTimer invalidate];
    self.recordTimer = [NSTimer timerWithTimeInterval:0.5
                                         target:self
                                       selector:@selector(updateRecordCurrentTime)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.recordTimer forMode:NSRunLoopCommonModes];
}

- (void)stopRecordTimer {
    [self.recordTimer invalidate];
    self.recordTimer = nil;
}

- (void)updateRecordCurrentTime {
    self.recordCurrentTimeLabel.text = [self.recordTool recordFormattedCurrentTime];
}

#pragma mark play

- (void)palyButtonClicked:(UIButton *)sender {
    
    self.startButton.enabled = NO;
    
    [AVAudioSession setCategory:AVAudioSessionCategoryPlayback];
    
    if (self.recordTool.isPlaying) {
        [self.recordTool pausePlay];
        self.startButton.enabled = YES;
        return ;
    }
    
    [self startPlayTimer];
    __weak AudioController *weakSelf = self;
    self.recordTool.audioPlayCompletionBlock = ^(BOOL flag){
        if (flag) {
            weakSelf.startButton.enabled = YES;
        }
    };
    [self.recordTool playBack:self.recordTool.tempURL];
}

- (void)startPlayTimer {
    self.recordCurrentTimeLabel.hidden = YES;
    self.playCurrentTimeLabel.hidden   = NO;
    [self.playTimer invalidate];
    self.playTimer = [NSTimer timerWithTimeInterval:0.5
                                             target:self
                                           selector:@selector(updatePlayCurrentTime)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.playTimer forMode:NSRunLoopCommonModes];
}

- (void)stopPlayTimer {
    [self.playTimer invalidate];
    self.playTimer = nil;
}

- (void)updatePlayCurrentTime {
    self.playCurrentTimeLabel.text = [self.recordTool playFormattedCurrentTime];
}

#pragma mark save

- (void)finishButtonClicked:(UIButton *)sender {
    
    sender.enabled = NO;
    
    [self.recordTool stopPlay];
    
    self.fileTotalTime = [self.recordTool recordFormattedCurrentTime];
    
    [self.recordTool stopWithCompletionHandler:^(BOOL result) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showAlertView];
        });
    }];
    
}

- (void)showAlertView {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"保存录音"
                                          message:@"请输入录音名字（英文字母和数字）"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"My Recording", @"Login");
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.delegate = self;
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSString *filename = [alertController.textFields.firstObject text];
      
        NSString * audioName     = [self.recordTool saveRecordingWithName:filename];
        NSString *date     = [self stringFromDate:[NSDate date]];
        
    
        AudioDataModel *audioDataModel = [[AudioDataModel alloc] initWithTitle:filename fileName:audioName date:date currentTime:self.fileTotalTime];;
        [self.audioDatasArray insertObject:audioDataModel atIndex:0];
        [self.showsArray addObject:@0];
        [self saveAudioDataModel];
        
        [UIView animateWithDuration:kAnimateDuration animations:^{
            self.titleLabel.text = @"语音备忘录";
            self.recordView.frame = CGRectMake(0, -295 + 64 + 64, KWidth, 355);
            CGFloat frameY = CGRectGetMaxY(self.recordView.frame);
            self.tableView.frame = CGRectMake(0, frameY, KWidth, KHeight - frameY);
            [self setPlayAndFinishStatus:YES];
            self.playButton.enabled = NO;
            self.finishButton.enabled = NO;
            
        }];
        
        [self removeViewForCoverTableView];

        [self.tableView reloadData];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}
- (void)saveAudioDataModel {
    NSData *fileDate = [NSKeyedArchiver archivedDataWithRootObject:self.audioDatasArray];
    [fileDate writeToURL:[self archiveURL] atomically:YES];
}

- (NSURL *)archiveURL {
    NSString *archivePath =  [[NSString documentDirectory] stringByAppendingPathComponent:kAudioArchivePath];
    
    return [NSURL fileURLWithPath:archivePath];
}

#pragma mark - meter voice

- (void)startMeterTimer {
    [self.meterTimer invalidate];
    self.meterTimer = [CADisplayLink displayLinkWithTarget:self
                                                  selector:@selector(updateMeter)];
    self.meterTimer.frameInterval = 5;
    [self.meterTimer addToRunLoop:[NSRunLoop currentRunLoop]
                          forMode:NSRunLoopCommonModes];
}

- (void)stopMeterTimer  {
    [self.meterTimer invalidate];
    self.meterTimer = nil;
    [self.meterView resetMeterLevel];
}

- (void)updateMeter {
    
    MeterLavel *meterlevel = [self.recordTool meterLevel];
    self.meterView.level = meterlevel.level;
    self.meterView.peakLevel = meterlevel.peakLevel;
    [self.meterView setNeedsDisplay];
    
}

#pragma mark - tableView method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.audioDatasArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioPlayCell *audioPlayCell = [AudioPlayCell cellWithTableView:tableView];
    audioPlayCell.tag            = indexPath.row;
    [audioPlayCell.playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return audioPlayCell;
}

- (void)playButtonClicked:(UIButton *)sender {
    if ([self.selfPlayer isPlaying]) {
        [self.selfPlayer pause];
        [sender setTitle:@"播放" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        return ;
    }
    AudioDataModel *audioDataModel = self.audioDatasArray[self.selectedIndexPath.row];
    NSURL *url = [NSURL fileURLWithPath:[DOCUMENTDIRECTORY stringByAppendingPathComponent:audioDataModel.fileName]];
    NSError *error;
    self.selfPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.selfPlayer.delegate = self;
    [AVAudioSession setCategory:AVAudioSessionCategoryPlayback];
    [self.selfPlayer play];
    [sender setTitle:@"停止" forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *number = self.showsArray[indexPath.row];
    NSInteger num = number.integerValue;
    if (num == 0) {
        return 75;
    }
    return 120;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioPlayCell *audioPlayCell        = (AudioPlayCell *)cell;
    AudioDataModel *audioDataModel      = self.audioDatasArray[indexPath.row];
    audioPlayCell.fileNameLabel.text    = audioDataModel.title;
    audioPlayCell.dateLabel.text        = audioDataModel.date;
    audioPlayCell.currentTimeLabel.text = audioDataModel.currentTime;
    NSInteger row                       = indexPath.row;
    NSNumber *number                    = self.showsArray[row];
    if (number.integerValue) {
        audioPlayCell.playButton.frame = CGRectMake((KWidth - 100) * 0.5, 70, 100, 40);
        audioPlayCell.playButton.hidden = NO;
    } else {
        audioPlayCell.playButton.hidden = YES;
        audioPlayCell.playButton.frame = CGRectMake((KWidth - 100) * 0.5, 70, 100, 0);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioDataModel *audioDataModel = self.audioDatasArray[indexPath.row];
    _audioDataModel = audioDataModel;
    _selectedAudioPath = audioDataModel.fileName;
    if (_lastIndex >= 0 &&_lastIndex != indexPath.row) {
        AudioPlayCell *lastCell = (AudioPlayCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_lastIndex inSection:0]];
        [lastCell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    AudioPlayCell *audioPlayCell = (AudioPlayCell *)[tableView cellForRowAtIndexPath:indexPath];
    [audioPlayCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    _lastIndex = indexPath.row;
    self.selectedIndexPath = indexPath;
    
    
//    if ([self.selfPlayer isPlaying]) {
//        [self.selfPlayer stop];
//        [audioPlayCell.playButton setTitle:@"播放" forState:UIControlStateNormal];
//        [audioPlayCell.playButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    }
//    
//    [self removeTopAndBottomCover];
//    
//    self.selectedIndexPath = indexPath;
//    
//    NSInteger row = indexPath.row;
//    NSNumber *number = self.showsArray[row];
//    [self.showsArray replaceObjectAtIndex:row withObject:[NSNumber numberWithInteger:!(number.integerValue)]];
//    
//    if (!number.integerValue) {
//        
//        audioPlayCell.playButton.frame = CGRectMake((kScreenWidth - 100) * 0.5, 70, 100, 40);
//        audioPlayCell.playButton.hidden = NO;
//        
//        CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
//        CGRect rect = [tableView convertRect:rectInTableView toView:self.view];
//        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + 45);
//
//        [self addTopCover:rect];
//        [self addBottomCover:rect];
//        
//        self.tableView.scrollEnabled = NO;
//        
//    } else {
//        
//        audioPlayCell.playButton.hidden = YES;
//        audioPlayCell.playButton.frame = CGRectMake((kScreenWidth - 100) * 0.5, 70, 100, 0);
//        self.tableView.scrollEnabled = YES;
//        
//    }
//    
//    NSArray *indexPathArray = @[indexPath];
//    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (void)removeTopAndBottomCover  {
    NSArray *views = self.view.subviews;
    for (UIView *view in views) {
        if (view.tag == kTagForCoverTop || view.tag == kTagForCoverBottom) {
            [view removeFromSuperview];
        }
    }
}

- (void)addTopCover:(CGRect)rect {
    CGFloat topViewY = CGRectGetMinY(rect);
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, topViewY)];
    topView.tag = kTagForCoverTop;
    topView.backgroundColor = [UIColor colorWithRed:223 green:223 blue:223 alpha:0.8];
    [self.view addSubview:topView];
}

- (void)addBottomCover:(CGRect)rect {
    CGFloat bottomY = CGRectGetMaxY(rect);
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomY, KWidth, KHeight - bottomY)];
    bottomView.tag = kTagForCoverBottom;
    bottomView.backgroundColor = [UIColor colorWithRed:223 green:223 blue:223 alpha:0.8];
    [self.view addSubview:bottomView];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger row                  = indexPath.row;
        AudioDataModel *audioDataModel = self.audioDatasArray[row];
        [self.audioDatasArray removeObjectAtIndex:row];
        [audioDataModel deleteAudioFile];
        [self saveAudioDataModel];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - audio paly delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        AudioPlayCell *audioPlayCell = (AudioPlayCell *)[self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
        [audioPlayCell.playButton setTitle:@"播放" forState:UIControlStateNormal];
        [audioPlayCell.playButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    if (self.selfPlayer.isPlaying) {
        [self.selfPlayer pause];
    }
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    
}

#pragma mark - other

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.selfPlayer stop];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(NSArray *)getMp3File{
    NSString *path= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject; // 要列出来的目录
    
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    
    NSDirectoryEnumerator *myDirectoryEnumerator;
    
    myDirectoryEnumerator=[myFileManager enumeratorAtPath:path];
    
    //列举目录内容，可以遍历子目录
    
    NSMutableArray * fileArray = [NSMutableArray new];
    NSString * filePath;
    while((filePath=[myDirectoryEnumerator nextObject])!=nil)
    {
        DLog(@">>>>>>>>>>>filePath:%@",filePath);
        if([[filePath pathExtension] isEqualToString:@"mp3"])  //取得后缀名为.xml的文件名
        {
            [fileArray addObject:[path stringByAppendingPathComponent:filePath]];//存到数组
        }
        
    }
    return fileArray;
}

@end
