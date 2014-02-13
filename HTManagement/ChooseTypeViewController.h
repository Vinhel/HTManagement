//
//  ChooseTypeViewController.h
//  HTManagement
//
//  Created by lyn on 14-1-20.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressForm.h"


@interface ChooseTypeViewController : UIViewController

@property (nonatomic, weak) IBOutlet UISegmentedControl *typeControl;
@property (nonatomic, weak) IBOutlet UISegmentedControl *timeControl;
@property (nonatomic, strong) ExpressForm *form;

- (IBAction)buttonClicked:(id)sender;

@end
