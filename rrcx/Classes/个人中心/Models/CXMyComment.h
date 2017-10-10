//
//  CXMyComment.h
//  rrcx
//
//  Created by 123 on 2017/9/29.
//  Copyright © 2017年 123. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXMyComment : NSObject
/*
 "comm_id" : "0",
 "num_up" : "0",
 "source" : "",
 "id" : "40",
 "con" : "5756uygjgh",
 "msg_look" : "0",
 "member_id" : "38",
 "article_id" : "269",
 "num_comment" : "0",
 "to_id" : "38",
 "add_time" : "2017-09-23"
 */
@property (nonatomic,copy) NSString *comm_id;
@property (nonatomic,copy) NSString *num_up;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *con;
@property (nonatomic,copy) NSString *msg_look;
@property (nonatomic,copy) NSString *member_id;
@property (nonatomic,copy) NSString *article_id;
@property (nonatomic,copy) NSString *num_comment;
@property (nonatomic,copy) NSString *to_id;
@property (nonatomic,copy) NSString *add_time;

@end
