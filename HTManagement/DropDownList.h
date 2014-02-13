//
//  DropDownList.h
//  HTManagement
//
//  Created by lyn on 14-1-6.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//
/*
参照NIDropDown

*/
#import <UIKit/UIKit.h>

@protocol DropDownListDelegate <NSObject>

- (void)dropDownListDelegateMethod:(id)sender WithIndex:(NSIndexPath *)index;

@end


@interface DropDownList : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id <DropDownListDelegate> delegate;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSString *chooseString;

- (void)showDropDownList:(UIButton *)sender withContentArray:(NSArray *)array withHeight:(CGFloat)height;

- (void)hideDropDownList:(UIButton *)sender;



@end
