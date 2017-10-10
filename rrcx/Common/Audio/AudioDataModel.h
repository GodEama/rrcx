//
//  AudioDataModel.h
//  AVAudioRecord
//
//  Created by Jax on 16/6/13.
//  Copyright © 2016年 Jax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioDataModel : NSObject

//@property (nonatomic, strong) NSURL    *fileURL;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, copy  ) NSString *date;
@property (nonatomic, copy  ) NSString *currentTime;
@property (nonatomic, copy) NSString * fileName;

- (instancetype)initWithTitle:(NSString *)title fileName:(NSString *)fileName date:(NSString *)date currentTime:(NSString *)currentTime ;
- (void)deleteAudioFile;

@end
