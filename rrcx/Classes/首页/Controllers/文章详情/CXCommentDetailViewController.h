//
//  CXCommentDetailViewController.h
//  rrcx
//
//  Created by 123 on 2017/9/22.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXComment.h"
@interface CXCommentDetailViewController : UIViewController

@property (nonatomic,copy) NSString *articleId;

@property (nonatomic,copy) NSString *blogId;

@property (nonatomic,copy) NSString *commentId;
@property (nonatomic,assign) NSInteger type ;
@property (nonatomic,strong) CXComment * comment;
@end
