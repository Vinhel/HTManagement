//
//  StartRatingView.m
//  HTManagement
//
//  Created by lyn on 14-1-20.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "StarRatingView.h"

#define starsnum 3
#define kBACKGROUND_STAR @"backgroundStar"
#define kFOREGROUND_STAR @"foregroundStar"

@interface StarRatingView()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@end

@implementation StarRatingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _ratingNum = 0;
        self.starBackgroundView = [self buidlStarViewWithImageName:kBACKGROUND_STAR];
        self.starForegroundView = [self buidlStarViewWithImageName:kFOREGROUND_STAR];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
        CGRect frame = self.starForegroundView.frame;
        frame.size.width = 0;
        self.starForegroundView.frame = frame;
        
    }
    return self;
}


- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < starsnum; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * frame.size.width / starsnum, 0, frame.size.width / starsnum, frame.size.height);
			NSLog(@"imageview frame %@",NSStringFromCGRect(imageView.frame));
        [view addSubview:imageView];
    }
    return view;
}


#pragma mark - Touche Event
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point))
    {
        //   [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    
    [UIView animateWithDuration:0.2 animations:^
     {
         [self changeStarForegroundViewWithPoint:point];
     }];
}

- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGPoint p = point;
    
    if (p.x < 0)
    {
        p.x = 0;
    }
        if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }
    NSLog(@"test %d",6/5);
    NSInteger num = p.x*starsnum/self.frame.size.width;
    NSLog(@"num %d",num);

    self.starForegroundView.frame = CGRectMake(0, 0, (num+1)* self.bounds.size.width/ starsnum, self.frame.size.height);
    _ratingNum = num+1;
}


@end
