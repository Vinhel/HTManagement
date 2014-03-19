//
//  UserProfileViewController.m
//  HTManagement
//
//  Created by lyn on 14-3-19.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "UserProfileViewController.h"
#import "AFNetworking.h"
#import "UserInfoCell.h"
@interface UserProfileViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *detailArray;

@end

@implementation UserProfileViewController

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
    if (ios7) self.edgesForExtendedLayout = UIRectEdgeNone;
    _array = @[@"姓名", @"小区", @"楼栋", @"门牌号", @"电子邮箱" , @"联系电话", @"详细地址"];
    _detailArray =[NSArray arrayWithObjects:[kUserProfile objectForKey:@"username"],[kUserProfile objectForKey:@"community_name"],[kUserProfile objectForKey:@"floor"],[kUserProfile objectForKey:@"room"],[kUserProfile objectForKey:@"email"],[kUserProfile objectForKey:@"phone_num"],[kUserProfile objectForKey:@"address"], nil];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, Screen_width - 20, 348) style:UITableViewStyleGrouped];
    _tableView.layer.cornerRadius = 5.0;
   // _tableView.layer.borderWidth = 0.5;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
       // cell = [[UserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserInfoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.indexLabel.text = [_array objectAtIndex:[indexPath row]];
    cell.detailText.text = [_detailArray objectAtIndex:[indexPath row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate methods


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
