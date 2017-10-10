//
//  HZPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HZButton, HZPhotoBrowser;

@protocol HZPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)CX_photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)CX_photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end


@interface HZPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, copy) NSArray * descArray;

@property (nonatomic, weak) id<HZPhotoBrowserDelegate> delegate;

- (void)show;
- (void)showInView:(UIView *)view;

@end
