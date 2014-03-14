//
//  UserProfile.h
//  HTManagement
//
//  Created by lyn on 14-3-12.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserProfile : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * community_id;
@property (nonatomic, retain) NSString * community_name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * floor;
@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) NSString * phonenum;
@property (nonatomic, retain) NSString * name;

@end
