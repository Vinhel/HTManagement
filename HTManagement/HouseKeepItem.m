//
//  HouseKeepItem.m
//  HTManagement
//
//  Created by lyn on 14-1-5.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "HouseKeepItem.h"

@implementation HouseKeepItem
- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.item_content = [dict objectForKey:@"item_content"];
        self.item_remarks = [dict objectForKey:@"item_remarks"];
        self.item_id = [[dict objectForKey:@"item_id"] integerValue];
        self.price_description = [dict objectForKey:@"price_description"];
        self.item_name = [dict objectForKey:@"item_name"];

    }

    return self;
}

@end
