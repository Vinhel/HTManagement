//
//  RepairForm.h
//  HTManagement
//
//  Created by lyn on 13-12-24.
//  Copyright (c) 2013年 SFI-china. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepairForm : NSObject
/*"content":"2555",
"src":"uploads/2013/12/11/QQ\u622a\u56fe20131029141332123444_2.png",
"deal_status":3,
"time":"2013-12-11 10:06:38+00:00",
"type":"\u7a7a\u8c03",
"id":9,
"repair_author":"user2",
"pleased":0
*/
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *imgSrc;
@property (nonatomic, assign) NSInteger deal_status;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *repair_type;
@property (nonatomic, assign) NSInteger idNum;
@property (nonatomic, strong) NSString *repair_author;
@property (nonatomic, assign) NSInteger pleased;
@property (nonatomic, strong) NSString *handler;
@property (nonatomic, assign) NSInteger author_floor;
@property (nonatomic, assign) NSInteger author_room;

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic) NSInteger pageCount;


- (id)initWithDictionary:(NSDictionary *)dict;


- (NSMutableArray *)getRepairFormWith:(NSString *)urlstring
                          communityID:(NSString *)communityID
                         repairStatus:(NSString *)status;

@end
