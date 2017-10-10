//
//  MeterView.m
//  AVAudioRecord
//
//  Created by Jax on 16/6/15.
//  Copyright © 2016年 Jax. All rights reserved.
//

#import "MeterView.h"

@interface MeterView()


@end

@implementation MeterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextMoveToPoint(context, 0, 140);
    
    CGFloat width = rect.size.width / 100.0;
    
    
    for (int i = 0; i < 100; i ++) {
        CGContextMoveToPoint(context, i * width, (1 - self.level) * 140);
        i ++;
        CGContextAddLineToPoint(context, i * width, (1 - self.peakLevel) * 140);
        CGContextStrokePath(context);
    }
    
    for (int i = 1; i < 100; i ++) {
        CGContextMoveToPoint(context, i * width, (1 - self.peakLevel) * 140);
        i ++;
        CGContextAddLineToPoint(context, i * width, (1 - self.level) * 140);
        CGContextStrokePath(context);
    }

}


- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)resetMeterLevel {
    self.level = 0.0f;
    self.peakLevel = 0.0f;
    [self setNeedsDisplay];
}


@end
