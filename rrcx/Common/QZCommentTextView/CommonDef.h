//
//  CommonDef.h
//  QZCommentTextViewDemo
//
//  Created by MrYu on 16/8/20.
//  Copyright © 2016年 yu qingzhu. All rights reserved.
//

#ifndef CommonDef_h
#define CommonDef_h

#import "UIView+Extension.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

// 16进制颜色转RGB
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 适配函数
#define CONVERT_SCALE(x) (x)/2
#define ConvertTo6_W(x) (CONVERT_SCALE(x)*320)/375
#define ConvertTo6_H(x) (CONVERT_SCALE(x)*568)/667
#define CT_SCALE_X      SCREEN_WIDTH/320.0
#define CT_SCALE_Y      SCREEN_HEIGHT/568.0

#endif /* CommonDef_h */
