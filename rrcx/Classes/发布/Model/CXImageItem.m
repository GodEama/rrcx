//
//  CXImageItem.m
//  rrcx
//
//  Created by 123 on 2017/9/7.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CXImageItem.h"

@implementation CXImageItem
+(id)parserWithDictionary:(NSDictionary *)dic
{
    return [[self alloc] initWithDictionary:dic];
}

-(id)initWithDictionary:(NSDictionary *)dic
{
    self.imagePath = [dic objectForKey:@"img"];
    self.desc = [dic objectForKey:@"text"];
    
    return self;
}
@end
