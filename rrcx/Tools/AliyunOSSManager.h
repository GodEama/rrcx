//
//  AliyunOSSManager.h
//  rrcx
//
//  Created by 123 on 2017/9/14.
//  Copyright © 2017年 123. All rights reserved.
//

#import <Foundation/Foundation.h>
//上传类型

//article_image,member_avatar,microblog_image,article_voice,microblog_voice,article_video,microblog_video
typedef enum {
    article_image = 0,                       //文章图片
    member_avatar = 1,                        //用户头像
    microblog_image = 2,                       //动态中的图片
    article_voice = 3,                        //文章语音
    microblog_voice = 4,                        //动态中的语音
    article_video = 5,                          //文章视频
    microblog_video = 6,                        //动态中的视频
    
}mimeType;
@interface AliyunOSSManager : NSObject
@property(nonatomic,strong)NSDictionary *responseObject;
@property(nonatomic,assign)mimeType uploadType;
@property(nonatomic,copy) NSString* endPoint;
+ (instancetype)sharedInstance;
- (void)setupEnvironment;
- (void)initOSSClientWithUploadType:(mimeType)uploadType andNumFiles:(NSInteger)numFiles andData:(NSData *)uploadData;
- (void)uploadObjectAsyncWith:(NSData *)uploadData withObjectKey:(NSString *)objectKey withAlbumNumber:(NSString *)number;

- (void)uploadObjectAsyncWithData:(NSData *)uploadData;
@end
