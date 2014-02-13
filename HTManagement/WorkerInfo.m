//
//  WorkerInfo.m
//  HTManagement
//
//  Created by lyn on 14-1-21.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "WorkerInfo.h"

@implementation WorkerInfo


- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.phoneNum = [dict objectForKey:@"phone_number"];
        self.workerID = [[dict objectForKey:@"id"] integerValue];
        self.username = [dict objectForKey:@"username"];
    }
    return  self;
}
@end
