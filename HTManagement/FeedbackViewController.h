//
//  FeedbackViewController.h
//  HTManagement
//
//  Created by lyn on 14-1-9.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressForm.h"
#import "HouseKeepingForm.h"
#import "ComplainForm.h"
#import "RepairForm.h"

@protocol  FeedbackSubmitDelegate;

@interface FeedbackViewController : UIViewController


@property (nonatomic, weak) id<FeedbackSubmitDelegate> delegate;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, weak) IBOutlet UITextView *contentView;
@property (nonatomic, strong) id form;
@property (nonatomic, assign) HTFeedbackType feedbackType;

- (IBAction)submitButtonClicked:(id)sender;


@end

@protocol FeedbackSubmitDelegate <NSObject>

- (void)submitWithPleased:(NSInteger)num WithContent:(NSString *)content;


@end