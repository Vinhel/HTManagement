//
//  WorkerViewController.m
//  HTManagement
//
//  Created by lyn on 14-3-19.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "WorkerViewController.h"
#import "UserProfileViewController.h"


@interface WorkerViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imgArray;

@end

@implementation WorkerViewController

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
    
    self.navigationItem.title = @"个人中心";
    if (ios7) self.edgesForExtendedLayout = UIRectEdgeNone;
        
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, 300, 150) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    _titleArray = @[@"个人资料",@"修改密码",@"注销"];
    
	// Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = [_titleArray objectAtIndex:[indexPath row]];
    cell.imageView.image = [UIImage imageNamed:[_titleArray objectAtIndex:[indexPath row]]];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row]) {
        case 0:
        {
            UserProfileViewController *profile = [UserProfileViewController new];
            [self.navigationController pushViewController:profile animated:YES];
            break;
        
        }
     
        case 2:
        {
            [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
            break;
        
        }
            
        default:
            break;
    }


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
