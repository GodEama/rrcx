//
//  CXPostImagesViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/5.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXPostImagesViewController.h"
#import "YMArticleAddTableViewCell.h"
#import "CXImagesArticleTableViewCell.h"
#import "CXSelectImagesCoverViewController.h"
#import "CXImageItem.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "YMEditArticleViewController.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>
@interface CXPostImagesViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL vocieIsOk;
    BOOL contentImgIsOk;
    BOOL coverImagIsOk;
    BOOL _isPosting;
}

@property (nonatomic, strong) UITableView * imagesTable;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIImageView * coverImg;
@property (nonatomic, strong) UITextField * titleTF;
@property (nonatomic, strong) NSMutableArray * coverImgUrls;
@property (nonatomic, assign) NSInteger lastExpandIndex;
@property (nonatomic, assign) NSUInteger waitUploadCoverCount;
@property (nonatomic, assign) NSUInteger waitUploadImageCount;
@property (nonatomic, assign) NSUInteger clearWaitUploadCoverCount;
@property (nonatomic, assign) NSUInteger clearWaitUploadImageCount;
@property (nonatomic, retain) NSMutableDictionary * contentDic;
@property (nonatomic, strong) MBProgressHUD * hud;
@property (nonatomic, copy)   NSString * coverImageUrl;
@property (nonatomic, assign) NSInteger coverImageIndex;


@end
static NSString *const imageCell=@"imageCell";

@implementation CXPostImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布图集";
    self.automaticallyAdjustsScrollViewInsets = NO;

    _dataArray = [NSMutableArray new];
    _coverImgUrls = [NSMutableArray new];
    [self initlizationViews];
    [self initlizationData];
}

-(void)initlizationViews{
    [self.imagesTable setTableHeaderView:self.headerView];
    [self.view addSubview:self.imagesTable];
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
    
}
-(void)initlizationData{
    if (self.firstAsset.count) {
        [self printAssetsName:self.firstAsset];
    }
    else{
        [self cancelSend];
    }
    
    
}
-(void)cancelSend{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}





-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray * arr = [NSMutableArray new];
    for (CXImageItem * item in _dataArray) {
        [arr addObject:item.imagePath];
    }
    DLog(@">>>>>>>>%@",arr);
    return _dataArray.count + 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.row == 0?40:174;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        YMArticleAddTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"addCell"];
        cell.addBtn.tag = indexPath.row;
        [cell.addBtn addTarget:self action:@selector(addImageContent:) forControlEvents:UIControlEventTouchUpInside];
        cell.textBtn.tag = indexPath.row;
        cell.imgBtn.tag = indexPath.row;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    else{
        CXImagesArticleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:imageCell];
        cell.upBtn.hidden = indexPath.row == 1?YES:NO;
        cell.downBtn.hidden = indexPath.row == _dataArray.count? YES:NO;
        CXImageItem * model = _dataArray[indexPath.row - 1];
        cell.model = model;
        NSString * desc1 = model.desc;
        
        __block NSString * desc = desc1;
        __weak CXImagesArticleTableViewCell * weakCell = cell;
        WeakSelf(weakSelf)
        
        cell.editTextBlock = ^NSString *{
            YMEditArticleViewController * editVC = [[YMEditArticleViewController alloc] init];
            editVC.contentType = ArticleContentType;
            editVC.contentText = desc1;
            //__block typeof(self) uvc = self;
            editVC.saveButtonIsDissMiss = ^(NSString *text) {
                desc = text;
                model.desc = text;
                weakCell.model = model;
                [weakSelf.dataArray replaceObjectAtIndex:indexPath.row-1 withObject:model];
                
                return YES;
            };

            [self.navigationController pushViewController:editVC animated:YES];
                
            return desc;
                
        };
       
        
        cell.addImageBlock = ^{
            self.lastExpandIndex = indexPath.row;
            [self pushImagePickerController];
                
        };
        
        cell.deleteBtn.tag = indexPath.row;
        cell.upBtn.tag = indexPath.row;
        cell.downBtn.tag = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.upBtn addTarget:self action:@selector(upBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.downBtn addTarget:self action:@selector(downBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CXImageItem * model = _dataArray[indexPath.row -1];
    DLog(@">>>>>>>>>%@",[model yy_modelToJSONObject]);
    
}

-(void)addImageContent:(UIButton *)sender{
    _lastExpandIndex = sender.tag;
    [self pushImagePickerController];
}
#pragma mark - 删除cell
-(void)deleteBtnClick:(UIButton *)sender{
    if (_dataArray.count == 1) {
        [Message showMiddleHint:@"至少一张图片"];
    }
    else if (_dataArray.count >1){
        NSInteger index = sender.tag - 1;
        CXImageItem * con = _dataArray[index];
        
        [_dataArray removeObjectAtIndex:index];
        if ([_coverImageUrl isEqualToString:con.imagePath]) {
            CXImageItem * model = [_dataArray firstObject];
            _coverImageUrl = model.imagePath;
            if ([_coverImageUrl rangeOfString:@"http"].location == NSNotFound) {
                [_coverImg setImage:[UIImage imageWithContentsOfFile:[DOCUMENTDIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"MyImage/%@",_coverImageUrl]]]];
                
            }else{
                [_coverImg sd_setImageWithURL:[NSURL URLWithString:_coverImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_articleCover"]];
            }
        }
        [_imagesTable beginUpdates];
        [_imagesTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [_imagesTable endUpdates];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [_imagesTable reloadData];
        });
        
    }
    
    
}
-(void)upBtnClick:(UIButton *)sender{
    if (sender.tag-1 > 0) {
        sender.userInteractionEnabled = NO;
        [_dataArray exchangeObjectAtIndex:sender.tag-1 withObjectAtIndex:sender.tag -2];
        [_imagesTable beginUpdates];
        [_imagesTable moveRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0] toIndexPath:[NSIndexPath indexPathForRow:sender.tag-1 inSection:0]];

        [_imagesTable endUpdates];
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [_imagesTable reloadData];
            sender.userInteractionEnabled = YES;
        });
    }
}
-(void)downBtnClick:(UIButton *)sender{
    if (sender.tag  < _dataArray.count) {
        sender.userInteractionEnabled = NO;
        [_dataArray exchangeObjectAtIndex:sender.tag-1 withObjectAtIndex:sender.tag];
        [_imagesTable beginUpdates];
        
        [_imagesTable moveRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0] toIndexPath:[NSIndexPath indexPathForRow:sender.tag + 1 inSection:0]];
        [_imagesTable endUpdates];
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [_imagesTable reloadData];
            sender.userInteractionEnabled = YES;
        });
    }
    
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    
    //    if (self.selecteMaxCount > 1) {
    //        // 1.设置目前已经选中的图片数组
    //        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    //    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.circleCropRadius = 100;
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    
    // 1.打印图片名字
    [self printAssetsName:assets];
    //[self savePhotos:photos];
    
    
}


// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    
}
#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (int i =0;i<assets.count;i++) {
        id asset = assets[i];
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        //        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
        //        CGImageRef imgRef = [assetRep fullResolutionImage];
        //        UIImage * image = [UIImage imageWithCGImage:imgRef
        //                                                  scale:assetRep.scale
        //                                            orientation:(UIImageOrientation)assetRep.orientation];
        //[self savePhotosWith:fileName andImage:image];
        [[TZImageManager manager] getPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            if (!isDegraded) {
                //                [self uploadImage:photo andFileName:fileName];
                [self savePhotosWith:fileName andImage:photo andIndex:_lastExpandIndex + i];
                
            }
            //            [self savePhotosWith:fileName andImage:photo];
        }];
    }
}

#pragma mark - 保存选择的图片
-(void)savePhotosWith:(NSString*)imageName andImage:(UIImage *)image andIndex:(NSInteger)index{
    // 本地沙盒目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 得到本地沙盒中名为"MyImage"的路径，"MyImage"是保存的图片名
    
    // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
    
    NSString *imageFilePath = [path stringByAppendingPathComponent:@"MyImage"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:imageFilePath]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        
        [fileManager createDirectoryAtPath:imageFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString * imagePath = [imageFilePath stringByAppendingPathComponent:imageName];
    DLog(@"保存路径：%@",imagePath);
    if (!_coverImageUrl &&index == 0 ) {
        _coverImageUrl = imagePath;
        [_coverImg setImage:image];
        
    }
    if ([fileManager fileExistsAtPath:imagePath]) {
        NSDictionary * dic = @{@"img":imageName,@"text":@"",@"desc":@""};
        CXImageItem * con = [CXImageItem parserWithDictionary:dic];
        [self.dataArray insertObject:con atIndex:_lastExpandIndex];
        [self.imagesTable reloadData];
        [self uploadOneImageWithFileName:imageName andIndex:_lastExpandIndex isPost:NO];

    }
    else{
        BOOL success = [UIImageJPEGRepresentation(image, 1) writeToFile:imagePath atomically:YES];
        if (success) {
            NSDictionary * dic = @{@"img":imageName,@"text":@"",@"desc":@""};
            
            CXImageItem * con = [CXImageItem parserWithDictionary:dic];
            [self.dataArray insertObject:con atIndex:_lastExpandIndex];
            [self.imagesTable reloadData];
            [self uploadOneImageWithFileName:imageName andIndex:_lastExpandIndex isPost:NO];

        }
        else{
            DLog(@"保存失败");
        }
    }
    
    
}




#pragma mark - 更换封面
-(void)setArticleCoverImg{
    CXSelectImagesCoverViewController * coverVC = [[CXSelectImagesCoverViewController alloc] init];
    //    coverVC.conArray = self.dataArray;
    coverVC.currentCoverImageUrl = self.coverImageUrl;
    coverVC.conArray = self.dataArray;
    coverVC.saveButtonIsDissMiss = ^(NSString*selectPhotoUrl){
        self.coverImageUrl = selectPhotoUrl;
        if ([_coverImageUrl rangeOfString:@"http"].location == NSNotFound) {
            [_coverImg setImage:[UIImage imageWithContentsOfFile:[DOCUMENTDIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"MyImage/%@",_coverImageUrl]]]];
            
        }else{
            [_coverImg sd_setImageWithURL:[NSURL URLWithString:_coverImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_articleCover"]];
        }
        
        return YES;
    };
    [self.navigationController pushViewController:coverVC animated:YES];
}




-(UITableView *)imagesTable{
    if (!_imagesTable) {
        _imagesTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KWidth, KHeight - kTopHeight) style:UITableViewStylePlain];
        _imagesTable.delegate = self;
        _imagesTable.dataSource = self;
        [_imagesTable registerNib:[UINib nibWithNibName:@"YMArticleAddTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"addCell"];
        [_imagesTable registerClass:[CXImagesArticleTableViewCell class] forCellReuseIdentifier:imageCell];
        _imagesTable.tableFooterView = [UIView new];
        _imagesTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _imagesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _imagesTable.estimatedRowHeight = 0;
        _imagesTable.estimatedSectionHeaderHeight = 0;
        _imagesTable.estimatedSectionFooterHeight = 0;
    }
    return _imagesTable;
}
#pragma mark - headerView
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 200)];
        _headerView.backgroundColor = [UIColor clearColor];
        _coverImg = [[UIImageView alloc] init];
        [_headerView addSubview:_coverImg];
        _titleTF = [[UITextField alloc] init];
        [_headerView addSubview:_titleTF];
        _titleTF.placeholder = @"请输入标题";
        [_titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView.mas_left).with.offset = 15;
            make.right.equalTo(_headerView.mas_right).with.offset = 15;
            make.top.equalTo(_headerView.mas_top).with.offset = 0;
            make.height.equalTo(@40);
        }];
        [_coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView.mas_left).with.offset = 0;
            make.right.equalTo(_headerView.mas_right).with.offset = 0;
            make.top.equalTo(_headerView.mas_top).with.offset = 40;
            make.bottom.equalTo(_headerView.mas_bottom).with.offset = 0;
        }];
        _coverImg.backgroundColor = [UIColor lightGrayColor];
        _coverImg.contentMode = UIViewContentModeScaleAspectFill;
        _coverImg.clipsToBounds = YES;
        
        
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headerView.mas_right).with.offset = -10;
            
            make.bottom.equalTo(_headerView.mas_bottom).with.offset = -5;
            make.size.mas_equalTo(CGSizeMake(90, 35));
        }];
        [button setTitle:@"编辑封面" forState:UIControlStateNormal];
        [button setTitleColor:RGB(58, 59, 60) forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4;
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(setArticleCoverImg) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    
    return _headerView;
}



#pragma mark - 单张上传图片根据Image路径
-(void)uploadOneImageWithFileName:(NSString *)fileName andIndex:(NSInteger)index isPost:(BOOL)isPost{
    NSString * imagePath = [DOCUMENTDIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"MyImage/%@",fileName]];
    //NSString * ex = [imagePath pathExtension];
    UIImage * imag = [UIImage imageWithContentsOfFile:imagePath];
    NSData * data = [self resetSizeOfImageData:imag maxSize:500];
    NSString * ext = [[fileName componentsSeparatedByString:@"."] lastObject];

    if (data.length) {
        [CXHomeRequest getAliyunToken:@{@"type":@"article_image",@"num_files":@(1)} success:^(id response) {
            if ([response[@"code"] intValue] == 0) {
                [OSSLog enableLog];
                NSString * endPoint = response[@"data"][@"endpoint"];
                id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:response[@"data"][@"Credentials"][@"AccessKeyId"] secretKeyId:response[@"data"][@"Credentials"][@"AccessKeySecret"] securityToken:response[@"data"][@"Credentials"][@"SecurityToken"]];
                OSSClientConfiguration * conf = [OSSClientConfiguration new];
                conf.maxRetryCount = 3;
                conf.timeoutIntervalForRequest = 30;
                conf.timeoutIntervalForResource = 24 * 60 * 60;
                OSSClient * client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
                [self uploadImageAsyncWithData:data andResponse:response andClient:client andIndex:index andImageType:@"article_image" isCover:[imagePath isEqualToString:_coverImageUrl] isPost:isPost andExt:ext];
            }
            
        } failure:^(NSError *error) {
            if (_isPosting) {
                [_hud hideAnimated:YES];
                _isPosting = NO;
                [Message showMiddleHint:@"上传失败"];
                
            }
        }];
    }
    
}
// 异步上传
- (void)uploadImageAsyncWithData:(NSData *)uploadData andResponse:(NSDictionary *)response andClient:(OSSClient*)client andIndex:(NSInteger)index andImageType:(NSString*)imageType isCover:(BOOL)isCover isPost:(BOOL)isPost andExt:(NSString *)ext{
    
    //上传请求类
    OSSPutObjectRequest * request = [OSSPutObjectRequest new];
    //文件夹名 后台给出
    request.bucketName = response[@"data"][@"bucket"];
    //objectKey为文件名 一般自己拼接
    request.objectKey = [NSString stringWithFormat:@"%@%@.png",response[@"data"][@"uploadFile"][@"savePath"],response[@"data"][@"uploadFile"][@"saveFileNames"][0]];
    
    //    request.uploadingFileURL = self.responseObject[@"data"][@"uploadFile"][@"savePath"];
    //上传数据类型为NSData
    request.uploadingData = uploadData;
    
    OSSTask * putTask = [client putObject:request];
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        if (!task.error) {
            
            NSString * imageUrl = @"";
            imageUrl = [NSString stringWithFormat:@"%@/%@%@.%@",response[@"data"][@"previewHost"],response[@"data"][@"uploadFile"][@"savePath"],response[@"data"][@"uploadFile"][@"saveFileNames"][0],ext];
            if ([imageType isEqualToString:@"article_image"]) {
                CXImageItem * item = _dataArray[index];
                NSDictionary *dic = @{@"img":imageUrl,@"text":item.desc};
                
                CXImageItem * con = [CXImageItem parserWithDictionary:dic];
                [_dataArray replaceObjectAtIndex:index withObject:con];
                
                if (isCover) {
                    _coverImageUrl = imageUrl;
                }
                if (isPost) {
                    _clearWaitUploadImageCount ++;
                    if (_clearWaitUploadImageCount >= _waitUploadImageCount) {
                        contentImgIsOk = YES;
                        [self uploadMyArticle];
                    }
                }
                
            }

            
        }
        else
        {
            if (_isPosting) {
                [_hud hideAnimated:YES];
                _isPosting = NO;
                [Message showMiddleHint:@"上传失败"];
                
            }
            
        }
        return nil;
    }];
    
//    [putTask waitUntilFinished];
    
    //上传进度
    request.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        
    };
    
}


-(void)sendButtonClick{
    if ([self judgeIsHaveTitle]) {
        _waitUploadImageCount = 0;
        _clearWaitUploadImageCount = 0;
        contentImgIsOk = NO;
        _isPosting = YES;
        _hud = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.label.text = @"正在上传...";
        _hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        _hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
        _hud.removeFromSuperViewOnHide = YES;
        [self.view addSubview:_hud];
        
        [_hud showAnimated:YES];
        
        [self uploadArticleContentImage];
    }
}





-(BOOL)judgeIsHaveTitle{
    if (!_titleTF.text) {
        [Message showMiddleHint:@"未设置标题"];
        return NO ;
    }
    else if (_titleTF.text.length == 0 ){
        [Message showMiddleHint:@"未设置标题"];
        return NO;
    }
    else{
        return YES;
    }
    
}

#pragma mark - 上传未获得网络路径的图片
-(void)uploadArticleContentImage{
    BOOL contentImgOK = YES;
    if (_dataArray.count) {
        for (int i = 0; i<_dataArray.count; i++) {
            CXImageItem * con = _dataArray[i];
            
            if ([con.imagePath rangeOfString:@"http"].location== NSNotFound) {
                _waitUploadImageCount ++;
                [self uploadOneImageWithFileName:con.imagePath andIndex:i isPost:YES];
                contentImgOK = NO;
            }
            
        }
    }
    contentImgIsOk = contentImgOK;
    if (contentImgIsOk) {
        [self uploadMyArticle];
    }
    
}



//#pragma mark -  如果语音、封面、文章图片都上传完毕
//-(void)judgeAllContentIsReady{
//    if (vocieIsOk&&coverImagIsOk&&contentImgIsOk) {
//        [self uploadMyArticle];
//    }
//}

-(void)uploadMyArticle{
    [self loadAllContent];
    //index.php?m=Api&c=Article&a=save&key=令牌
    NSString * postUrl;
    switch (_loadImagesType) {
        case localLoadImagesType:
            postUrl = CXPostArticle;
            break;
        case netLoadImagesType:
            postUrl = CXFixArticle;
            break;
            
        default:
            postUrl = CXPostArticle;
            break;
    }
    NSString * conStr = [PPNetworkCache dataWithJSONObject:_contentDic];
    [CXHomeRequest postArticleWithUrl:postUrl andParameters:@{@"data":conStr,@"type":@1} success:^(id response) {
        [_hud hideAnimated:YES];
        if ([response[@"code"] intValue] == 0) {
            [Message showMiddleHint:@"上传成功"];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                if (self.loadImagesType == localLoadImagesType) {
                    _contentDic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":@"",@"addr":@"",@"cover_images":[NSArray new],@"digest":@"",@"con_list":[NSArray new]}];
                    NSMutableData *data = [[NSMutableData alloc]init];
                    NSKeyedArchiver *archvier = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                    [archvier encodeObject:_contentDic forKey:@"privacyArticle"];
                    [archvier finishEncoding];
                    [data writeToFile:Draft_Article atomically:YES];
                }
                NSString * imagePath = [DOCUMENTDIRECTORY stringByAppendingPathComponent:@"MyImage"];
                [PPNetworkCache clearCacheWithFilePath:imagePath];
            }];
            
        }
        else{
            if (_isPosting) {
                [_hud hideAnimated:YES];
                _isPosting = NO;
                
            }
            [Message showMiddleHint:response[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)loadAllContent{
    /*
     
     
     addr 地址
     title 标题
     cover_images 封面图片【数组['图片地址1','图片地址2','图片地址3']】【封面图片宽高比例为1:0.65】
     voice 音频
     digest 摘要
     con_list 文章主体 [{type:'text',text:'文本信息'},{type:'img',img:'图片地址'}]
     
     */
    
    NSMutableDictionary * conDic = [[NSMutableDictionary alloc] init];
    
    [conDic setObject:_titleTF.text forKey:@"title"];
    
    [conDic setObject:@[_coverImageUrl] forKey:@"cover_images"];
    
    [conDic setObject:_titleTF.text forKey:@"digest"];
    NSMutableArray * conArr = [NSMutableArray new];
    // BOOL isHaveVoice = [self judgeIsHaveVoice];
    for (CXImageItem * con in _dataArray) {
        NSDictionary * dic = @{@"type":@"img",@"value":con.imagePath,@"desc":con.desc};
        [conArr addObject:dic];
    }
    [conDic setObject:conArr forKey:@"con_list"];
    _contentDic = conDic;
    //    NSString * conStr = [PPNetworkCache dataWithJSONObject:conArr];
    //    [_contentDic setObject:conStr forKey:@"con_list"];
}








-(NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    
    CGFloat tempHeight = newSize.height / 640;
    CGFloat tempWidth = newSize.width / 640;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        return finallImageData;
    }
    
    return imageData;
}





























-(void)dealloc{
    DLog(@"*************************************Say Bye**********************");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
