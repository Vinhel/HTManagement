//
//  HouseKeepingCell.h
//  HTManagement
//
//  Created by lyn on 14-1-15.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseKeepingForm.h"

@protocol HouseKeepingCellDelegate;

@interface HouseKeepingCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *handlerLabel;
@property (nonatomic, weak) IBOutlet UILabel *itemLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *remarksLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorLabel;
@property (nonatomic, strong) HouseKeepingForm *form;
@property (nonatomic, weak) id<HouseKeepingCellDelegate> delegate;
@property (nonatomic, assign) NSInteger cellHeight;


@end
@protocol HouseKeepingCellDelegate <NSObject>

@optional

- (void)finishHouseKeepingItem:(HouseKeepingForm *)form;

- (void)feedBack:(HouseKeepingForm *)form;

- (void)chooseHouseKeepingWorker:(HouseKeepingForm *)form;

@end