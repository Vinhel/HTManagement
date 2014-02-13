
//
//  ExpressForm.m
//  HTManagement
//
//  Created by lyn on 14-1-2.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "ExpressForm.h"
/*
@property (nonatomic, strong) NSString *arrive_time;
@property (nonatomic, strong) NSString *deal_status;
@property (nonatomic, assign) NSInteger pleased;
@property (nonatomic, strong) NSString *express_author;
@property (nonatomic, strong) NSString *get_time;
@property (nonatomic, strong) NSString *get_express_type;
@property (nonatomic, assign) NSInteger id;
*/
 @implementation ExpressForm


- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.arrive_time = [dict objectForKey:@"arrive_time"];
        self.deal_status = [[dict objectForKey:@"deal_status"] integerValue];
        self.pleased = [[dict objectForKey:@"pleased"] integerValue];
        self.express_author = [dict objectForKey:@"express_author"];
        self.get_time = [dict objectForKey:@"get_time"];
        self.get_express_type = [dict objectForKey:@"get_express_type"];
        self.express_id = [[dict objectForKey:@"id"] integerValue];
    }
    
    return self;

}

- (NSMutableArray *)getExpressesFormWith:(NSString *)urlstring
                             communityID:(NSString *)communityID
                         expressesStatus:(NSString *)status
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
        
        for (NSDictionary *dict in [[self connectWithURLString:string] objectForKey:@"express_list"]) {
            ExpressForm *form = [[ExpressForm alloc]init];
            form.arrive_time = [dict objectForKey:@"arrive_time"];
            form.deal_status = [[dict objectForKey:@"deal_status"] integerValue];
            form.pleased = [[dict objectForKey:@"pleased"] integerValue];
            form.express_author = [dict objectForKey:@"express_author"];
            form.get_time = [dict objectForKey:@"get_time"];
            form.get_express_type = [dict objectForKey:@"get_express_type"];
            form.express_id = [[dict objectForKey:@"id"] integerValue];            [_array addObject:form];
            
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
