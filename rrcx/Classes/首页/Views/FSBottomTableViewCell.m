//
//  FSBottomTableViewCell.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "FSBottomTableViewCell.h"
#import "CXSingleTableViewController.h"
#import "CXSingleTableViewController_1.h"
@implementation FSBottomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

#pragma mark Setter
- (void)setViewControllers:(NSMutableArray *)viewControllers
{
    _viewControllers = viewControllers;
}

- (void)setCellCanScroll:(BOOL)cellCanScroll
{
    _cellCanScroll = cellCanScroll;
    
    CXSingleTableViewController * articleVC = _viewControllers[0];
    CXSingleTableViewController_1 * newsVC = _viewControllers[1];
    articleVC.vcCanScroll = cellCanScroll;
    newsVC.vcCanScroll = cellCanScroll;
    if (!cellCanScroll) {
        articleVC.tableView.contentOffset = CGPointZero;
        newsVC.tableView.contentOffset = CGPointZero;
    }
    
    
}

//- (void)setIsRefresh:(BOOL)isRefresh
//{
//    _isRefresh = isRefresh;
//    
//    for (FSScrollContentViewController *ctrl in self.viewControllers) {
//        if ([ctrl.title isEqualToString:self.currentTagStr]) {
//            ctrl.isRefresh = isRefresh;
//        }
//    }
//}
@end
