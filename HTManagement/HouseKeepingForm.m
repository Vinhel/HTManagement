

//
//  HouseKeepingForm.m
//  HTManagement
//
//  Created by lyn on 14-1-5.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "HouseKeepingForm.h"
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
 
 @property (nonatomic, strong) NSString *content;
 @property (nonatomic, assign) NSInteger status;
 @property (nonatomic, strong) NSString *handler;
 @property (nonatomic, strong) NSString *item;
 @property (nonatomic, strong) NSString *remarks;
 @property (nonatomic, strong) NSString *price_description;
 @property (nonatomic, strong) NSString *time;
 @property (nonatomic, assign) NSInteger housekeeping_id;
 @property (nonatomic, strong) NSString *author;
 @property (nonatomic, assign) NSInteger pleased;
 */
@implementation HouseKeepingForm


- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.content = [dict objectForKey:@"content"];
        self.deal_status = [[dict objectForKey:@"housekeeping_status"]integerValue];
        self.handler = [dict objectForKey:@"handler"];
        self.item = [dict objectForKey:@"item"];
        self.price_description = [dict objectForKey:@"price_description"];
        self.time = [dict objectForKey:@"time"];
        self.housekeeping_id = [[dict objectForKey:@"id"] integerValue];
        self.remarks = [dict objectForKey:@"remarks"];
        self.author = [dict objectForKey:@"housekeeping_author"];
        self.pleased = [[dict objectForKey:@"pleased"] integerValue];

    }
    
    return  self;
   

}


- (NSMutableArray *)getHouseKeepingFormWith:(NSString *)urlstring
                                communityID:(NSString *)communityID
                         houseKeepingStatus:(NSString *)status
{
    if (_array) {
        [_array removeAllObjects];
    }
    else
        _array = [NSMutableArray array];
    
    NSString *string = [NSString stringWithFormat:urlstring,1,[communityID integerValue],status];
    
    _pageCount = [[[self connectWithURLString:string] objectForKey:@"page_count"] integerValue];
    
    for (NSInteger i = 1; i <= _pageCount; i++) {
        
        NSString *string = [NSString stringWithFormat:urlstring,i,[communityID integerValue],status];
        
        for (NSDictionary *dict in [[self connectWithURLString:string] objectForKey:@"house_keep_list"]) {
            HouseKeepingForm *form = [[HouseKeepingForm alloc]init];
            form.content = [dict objectForKey:@"content"];
            form.deal_status = [[dict objectForKey:@"housekeeping_status"]integerValue];
            form.handler = [dict objectForKey:@"handler"];
            form.item = [dict objectForKey:@"item"];
            form.price_description = [dict objectForKey:@"price_description"];
            form.time = [dict objectForKey:@"time"];
            form.housekeeping_id = [[dict objectForKey:@"id"] integerValue];
            form.remarks = [dict objectForKey:@"remarks"];
            form.author = [dict objectForKey:@"housekeeping_author"];
            form.pleased = [[dict objectForKey:@"pleased"] integerValue];
            [_array addObject:form];
            
        }
    }
    return _array;
    


}


- (NSDictionary *)connectWithURLString:(NSString *)urlstring
{
    NSURL *url = [NSURL URLWithString:urlstring];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"dictionary %@",dictionary);
    return dictionary;
}

@end
