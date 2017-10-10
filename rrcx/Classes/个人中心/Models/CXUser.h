//
//  CXUser.h
//  rrcx
//
//  Created by 123 on 2017/9/13.
//  Copyright © 2017年 123. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXUser : NSObject
/*
 
 "member_id": "22",
 "member_avatar": "http://rrcx-upload.oss-cn-qingdao.aliyuncs.com/upload/member/avatar/avatar_22.jpeg",
 "member_mobile": "18638781763",
 "member_nick": "zongxun1763",
 "member_intro": "简介",
 "member_province_id": "1",
 "hy_id": "1",
 "member_birthday": "2001-04-16",
 "member_realname": "姓名",
 "member_sex": "1",
 "member_follows": "0",
 "member_focus": "3",
 "member_city_id": "0",
 "member_cityName": "北京",
 "hy_name": "法律"
 "article_count": "0",
 "microblog_count": "0"
 */


@property (nonatomic,copy) NSString *member_id;
@property (nonatomic,copy) NSString *member_avatar;
@property (nonatomic,copy) NSString *member_mobile;
@property (nonatomic,copy) NSString *member_nick;
@property (nonatomic,copy) NSString *member_intro;
@property (nonatomic,assign) NSInteger *member_province_id;
@property (nonatomic,assign) NSInteger *hy_id;
@property (nonatomic,copy) NSString *member_birthday;
@property (nonatomic,copy) NSString *member_realname;
@property (nonatomic,copy) NSString *member_sex;
@property (nonatomic,copy) NSString *member_follows;
@property (nonatomic,copy) NSString *member_focus;
@property (nonatomic,copy) NSString *member_city_id;
@property (nonatomic,copy) NSString *member_cityName;
@property (nonatomic,copy) NSString *hy_name;
@property (nonatomic,copy) NSString *article_count;
@property (nonatomic,copy) NSString *microblog_count;
@property (nonatomic,copy) NSString *homepage_visit_count;

@end
