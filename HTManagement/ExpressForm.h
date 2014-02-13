//
//  ExpressForm.h
//  HTManagement
//
//  Created by lyn on 14-1-2.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 page_count:（总页数）
 express_list:
 [
 
 {
 arrive_time: "2013-12-16 01:09:36+00:00"（快件到达时间）
 deal_status: false (false:未领取，true:领取)
 pleased: 0
 express_author: "user3"
 get_time: "None"（快件领取时间）
 get_express_type: ""
 id: 13
 }
 
 
 ]
 }
 */

@interface ExpressForm : NSObject


@property (nonatomic, strong) NSString *arrive_time;
@property (nonatomic, assign) NSInteger deal_status;
@property (nonatomic, assign) NSInteger pleased;
@property (nonatomic, strong) NSString *express_author;
@property (nonatomic, strong) NSString *get_time;
@property (nonatomic, strong) NSString *get_express_type;
@property (nonatomic, assign) NSInteger express_id;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic) NSInteger pageCount;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSMutableArray *)getExpressesFormWith:(NSString *)urlstring
                             communityID:(NSString *)communityID
                         expressesStatus:(NSString *)status;

@end
