//
//  AudioDataModel.m
//  AVAudioRecord
//
//  Created by Jax on 16/6/13.
//  Copyright © 2016年 Jax. All rights reserved.
//

#import "AudioDataModel.h"

static NSString * const kTitleKey = @"title";
static NSString * const kFileName = @"fileName";
static NSString * const kDateKey = @"date";
static NSString * const kCurrentTime = @"currentTime";

@implementation AudioDataModel

- (instancetype)initWithTitle:(NSString *)title fileName:(NSString *)fileName date:(NSString *)date currentTime:(NSString *)currentTime {
    self = [super init];
    if (self) {
        _title       = [title copy];
        _fileName     = [fileName copy];
        _date        = [date copy];
        _currentTime = [currentTime copy];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.title forKey:kTitleKey];
    [coder encodeObject:self.fileName forKey:kFileName];
    [coder encodeObject:self.date forKey:kDateKey];
    [coder encodeObject:self.currentTime forKey:kCurrentTime];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _title = [decoder decodeObjectForKey:kTitleKey];
        _fileName = [decoder decodeObjectForKey:kFileName];
        _date = [decoder decodeObjectForKey:kDateKey];
        _currentTime = [decoder decodeObjectForKey:kCurrentTime];

    }
    return self;
}

- (void)deleteAudioFile {
    NSError *error;
     NSString *path= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:[path stringByAppendingPathComponent:self.fileName]] error:&error];
    
}

@end
