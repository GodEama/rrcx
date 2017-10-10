//
//  YMArticleCon.h
//  YunMuFocus
//
//  Created by apple on 2017/4/17.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMArticleCon : NSObject
@property (nonatomic,copy) NSString * type;

@property (nonatomic,copy) NSString * voiceName;
@property (nonatomic,copy) NSString * value;
+(id)parserWithDictionary:(NSDictionary *)dic;
@end
