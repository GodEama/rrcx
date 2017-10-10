//
//  CXMineServiceTableViewCell.h
//  rrcx
//
//  Created by 123 on 2017/9/5.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXMineServiceTableViewCell : UITableViewCell
@property (nonatomic, copy) void(^switchServiceBlock)(BOOL isOn);
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UISwitch * serviceSwitch;
@property (nonatomic, strong) UILabel * hintLab;
@end
