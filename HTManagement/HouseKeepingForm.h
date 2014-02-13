//
//  HouseKeepingForm.h
//  HTManagement
//
//  Created by lyn on 14-1-5.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseKeepingForm : NSObject

/*
 {
 content: "一般性家庭保洁"
 housekeeping_status: 2
 handler: "worker9"
 item: "钟点工"
 remarks: "小于20小时每月，两小时起步。"
 price_description: "40元/小时"
 time: "2013-12-25 08:54:32.425000+00:00"
 id: 8
 housekeeping_author: "sfi12345"
 pleased: 0
 }
 */
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger deal_status;
@property (nonatomic, strong) NSString *handler;
@property (nonatomic, strong) NSString *item;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSString *price_description;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) NSInteger housekeeping_id;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, assign) NSInteger pleased;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic) NSInteger pageCount;

- (id)initWithDictionary:(NSDictionary *)dict;


- (NSMutableArray *)getHouseKeepingFormWith:(NSString *)urlstring
                             communityID:(NSString *)communityID
                         houseKeepingStatus:(NSString *)status;
@end
