//
//  CommunityViewController.h
//  HTManagement
//
//  Created by lyn on 14-2-8.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommunityInfo;

@protocol CommunityViewControllerDelegate <NSObject>

- (void)selectedCommunity:(CommunityInfo *)info;

@end


@interface CommunityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<CommunityViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *communityArray;
@property (nonatomic, strong) UITableView *tableView;

@end
