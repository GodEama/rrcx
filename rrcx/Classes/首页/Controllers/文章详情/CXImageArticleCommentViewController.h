//
//  CXImageArticleCommentViewController.h
//  rrcx
//
//  Created by 123 on 2017/9/28.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXArticleDetailModel.h"
@interface CXImageArticleCommentViewController : UIViewController
@property (nonatomic,copy) NSString * articleId;
@property (nonatomic,strong) CXArticleDetailModel * articleModel;

@end
