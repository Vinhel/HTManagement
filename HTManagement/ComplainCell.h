//
//  ComplainCell.h
//  HTManagement
//
//  Created by lyn on 14-1-15.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplainForm.h"

@protocol  ComplainCellDelegate;


@interface ComplainCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *handlerLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *satisfactionLabel;
@property (nonatomic, weak) IBOutlet UIButton *feedbackButton;
@property (nonatomic, weak) IBOutlet UILabel *ownerLabel;
@property (nonatomic, strong) ComplainForm *complainForm;
@property (nonatomic, assign) id<ComplainCellDelegate> delegate;


@end

@protocol ComplainCellDelegate <NSObject>

@optional

- (void)finishComplainItem:(ComplainForm *)form;

- (void)feedBack:(ComplainForm *)form;

- (void)chooseComplainWorker:(ComplainForm *)form;

- (void)acceptComplain:(ComplainForm *)form;

@end