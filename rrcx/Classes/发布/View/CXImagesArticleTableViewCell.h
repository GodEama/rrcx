//
//  CXImagesArticleTableViewCell.h
//  rrcx
//
//  Created by 123 on 2017/9/7.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXImageItem.h"
@interface CXImagesArticleTableViewCell : UITableViewCell
@property (nonatomic, strong) CXImageItem * model;
@property (nonatomic,strong) UIButton * addBtn;
@property (nonatomic,strong) UIButton * textBtn;
@property (nonatomic,strong) UIButton * upBtn;
@property (nonatomic,strong) UIButton * downBtn;
@property (nonatomic,strong) UIButton * deleteBtn;
@property (nonatomic,copy) void(^addImageBlock)();
@property (nonatomic,copy) NSString * (^editTextBlock)();
@end
