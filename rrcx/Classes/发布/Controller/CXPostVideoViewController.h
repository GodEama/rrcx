//
//  CXPostVideoViewController.h
//  rrcx
//
//  Created by 123 on 2017/9/5.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface CXPostVideoViewController : UIViewController
typedef NS_ENUM(NSInteger,loadVideoType){
    localLoadVideoType = 0,
    netLoadVideoType = 1
};
@property (nonatomic, assign) NSInteger loadVideoType;
@property (nonatomic, copy)   NSString * articleID;
@property (nonatomic, strong) PHAsset * asset;

@end
