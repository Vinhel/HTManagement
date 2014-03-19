//
//  HomeViewController.m
//  HTManagement
//
//  Created by lyn on 14-3-14.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) int timeCount;
@property (nonatomic, strong) NSTimer *timer;

#define ScrollViewHeight 180
#define PageNum 2
#define ItemNum 4
#define kSpace 20
#define kButtonWidth 120
#define kButtonHeight 120



@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"亨通物业";
    if (ios7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height - HeightOfNavigationBar - HeightOfStatusBar -HeightOfTabBar)];
    _scrollView.contentSize = CGSizeMake(Screen_width * 2, ScrollViewHeight);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ScrollViewHeight , Screen_width, Screen_height - _scrollView.frame.size.height - HeightOfNavigationBar - HeightOfStatusBar - HeightOfTabBar)];
    
    NSArray *array = @[@"投诉", @"报修", @"快递", @"更多服务"];
    NSArray *imgArray =[NSArray arrayWithObjects:[UIImage imageNamed:@"投诉2"],[UIImage imageNamed:@"报修2"],
                        [UIImage imageNamed:@"快递2"],[UIImage imageNamed:@"更多"], nil];
    for (int i = 0; i < ItemNum; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.bounds = CGRectMake(0, 0, kButtonWidth, kButtonHeight);
        button.tag = i;
        button.center = CGPointMake(80 + 160 * (i % 2), 65 + 125 * (i / 2));
        [button setBackgroundImage:[imgArray objectAtIndex:i] forState:UIControlStateNormal];
       // [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [_contentView addSubview:button];
    }
    _contentView.contentSize = CGSizeMake(Screen_width, 290);
   // [self.view addSubview:_contentView];
    
    
    UIImageView *imgView1 = [[UIImageView alloc]initWithFrame:_scrollView.frame];
    [imgView1 setImage:[UIImage imageNamed:@"ad1"]];
    [_scrollView addSubview:imgView1];
    
    UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width, 0, Screen_width, Screen_height - HeightOfNavigationBar - HeightOfStatusBar -HeightOfTabBar)];
    [imgView2 setImage:[UIImage imageNamed:@"ad2"]];
    [_scrollView addSubview:imgView2];
    
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.frame = CGRectMake(150, 160, 20, 20);
    _pageControl.numberOfPages = PageNum;
    _pageControl.currentPage = 0;
    //[_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
    
    _timeCount = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    

    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_timer setFireDate:[NSDate distantPast]];
    

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollTimer
{
    _timeCount ++;
    if (_timeCount == PageNum) {
        _timeCount = 0;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [_scrollView setContentOffset:CGPointMake(Screen_width * _timeCount, 0) animated:YES];
    
    [UIView commitAnimations];

}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    int page = _scrollView.contentOffset.x / Screen_width;
    
    _pageControl.currentPage = page;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
