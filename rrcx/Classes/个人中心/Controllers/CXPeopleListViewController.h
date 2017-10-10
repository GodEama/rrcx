//
//  CXPeopleListViewController.h
//  rrcx
//
//  Created by 123 on 2017/9/26.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    peopleListTypeMyFans = 0,                       //粉丝列表
    peopleListTypeMyFollows = 1,                   //关注列表
   
    
}peopleListType;
@interface CXPeopleListViewController : UIViewController
@property(nonatomic, copy) NSString * member_id;
@property (nonatomic,assign) peopleListType listType;
@end
