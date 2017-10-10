//
//  MeterView.h
//  AVAudioRecord
//
//  Created by Jax on 16/6/15.
//  Copyright © 2016年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeterView : UIView

@property (nonatomic, assign) CGFloat level;
@property (nonatomic, assign) CGFloat peakLevel;

- (void)resetMeterLevel;

@end
