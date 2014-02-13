//
//  ExpressCell.h
//  HTManagement
//
//  Created by lyn on 14-1-3.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExpressForm;

@protocol ExpressCellDelegate <NSObject>

@optional

- (void)chooseGetExpressType:(ExpressForm *)expressForm;

- (void)finishExpress:(ExpressForm *)expressForm;

- (void)feedBack:(ExpressForm *)expressForm;

@end



@interface ExpressCell : UITableViewCell

@property (nonatomic, strong) ExpressForm *expressForm;
@property (nonatomic, weak)  id<ExpressCellDelegate> delegate;
@property (nonatomic, weak) IBOutlet UILabel *userLabel;
@property (nonatomic, weak) IBOutlet UILabel *arriveTimeLabel;
@property (nonatomic, weak) IBOutlet UIButton *typeButton;
@property (nonatomic, weak) IBOutlet UIButton *finishButton;


@end
