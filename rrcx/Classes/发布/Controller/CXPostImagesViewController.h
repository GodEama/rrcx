//
//  CXPostImagesViewController.h
//  rrcx
//
//  Created by 123 on 2017/9/5.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXPostImagesViewController : UIViewController
@property (nonatomic, copy) NSString * titleText;

typedef NS_ENUM(NSInteger,loadImagesType){
    localLoadImagesType = 0,
    netLoadImagesType = 1
};
@property (nonatomic, assign) NSInteger loadImagesType;
@property (nonatomic, copy)   NSString * articleID;
@property (nonatomic, copy)   NSArray * firstAsset;
@end
