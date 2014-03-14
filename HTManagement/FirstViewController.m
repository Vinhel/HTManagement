//
//  FirstViewController.m
//  HTManagement
//
//  Created by lyn on 14-2-28.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "FirstViewController.h"

#define distance 5

@interface FirstViewController ()

//弹出视图层
@property (nonatomic, retain) UIView * coverView;//黑色半透明遮盖层
@property (nonatomic, retain) UIImageView * popIMgview;//弹出列表背景
@property (nonatomic, retain) UITableView * popTableView;//弹出列表
@property (nonatomic, retain) UILabel * popLabel;//弹出视图标题
@property (nonatomic, retain) NSMutableArray * tabArray;//列表数组
@property (nonatomic, retain) NSString * popType;//弹出视图标识
@property (nonatomic, retain) NSString * xianString;//显示数据

@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation FirstViewController

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
    if (ios7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.navigationController.tabBarItem setImage:[UIImage imageNamed:@"报修"]];
    self.navigationController.tabBarItem.title = @"首页";
    
    _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height -HeightOfNavigationBar - HeightOfStatusBar - HeightOfTabBar)];
    [_backgroundView setBackgroundColor:[UIColor colorWithRed:7 / 255.0 green:178 / 255.0 blue:230 / 255.0 alpha:1]];
    CGFloat height = _backgroundView.frame.size.height;
    [self.view addSubview:_backgroundView];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 2 * height / 5)];
    [scrollView setContentSize:CGSizeMake(Screen_width * 3, scrollView.frame.size.height)];
    [_backgroundView addSubview:scrollView];
    
    UIButton *houseKeepingBtn  =[[UIButton alloc]initWithFrame:CGRectMake(0, 2 * height / 5 +distance,  (Screen_width - distance) / 2, (3 * height / 5 - distance * 3) / 2 )];
    [houseKeepingBtn setImage:[UIImage imageNamed:@"家政"] forState:UIControlStateNormal];
    houseKeepingBtn.tag = 1;
    [_backgroundView addSubview:houseKeepingBtn];
    
    UIButton *repairBtn  =[[UIButton alloc]initWithFrame:CGRectMake(houseKeepingBtn.frame.size.width + distance, 2 * height / 5 + distance,  (Screen_width - distance) / 2, (3 * height / 5 - distance * 3) / 2 )];
    [repairBtn setImage:[UIImage imageNamed:@"报修"] forState:UIControlStateNormal];
    repairBtn.tag = 2;
    [_backgroundView addSubview:repairBtn];
    
    UIButton *expressBtn  =[[UIButton alloc]initWithFrame:CGRectMake(0, houseKeepingBtn.frame.size.height + houseKeepingBtn.frame.origin.y + distance,  (Screen_width - distance) / 2, (3 * height / 5 - distance * 3) / 2 )];
    [expressBtn setImage:[UIImage imageNamed:@"快递领取"] forState:UIControlStateNormal];
    expressBtn.tag = 3;
    [_backgroundView addSubview:expressBtn];
    
    UIButton *comlainBtn  =[[UIButton alloc]initWithFrame:CGRectMake(expressBtn.frame.size.width + distance, houseKeepingBtn.frame.size.height + houseKeepingBtn.frame.origin.y + distance,  (Screen_width - distance) / 2, (3 * height / 5 - distance * 3) / 2 )];
    [comlainBtn setImage:[UIImage imageNamed:@"投诉"] forState:UIControlStateNormal];
    comlainBtn.tag = 4;
    [_backgroundView addSubview:comlainBtn];
    
}

/*

- (void)createPopView
{
    _tabArray = [[NSMutableArray alloc]initWithCapacity:0];
    //背景层
    _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    _coverView.hidden = YES;
    //coverView.backgroundColor = [UIColor redColor];
    _coverView.alpha = 0.1;
    [self.view addSubview:_coverView];
    //显示视图
    _popIMgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 304, 288)];
    _popIMgview.hidden = YES;
    _popIMgview.center = self.view.center;
    _popIMgview.userInteractionEnabled = YES;
    _popIMgview.image = [UIImage imageNamed:@"appear_03.png"];
    [self.view addSubview:_popIMgview];
    //添加列表
    _popTableView = [[UITableView alloc] initWithFrame:CGRectMake(2, 41, 298, 198) style:UITableViewStylePlain];
    _popTableView.delegate = self;
    _popTableView.dataSource = self;
    _popTableView.tableFooterView = [[UIView alloc] init] ;
    [_popIMgview addSubview:_popTableView];
    //标题栏
    _popLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 5, 240, 30)];
    _popLabel.backgroundColor = [UIColor clearColor];
    [_popIMgview addSubview:_popLabel];
    //按钮
    //控制按钮
    UIButton * quxiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quxiaoBtn.frame = CGRectMake(5, 240, 143, 43);
    [quxiaoBtn setImage:[UIImage imageNamed:@"appear_05.png"] forState:UIControlStateNormal];
    [quxiaoBtn setImage:[UIImage imageNamed:@"appear_65.png"] forState:UIControlStateHighlighted];
    [quxiaoBtn addTarget:self action:@selector(fsalAction:) forControlEvents:UIControlEventTouchUpInside];
    [_popIMgview addSubview:quxiaoBtn];
    
    UIButton * quedingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quedingBtn.frame = CGRectMake(152, 240, 143, 43);
    [quedingBtn setImage:[UIImage imageNamed:@"appear_08.png"] forState:UIControlStateNormal];
    [quedingBtn setImage:[UIImage imageNamed:@"appear_80.png"] forState:UIControlStateHighlighted];
    [quedingBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [_popIMgview addSubview:quedingBtn];

}

*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
