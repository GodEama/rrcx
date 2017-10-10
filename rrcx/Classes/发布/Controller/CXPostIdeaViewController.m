//
//  CXPostIdeaViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/5.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXPostIdeaViewController.h"
#import "SDAutoLayout.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "CXLoactionsViewController.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>
@interface CXPostIdeaViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    
    
    AMapSearchAPI* _search;
    AMapPOIAroundSearchRequest *request;
}


@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) UIView * headerView;
@property (nonatomic,strong) UITextView * textView;
@property (nonatomic,strong) UIView * footerView;
@property (nonatomic,strong) MBProgressHUD * hud;
@property (nonatomic,copy)   NSString * placeHolder;
@property (nonatomic, strong) NSMutableArray * locationArray;
@property (nonatomic, strong) AMapPOI * poi;
@property (nonatomic, strong) UILabel * addrLab;
@property (nonatomic, strong) NSMutableArray * imgUrlArray;

@end

@implementation CXPostIdeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布动态";
    _imgUrlArray = [NSMutableArray new];
    [self initlizationViews];
    self.automaticallyAdjustsScrollViewInsets = NO;

    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    [self sendRequest];
}
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}
-(void)initlizationViews{
    [self.view addSubview:self.collectionView];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
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
-(void)cancelSend{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)initlizationDatas{
    
    
}

//发送
-(void)sendButtonClick{

    _hud = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
    _hud.mode = MBProgressHUDModeDeterminate;
    _hud.label.text = @"正在上传...";
    _hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    _hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.3f];
    _hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:_hud];
    
    [_hud showAnimated:YES];
    /*
     {
     "microblog_content": "动态描述，动态描述",
     "images": [
     "20170905/59ae040841942.jpeg",
     "20170905/59ae045cceba3.jpeg",
     "20170905/59ae04e852a96.jpeg"
     ],
     "video": "视频文件地址（仅视频类型文章适用）"
     }
     */
    [_imgUrlArray removeAllObjects];
    [self uploadSelectImages];
    
}

-(void)uploadSelectImages{
    if (_selectedPhotos.count) {
        for (UIImage * image in _selectedPhotos) {
            [self uploadOneImageWithImage:image];
        }
    }
    else{
        [self postMyBlog];
    }
    
    
}
-(void)postMyBlog{
    NSDictionary * dict = @{@"microblog_content":_textView.text,@"images":_imgUrlArray.count?_imgUrlArray:@[],@"location_longitude":_poi?@(_poi.location.longitude):@"",@"location_latitude":_poi?@(_poi.location.latitude):@"",@"location_desc":_poi?[_poi.city stringByAppendingString:_poi.name]:@""};
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    if (!_imgUrlArray.count) {
        [dic removeObjectForKey:@"images"];
    }
    if (!_poi) {
        [dic removeObjectForKey:@"location_longitude"];
        [dic removeObjectForKey:@"location_latitude"];
        [dic removeObjectForKey:@"location_desc"];

    }
    
    [CXHomeRequest postMyBlogWithUrl:CXPostUserFind andParameters:@{@"type":@1,@"data":[PPNetworkCache dataWithJSONObject:dic]} success:^(id response) {
        [_hud hideAnimated:YES];
        if ([response[@"code"] integerValue] == 0) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        [_hud hideAnimated:YES];
        [Message showMessageWithConfirm:NO title:@"上传失败"];
    }];
}

#pragma mark - 单张上传图片根据Image路径
-(void)uploadOneImageWithImage:(UIImage *)image{
    
    NSData * data = [self resetSizeOfImageData:image maxSize:500];
    if (data.length) {
        [CXHomeRequest getAliyunToken:@{@"type":@"microblog_image",@"num_files":@(1)} success:^(id response) {
            if ([response[@"code"] intValue] == 0) {
                [OSSLog enableLog];
                NSString * endPoint = response[@"data"][@"endpoint"];
                id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:response[@"data"][@"Credentials"][@"AccessKeyId"] secretKeyId:response[@"data"][@"Credentials"][@"AccessKeySecret"] securityToken:response[@"data"][@"Credentials"][@"SecurityToken"]];
                OSSClientConfiguration * conf = [OSSClientConfiguration new];
                conf.maxRetryCount = 3;
                conf.timeoutIntervalForRequest = 30;
                conf.timeoutIntervalForResource = 24 * 60 * 60;
                OSSClient * client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
                [self uploadImageAsyncWithData:data andResponse:response andClient:client andImageType:@"microblog_image"];
            }
            
        } failure:^(NSError *error) {
            [_hud hideAnimated:YES];
            [Message showMiddleHint:@"发布失败"];
        }];
    }
    
}
// 异步上传
- (void)uploadImageAsyncWithData:(NSData *)uploadData andResponse:(NSDictionary *)response andClient:(OSSClient*)client andImageType:(NSString*)imageType{
    
    //上传请求类
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    //文件夹名 后台给出
    put.bucketName = response[@"data"][@"bucket"];
    //objectKey为文件名 一般自己拼接
    put.objectKey = [NSString stringWithFormat:@"%@%@.png",response[@"data"][@"uploadFile"][@"savePath"],response[@"data"][@"uploadFile"][@"saveFileNames"][0]];
    
    //    request.uploadingFileURL = self.responseObject[@"data"][@"uploadFile"][@"savePath"];
    //上传数据类型为NSData
    put.uploadingData = uploadData;
    
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        if (!task.error) {
            
            NSString * imageUrl = @"";
            imageUrl = [NSString stringWithFormat:@"%@/%@%@.png",response[@"data"][@"previewHost"],response[@"data"][@"uploadFile"][@"savePath"],response[@"data"][@"uploadFile"][@"saveFileNames"][0]];
            if ([imageType isEqualToString:@"microblog_image"]) {
                [_imgUrlArray addObject:imageUrl];
                if (_imgUrlArray.count == _selectedPhotos.count) {
                    [self postMyBlog];
                }
            }
            static NSInteger i = 0;
            DLog(@"上传第%ld张完成",i);
            i++;
           
            
        }
        else
        {
            
            [_hud hideAnimated:YES];
            [Message showMessageWithConfirm:NO title:@"上传失败"];
            
        }
        return nil;
    }];
    
    //同步上传（去掉就是异步）因为我上传的文件有多种包括音视频,图片。而且OSS这边是每上传成功一个文件都要回调一次。比如我成功上传5张图片，那么就要回调5次。所以这个时候我就无法判断文件是否都上传完成。所以我就把这些上传的文件放在调度组里面，这样所有文件上传成功后我这边就知道了。如果上传放在调度组里，那么这里的同步上传就必须加上。
//    [putTask waitUntilFinished];
    
    //上传进度
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        
    };
    
}













-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        [self.collectionView addSubview:_headerView];
        _headerView.sd_layout
        .leftEqualToView(self.collectionView)
        .rightEqualToView(self.collectionView)
        .topSpaceToView(self.collectionView, -124)
        .heightIs(120);
        _headerView.backgroundColor = [UIColor whiteColor];
        _textView = [[UITextView alloc] init];
        [_headerView addSubview:_textView];
        _textView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(4, 4, 4, 4));
        _textView.font = [UIFont systemFontOfSize:14];
        
        [_textView setValue:@(400) forKey:@"limit"];
        self.placeHolder = @"分享新鲜事～";
        
    }
    return _headerView;
}
-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.frame = CGRectMake(0, 10, KWidth, 46);
        _footerView.backgroundColor = [UIColor whiteColor];
        UIView * line = [UIView new];
        [_footerView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_footerView);
            make.right.equalTo(_footerView);
            make.top.equalTo(_footerView).offset(0);
            make.height.equalTo(@0.5);
        }];
        line.backgroundColor = [UIColor lightGrayColor];
        UIImageView * addrImg = [[UIImageView alloc] init];
        addrImg.image = [UIImage imageNamed:@"location"];
        [_footerView addSubview:addrImg];
        UIImageView * moreImg = [[UIImageView alloc] init];
        moreImg.image = [UIImage imageNamed:@"arrow"];
        [_footerView addSubview:moreImg];
        
        _addrLab = [[UILabel alloc] init];
        _addrLab.textColor = RGB(55, 56, 57);
        _addrLab.font = [UIFont systemFontOfSize:14];
        [_footerView addSubview:_addrLab];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footerView addSubview:btn];
        [addrImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_footerView).offset(10);
            make.top.equalTo(line.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [moreImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_footerView).offset(-10);
            make.top.equalTo(line.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(12, 20));
        }];
        [_addrLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(addrImg.mas_right).offset(10);
            make.centerY.equalTo(moreImg);
        }];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_footerView);
            make.right.equalTo(_footerView);
            make.top.equalTo(line);
            make.bottom.equalTo(_footerView);
        }];
        
        [btn addTarget:self action:@selector(selectAddress) forControlEvents:UIControlEventTouchUpInside];
    
        UIView * line1 = [UIView new];
        [_footerView addSubview:line1];
        
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_footerView);
            make.right.equalTo(_footerView);
            make.top.equalTo(_footerView.mas_bottom).offset(-2);
            make.height.equalTo(@0.5);
        }];
        line1.backgroundColor = [UIColor lightGrayColor];;
        
        line.alpha = 0.5;
        line1.alpha = 0.5;
        _addrLab.text = @"所在位置";
    }
    return _footerView;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
        _margin = 4;
        _itemWH = (self.view.tz_width - 3 * _margin - 4) / 4 - _margin;
        layout.itemSize = CGSizeMake(_itemWH, _itemWH);
        layout.minimumInteritemSpacing = _margin;
        layout.minimumLineSpacing = _margin;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kTopHeight, self.view.tz_width, KHeight - kTopHeight) collectionViewLayout:layout];
        
        _collectionView.alwaysBounceVertical = YES;
        //        CGFloat rgb = 243 / 255.0;
        //        _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.contentInset = UIEdgeInsetsMake(124, 4, 201, 4);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
//        _collectionView.backgroundColor = RGB(247, 247, 247);
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self.view addSubview:_collectionView];
        [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"collectionFooter"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader"];
    }
    return _collectionView;
}


#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count <=8) {
        return _selectedPhotos.count + 1;
    }
    else{
        return 9;
    }
    
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
            UICollectionReusableView * reusableViewFooterView =  [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"collectionFooter" forIndexPath:indexPath];
            reusableViewFooterView.backgroundColor = RGB(247, 247, 247);
        [reusableViewFooterView addSubview:self.footerView];
        
            return reusableViewFooterView;
    }
    else{
        UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"collectionFooter" forIndexPath:indexPath];
        
        return headerView;
    }
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}

//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(KWidth, KHeight - 190);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    
    cell.gifLable.hidden = YES;
    
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count && _selectedPhotos.count < 9) {
        
        [self pushImagePickerController];
        
    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        if ([[asset valueForKey:@"filename"] containsString:@"GIF"]) {
            TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        } else if (isVideo) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            imagePickerVc.maxImagesCount = 9;
            imagePickerVc.allowPickingOriginalPhoto = NO;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                [_collectionView reloadData];
                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}
-(void)selectAddress{
    CXLoactionsViewController * locationVC = [[CXLoactionsViewController alloc] init];
    locationVC.lastPoi = self.poi;
    locationVC.selectAddressBlock = ^(AMapPOI *poi) {
        self.poi = poi;
        
        [self.addrLab setText:poi?poi.name:@"所在位置"];
        
    };
    [self.navigationController pushViewController:locationVC animated:YES];
}


#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    
    // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = YES;
    imagePickerVc.allowPickingMultipleVideo = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = YES;
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

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([TZImageManager authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return [self takePhoto];
        });
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {

        }
    }
    else{
        if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
            if (iOS8Later) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            } else {
                NSURL *privacyUrl;
                if (alertView.tag == 1) {
                    privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
                } else {
                    privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
                }
                if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                    [[UIApplication sharedApplication] openURL:privacyUrl];
                } else {
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
            }
        }
    }
    
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));

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
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [_collectionView reloadData];
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    [_collectionView reloadData];
    //    [_collectionView performBatchUpdates:^{
    //        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    //        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    //    } completion:^(BOOL finished) {
    //        [_collectionView reloadData];
    //    }];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Private



- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_textView endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = placeHolder;
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [_textView addSubview:placeHolderLabel];
    
    // same font
    _textView.font = [UIFont systemFontOfSize:13.f];
    placeHolderLabel.font = [UIFont systemFontOfSize:13.f];
    
    [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
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
//***************************************位置相关******************************
- (void) sendRequest {
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    request = [[AMapPOIAroundSearchRequest alloc] init];
    request.keywords = nil;
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"地名地址信息|体育休闲服务|科教文化服务";
    request.sortrule = 0;
    request.requireExtension = YES;
    request.page = 1;
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，可修改，最小2s
    self.locationManager.locationTimeout = 5;
    //   逆地理请求超时时间，可修改，最小2s
    self.locationManager.reGeocodeTimeout = 5;
    
    // 带逆地理（返回坐标和地址信息）
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
//            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"失败" message:@"获取位置失败，试试右上角的“刷新位置”？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alertview show];
            [_addrLab setText:@"定位失败"];
        }
        AMapPOI *p = [[AMapPOI alloc] init];
        p.name = [NSString stringWithFormat:@"%@%@", regeocode.city == nil ? @"" : regeocode.city, regeocode.district == nil ? @"" : regeocode.district];
        p.address = regeocode.province;
        [self.locationArray addObject:p];
        CLLocationCoordinate2D coor = location.coordinate;
        request.location = [AMapGeoPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
        [_search AMapPOIAroundSearch: request];
    }];
}
//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count != 0)
    {
        AMapPOI * poi = response.pois.firstObject;
        [_addrLab setText:poi.name];
        
    } else {
        [_addrLab setText:@"定位失败"];
    }
    
    DLog(@">>>>>>>>%@",response.pois);
    
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
