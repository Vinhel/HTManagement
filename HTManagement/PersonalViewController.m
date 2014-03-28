//
//  PersonalViewController.m
//  HTManagement
//
//  Created by lyn on 14-3-14.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "PersonalViewController.h"
#import "ComplainViewController.h"
#import "RepairViewController.h"
#import "ExpressViewController.h"
#import "HouseKeepingViewController.h"
#import "UserProfileViewController.h"

@interface PersonalViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSArray *imgArray;
@property (nonatomic, strong) NSArray *img1Array;
@property (nonatomic, strong) NSArray *img2Array;


@end

@implementation PersonalViewController

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
	
	self.navigationItem.title = @"个人";
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc]init];
	backButton.title = @"返回";
	self.navigationItem.backBarButtonItem = backButton;
	
	if (ios7) self.edgesForExtendedLayout = UIRectEdgeNone;
	
	_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height - HeightOfNavigationBar - HeightOfStatusBar - HeightOfTabBar) style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	
	_imgArray = @[[UIImage imageNamed:@"个人资料"],[UIImage imageNamed:@"修改密码"]];
	_img1Array = @[[UIImage imageNamed:@"13"],[UIImage imageNamed:@"16"],[UIImage imageNamed:@"15"],[UIImage imageNamed:@"14"],[UIImage imageNamed:@"18"]];
	_img2Array = @[[UIImage imageNamed:@"11"],[UIImage imageNamed:@"12"]];
	
	
	_array = @[@"个人中心", @"缴费记录", @"物业记录", @"设置"];
	_dict = @{@"个人中心":@[@"个人资料", @"修改密码"],
						@"缴费记录":@[@"物业费", @"停车费"],
						@"物业记录":@[@"报修",@"投诉", @"家政", @"快递", @"微水洗车"],
						@"设置":@[@"注销"]};
	NSLog(@"allkeys %@",[_dict allKeys]);
	
	
}

#pragma mark - TableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *array = [_dict objectForKey:[_array objectAtIndex:section]];
	return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (!cell) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	cell.textLabel.text = [[_dict objectForKey:[_array objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]];
	//
	//    if ([indexPath section] == 2) {
	//        cell.imageView.image = [_img1Array objectAtIndex:[indexPath row]];
	//    }
	//    if ([indexPath section] == 1) {
	//        cell.imageView.image = [_img2Array objectAtIndex:[indexPath row]];
	//    }
	switch ([indexPath section]) {
			
		case 0:
			cell.imageView.image = [_imgArray objectAtIndex:[indexPath row]];
			break;
		case 1:
			cell.imageView.image = [_img2Array objectAtIndex:[indexPath row]];
			break;
		case 2:
			cell.imageView.image = [_img1Array objectAtIndex:[indexPath row]];
			break;
			
		default:
			cell.imageView.image = [UIImage imageNamed:@"注销"];
			break;
	}
	
	return cell;
	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
// Default is 1 if not implemented
{
	return [_array count];
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [_array objectAtIndex:section];
	
}

#pragma mark - TableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath section] == 2) {
		switch ([indexPath row]) {
			case 1:
			{
				ComplainViewController *complain = [ComplainViewController new];
				[self.navigationController pushViewController:complain animated:YES];
				break;
			}
			case 0:
			{
				RepairViewController *repair = [RepairViewController new];
				[self.navigationController pushViewController:repair animated:YES];
				break;
				
			}
			case 3:
			{
				ExpressViewController *express = [ExpressViewController new];
				[self.navigationController pushViewController:express animated:YES];
				break;
				
			}
			case 2:
			{
				//HouseKeepingViewController *housekeeping = [HouseKeepingViewController new];
				//[self.navigationController pushViewController:housekeeping animated:YES];
				break;
			}
			default:
				break;
		}
	}
	if ([indexPath section] == 3) {
		switch ([indexPath row]) {
			case 0:
				[self.tabBarController dismissViewControllerAnimated:YES completion:nil];
				break;
				
			default:
				break;
		}
	}
	if ([indexPath section] == 0 ) {
		switch ([indexPath row]) {
			case 0:
			{
				UserProfileViewController *profile = [UserProfileViewController new];
				[self.navigationController pushViewController:profile animated:YES];
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
