//
//  CXSelectImagesCoverViewController.h
//  rrcx
//
//  Created by 123 on 2017/9/20.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXSelectImagesCoverViewController : UIViewController
@property (nonatomic , retain) NSArray * conArray;
@property (nonatomic,retain) NSArray * coverImageUrls;
@property (nonatomic,copy) NSString * currentCoverImageUrl;

@property (nonatomic, copy) BOOL (^saveButtonIsDissMiss)(NSString *selecedPhotoUrl);
@end
