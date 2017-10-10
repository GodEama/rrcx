//
//  CXArea.h
//  rrcx
//
//  Created by 123 on 2017/9/13.
//  Copyright © 2017年 123. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXArea : NSObject
/*
 "area_id": "1",
 "area_name": "北京",
 "area_parent_id": "0",
 "area_sort": "0",
 "area_deep": "1",
 "area_region": "华北"
 */
@property (nonatomic,copy) NSString *area_id;
@property (nonatomic,copy) NSString *area_name;
@property (nonatomic,copy) NSString *area_parent_id;
@property (nonatomic,copy) NSString *area_sort;
@property (nonatomic,copy) NSString *area_deep;
@property (nonatomic,copy) NSString *area_region;


@end
