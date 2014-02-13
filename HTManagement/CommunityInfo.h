//
//  CommunityInfo.h
//  HTManagement
//
//  Created by lyn on 14-1-22.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityInfo : NSObject

@property (nonatomic, strong) NSString *community_description;
@property (nonatomic, strong) NSString *community_title;
@property (nonatomic, assign) NSInteger community_id;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
