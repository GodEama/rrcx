//
//  XLChannelItem.h
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CategoryTitleModel;

@protocol ChannelItemDelegate <NSObject>

-(void)clickdelAction:(id)sender;


@end
@interface XLChannelItem : UICollectionViewCell
//标题
@property (nonatomic, copy) NSString *title;
@property(nonatomic,weak)id<ChannelItemDelegate>delegate;

//是否正在移动状态
@property (nonatomic, assign) BOOL isMoving;

//是否被固定
@property (nonatomic, assign) BOOL isFixed;


@property(nonatomic,assign)BOOL isEdit;

@end
