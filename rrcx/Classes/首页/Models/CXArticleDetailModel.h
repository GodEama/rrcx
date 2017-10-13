//
//  CXArticleDetail.h
//  rrcx
//
//  Created by 123 on 2017/9/19.
//  Copyright © 2017年 123. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXAuthInfo.h"
@interface CXArticleDetailModel : NSObject
@property (nonatomic,copy) NSString *hits;
@property (nonatomic,copy) NSString *num_share;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *sc_probation;
@property (nonatomic,copy) NSString *hy_id;
@property (nonatomic,copy) NSString *microblog_content;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *bigsort;
@property (nonatomic,copy) NSString *  add_time;
@property (nonatomic,copy) NSString * digest;
@property (nonatomic,copy) NSString * commend_flag;
@property (nonatomic,copy) NSString * cat_id;
@property (nonatomic,copy) NSArray * con_list;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSArray *cover_images;
@property (nonatomic,copy) NSString *num_look;
@property (nonatomic,copy) NSString *ad_point_all;
@property (nonatomic,copy) NSString *daily_voice;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSArray *images;
@property (nonatomic,copy) NSString *top;
@property (nonatomic,copy) NSString *is_sc;
@property (nonatomic,copy) NSString *video;
@property (nonatomic,copy) NSArray *voices;
@property (nonatomic,copy) NSArray *goods_list;
@property (nonatomic,copy) NSString *num_up;
@property (nonatomic,copy) NSString *is_original;
@property (nonatomic,copy) NSString *member_id;

@property (nonatomic,copy) NSString *num_down;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *ad_point;
@property (nonatomic,copy) NSString *num_comment;
@property (nonatomic,copy) NSString *area_city;
@property (nonatomic,copy) NSString *cause;
@property (nonatomic,copy) NSString *area_province;
@property (nonatomic,copy) NSString *del_time;

@property (nonatomic,copy) NSString *addr;
@property (nonatomic,copy) NSString *contenturl;
@property (nonatomic,strong) CXAuthInfo * authorInfo;
@property (nonatomic,copy) NSString * islike;
@property (nonatomic,copy) NSString *iscollect;
@property (nonatomic,copy) NSString *ishits;
@property (nonatomic,copy) NSString *detailsurl;
@end
