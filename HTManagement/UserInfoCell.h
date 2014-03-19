//
//  UserInfoCell.h
//  HTManagement
//
//  Created by lyn on 14-3-19.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *indexLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
@property (nonatomic, weak) IBOutlet UITextField *detailText;
@end
