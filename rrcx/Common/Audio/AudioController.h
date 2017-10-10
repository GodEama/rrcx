//
//  AudioController.h
//  AVAudioRecord
//
//  Created by Jax on 16/6/13.
//  Copyright © 2016年 Jax. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AudioController;

@protocol AudioControllerDelegate <NSObject>

- (void)audioController:(AudioController *)AudioController savePath:(NSString *)savePath andFileName:(NSString *)fileName;
@end
@interface AudioController : UIViewController
@property (nonatomic, retain) id<AudioControllerDelegate> delegate;

@end
