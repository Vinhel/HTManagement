//
//  CommunityViewController.m
//  HTManagement
//
//  Created by lyn on 14-2-8.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "CommunityViewController.h"
#import "AFNetworking.h"
#import "CommunityInfo.h"

@interface CommunityViewController ()

@end

@implementation CommunityViewController

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
    
    _communityArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    NSLog(@"tableview frame %@",NSStringFromCGRect(_tableView.frame));
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self getCommunities];

}

- (void)getCommunities
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer new];
    [manager GET:api_get_community parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response %@",responseObject);
        for (NSDictionary *dict in [responseObject objectForKey:@"community_list"] ) {
            CommunityInfo *info = [[CommunityInfo alloc]initWithDictionary:dict];
            [_communityArray addObject:info];
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];
    
}

#pragma mark - UITableViewDatasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_communityArray count];
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [[_communityArray objectAtIndex:[indexPath row]]community_title];
    
    return cell;
}

#pragma mark - UITableView delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedCommunity:)]) {
        [self.delegate selectedCommunity:[_communityArray objectAtIndex:[indexPath row]] ];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
