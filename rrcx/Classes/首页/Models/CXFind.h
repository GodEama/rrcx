//
//  CXFind.h
//  rrcx
//
//  Created by 123 on 2017/9/12.
//  Copyright © 2017年 123. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXFind : NSObject


@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *bigsort;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *member_avatar;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *member_nick;
@property (nonatomic,copy) NSArray *cover_images;
@property (nonatomic,assign) NSInteger num_look;
@property (nonatomic,assign) NSInteger num_comment;
@property (nonatomic,copy) NSArray *images;
@property (nonatomic,copy) NSString *hits;
@property (nonatomic,copy) NSString *add_time;
@property (nonatomic,copy) NSString *member_id;
@property (nonatomic,assign) NSInteger num_share;
@property (nonatomic,copy) NSString *microblog_content;
@property (nonatomic,copy) NSString *iscollect;
@property (nonatomic,copy) NSString *cat_id;

@property (nonatomic,assign) NSInteger num_up;
@property (nonatomic,copy) NSString *islike;



@end
