

//
//  RepairForm.m
//  HTManagement
//
//  Created by lyn on 13-12-24.
//  Copyright (c) 2013年 SFI-china. All rights reserved.
//

#import "RepairForm.h"
/*"content":"2555",
 "src":"uploads/2013/12/11/QQ\u622a\u56fe20131029141332123444_2.png",
 "deal_status":3,
 "time":"2013-12-11 10:06:38+00:00",
 "type":"\u7a7a\u8c03",
 "id":9,
 "repair_author":"user2",
 "pleased":0
 */
@implementation RepairForm

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
       
        self.content = [dict objectForKey:@"content"];
        self.imgSrc = [dict objectForKey:@"src"];
        self.deal_status = [[dict objectForKey:@"deal_status"] integerValue];
        self.time = [dict objectForKey:@"time"];
        self.repair_type = [dict objectForKey:@"type"];
        self.idNum = [[dict objectForKey:@"id"] integerValue];
        self.repair_author = [dict objectForKey:@"repair_author"];
        self.pleased = [[dict objectForKey:@"pleased"] integerValue];
        
    }
    return self;
}


- (NSMutableArray *)getRepairFormWith:(NSString *)urlstring
                          communityID:(NSString *)communityID
                         repairStatus:(NSString *)status
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
        
        for (NSDictionary *dict in [[self connectWithURLString:string] objectForKey:@"repair_list"]) {
            RepairForm *form = [[RepairForm alloc]init];
            form.content = [dict objectForKey:@"content"];
            form.imgSrc = [dict objectForKey:@"src"];
            form.handler = [dict objectForKey:@"handler"];
            form.deal_status = [[dict objectForKey:@"deal_status"] integerValue];
            form.time = [dict objectForKey:@"time"];
            form.repair_type = [dict objectForKey:@"type"];
            form.idNum = [[dict objectForKey:@"id"] integerValue];
            form.repair_author = [dict objectForKey:@"repair_author"];
            form.pleased = [[dict objectForKey:@"pleased"] integerValue];
            form.author_floor = [[dict objectForKey:@"author_floor"] integerValue];
            form.author_room = [[dict objectForKey:@"author_room"] integerValue];
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
    NSDictionary *dictionary;
    if (data) {
        dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
			NSLog(@"error %@",error);
         NSLog(@"dictionary %@",dictionary);
    }
   
   
    return dictionary;
}

@end
