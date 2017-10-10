//
//  CXPostVideoViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/5.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXPostVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "TZImageManager.h"
#import "TZAssetModel.h"
#import "TZImagePickerController.h"
#import "TZPhotoPreviewController.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>
#import "TZVideoPlayerController.h"
@interface CXPostVideoViewController (){
    AVPlayer *_player;
    AVPlayerLayer *_playerLayer;
    UIImage *_cover;
    
    UIView *_toolBar;
    UIButton *_doneButton;
    UIProgressView *_progress;
    
    UIStatusBarStyle _originStatusBarStyle;
    BOOL _isPost;
}
@property (nonatomic,strong) UIImageView * coverImageView;
@property (nonatomic,strong) UITextField * titleTF;
@property (nonatomic,strong) UIButton * playButton;
@property (nonatomic,copy) NSString *VideoUrl;

@end

@implementation CXPostVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布视频";
    [self initlizationViews];
    [self configMoviePlayer];
    
//    //上传
//    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:_asset presetName:AVAssetExportPresetMediumQuality];
//    exportSession.outputFileType = AVFileTypeMPEG4;
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    if (_asset.mediaType == PHAssetMediaTypeVideo) {
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:_asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            
            NSURL *url = urlAsset.URL;
            NSData *data = [NSData dataWithContentsOfURL:url];
            [self uploadVideoWithData:data andFilePath:url.absoluteString];
            NSLog(@"%@",url.absoluteString);
        }];
    }
    
    

}
-(void)upload{
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    if (_asset.mediaType == PHAssetMediaTypeVideo) {
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:_asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            
            NSURL *url = urlAsset.URL;
            NSData *data = [NSData dataWithContentsOfURL:url];
            [self uploadVideoWithData:data andFilePath:url.absoluteString];
            NSLog(@"%@",url.absoluteString);
        }];
    }
}
//- (void) convertVideoWithModel:(PHAsset *) model
//{
//
//    [self creatSandBoxFilePathIfNoExist];
//    //保存至沙盒路径
//    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *videoPath = [NSString stringWithFormat:@"%@/Video", pathDocuments];
//    model.sandboxPath = [videoPath stringByAppendingPathComponent:model.fileName];
//
//    //转码配置
//    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:model.imageURL options:nil];
//
//    //AVAssetExportPresetMediumQuality可以更改，是枚举类型，官方有提供，更改该值可以改变视频的压缩比例
//    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
//    exportSession.shouldOptimizeForNetworkUse = YES;
//    exportSession.outputURL = [NSURL fileURLWithPath:model.sandboxPath];
//    //AVFileTypeMPEG4 文件输出类型，可以更改，是枚举类型，官方有提供，更改该值也可以改变视频的压缩比例
//    exportSession.outputFileType = AVFileTypeMPEG4;
//    [exportSession exportAsynchronouslyWithCompletionHandler:^{
//        int exportStatus = exportSession.status;
//        NSLog(@"%d",exportStatus);
//        switch (exportStatus)
//        {
//            case AVAssetExportSessionStatusFailed:
//            {
//                // log error to text view
//                NSError *exportError = exportSession.error;
//                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
//                break;
//            }
//            case AVAssetExportSessionStatusCompleted:
//            {
//                NSLog(@"视频转码成功");
//                NSData *data = [NSData dataWithContentsOfFile:model.sandboxPath];
//                model.fileData = data;
//            }
//        }
//    }];
//
//}

-(void)initlizationViews{

    UIBarButtonItem * rightIteam = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonClick)];
    NSDictionary *attrsDic=@{
                             NSForegroundColorAttributeName:BasicColor,
                             NSFontAttributeName:[UIFont systemFontOfSize:16],
                             };
    [rightIteam setTitleTextAttributes:attrsDic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightIteam;

    UIBarButtonItem * leftIteam = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSend)];

    NSDictionary *attrsDic1=@{
                              NSForegroundColorAttributeName:[UIColor blackColor],
                              NSFontAttributeName:[UIFont systemFontOfSize:16],
                              };
    [leftIteam setTitleTextAttributes:attrsDic1 forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftIteam;
    [self.view addSubview:self.coverImageView];
    [self.view addSubview:self.titleTF];
    [self.view addSubview:self.playButton];
    [self.titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(74);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@40);
    }];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleTF.mas_bottom).offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@200);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.coverImageView);
        make.size.mas_equalTo(self.coverImageView);
    }];


}
-(UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        
    }
    return _coverImageView;
}
-(UITextField *)titleTF{
    if (!_titleTF) {
        _titleTF = [[UITextField alloc] init];
        _titleTF.placeholder = @"请输入标题";
        _titleTF.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleTF;
}
-(void)cancelSend{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)sendButtonClick{
    if ([FuncManage theStringIsEmpty:_titleTF.text]||[_titleTF.text isEqualToString:@"请输入标题"]) {
        [Message showMiddleHint:@"请输入标题"];
    }
    else if (!_VideoUrl){
        _isPost = YES;
        [self upload];
    }
    else{
        [self postVideArticle];
    }
}

-(void)postVideArticle{
    NSDictionary * dic = @{@"title":_titleTF.text,@"video":_VideoUrl};
    [CXHomeRequest postArticleWithUrl:CXPostArticle andParameters:@{@"type":@2,@"data":[PPNetworkCache dataWithJSONObject:dic]} success:^(id response) {
        if ([response[@"code"] integerValue] == 0) {
            [Message showMiddleHint:@"上传成功"];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            if (_isPost) {
                _isPost = NO;
            }
            [Message showMiddleHint:response[@"message"]];
        }
        
    } failure:^(NSError *error) {
        if (_isPost) {
            [Message showMiddleHint:@"上传视频失败"];
            _isPost = NO;
        }
    }];
}





- (void)configMoviePlayer {
    [[TZImageManager manager] getPhotoWithAsset:_asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        _cover = photo;
        self.coverImageView.image = photo;
        
    }];
    
    
}


-(void)uploadVideoWithData:(NSData *)data andFilePath:(NSString *)filePath{
    [CXHomeRequest getAliyunToken:@{@"type":@"article_video",@"num_files":@1} success:^(id response) {
        if ([response[@"code"] intValue] == 0) {
            [OSSLog enableLog];
            NSString * endPoint = response[@"data"][@"endpoint"];
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:response[@"data"][@"Credentials"][@"AccessKeyId"] secretKeyId:response[@"data"][@"Credentials"][@"AccessKeySecret"] securityToken:response[@"data"][@"Credentials"][@"SecurityToken"]];
            OSSClientConfiguration * conf = [OSSClientConfiguration new];
            conf.maxRetryCount = 3;
            conf.timeoutIntervalForRequest = 30;
            conf.timeoutIntervalForResource = 24 * 60 * 60;
            OSSClient * client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
            [self chuckUploadInitWith:response andClient:client andFileData:data andFilePath:filePath];

        }

    } failure:^(NSError *error) {
        if (_isPost) {
            [Message showMiddleHint:@"上传视频失败"];
            _isPost = NO;
        }
    }];
}

-(void)chuckUploadInitWith:(id)response andClient:(OSSClient *)client andFileData:(NSData*)data andFilePath:(NSString *)filePath{
    __block NSString * uploadId = nil;
    __block NSMutableArray * partInfos = [NSMutableArray new];

    NSString * uploadToBucket = response[@"data"][@"bucket"];
    NSString * ext = [[filePath componentsSeparatedByString:@"."] lastObject];
    NSString * uploadObjectkey = [NSString stringWithFormat:@"%@%@.%@",response[@"data"][@"uploadFile"][@"savePath"],response[@"data"][@"uploadFile"][@"saveFileNames"][0],ext];
    OSSInitMultipartUploadRequest * init = [OSSInitMultipartUploadRequest new];
    init.bucketName = uploadToBucket;
    init.objectKey = uploadObjectkey;
    // init.contentType = @"application/octet-stream";
    OSSTask * initTask = [client multipartUploadInit:init];
    [initTask waitUntilFinished];
    if (!initTask.error) {
        OSSInitMultipartUploadResult * result = initTask.result;
        uploadId = result.uploadId;
    } else {
        NSLog(@"multipart upload failed, error: %@", initTask.error);
        return;
    }
    //分片上传数量
    for (int i = 1; i <= 1; i++) {
        @autoreleasepool {
            OSSUploadPartRequest * uploadPart = [OSSUploadPartRequest new];
            uploadPart.bucketName = uploadToBucket;
            uploadPart.objectkey = uploadObjectkey;
            uploadPart.uploadId = uploadId;
            uploadPart.partNumber = i; // part number start from 1

//            NSFileHandle* readHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
//            [readHandle seekToFileOffset:offset * (i -1)];
//            NSData* data1 = [readHandle readDataOfLength:offset];
            uploadPart.uploadPartData = data;

            OSSTask * uploadPartTask = [client uploadPart:uploadPart];

//            [uploadPartTask waitUntilFinished];

            if (!uploadPartTask.error) {
                OSSUploadPartResult * result = uploadPartTask.result;
                uint64_t fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:uploadPart.uploadPartFileURL.absoluteString error:nil] fileSize];
                [partInfos addObject:[OSSPartInfo partInfoWithPartNum:i eTag:result.eTag size:fileSize]];
            } else {
                NSLog(@"upload part error: %@", uploadPartTask.error);
                return;
            }
        }
    }

    OSSCompleteMultipartUploadRequest * complete = [OSSCompleteMultipartUploadRequest new];
    complete.bucketName = uploadToBucket;
    complete.objectKey = uploadObjectkey;
    complete.uploadId = uploadId;
    complete.partInfos = partInfos;

    OSSTask * completeTask = [client completeMultipartUpload:complete];

    [completeTask waitUntilFinished];

    if (!completeTask.error) {
        DLog(@"--------------------------------------视频上传成功---------------");
        _VideoUrl = [NSString stringWithFormat:@"%@/%@%@.%@",response[@"data"][@"previewHost"],response[@"data"][@"uploadFile"][@"savePath"],response[@"data"][@"uploadFile"][@"saveFileNames"][0],ext];
        if (_isPost) {
            [self sendButtonClick];
        }
    } else {
        if (_isPost) {
            [Message showMiddleHint:@"上传视频失败"];
            _isPost = NO;
        }
        return;
    }

}

-(UIButton *)playButton{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlay"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlayHL"] forState:UIControlStateHighlighted];
        [_playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}




-(void)playButtonClick{
    TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
    TZAssetModel *model = [TZAssetModel modelWithAsset:_asset type:TZAssetModelMediaTypeVideo timeLength:@""];
    vc.model = model;
    [self presentViewController:vc animated:YES completion:nil];
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
