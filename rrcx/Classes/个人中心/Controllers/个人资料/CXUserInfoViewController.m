//
//  CXUserInfoViewController.m
//  rrcx
//
//  Created by 123 on 2017/9/11.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXUserInfoViewController.h"
#import "CXUserAvatarTableViewCell.h"
#import "CXUserInfoTableViewCell.h"
#import "SelectView.h"
#import <AliyunOSSiOS/OSSService.h>
#import "DatePicker.h"
#import "CXTextViewController.h"
#import "CXDescViewController.h"

@interface CXUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,SelectViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CXTextViewControllerDelegate,CXDescViewControllerDelegate>
@property (nonatomic,strong) UITableView * userInfoTable;
@property (nonatomic,copy) NSArray * data;
@property (nonatomic,copy) NSMutableArray * infoArray;

@end

@implementation CXUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"个人资料";
    _data = @[@[@"头像",@"用户名",@"介绍"],@[@"性别",@"生日",@"地区"]];
    _infoArray = [NSMutableArray new];
    [_infoArray addObjectsFromArray:@[@[@"",_user.member_nick?:@"",_user.member_intro?:@""],@[_user.member_sex?:@"",_user.member_birthday?:@"",_user.member_cityName?:@""]]];
    [self.view addSubview:self.userInfoTable];
    [self getUserData];
   
    
}


-(void)getUserData{
    [CXHomeRequest getSelfInfo:nil responseCache:^(id responseCaches) {
        
    } success:^(id response) {
        if ([response[@"code"] intValue] == 0) {
            _user = [CXUser yy_modelWithJSON:response[@"data"]];
            [_infoArray removeAllObjects];
            [_infoArray addObjectsFromArray:@[@[@"",_user.member_nick?:@"",_user.member_intro?:@""],@[_user.member_sex?:@"",_user.member_birthday?:@"",_user.member_cityName?:@""]]];
            [self.userInfoTable reloadData];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}







-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        CXUserAvatarTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"avatarCell"];
        cell.titleLab.text = @"头像";
        cell.imgUrl = _user.member_avatar;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else{
        CXUserInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
        NSArray * arr = _data[indexPath.section];
        cell.titleLab.text = arr[indexPath.row];
        if (_user) {
            NSArray * array = _infoArray[indexPath.section];
            NSString * str = array[indexPath.row];
            if (![FuncManage theStringIsEmpty:str]) {
                cell.detailLab.text = str;
                cell.detailLab.textColor = [UIColor lightGrayColor];
                if (indexPath.section == 1 && indexPath.row == 0) {
                    if ([str isEqualToString:@"1"]) {
                        cell.detailLab.text = @"男";
                    }else if ([str isEqualToString:@"2"]){
                        cell.detailLab.text = @"女";
                    }
                    else{
                        
                        cell.detailLab.text = @"保密";
                    }
                }
            }
            else{
                cell.detailLab.text = @"未填写";
                cell.detailLab.textColor = [UIColor blueColor];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                SelectView *selevtView = [[SelectView alloc] initWithTitle:@[@"拍照", @"从相册选择"] delegate:self];
                selevtView.myTag = 10;
                [selevtView showInWindow];
            }
                break;
            case 1:
            {
                CXTextViewController *tvc = [[CXTextViewController alloc] init];
                tvc.title = @"昵称";
                tvc.text = _user.member_nick;
                tvc.delegate = self;
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:tvc];
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
            case 2:{
                CXDescViewController *dvc = [[CXDescViewController alloc] init];
                dvc.title = @"简介";
                dvc.text = _user.member_intro;
                dvc.delegate = self;
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:dvc];
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    }
    else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                SelectView * selectView = [[SelectView alloc] initWithTitle:@[@"男",@"女",@"保密"] delegate:self];
                selectView.myTag = 11;
                [selectView showInWindow];
            }
                break;
            case 1:
            {
                DatePicker *datePicker = [[DatePicker alloc] init];
                //字符串转为date
                NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init] ;
                
                [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
                
                [inputFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString * birthday = _user.member_birthday?:@"2000-01-01";
                
                NSDate*inputDate = [inputFormatter dateFromString:birthday];
                datePicker.defaultDate = inputDate;
                
                __block typeof(self) ageVC = self;
                datePicker.maxDate = [NSDate date];
                datePicker.endBlock = ^(NSDate *date) {
                    
                    
                    [ageVC updateBirthdayWithTimeString:[FuncManage timeWithDate:date]];
                };
                [datePicker showInWindow];
            }
                break;
            case 2:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
    
    
}
-(void)textViewController:(CXTextViewController *)textViewController saveText:(NSString *)saveText{
    if ([FuncManage theStringIsEmpty:saveText]) {
        [Message showMiddleHint:@"请输入有效昵称"];
    }
    else if (saveText.length > 16){
        [Message showMiddleHint:@"长度超出限制"];
    }
    else{
        _user.member_nick = saveText;
        CXUserInfoTableViewCell * cell = [_userInfoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.detailLab.text = saveText;
        cell.detailLab.textColor = [UIColor lightGrayColor];
        [self changeMyInfoWithParameters:@{@"member_nick":saveText}];
    }
    
}

-(void)descViewController:(CXDescViewController *)descViewController saveText:(NSString *)saveText{
    _user.member_intro = saveText;
    CXUserInfoTableViewCell * cell = [_userInfoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.detailLab.text = saveText;
    cell.detailLab.textColor = [UIColor lightGrayColor];
    [self changeMyInfoWithParameters:@{@"member_intro":saveText}];
}

- (void)updateBirthdayWithTimeString:(NSString *)timeString {
    CXUserInfoTableViewCell * cell = [_userInfoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    cell.detailLab.text = timeString;
    cell.detailLab.textColor = [UIColor lightGrayColor];
    _user.member_birthday = timeString;
    [self changeMyInfoWithParameters:@{@"member_birthday":timeString}];
    
}


-(void)selectView:(SelectView *)selectView index:(NSInteger)index{
    if (selectView.myTag == 10) {
        //头像
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
        if (index == 0) {
            
            if (![UIImagePickerController isSourceTypeAvailable:type]) {
                
                [Message showMessageWithConfirm:NO title:@"该设备没有相机"];
                return;
            }
        }
        else {
            
            type = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = self;
        pickerController.sourceType = type;
        pickerController.allowsEditing = YES;
        [self presentViewController:pickerController animated:YES completion:nil];
    }
    else if (selectView.myTag == 11) {
        //性别
        CXUserInfoTableViewCell * cell = [_userInfoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        if (index == 0) {
            
            [self changeMyInfoWithParameters:@{@"member_sex":@1}];
            _user.member_sex =@"1";
            cell.detailLab.text = @"男";
        }
        else if (index == 1){
            cell.detailLab.text = @"女";
            _user.member_sex =@"2";
            [self changeMyInfoWithParameters:@{@"member_sex":@2}];
        }
        else{
            cell.detailLab.text = @"保密";
            _user.member_sex =@"0";
            [self changeMyInfoWithParameters:@{@"member_sex":@0}];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    UIImage * headImg = info[UIImagePickerControllerEditedImage];
    NSData * headImgData = [self resetSizeOfImageData:headImg maxSize:1000];
    [CXHomeRequest getAliyunToken:@{@"type":@"member_avatar",@"num_files":@(1)} success:^(id response) {
        if ([response[@"code"] intValue] == 0) {
            [OSSLog enableLog];
            NSString * endPoint = response[@"data"][@"endpoint"];
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:response[@"data"][@"Credentials"][@"AccessKeyId"] secretKeyId:response[@"data"][@"Credentials"][@"AccessKeySecret"] securityToken:response[@"data"][@"Credentials"][@"SecurityToken"]];
            OSSClientConfiguration * conf = [OSSClientConfiguration new];
            conf.maxRetryCount = 3;
            conf.timeoutIntervalForRequest = 30;
            conf.timeoutIntervalForResource = 24 * 60 * 60;
            OSSClient * client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
            [self uploadImageAsyncWithData:headImgData andResponse:response andClient:client  andImageType:@"member_avatar"];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

// 异步上传
- (void)uploadImageAsyncWithData:(NSData *)uploadData andResponse:(NSDictionary *)response andClient:(OSSClient*)client andImageType:(NSString*)imageType{
    
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
            imageUrl = [NSString stringWithFormat:@"%@/%@%@.png",response[@"data"][@"previewHost"],response[@"data"][@"uploadFile"][@"savePath"],response[@"data"][@"uploadFile"][@"saveFileNames"][0]];
            if ([imageType isEqualToString:@"member_avatar"]) {
                [self changeMyInfoWithParameters:@{@"member_avatar":imageUrl}];
            }
            
            
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                [_conTable reloadData];
            //            });
            
        }
        else
        {
            
            
            
        }
        return nil;
    }];
    
    //同步上传（去掉就是异步）因为我上传的文件有多种包括音视频,图片。而且OSS这边是每上传成功一个文件都要回调一次。比如我成功上传5张图片，那么就要回调5次。所以这个时候我就无法判断文件是否都上传完成。所以我就把这些上传的文件放在调度组里面，这样所有文件上传成功后我这边就知道了。如果上传放在调度组里，那么这里的同步上传就必须加上。
    [putTask waitUntilFinished];
    
    //上传进度
    request.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        
    };
    
}

-(void)changeMyInfoWithParameters:(NSDictionary *)dic{
    /*
     头像：'member_avatar',
     昵称：'member_nick',
     简介：'member_intro',
     生日：'member_birthday',（例如：2011-02-03）
     性别：'member_sex',
     邮箱：'member_email'
     */
    
    [CXHomeRequest changeMyInfoWithParameters:@{@"data":[PPNetworkCache dataWithJSONObject:dic]} success:^(id response) {
        
    } failure:^(NSError *error) {
        
    }];
}


-(UITableView *)userInfoTable{
    if (!_userInfoTable) {
        _userInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KWidth, KHeight- kTopHeight) style:UITableViewStyleGrouped];
        _userInfoTable.delegate = self;
        _userInfoTable.dataSource =self;
        _userInfoTable.rowHeight = 45;
        [_userInfoTable registerClass:[CXUserInfoTableViewCell class] forCellReuseIdentifier:@"infoCell"];
        [_userInfoTable registerClass:[CXUserAvatarTableViewCell class] forCellReuseIdentifier:@"avatarCell"];
        _userInfoTable.estimatedRowHeight = 0;
        _userInfoTable.estimatedSectionHeaderHeight = 0;
        _userInfoTable.estimatedSectionFooterHeight = 0;
    }
    return _userInfoTable;
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
