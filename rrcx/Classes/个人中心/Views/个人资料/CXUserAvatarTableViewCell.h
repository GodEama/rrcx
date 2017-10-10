//
//  CXUserAvatarTableViewCell.h
//  rrcx
//
//  Created by 123 on 2017/9/11.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXUserAvatarTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,copy)   NSString * imgUrl;
@end
