//
//  ComplainForm.h
//  HTManagement
//
//  Created by lyn on 14-1-5.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 */
@interface ComplainForm : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *imgSrc;
@property (nonatomic, assign) NSInteger deal_status;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *complainType;
@property (nonatomic, assign) NSInteger complainId;
@property (nonatomic, assign) NSInteger pleased;
@property (nonatomic, strong) NSString *complain_author;
@property (nonatomic, strong) NSString *handler;
@property (nonatomic) NSInteger pageCount;
@property (nonatomic, strong) NSMutableArray *array;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSMutableArray *)getComplainsFormWith:(NSString *)urlstring
                        communityID:(NSString *)communityID
                         complainsStatus:(NSString *)status;

- (NSMutableArray *)getComplainsFormWith:(NSString *)urlstring
                         complainsStatus:(NSString *)status;

@end
