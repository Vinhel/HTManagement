//
//  ServicesViewController.m
//  HTManagement
//
//  Created by lyn on 14-3-14.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "ServicesViewController.h"
#import "CreateRepairFormViewController.h"
#import "CreateComplainViewController.h"
#import "CreateHouseKeepingViewController.h"
#import "ExpressViewController.h"


@interface ServicesViewController ()
@property (nonatomic, strong) NSArray *title1Array;
@property (nonatomic, strong) NSArray *title2Array;
@property (nonatomic, strong) NSArray *img1Array;
@property (nonatomic, strong) NSArray *img2Array;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation ServicesViewController

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
    self.navigationItem.title = @"物业服务";
	// Do any additional setup after loading the view.
    if (ios7) self.edgesForExtendedLayout = UIRectEdgeNone;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height - HeightOfTabBar - HeightOfStatusBar - HeightOfNavigationBar) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _sectionArray = @[@"便民服务", @"缴费服务"];
    _title1Array = @[@"报修", @"投诉", @"家政", @"快递" , @"微水洗车"];
    _img1Array = @[[UIImage imageNamed:@"13"],[UIImage imageNamed:@"16"],[UIImage imageNamed:@"15"],[UIImage imageNamed:@"14"],[UIImage imageNamed:@"18"]];
    _title2Array = @[@"物业费", @"停车费"];
    _img2Array = @[[UIImage imageNamed:@"11"],[UIImage imageNamed:@"12"]];
    [self.view addSubview:_tableView];
    
}



#pragma  mark -  UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [_sectionArray count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    switch (section) {
        case 0:
            count = [_title1Array count];
            break;
            
        default:
            count = [_title2Array count];
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    switch ([indexPath section]) {
        case 0:
            cell.textLabel.text = [_title1Array objectAtIndex:[indexPath row]];
            cell.imageView.image = [_img1Array objectAtIndex:[indexPath row]];
            break;
            
        default:
            cell.textLabel.text = [_title2Array objectAtIndex:[indexPath row]];
            cell.imageView.image = [_img2Array objectAtIndex:[indexPath row]];

            break;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionArray objectAtIndex:section];
}


#pragma  mark -  UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        switch ([indexPath row]) {
            case 0:
            {
                CreateRepairFormViewController *create = [[CreateRepairFormViewController alloc]initWithNibName:@"CreateRepairViewController" bundle:nil];
                [self.navigationController pushViewController:create animated:YES];
                break;
            }
            case 1:
            {
                CreateComplainViewController *create = [[CreateComplainViewController alloc]initWithNibName:@"CreateComplainViewController" bundle:nil];
                [self.navigationController pushViewController:create animated:YES];
                break;
            }
            case 2:
            {
                CreateHouseKeepingViewController *create = [[CreateHouseKeepingViewController alloc]init];
                [self.navigationController pushViewController:create animated:YES];
                break;
            }
            case 3:
            {
                ExpressViewController *express = [[ExpressViewController alloc]init];
                [self.navigationController pushViewController:express animated:YES];
                break;
            
            }
            default:
                break;
        }
    }

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
