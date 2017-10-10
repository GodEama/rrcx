//
//  MeterLavel.h
//  AVAudioRecord
//
//  Created by Jax on 16/6/15.
//  Copyright © 2016年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeterLavel : NSObject

@property (nonatomic, assign, readonly) float level;
@property (nonatomic, assign, readonly) float peakLevel;

+ (instancetype)levelsWithLevel:(float)level peakLevel:(float)peakLevel;
- (instancetype)initWithLevel:(float)level peakLevel:(float)peakLevel;

@end
