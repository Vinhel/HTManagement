//
//  ScanRepairFormViewController.h
//  HTManagement
//
//  Created by lyn on 13-12-26.
//  Copyright (c) 2013年 SFI-china. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepairForm.h"
#import "FeedbackViewController.h"
@interface ScanRepairFormViewController : UIViewController <FeedbackSubmitDelegate>


@property (nonatomic, strong) RepairForm *repairForm;
@property (nonatomic, weak)  IBOutlet UILabel *typeLabel;
@property (nonatomic, weak)  IBOutlet UILabel *itemLabel;
@property (nonatomic, weak)  IBOutlet UITextView *contentView;
@property (nonatomic, weak)  IBOutlet UIImageView *imageView;
@property (nonatomic, weak)  IBOutlet UIButton *statusButton;

@end
