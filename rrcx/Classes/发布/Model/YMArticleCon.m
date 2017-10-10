//
//  YMArticleCon.m
//  YunMuFocus
//
//  Created by apple on 2017/4/17.
//  Copyright © 2017年 YunMu. All rights reserved.
//

#import "YMArticleCon.h"

@implementation YMArticleCon

+(id)parserWithDictionary:(NSDictionary *)dic
{
    return [[self alloc] initWithDictionary:dic];
}

-(id)initWithDictionary:(NSDictionary *)dic
{
    self.type = [dic objectForKey:@"type"];

    self.voiceName = [dic objectForKey:@"voiceName"];
    self.value = [dic objectForKey:@"value"];
    return self;
}
@end
