//
//  RepairCell.h
//  HTManagement
//
//  Created by lyn on 13-12-31.
//  Copyright (c) 2013年 SFI-china. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepairForm.h"

@protocol RepairCellDelegate <NSObject>

@optional

- (void)finishRepairItem:(RepairForm *)form;

- (void)feedBack:(RepairForm *)form;

- (void)chooseRepairWorker:(RepairForm *)form;

- (void)acceptRepair:(RepairForm *)form;

@end

@interface RepairCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *workerLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *satisfactionLabel;
@property (nonatomic) id<RepairCellDelegate> delegate;
@property (nonatomic, strong) RepairForm *repairForm;

@end
