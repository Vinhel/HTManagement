//
//  HouseKeepingViewController.h
//  HTManagement
//
//  Created by lyn on 14-1-5.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseKeepingCell.h"
#import "WorkerListViewController.h"
#import "CommunityInfo.h"


@interface HouseKeepingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, HouseKeepingCellDelegate>

@property (nonatomic, strong) CommunityInfo *info;

@end
