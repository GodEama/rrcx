//
//  CXComment.h
//  rrcx
//
//  Created by 123 on 2017/9/21.
//  Copyright © 2017年 123. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXComment : NSObject
/*
 "comm_id" : "0",
 "num_up" : "0",
 "id" : "35",
 "con" : "The only thing I don't like is the ",
 "msg_look" : "0",
 "member_id" : "38",
 "article_id" : "204",
 "num_comment" : "0",
 "to_id" : "32",
 "add_time" : "1505984930"

 */

@property (nonatomic,copy) NSString *comm_id;
@property (nonatomic,copy) NSString *num_up;
@property (nonatomic,copy) NSString *con;
@property (nonatomic,copy) NSString *msg_look;
@property (nonatomic,copy) NSString *member_id;
@property (nonatomic,copy) NSString *article_id;
@property (nonatomic,copy) NSString *num_comment;
@property (nonatomic,copy) NSString *to_id;
@property (nonatomic,copy) NSString *add_time;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *member_avatar;

@property (nonatomic,copy) NSString *member_nick;
@property (nonatomic,copy) NSArray *images;
@property (nonatomic,copy) NSString *islike;
@end
