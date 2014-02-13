//
//  WorkerListViewController.m
//  HTManagement
//
//  Created by lyn on 14-1-22.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "WorkerListViewController.h"
#import "WorkerInfo.h"
#import "AFNetworking.h"
#import "CommunityInfo.h"
#import "HouseKeepingForm.h"
#import "ComplainForm.h"
#import "RepairForm.h"

@interface WorkerListViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *array ;
@property (nonatomic, strong) NSMutableArray *communityArray;
@property (nonatomic, strong) NSMutableDictionary *workInfoWithID;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation WorkerListViewController

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
    if (ios7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
	// Do any additional setup after loading the view.
    _communityArray = [NSMutableArray array];
    _workInfoWithID = [NSMutableDictionary dictionary];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitForm)];
    
    [self setupTableView];
}

- (void)submitForm
{
    NSUInteger section = self.selectedIndexPath.section;
    NSInteger row = self.selectedIndexPath.row;
    NSString *key =[NSString stringWithFormat:@"%d",[[_communityArray objectAtIndex:
                                                      section ]community_id]] ;
    NSArray *array =[NSArray arrayWithArray:[_workInfoWithID objectForKey:key]] ;
    WorkerInfo *workerInfo = [array objectAtIndex:row];
    
    NSDictionary *dict ;
    NSString *string;
    
    switch (self.serviceType) {
        case HTHousekeepingService:
            
            /*
             'housekeeping_id_string': ''家政项目id（多个项目 以字符串形式发送 如： 1,3,4）'
             'deal_person_id': 处理人id',
             */
            dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[_form housekeeping_id]],@"housekeeping_id_string",[NSString stringWithFormat:@"%d",[workerInfo workerID]],@"deal_person_id",nil];
            string = api_housekeeping_deal;
            break;
        case HTComplainService:
            /*
             
             'complains_id_string': '要处理的投诉id号',（多个投诉id 拼接成字符串以逗号隔开 "1,2,32,45"）
             'deal_person_id': '指派的处理人的id',
             */
            dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[_form complainId]],@"complains_id_string",[NSString stringWithFormat:@"%d",[workerInfo workerID]],@"deal_person_id",nil];
            string = api_complain_deal;
            break;
        case HTRepairService:
        /*
         'repair_id_string': '要处理的报修id号',（多个投诉id 拼接成字符串以逗号隔开 "1,2,32,45"）
         'deal_person_id': '指派的处理人的id',
         */
            dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[_form idNum]],@"repair_id_string",[NSString stringWithFormat:@"%d",[workerInfo workerID]],@"deal_person_id",nil];
            string = api_repair_deal;
            
            break;
        
        default:
            break;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    manager.responseSerializer = [AFJSONResponseSerializer new];
    
    
    
    [manager POST:string parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        
        [self.view addSubview:_HUD];
        _HUD.labelText = @"提交完成";
        _HUD.mode = MBProgressHUDModeText;
        [_HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1.5);
            
        } completionBlock:^{
            [_HUD removeFromSuperview];
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];


}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getCommunities];

}

- (void)setupTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, iPhone5?504:416)style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

- (void)getWorkersList
{
    for (CommunityInfo *info in _communityArray) {

        NSURL *url = [NSURL URLWithString:[api_get_workers stringByAppendingString:[NSString stringWithFormat:@"%d",info.community_id]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSError *error = nil;

        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSMutableArray *tmp = [NSMutableArray array];
        for (NSDictionary *dict in [dictionary objectForKey:@"worker_list"]) {
            WorkerInfo *workerInfo = [[WorkerInfo alloc]initWithDictionary:dict];
            [tmp addObject:workerInfo];

        }
        [_workInfoWithID setObject:tmp forKey:[NSString stringWithFormat:@"%d",info.community_id]];
    }
    [_tableView reloadData];
    
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
        [self getWorkersList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];
    
}


#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [_communityArray count];
    return count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    NSString *string = [[_communityArray objectAtIndex:section] community_title];

    return string;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [[_workInfoWithID objectForKey:[NSString stringWithFormat:@"%d",[[_communityArray objectAtIndex:section] community_id]]]count];
   // [[_communityArray objectAtIndex:(section-1)] community_id]
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSString *key =[NSString stringWithFormat:@"%d",[[_communityArray objectAtIndex:
                                                      section ]community_id]] ;

    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
//    cell.textLabel.text
    NSArray *array =[NSArray arrayWithArray:[_workInfoWithID objectForKey:key]] ;
    WorkerInfo *workerInfo = [array objectAtIndex:row];
    cell.textLabel.text = workerInfo.username;
    cell.detailTextLabel.text = workerInfo.phoneNum;
    
    if ([self.selectedIndexPath isEqual:indexPath])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndexPath) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.selectedIndexPath = nil;
    }
    else{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedIndexPath = indexPath;
        
    }
    
}
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    [_tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
