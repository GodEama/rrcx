//
//  CXMyCollectTableViewCell.h
//  rrcx
//
//  Created by 123 on 2017/9/27.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXArticle.h"
@interface CXMyCollectTableViewCell : UITableViewCell
@property (nonatomic,strong)CXArticle * model;
-(void)setModel:(CXArticle *)model;
@end
