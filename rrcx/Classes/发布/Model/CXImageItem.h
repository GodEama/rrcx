//
//  CXImageItem.h
//  rrcx
//
//  Created by 123 on 2017/9/7.
//  Copyright © 2017年 123. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXImageItem : NSObject
@property (nonatomic,copy) NSString * imagePath;
@property (nonatomic,copy) NSString * desc;
+(id)parserWithDictionary:(NSDictionary *)dic;
@end
