//
//  YMCoverSelectViewController.h
//  YunMuFocus
//
//  Created by apple on 2017/4/19.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMCoverSelectViewController : UIViewController
@property (nonatomic , retain) NSArray * conArray;
@property (nonatomic,retain) NSArray * coverImageUrls;

@property (nonatomic, copy) BOOL (^saveButtonIsDissMiss)(NSArray *selecedPhotoUrls);
@end
