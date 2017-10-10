//
//  MeterLavel.m
//  AVAudioRecord
//
//  Created by Jax on 16/6/15.
//  Copyright © 2016年 Jax. All rights reserved.
//

#import "MeterLavel.h"

@implementation MeterLavel

+ (instancetype)levelsWithLevel:(float)level peakLevel:(float)peakLevel {
    return [[self alloc] initWithLevel:level peakLevel:peakLevel];
}

- (instancetype)initWithLevel:(float)level peakLevel:(float)peakLevel {
    self = [super init];
    if (self) {
        _level = level;
        _peakLevel = peakLevel;
    }
    return self;
}

@end
