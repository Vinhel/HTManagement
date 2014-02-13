//
//  CreateRepairFormViewController.h
//  HTManagement
//
//  Created by lyn on 13-12-25.
//  Copyright (c) 2013年 SFI-china. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownList.h"

@interface CreateRepairFormViewController : UIViewController <UITextViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DropDownListDelegate>

@property (nonatomic, weak)   IBOutlet UILabel *serviceType;
@property (nonatomic, weak)   IBOutlet UILabel *servicePrice;
@property (nonatomic, weak)   IBOutlet UIImageView *imageView;
@property (nonatomic, weak)   IBOutlet UITextView *content;
@property (nonatomic, weak)   IBOutlet UIButton *typeButton;
@property (nonatomic, weak)   IBOutlet UIButton *priceButton;
@property (nonatomic, weak)   IBOutlet UIView   *backgroundView;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, assign) IBOutlet UIButton *submitButton;

@end
