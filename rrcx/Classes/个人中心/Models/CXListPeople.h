//
//  CXListPeople.h
//  rrcx
//
//  Created by 123 on 2017/9/26.
//  Copyright © 2017年 123. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXListPeople : NSObject
/*
 "member_id": "32",
 "member_avatar": "http://rrcx-upload1.oss-cn-beijing.aliyuncs.com/upload/member/avatar/20170923/59c62d306c1e5.jpg",
 "member_nick": "隔壁老王",
 "member_intro": "隔壁老王",
 "auth_vip": "0",
 "is_followed": true
 */
@property (nonatomic,copy) NSString *member_id;
@property (nonatomic,copy) NSString *member_avatar;
@property (nonatomic,copy) NSString *member_nick;
@property (nonatomic,copy) NSString *member_intro;
@property (nonatomic,assign) BOOL is_followed;
@property (nonatomic,copy) NSString *auth_vip;
@property (nonatomic,copy) NSString *add_time;

@end
