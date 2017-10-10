//
//  YMEditArticleViewController.h
//  YunMuFocus
//
//  Created by apple on 2017/4/18.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMEditArticleViewController : UIViewController
typedef NS_ENUM(NSInteger, contentType){
    titleType = 0,
    ArticleContentType = 1,
};
@property (nonatomic, copy) NSString * contentText;
@property (nonatomic, copy) BOOL (^saveButtonIsDissMiss)(NSString *saveText);
@property (nonatomic, assign) NSInteger contentType;
@end
