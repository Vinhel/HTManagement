//
//  ComplainViewController.h
//  HTManagement
//
//  Created by lyn on 14-1-5.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplainCell.h"
#import "WorkerListViewController.h"
#import "FeedbackViewController.h"
#import "CommunityInfo.h"

@interface ComplainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, ComplainCellDelegate>

@property (nonatomic, strong) CommunityInfo *info;

@end
