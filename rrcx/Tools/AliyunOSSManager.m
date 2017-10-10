//
//  AliyunOSSManager.m
//  rrcx
//
//  Created by 123 on 2017/9/14.
//  Copyright © 2017年 123. All rights reserved.
//

#import "AliyunOSSManager.h"
#import <AliyunOSSiOS/OSSService.h>
#import "AFNetworking.h"
NSString * const multipartUploadKey = @"multipartUploadObject";


OSSClient * client;
static dispatch_queue_t queue4demo;
@interface AliyunOSSManager ()
//获取token返回的json数据

@property (assign, nonatomic) int age;
@end
@implementation AliyunOSSManager



+ (instancetype)sharedInstance {
    static AliyunOSSManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [AliyunOSSManager new];
    });
    return instance;
}

- (void)setupEnvironment {
    // 打开调试log
    [OSSLog enableLog];
    
    // 在本地生成一些文件用来演示
    [self initLocalFile];
    
    // 初始化sdk
    
}

- (void)runDemo {
    /*************** 以下每个方法调用代表一个功能的演示，取消注释即可运行 ***************/
    
    // 罗列Bucket中的Object
    // [self listObjectsInBucket];
    
    // 异步上传文件
    // [self uploadObjectAsync];
    
    // 同步上传文件
    // [self uploadObjectSync];
    
    // 异步下载文件
    // [self downloadObjectAsync];
    
    // 同步下载文件
    // [self downloadObjectSync];
    
    // 复制文件
    // [self copyObjectAsync];
    
    // 签名Obejct的URL以授权第三方访问
    // [self signAccessObjectURL];
    
    // 分块上传的完整流程
    // [self multipartUpload];
    
    // 只获取Object的Meta信息
    // [self headObject];
    
    // 罗列已经上传的分块
    // [self listParts];
    
    // 自行管理UploadId的分块上传
    // [self resumableUpload];
}

// get local file dir which is readwrite able
- (NSString *)getDocumentDirectory {
    NSString * path = NSHomeDirectory();
    NSLog(@"NSHomeDirectory:%@",path);
    NSString * userName = NSUserName();
    NSString * rootPath = NSHomeDirectoryForUser(userName);
    NSLog(@"NSHomeDirectoryForUser:%@",rootPath);
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

// create some random file for demo cases
- (void)initLocalFile {
    NSFileManager * fm = [NSFileManager defaultManager];
    NSString * mainDir = [self getDocumentDirectory];
    
    NSArray * fileNameArray = @[@"file1k", @"file10k", @"file100k", @"file1m", @"file10m", @"fileDirA/", @"fileDirB/"];
    NSArray * fileSizeArray = @[@1024, @10240, @102400, @1024000, @10240000, @1024, @1024];
    
    NSMutableData * basePart = [NSMutableData dataWithCapacity:1024];
    for (int i = 0; i < 1024/4; i++) {
        u_int32_t randomBit = arc4random();
        [basePart appendBytes:(void*)&randomBit length:4];
    }
    
    for (int i = 0; i < [fileNameArray count]; i++) {
        NSString * name = [fileNameArray objectAtIndex:i];
        long size = [[fileSizeArray objectAtIndex:i] longValue];
        NSString * newFilePath = [mainDir stringByAppendingPathComponent:name];
        if ([fm fileExistsAtPath:newFilePath]) {
            [fm removeItemAtPath:newFilePath error:nil];
        }
        [fm createFileAtPath:newFilePath contents:nil attributes:nil];
        NSFileHandle * f = [NSFileHandle fileHandleForWritingAtPath:newFilePath];
        for (int k = 0; k < size/1024; k++) {
            [f writeData:basePart];
        }
        [f closeFile];
    }
    NSLog(@"main bundle: %@", mainDir);
}

- (void)initOSSClientWithUploadType:(mimeType)uploadType andNumFiles:(NSInteger)num_files andData:(NSData *)uploadData {
    
//    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:@"AccessKeyId" secretKeyId:@"AccessKeySecret" securityToken:@"SecurityToken"];
    
    
//    // 自实现签名，可以用本地签名也可以远程加签
//    id<OSSCredentialProvider> credential1 = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
//        NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:@"<your secret key>"];
//        if (signature != nil) {
//            *error = nil;
//        } else {
//            // construct error object
//            *error = [NSError errorWithDomain:@"<your error domain>" code:OSSClientErrorCodeSignFailed userInfo:nil];
//            return nil;
//        }
//        return [NSString stringWithFormat:@"OSS %@:%@", @"<your access key>", signature];
//    }];
    
    // Federation鉴权，建议通过访问远程业务服务器获取签名
    // 假设访问业务服务器的获取token服务时，返回的数据格式如下：
    // {"accessKeyId":"STS.iA645eTOXEqP3cg3VeHf",
    // "accessKeySecret":"rV3VQrpFQ4BsyHSAvi5NVLpPIVffDJv4LojUBZCf",
    // "expiration":"2015-11-03T09:52:59Z[;",
    // "federatedUser":"335450541522398178:alice-001",
    // "requestId":"C0E01B94-332E-4582-87F9-B857C807EE52",
    // "securityToken":"CAES7QIIARKAAZPlqaN9ILiQZPS+JDkS/GSZN45RLx4YS/p3OgaUC+oJl3XSlbJ7StKpQp1Q3KtZVCeAKAYY6HYSFOa6rU0bltFXAPyW+jvlijGKLezJs0AcIvP5a4ki6yHWovkbPYNnFSOhOmCGMmXKIkhrRSHMGYJRj8AIUvICAbDhzryeNHvUGhhTVFMuaUE2NDVlVE9YRXFQM2NnM1ZlSGYiEjMzNTQ1MDU0MTUyMjM5ODE3OCoJYWxpY2UtMDAxMOG/g7v6KToGUnNhTUQ1QloKATEaVQoFQWxsb3cSHwoMQWN0aW9uRXF1YWxzEgZBY3Rpb24aBwoFb3NzOioSKwoOUmVzb3VyY2VFcXVhbHMSCFJlc291cmNlGg8KDWFjczpvc3M6KjoqOipKEDEwNzI2MDc4NDc4NjM4ODhSAFoPQXNzdW1lZFJvbGVVc2VyYABqEjMzNTQ1MDU0MTUyMjM5ODE3OHIHeHljLTAwMQ=="}
    //STS鉴权模式
//    NSString *mobile = @"13715006982";
//    NSString  *secretString = [NSString stringWithFormat:@"%@",mobile];
    
    //直接设置StsToken
    if (self.responseObject) {
        self.endPoint = self.responseObject[@"data"][@"endpoint"];
        id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:self.responseObject[@"data"][@"Credentials"][@"AccessKeyId"] secretKeyId:self.responseObject[@"data"][@"Credentials"][@"AccessKeySecret"] securityToken:self.responseObject[@"data"][@"Credentials"][@"SecurityToken"]];
        OSSClientConfiguration * conf = [OSSClientConfiguration new];
        conf.maxRetryCount = 3;
        conf.timeoutIntervalForRequest = 30;
        conf.timeoutIntervalForResource = 24 * 60 * 60;
        client = [[OSSClient alloc] initWithEndpoint:_endPoint credentialProvider:credential clientConfiguration:conf];
        [self uploadObjectAsyncWithData:uploadData];
    }
    else{
        NSString * type = @"article_image";
        switch (uploadType) {
            case article_image:
                type = @"article_image";
                break;
            case member_avatar:
                type = @"member_avatar";
                break;
            case microblog_image:
                type = @"microblog_image";
                break;
            case article_voice:
                type = @"article_voice";
                break;
            case microblog_voice:
                type = @"microblog_voice";
                break;
            case article_video:
                type = @"article_video";
                break;
            case microblog_video:
                type = @"microblog_video";
                break;
                
            default:
                break;
        }
        
        [CXHomeRequest getAliyunToken:@{@"type":type,@"num_files":@(num_files)} success:^(id response) {
            self.responseObject = response;
            self.endPoint = self.responseObject[@"data"][@"endpoint"];
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:self.responseObject[@"data"][@"Credentials"][@"AccessKeyId"] secretKeyId:self.responseObject[@"data"][@"Credentials"][@"AccessKeySecret"] securityToken:self.responseObject[@"data"][@"Credentials"][@"SecurityToken"]];
            OSSClientConfiguration * conf = [OSSClientConfiguration new];
            conf.maxRetryCount = 3;
            conf.timeoutIntervalForRequest = 30;
            conf.timeoutIntervalForResource = 24 * 60 * 60;
            client = [[OSSClient alloc] initWithEndpoint:_endPoint credentialProvider:credential clientConfiguration:conf];
            [self uploadObjectAsyncWithData:uploadData];
        } failure:^(NSError *error) {
            if (error) {
                
                return ;
            }
        }];
    }
    
//    id<OSSCredentialProvider> credential2 = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
//        OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
    
//        NSString *string = @"//////////////////";
//        NSDictionary *dict = @{@"mobile":mobile,@"sign":secretString};
//
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
//        //设置信任CA证书 在https传输情况下需要设置
//        AFSecurityPolicy * policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        policy.allowInvalidCertificates = YES;
//        policy.validatesDomainName = NO;
//        manager.securityPolicy = policy;
//        NSString* deviceName = [[UIDevice currentDevice] systemName];
//        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//        
//        [PPNetworkHelper setValue:TOKEN?:@"" forHTTPHeaderField:@"Auth-Token"];
//        [PPNetworkHelper setValue:app_Version forHTTPHeaderField:@"APP-Version"];
//        [PPNetworkHelper setValue:@"ios" forHTTPHeaderField:@"Device-Type"];
//        [PPNetworkHelper setValue:deviceName forHTTPHeaderField:@"Device-Name"];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
//        [manager POST:string parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"%@",responseObject);
//            
//            self.responseObject = responseObject;
//            [tcs setResult:responseObject];
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"%@",error);
//            if (error) {
//                [tcs setError:error];
//                return;
//            }
//        }];
        
        //article_image,member_avatar,microblog_image,article_voice,microblog_voice,article_video,microblog_video
//        NSString * type = @"article_image";
//        switch (uploadType) {
//            case article_image:
//                type = @"article_image";
//                break;
//            case member_avatar:
//                type = @"member_avatar";
//                break;
//            case microblog_image:
//                type = @"microblog_image";
//                break;
//            case article_voice:
//                type = @"article_voice";
//                break;
//            case microblog_voice:
//                type = @"microblog_voice";
//                break;
//            case article_video:
//                type = @"article_video";
//                break;
//            case microblog_video:
//                type = @"microblog_video";
//                break;
//                
//            default:
//                break;
//        }
//        
//        [CXHomeRequest getAliyunToken:@{@"type":type,@"num_fiels":@(numFiles)} success:^(id response) {
//            NSLog(@"%@",response);
//            
//            self.responseObject = response;
//            [tcs setResult:response];
//        } failure:^(NSError *error) {
//            if (error) {
//                [tcs setError:error];
//                return ;
//            }
//        }];
//        //同步
//        [tcs.task waitUntilFinished];
//        
//        if (tcs.task.error) {
//            NSLog(@"get token error: %@", tcs.task.error);
//            return nil;
//        }
//        else {
//            //获取token返回的参数
//            OSSFederationToken * token = [OSSFederationToken new];
//            token.tAccessKey = self.responseObject[@"data"][@"Credentials"][@"AccessKeyId"];
//            token.tSecretKey = self.responseObject[@"data"][@"Credentials"][@"AccessKeySecret"];
//            token.tToken = self.responseObject[@"data"][@"Credentials"][@"SecurityToken"];
//            token.expirationTimeInGMTFormat = self.responseObject[@"data"][@"Credentials"][@"Expiration"];
//            
//            self.endPoint = self.responseObject[@"data"][@"endpoint"];
//            //NSLog(@"get token: %@\n%@\n%@\n%@\%@", token);
//            return token;
//        }
//        
//    }];
    
    
    
    
//    OSSClientConfiguration * conf = [OSSClientConfiguration new];
//    conf.maxRetryCount = 3;
//    conf.timeoutIntervalForRequest = 30;
//    conf.timeoutIntervalForResource = 24 * 60 * 60;
//    
//    
//    if (!_responseObject) {
//        [self getObjectKeyWithUploadType:uploadType andNumFiles:numFiles andData:uploadData andCredential:credential2 andOSSClientConfiguration:conf];
//    }
//    else{
//        client = [[OSSClient alloc] initWithEndpoint:_endPoint credentialProvider:credential2 clientConfiguration:conf];
//        [self uploadObjectAsyncWithData:uploadData];
//    }
    
}

#pragma mark work with normal interface

- (void)createBucket {
    OSSCreateBucketRequest * create = [OSSCreateBucketRequest new];
    create.bucketName = @"<bucketName>";
    create.xOssACL = @"public-read";
    create.location = @"oss-cn-hangzhou";
    
    OSSTask * createTask = [client createBucket:create];
    
    [createTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"create bucket success!");
        } else {
            NSLog(@"create bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

- (void)deleteBucket {
    OSSDeleteBucketRequest * delete = [OSSDeleteBucketRequest new];
    delete.bucketName = @"<bucketName>";
    
    OSSTask * deleteTask = [client deleteBucket:delete];
    
    [deleteTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"delete bucket success!");
        } else {
            NSLog(@"delete bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

- (void)listObjectsInBucket {
    OSSGetBucketRequest * getBucket = [OSSGetBucketRequest new];
    getBucket.bucketName = @"android-test";
    getBucket.delimiter = @"";
    getBucket.prefix = @"";
    
    
    OSSTask * getBucketTask = [client getBucket:getBucket];
    
    [getBucketTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            OSSGetBucketResult * result = task.result;
            NSLog(@"get bucket success!");
            for (NSDictionary * objectInfo in result.contents) {
                NSLog(@"list object: %@", objectInfo);
            }
        } else {
            NSLog(@"get bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

// 异步上传
- (void)uploadObjectAsyncWithData:(NSData *)uploadData {
    if (!_responseObject) {
        return;
    }
    //上传请求类
    OSSPutObjectRequest * request = [OSSPutObjectRequest new];
    //文件夹名 后台给出
    request.bucketName = self.responseObject[@"data"][@"bucket"];
    //objectKey为文件名 一般自己拼接
    request.objectKey = [NSString stringWithFormat:@"%@%@.png",self.responseObject[@"data"][@"uploadFile"][@"savePath"],self.responseObject[@"data"][@"uploadFile"][@"saveFileNames"][0]];
   
//    request.uploadingFileURL = self.responseObject[@"data"][@"uploadFile"][@"savePath"];
    //上传数据类型为NSData
    request.uploadingData = uploadData;

    OSSTask * putTask = [client putObject:request];
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        if (!task.error) {
            
            //每次上传完一个文件都要回调
            NSLog(@"上传成功!");
            _responseObject = nil;
        } else {
            
            //每上传失败一个文件后都要回调
            NSLog(@"upload object failed, error: %@" , task.error);
            //在即使上传失败后如果不作处理，那么上传时当调度组里面的方法执行了，不管方法执行成功还是失败，最后调度组执行完之后还是要回调，由于回调里只写了成功弹框，所以这里需要加上通知处理上传失败的结果
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"123" object:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
        }
        return nil;
    }];
    
    //同步上传（去掉就是异步）因为我上传的文件有多种包括音视频,图片。而且OSS这边是每上传成功一个文件都要回调一次。比如我成功上传5张图片，那么就要回调5次。所以这个时候我就无法判断文件是否都上传完成。所以我就把这些上传的文件放在调度组里面，这样所有文件上传成功后我这边就知道了。如果上传放在调度组里，那么这里的同步上传就必须加上。
    //[putTask waitUntilFinished];
    
    //上传进度
    request.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        
    };
    
}

// 同步上传
- (void)uploadObjectSync {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    // required fields
    put.bucketName = @"android-test";
    put.objectKey = @"file1m";
    NSString * docDir = [self getDocumentDirectory];
    put.uploadingFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"file1m"]];
    
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask waitUntilFinished]; // 阻塞直到上传完成
    
    if (!putTask.error) {
        NSLog(@"upload object success!");
    } else {
        NSLog(@"upload object failed, error: %@" , putTask.error);
    }
}

// 追加上传

- (void)appendObject {
    OSSAppendObjectRequest * append = [OSSAppendObjectRequest new];
    
    // 必填字段
    append.bucketName = @"android-test";
    append.objectKey = @"file1m";
    append.appendPosition = 0; // 指定从何处进行追加
    NSString * docDir = [self getDocumentDirectory];
    append.uploadingFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"file1m"]];
    
    // 可选字段
    append.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    // append.contentType = @"";
    // append.contentMd5 = @"";
    // append.contentEncoding = @"";
    // append.contentDisposition = @"";
    
    OSSTask * appendTask = [client appendObject:append];
    
    [appendTask continueWithBlock:^id(OSSTask *task) {
        NSLog(@"objectKey: %@", append.objectKey);
        if (!task.error) {
            NSLog(@"append object success!");
            OSSAppendObjectResult * result = task.result;
            NSString * etag = result.eTag;
            long nextPosition = result.xOssNextAppendPosition;
            NSLog(@"etag: %@, nextPosition: %ld", etag, nextPosition);
        } else {
            NSLog(@"append object failed, error: %@" , task.error);
        }
        return nil;
    }];
}

// 异步下载
- (void)downloadObjectAsync {
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    // required
    request.bucketName = @"android-test";
    request.objectKey = @"file1m";
    
    //optional
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    // NSString * docDir = [self getDocumentDirectory];
    // request.downloadToFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"downloadfile"]];
    
    OSSTask * getTask = [client getObject:request];
    
    [getTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"download object success!");
            OSSGetObjectResult * getResult = task.result;
            NSLog(@"download dota length: %lu", [getResult.downloadedData length]);
        } else {
            NSLog(@"download object failed, error: %@" ,task.error);
        }
        return nil;
    }];
}

// 同步下载
- (void)downloadObjectSync {
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    // required
    request.bucketName = @"android-test";
    request.objectKey = @"file1m";
    
    //optional
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    // NSString * docDir = [self getDocumentDirectory];
    // request.downloadToFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"downloadfile"]];
    
    OSSTask * getTask = [client getObject:request];
    
    [getTask waitUntilFinished];
    
    if (!getTask.error) {
        OSSGetObjectResult * result = getTask.result;
        NSLog(@"download data length: %lu", [result.downloadedData length]);
    } else {
        NSLog(@"download data error: %@", getTask.error);
    }
}

// 获取meta
- (void)headObject {
    OSSHeadObjectRequest * head = [OSSHeadObjectRequest new];
    head.bucketName = @"android-test";
    head.objectKey = @"file1m";
    
    OSSTask * headTask = [client headObject:head];
    
    [headTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            OSSHeadObjectResult * headResult = task.result;
            NSLog(@"all response header: %@", headResult.httpResponseHeaderFields);
            
            // some object properties include the 'x-oss-meta-*'s
            NSLog(@"head object result: %@", headResult.objectMeta);
        } else {
            NSLog(@"head object error: %@", task.error);
        }
        return nil;
    }];
}

// 删除Object
- (void)deleteObject {
    OSSDeleteObjectRequest * delete = [OSSDeleteObjectRequest new];
    delete.bucketName = @"android-test";
    delete.objectKey = @"file1m";
    
    OSSTask * deleteTask = [client deleteObject:delete];
    
    [deleteTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"delete success !");
        } else {
            NSLog(@"delete erorr, error: %@", task.error);
        }
        return nil;
    }];
}

// 复制Object
- (void)copyObjectAsync {
    OSSCopyObjectRequest * copy = [OSSCopyObjectRequest new];
    copy.bucketName = @"android-test"; // 复制到哪个bucket
    copy.objectKey = @"file_copy_to"; // 复制为哪个object
    copy.sourceCopyFrom = [NSString stringWithFormat:@"/%@/%@", @"android-test", @"file1m"]; // 从哪里复制
    
    OSSTask * copyTask = [client copyObject:copy];
    
    [copyTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"copy success!");
        } else {
            NSLog(@"copy error, error: %@", task.error);
        }
        return nil;
    }];
}

// 签名URL授予第三方访问
- (void)signAccessObjectURL {
    NSString * constrainURL = nil;
    NSString * publicURL = nil;
    
    // sign constrain url
    OSSTask * task = [client presignConstrainURLWithBucketName:@"<bucket name>"
                                                 withObjectKey:@"<object key>"
                                        withExpirationInterval:60 * 30];
    if (!task.error) {
        constrainURL = task.result;
    } else {
        NSLog(@"error: %@", task.error);
    }
    
    // sign public url
    task = [client presignPublicURLWithBucketName:@"<bucket name>"
                                    withObjectKey:@"<object key>"];
    if (!task.error) {
        publicURL = task.result;
    } else {
        NSLog(@"sign url error: %@", task.error);
    }
}

// 分块上传
- (void)multipartUpload {
    
    __block NSString * uploadId = nil;
    __block NSMutableArray * partInfos = [NSMutableArray new];
    
    NSString * uploadToBucket = @"android-test";
    NSString * uploadObjectkey = @"file20m";
    
    OSSInitMultipartUploadRequest * init = [OSSInitMultipartUploadRequest new];
    init.bucketName = uploadToBucket;
    init.objectKey = uploadObjectkey;
    init.contentType = @"application/octet-stream";
    init.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil];
    
    OSSTask * initTask = [client multipartUploadInit:init];
    
    [initTask waitUntilFinished];
    
    if (!initTask.error) {
        OSSInitMultipartUploadResult * result = initTask.result;
        uploadId = result.uploadId;
        NSLog(@"init multipart upload success: %@", result.uploadId);
    } else {
        NSLog(@"multipart upload failed, error: %@", initTask.error);
        return;
    }
    
    for (int i = 1; i <= 20; i++) {
        @autoreleasepool {
            OSSUploadPartRequest * uploadPart = [OSSUploadPartRequest new];
            uploadPart.bucketName = uploadToBucket;
            uploadPart.objectkey = uploadObjectkey;
            uploadPart.uploadId = uploadId;
            uploadPart.partNumber = i; // part number start from 1
            
            NSString * docDir = [self getDocumentDirectory];
            // uploadPart.uploadPartFileURL = [NSURL URLWithString:[docDir stringByAppendingPathComponent:@"file1m"]];
            uploadPart.uploadPartData = [NSData dataWithContentsOfFile:[docDir stringByAppendingPathComponent:@"file1m"]];
            
            OSSTask * uploadPartTask = [client uploadPart:uploadPart];
            
            [uploadPartTask waitUntilFinished];
            
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
        NSLog(@"multipart upload success!");
    } else {
        NSLog(@"multipart upload failed, error: %@", completeTask.error);
        return;
    }
}

// 罗列分块
- (void)listParts {
    OSSListPartsRequest * listParts = [OSSListPartsRequest new];
    listParts.bucketName = @"android-test";
    listParts.objectKey = @"file3m";
    listParts.uploadId = @"265B84D863B64C80BA552959B8B207F0";
    
    OSSTask * listPartTask = [client listParts:listParts];
    
    [listPartTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"list part result success!");
            OSSListPartsResult * listPartResult = task.result;
            for (NSDictionary * partInfo in listPartResult.parts) {
                NSLog(@"each part: %@", partInfo);
            }
        } else {
            NSLog(@"list part result error: %@", task.error);
        }
        return nil;
    }];
}

// 断点续传
- (void)resumableUpload {
    __block NSString * recordKey;
    
    NSString * docDir = [self getDocumentDirectory];
    NSString * filePath = [docDir stringByAppendingPathComponent:@"file10m"];
    NSString * bucketName = @"android-test";
    NSString * objectKey = @"uploadKey";
    
    [[[[[[OSSTask taskWithResult:nil] continueWithBlock:^id(OSSTask *task) {
        // 为该文件构造一个唯一的记录键
        NSURL * fileURL = [NSURL fileURLWithPath:filePath];
        NSDate * lastModified;
        NSError * error;
        [fileURL getResourceValue:&lastModified forKey:NSURLContentModificationDateKey error:&error];
        if (error) {
            return [OSSTask taskWithError:error];
        }
        recordKey = [NSString stringWithFormat:@"%@-%@-%@-%@", bucketName, objectKey, [OSSUtil getRelativePath:filePath], lastModified];
        // 通过记录键查看本地是否保存有未完成的UploadId
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        return [OSSTask taskWithResult:[userDefault objectForKey:recordKey]];
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        if (!task.result) {
            // 如果本地尚无记录，调用初始化UploadId接口获取
            OSSInitMultipartUploadRequest * initMultipart = [OSSInitMultipartUploadRequest new];
            initMultipart.bucketName = bucketName;
            initMultipart.objectKey = objectKey;
            initMultipart.contentType = @"application/octet-stream";
            return [client multipartUploadInit:initMultipart];
        }
        OSSLogVerbose(@"An resumable task for uploadid: %@", task.result);
        return task;
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        NSString * uploadId = nil;
        
        if (task.error) {
            return task;
        }
        
        if ([task.result isKindOfClass:[OSSInitMultipartUploadResult class]]) {
            uploadId = ((OSSInitMultipartUploadResult *)task.result).uploadId;
        } else {
            uploadId = task.result;
        }
        
        if (!uploadId) {
            return [OSSTask taskWithError:[NSError errorWithDomain:OSSClientErrorDomain
                                                              code:OSSClientErrorCodeNilUploadid
                                                          userInfo:@{OSSErrorMessageTOKEN: @"Can't get an upload id"}]];
        }
        // 将“记录键：UploadId”持久化到本地存储
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:uploadId forKey:recordKey];
        [userDefault synchronize];
        return [OSSTask taskWithResult:uploadId];
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        // 持有UploadId上传文件
        OSSResumableUploadRequest * resumableUpload = [OSSResumableUploadRequest new];
        resumableUpload.bucketName = bucketName;
        resumableUpload.objectKey = objectKey;
        resumableUpload.uploadId = task.result;
        resumableUpload.uploadingFileURL = [NSURL fileURLWithPath:filePath];
        resumableUpload.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            NSLog(@"%lld %lld %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
        };
        return [client resumableUpload:resumableUpload];
    }] continueWithBlock:^id(OSSTask *task) {
        if (task.error) {
            if ([task.error.domain isEqualToString:OSSClientErrorDomain] && task.error.code == OSSClientErrorCodeCannotResumeUpload) {
                // 如果续传失败且无法恢复，需要删除本地记录的UploadId，然后重启任务
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
            }
        } else {
            NSLog(@"upload completed!");
            // 上传成功，删除本地保存的UploadId
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
        }
        return nil;
    }];
}


#pragma mark ==== 同步上传=====
- (void)uploadObjectAsyncWith:(NSData *)uploadData withObjectKey:(NSString *)objectKey withAlbumNumber:(NSString *)number{
    
    
    //上传请求类
    OSSPutObjectRequest * request = [OSSPutObjectRequest new];
    //文件夹名 后台给出
    request.bucketName = self.responseObject[@"data"][@"bucket"];
    //objectKey为文件名 一般自己拼接
    request.objectKey = self.responseObject[@"data"][@"uploadFile"][@"saveFileNames"][0];
    request.uploadingFileURL = self.responseObject[@"data"][@"uploadFile"][@"savePath"];
    //上传数据类型为NSData
    request.uploadingData = uploadData;
    
    
    
    //    //上传回调URL
    //    获取用户ID
    //    NSString *userId = @"13715006982";
    //    NSString *upUrl = @"//////////////";
    //
    //
    //    //不同类型的数据设置不同的文件名 根据文件名可以设置不同类型的回调参数
    //    //头像
    //    if ([objectKey rangeOfString:@"anchorImage"].location != NSNotFound){
    //        //头像上传回调请求体 这里objectKey充当返回给后台URL的后缀
    //        NSString *callBackBody = [NSString stringWithFormat:@"imageUrl=%@&mimeType=headimage&userId=%@",objectKey,userId];
    //        // 设置回调参数
    //        request.callbackParam = @{
    //                                  @"callbackUrl":upUrl,
    //                                  @"callbackBody":callBackBody,
    //                                  @"callbackBodyType":@"application/json"
    //                                  };
    //    }
    
    
    
    OSSTask * putTask = [client putObject:request];
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        if (!task.error) {
            
            //每次上传完一个文件都要回调
            NSLog(@"上传成功!");
        } else {
            
            //每上传失败一个文件后都要回调
            NSLog(@"upload object failed, error: %@" , task.error);
            //在即使上传失败后如果不作处理，那么上传时当调度组里面的方法执行了，不管方法执行成功还是失败，最后调度组执行完之后还是要回调，由于回调里只写了成功弹框，所以这里需要加上通知处理上传失败的结果
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"123" object:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
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

@end
