//
//  RootViewController.m
//  HTManagement
//
//  Created by lyn on 13-12-31.
//  Copyright (c) 2013年 SFI-china. All rights reserved.
//

#import "RootsViewController.h"
#import "RepairViewController.h"
#import "ExpressViewController.h"
#import "HouseKeepingViewController.h"
#import "ComplainViewController.h"
#import "CommunityInfo.h"

@interface RootsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) CommunityInfo *info;

@end

@implementation RootsViewController

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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

//69 123 190
    self.navigationItem.title = @"首页";
    NSLog(@"self.view frame %@",NSStringFromCGRect(self.view.frame));
   
    self.navigationController.navigationBar.tintColor=RGBA(69, 123, 190, 1);
    _array = [NSMutableArray arrayWithObjects:@"物业费", @"停车费", @"报修", @"快递领取", @"家政", @"投诉",@"注销", nil];
    _tableView = [[UITableView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    NSLog(@"tableview frame %@",NSStringFromCGRect(_tableView.frame));
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"role"] isEqualToString:@"admin"]) {

        [_array insertObject:@"选择小区" atIndex:7];
    }
    
}


#pragma mark - UITableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = [_array objectAtIndex:[indexPath row]];
    return cell;
}

#pragma mark - UITableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row]) {
        case 0:
            break;
        case 1:
            break;
        case 2:
        {
            NSLog(@"hello");
            
            [self showAlertView];
            
            RepairViewController *repair = [[RepairViewController alloc]init];
            
            if (isAdmin)
                repair.info = _info;
            [self.navigationController pushViewController:repair animated:YES];
        
        }
            break;
        case 3:
        {
            
            [self showAlertView];
           
            ExpressViewController *express = [ExpressViewController new];
            if (isAdmin)
                express.info = _info;
            
            [self.navigationController pushViewController:express animated:YES];
        }
            break;
        case 4:
        {
            [self showAlertView];
            
            HouseKeepingViewController *houseKeeping = [HouseKeepingViewController new];
            houseKeeping.navigationItem.title = @"家政服务";
            if (isAdmin) {
                houseKeeping.info = _info;
            }
            [self.navigationController pushViewController:houseKeeping animated:YES];
        
        }
            break;
        case 5:
        {
       
            [self showAlertView];
           
            ComplainViewController *complain = [ComplainViewController new];
            complain.navigationItem.title = @"投诉";
            if (isAdmin) {
                complain.info = _info;
            }
            [self.navigationController pushViewController:complain animated:YES];
        
        
        }
            break;
        case 7:
        {
            CommunityViewController *community = [CommunityViewController new];
            community.delegate = self;
            [self.navigationController pushViewController:community animated:YES];
        }
            
            break;
            
        default:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
    }


}

- (void)showAlertView
{
    if (!_info && [[[NSUserDefaults standardUserDefaults] objectForKey:@"role"] isEqualToString:@"admin"]) {
        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:nil message:@"选择小区" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
   

}

#pragma mark - CommunityViewControllerDelegate method

- (void)selectedCommunity:(CommunityInfo *)info
{
    _info = info;
    NSLog(@"info %@",info.community_title);
    self.navigationItem.title = _info.community_title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
