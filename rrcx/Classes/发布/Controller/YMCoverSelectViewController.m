//
//  YMCoverSelectViewController.m
//  YunMuFocus
//
//  Created by apple on 2017/4/19.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import "YMCoverSelectViewController.h"
#import "YMArticleConCollectionViewCell.h"
#import "YMArticleCon.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "AliImageReshapeController.h"
@interface YMCoverSelectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,ALiImageReshapeDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (nonatomic, strong) UICollectionView * photoCollectView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * selectPhotoUrls;
@end

@implementation YMCoverSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initlizationView];
    [self initlizationData];
    
}
-(void)initlizationView{
    self.title = @"设置封面";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * right1 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveCoverImges)];
    UIBarButtonItem * right2 = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addNewPhotos)];
    NSDictionary *attrsDic=@{
                             NSForegroundColorAttributeName:BasicColor,
                             NSFontAttributeName:[UIFont systemFontOfSize:16],
                             };
    [right1 setTitleTextAttributes:attrsDic forState:UIControlStateNormal];
    [right2 setTitleTextAttributes:attrsDic forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItems = @[right1,right2];
    [self.view addSubview:self.photoCollectView];
    
    
}

-(void)saveCoverImges{
    
    if (_saveButtonIsDissMiss) {
        
        BOOL isDismiss = _saveButtonIsDissMiss(_selectPhotoUrls);
        
        if (isDismiss) {
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

-(void)addNewPhotos{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册选取", nil];
    [sheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //拍照
        [self takePhoto];
    } else if(buttonIndex == 1) {
        //相册选取
        [self chooseImageFromLibary];
    } else {
        //取消
    }
}
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
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            if(iOS8Later) {
                picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:picker animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}
- (void)chooseImageFromLibary
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - ALiImageReshapeDelegate

- (void)imageReshaperController:(AliImageReshapeController *)reshaper didFinishPickingMediaWithInfo:(UIImage *)image
{
    [self savePhotos:@[image]];
    [reshaper dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageReshaperControllerDidCancel:(AliImageReshapeController *)reshaper
{
    [reshaper dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (picker.allowsEditing) {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        [self savePhotos:@[image]];
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //[self savePhotos:@[image]];
        AliImageReshapeController *vc = [[AliImageReshapeController alloc] init];
        vc.sourceImage = image;
        vc.reshapeScale = 100/65.;
        vc.delegate = self;
        [picker pushViewController:vc animated:YES];
    }
    
}



-(void)initlizationData{
    _dataArray = [NSMutableArray new];
    _selectPhotoUrls = [NSMutableArray new];
    _selectedAssets = [NSMutableArray new];
    _selectedPhotos = [NSMutableArray new];
    [self GetSourceData];
}
-(void)GetSourceData{
    //    for (YMArticleCon * con in self.conArray) {
    //        if ([con.type isEqualToString:@"img"]) {
    //            [_dataArray addObject:con.img];
    //        }
    //        [_photoCollectView reloadData];
    //    }
    _dataArray = [NSMutableArray arrayWithArray:_coverImageUrls];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YMArticleConCollectionViewCell * cell = [_photoCollectView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    NSString * url = _dataArray[indexPath.row];
    if ([url rangeOfString:@"http"].location != NSNotFound) {
        [cell.conImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    }else{
        [cell.conImg setImage:[UIImage imageWithContentsOfFile:[DOCUMENTDIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"MyImage/%@",url]]]];
    }
    cell.isSelected = NO;
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YMArticleConCollectionViewCell * cell = (YMArticleConCollectionViewCell*)[_photoCollectView cellForItemAtIndexPath:indexPath];
    
    if (!cell.isSelected) {
        if (_selectPhotoUrls.count >= 3) {
            [Message showMiddleHint:@"封面图片最多选择3张"];
            
        }
        else{
            [_selectPhotoUrls addObject:_dataArray[indexPath.row]];
            cell.isSelected = !cell.isSelected;
        }
    }else{
        cell.isSelected = !cell.isSelected;
        for (int i = 0; i < _selectPhotoUrls.count; i++) {
            if ([_selectPhotoUrls[i] isEqualToString:_dataArray[indexPath.row]]) {
                [_selectPhotoUrls removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    
}

-(UICollectionView *)photoCollectView{
    if (!_photoCollectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _margin = 4;
        _itemWH = (KWidth - 2 * _margin - 4) / 3 - _margin;
        layout.itemSize = CGSizeMake(_itemWH, _itemWH);
        layout.minimumInteritemSpacing = _margin;
        layout.minimumLineSpacing = _margin;
        _photoCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight) collectionViewLayout:layout];
        CGFloat rgb = 244 / 255.0;
        _photoCollectView.alwaysBounceVertical = YES;
        _photoCollectView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
        _photoCollectView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
        _photoCollectView.dataSource = self;
        _photoCollectView.delegate = self;
        _photoCollectView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_photoCollectView registerNib:[UINib nibWithNibName:@"YMArticleConCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"photoCell"];
    }
    return _photoCollectView;
}

-(void)savePhotos:(NSArray *)photos {
    for (UIImage * image in photos) {
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
        NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
        [self savePhotosWith:timeString andImage:image];
    }
}
#pragma mark - 保存选择的图片
-(void)savePhotosWith:(NSString*)imageName andImage:(UIImage *)image{
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
    if ([fileManager fileExistsAtPath:imagePath]) {
        [self.dataArray addObject:imageName];
        [_photoCollectView reloadData];
        [_selectPhotoUrls removeAllObjects];
    }
    else{
        BOOL success = [UIImageJPEGRepresentation(image, 1) writeToFile:[self getImagePath:imageName] atomically:YES];
        if (success) {
            [self.dataArray addObject:imageName];
            [_photoCollectView reloadData];
            [_selectPhotoUrls removeAllObjects];
        }
        else{
            DLog(@"保存失败");
        }
    }
    
    
}
- (NSString*)getImagePath:(NSString *)name {
    
    
    NSString *docPath = [DOCUMENTDIRECTORY stringByAppendingPathComponent:@"MyImage"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *finalPath = [docPath stringByAppendingPathComponent:name];
    
    
    
    // Remove the filename and create the remaining path
    
    [fileManager createDirectoryAtPath:[finalPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];//stringByDeletingLastPathComponent是关键
    
    
    
    return finalPath;
    
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
