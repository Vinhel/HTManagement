//
//  UITextField+AddInputView.m
//  HTManagement
//
//  Created by lyn on 13-12-31.
//  Copyright (c) 2013年 SFI-china. All rights reserved.
//

#import "UITextField+AddInputView.h"

@implementation UITextField (AddInputView)





- (void)setupDoneToolBar:(BOOL)toolBar
{
    if (toolBar) {
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
        UIBarButtonItem *spaceBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)];
        NSArray *array = [NSArray arrayWithObjects:spaceBtn,doneBtn, nil];
        
        [toolBar setItems:array];
        
        [self setInputAccessoryView:toolBar];
    }


}

- (void)dismissKeyboard
{

    [self resignFirstResponder];


}
@end
