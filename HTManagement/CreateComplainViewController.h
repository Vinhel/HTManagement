//
//  CreateComplainViewController.h
//  HTManagement
//
//  Created by lyn on 14-1-5.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownList.h"

@interface CreateComplainViewController : UIViewController < UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DropDownListDelegate >

@property (nonatomic, strong) IBOutlet UIButton *typeBtn;
@property (nonatomic, weak) IBOutlet UITextView *contentView;
@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) UIImagePickerController *imgPicker;
@property (nonatomic, weak) IBOutlet UIButton *submitBtn;
@property (nonatomic, weak) IBOutlet UILabel *placeLabel;
@property (nonatomic, weak) IBOutlet UIView *backgroundView;
- (IBAction)submit:(id)sender;
- (IBAction)chooseComplainType;

@end
