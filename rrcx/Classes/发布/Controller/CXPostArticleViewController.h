//
//  CXPostArticleViewController.h
//  rrcx
//
//  Created by 123 on 2017/9/4.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXPostArticleViewController : UIViewController
@property (nonatomic, copy) NSString * titleText;

typedef NS_ENUM(NSInteger,loadType){
    localLoadType = 0,
    netLoadType = 1
};
@property (nonatomic, assign) NSInteger loadType;
@property (nonatomic, copy)   NSString * articleID;
@end
