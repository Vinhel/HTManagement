//
//  CommunityInfo.m
//  HTManagement
//
//  Created by lyn on 14-1-22.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "CommunityInfo.h"

@implementation CommunityInfo


- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.community_description = [dict objectForKey:@"community_description"];
        self.community_title = [dict objectForKey:@"community_title"];
        self.community_id = [[dict objectForKey:@"id"] integerValue];
        
    }
    return self;
}

@end
