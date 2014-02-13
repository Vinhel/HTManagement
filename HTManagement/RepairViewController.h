//
//  FirstViewController.h
//  HTManagement
//
//  Created by lyn on 13-12-23.
//  Copyright (c) 2013年 SFI-china. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ScanRepairFormViewController.h"
#import "RepairCell.h"
#import "CommunityInfo.h"

@interface RepairViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RepairCellDelegate>

@property (nonatomic, strong) CommunityInfo *info;

@end
