//
//  ExpressViewController.h
//  HTManagement
//
//  Created by lyn on 14-1-2.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressCell.h"
#import "CommunityInfo.h"

@interface ExpressViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, ExpressCellDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) CommunityInfo *info;
@end
