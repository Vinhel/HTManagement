//
//  WorkerListViewController.h
//  HTManagement
//
//  Created by lyn on 14-1-22.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WorkerInfo;

@protocol WorkerListViewControllerDelegate <NSObject>

@optional
- (void)chooseWorker:(WorkerInfo *)info;

@end
@interface WorkerListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<WorkerListViewControllerDelegate> delegate;
@property (nonatomic, strong) id form;
@property (nonatomic, assign) HTServiceType serviceType;
@end
