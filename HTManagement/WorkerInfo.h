//
//  WorkerInfo.h
//  HTManagement
//
//  Created by lyn on 14-1-21.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkerInfo : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, assign) NSInteger workerID;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
