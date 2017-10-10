//
//  JCWebProgressLayer.h
//  JingleCat
//
//  Created by apple on 2017/7/31.
//  Copyright © 2017年 Henan jingle cats electronic commerce co., LTD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface JCWebProgressLayer : CAShapeLayer

+ (instancetype)layerWithFrame:(CGRect)frame;

- (void)finishedLoad;
- (void)startLoad;

- (void)closeTimer;

@end
