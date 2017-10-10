//
//  AVAudioSession+Extension.m
//  AVAudioRecord
//
//  Created by Jax on 16/6/15.
//  Copyright © 2016年 Jax. All rights reserved.
//

#import "AVAudioSession+Extension.h"

@implementation AVAudioSession (Extension)

+ (void)setCategory:(NSString *)sessionCategory {
    AVAudioSession *audioSession = [self sharedInstance];
    NSError *error = nil;
    if (![audioSession setCategory:sessionCategory error:&error]) {
        NSLog(@"set category error: %@ ", error);
    }
    if (![audioSession setActive:YES error:&error]) {
        NSLog(@"set active");
    }
}

@end
