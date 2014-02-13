//
//  ComplainForm.m
//  HTManagement
//
//  Created by lyn on 14-1-5.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "ComplainForm.h"
#import "AFNetworking.h"
/*
 {
 content: "123F"
 src: "uploads/2013/12/09/2_21.jpg"
 deal_status: 1 (1,2,3  1代表未处理，2代表处理中...，3代表处理完成)
 time: "2013-12-09 05:01:04+00:00"
 type: "安全投诉"
 id: 24
 complain_author: "cainiao"
 pleased: 0
 }
 @property (nonatomic, strong) NSString *content;
 @property (nonatomic, strong) NSString *imgSrc;
 @property (nonatomic, assign) NSInteger deal_status;
 @property (nonatomic, strong) NSString *time;
 @property (nonatomic, strong) NSString *complainType;
 @property (nonatomic, assign) NSInteger *complainId;
 @property (nonatomic, assign) NSInteger *complainId;
 @property (nonatomic, assign) NSInteger pleased;
 
 
 */
@implementation ComplainForm

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.content = [dict objectForKey:@"content"];
        self.imgSrc = [dict objectForKey:@"src"];
        self.deal_status = [[dict objectForKey:@"deal_status"] integerValue];
        self.time = [dict objectForKey:@"time"];
        self.complainType = [dict objectForKey:@"type"];
        self.complainId = [[dict objectForKey:@"id"] integerValue];
        self.complain_author = [dict objectForKey:@"complain_author"];
        self.pleased = [[dict objectForKey:@"pleased"] integerValue];
        self.handler = [dict objectForKey:@"handler"];
    }

    return self;
}

- (NSMutableArray *)getComplainsFormWith:(NSString *)urlstring
                             communityID:(NSString *)communityID
                                complainsStatus:(NSString *)status
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
        
        for (NSDictionary *dict in [[self connectWithURLString:string] objectForKey:@"complains_list"]) {
            ComplainForm *form = [[ComplainForm alloc]init];
            form.content = [dict objectForKey:@"content"];
            form.imgSrc = [dict objectForKey:@"src"];
            form.deal_status = [[dict objectForKey:@"deal_status"] integerValue];
            form.time = [dict objectForKey:@"time"];
            form.complainType = [dict objectForKey:@"type"];
            form.complainId = [[dict objectForKey:@"id"] integerValue];
            form.complain_author = [dict objectForKey:@"complain_author"];
            form.pleased = [[dict objectForKey:@"pleased"] integerValue];
            form.handler = [dict objectForKey:@"handler"];
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



- (NSMutableArray *)getComplainsFormWith:(NSString *)urlstring
                         complainsStatus:(NSString *)status
{
    return [self getComplainsFormWith:urlstring   communityID:nil  complainsStatus:status];

}

@end
