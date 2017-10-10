//
//  CXCommentTableViewCell.h
//  rrcx
//
//  Created by 123 on 2017/9/21.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXComment.h"
@interface CXCommentTableViewCell : UITableViewCell
@property (nonatomic,strong) CXComment * commentModel;
@property (nonatomic,copy) void(^avatarBtnClickBlock)(void);
@property (nonatomic,copy) void(^zanCommentBlock)(void);
@property (nonatomic,copy) void(^replyCommentClickBlock)(void);
@property (nonatomic,strong) UIButton * zanBtn;

@property (nonatomic,assign) BOOL isLike;
@property (nonatomic,assign) NSInteger num_up;

-(void)setCommentModel:(CXComment *)commentModel;
@end
