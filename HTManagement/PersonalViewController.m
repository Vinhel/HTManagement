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


@interface PersonalViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSDictionary *dict;

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
    
    _array = @[@"个人中心", @"缴费记录", @"物业", @"设置"];
    _dict = @{@"个人中心":@[@"个人资料", @"修改密码"],
              @"缴费记录":@[@"物业费", @"停车费"],
              @"物业":@[@"投诉", @"报修", @"快递", @"家政", @"微水洗车"],
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
            case 0:
            {
                ComplainViewController *complain = [ComplainViewController new];
                [self.navigationController pushViewController:complain animated:YES];
                break;
            }
            case 1:
            {
                RepairViewController *repair = [RepairViewController new];
                [self.navigationController pushViewController:repair animated:YES];
                break;
            
            }
            case 2:
            {
                ExpressViewController *express = [ExpressViewController new];
                [self.navigationController pushViewController:express animated:YES];
                break;
            
            }
            case 3:
            {
                HouseKeepingViewController *housekeeping = [HouseKeepingViewController new];
                [self.navigationController pushViewController:housekeeping animated:YES];
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
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end