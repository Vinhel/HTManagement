//
//  HouseKeepItem.h
//  HTManagement
//
//  Created by lyn on 14-1-5.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 item_id: 3
 item_remarks: "大于20小时每月，两小时起步。"
 item_content: "一般性家庭保洁"
 price_description: "30元/小时"
 item_name: "钟点工"
 }
 */
@interface HouseKeepItem : NSObject

@property (nonatomic, assign) NSInteger item_id;
@property (nonatomic, strong) NSString *item_remarks;
@property (nonatomic, strong) NSString *item_content;
@property (nonatomic, strong) NSString *price_description;
@property (nonatomic, strong) NSString *item_name;



- (id)initWithDictionary:(NSDictionary *)dict;
@end
