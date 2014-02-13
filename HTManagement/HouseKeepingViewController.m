//
//  HouseKeepingViewController.m
//  HTManagement
//
//  Created by lyn on 14-1-5.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "HouseKeepingViewController.h"
#import "AFNetworking.h"
#import "HouseKeepingForm.h"
#import "CreateHouseKeepingViewController.h"
#import "FeedbackViewController.h"
#import "WorkerInfo.h"

typedef NS_ENUM(NSInteger, Status)
{
    Untreated = 0,
    Processing,
    Soloved
};

/**
 content = "\U5e2e\U5fd9\U63a5\U5b9d\U5b9d";
 handler = None;
 "housekeeping_author" = user2;
 "housekeeping_status" = 1;
 id = 81;
 item = "\U63a5\U5b69\U5b50";
 pleased = 0;
 "price_description" = "500\U5143/\U6708";
 remarks = "2\U5c0f\U65f6\U4ee5\U5185";
 time = "2014-01-15 07:13:47";
 
 **/
@interface HouseKeepingViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *untreatedArray;
@property (nonatomic, strong) NSMutableArray *processingArray;
@property (nonatomic, strong) NSMutableArray *solovedArray;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) UISegmentedControl *segmented_status;
@property (nonatomic, strong) HouseKeepingForm *houseKeepForm;

@end

@implementation HouseKeepingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (ios7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
  
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addHouseKeepingItem:)];
	// Do any additional setup after loading the view.
    _houseKeepForm = [HouseKeepingForm new];
    [self initArrays];
    [self setupSegmentedControl];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getHouseKeepingContent];
/*
 AFNetworking  异步请求 在加载完数据后刷新tableview
 
 */

}

- (void)initArrays
{

    _untreatedArray = [NSMutableArray array];
    _processingArray = [NSMutableArray array];
    _solovedArray = [NSMutableArray array];

}

- (void)setupSegmentedControl
{


    _segmented_status = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"未处理", @"处理中", @"处理完成", nil]];
    _segmented_status.frame = CGRectMake(0, 0, 320, 30);
    _segmented_status.selectedSegmentIndex = 0;
    _segmented_status.segmentedControlStyle = UISegmentedControlStyleBar;
    _segmented_status.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_segmented_status addTarget:self action:@selector(refreshTableViewWithStatus) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmented_status];

}

- (void)setupTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, 320, iPhone5?474:386)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

}

- (void)getHouseKeepingContent
{
    if ([_untreatedArray count]||[_processingArray count]||[_solovedArray count]) {
        [_untreatedArray removeAllObjects];
        [_processingArray removeAllObjects];
        [_solovedArray removeAllObjects];

    }
    NSString *idstring ;
    if (isAdmin) {
        idstring = [NSString stringWithFormat:@"%d",_info.community_id];
    }
    else
        idstring = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user_profile"] objectForKey:@"community_id"];
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSString *status = [@"未处理" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _untreatedArray  = [NSMutableArray arrayWithArray:[_houseKeepForm getHouseKeepingFormWith:api_get_housekeepings_by_status communityID:idstring houseKeepingStatus:status]] ;
        
        status = [@"处理中" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _processingArray  = [NSMutableArray arrayWithArray:[_houseKeepForm getHouseKeepingFormWith:api_get_housekeepings_by_status communityID:idstring houseKeepingStatus:status]] ;
        
        status = [@"已处理" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _solovedArray = [NSMutableArray arrayWithArray:[_houseKeepForm getHouseKeepingFormWith:api_get_housekeepings_by_status communityID:idstring houseKeepingStatus:status]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshTableViewWithStatus];
    });
    });
  /*
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer new];

    NSString *urlString = nil;
    if (isAdmin)
        urlString =[NSString stringWithFormat:api_get_all_housekeeping,1,_info.community_id];
    else
        urlString = api_own_housekeeping;
    

    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response %@",responseObject);
        _pageCount = [[responseObject objectForKey:@"page_count"] integerValue];
  
        for (NSDictionary *dict in [responseObject objectForKey:@"house_keep_list"]) {
            HouseKeepingForm *form = [[HouseKeepingForm alloc]initWithDictionary:dict];
            
            switch ([[dict objectForKey:@"housekeeping_status"] integerValue]) {
                case 1:
                    [_untreatedArray addObject:form];
                    break;
               
                case 2:
                    [_processingArray addObject:form];
                    break;
                
                default:
                    [_solovedArray addObject:form];
                    break;
            }
        }
        [self refreshTableViewWithStatus];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];
*/
    
    
}

- (void)addHouseKeepingItem:(id)sender
{
    CreateHouseKeepingViewController *vc = [CreateHouseKeepingViewController new];
    [self.navigationController pushViewController:vc animated:YES];


}
- (void)refreshTableViewWithStatus
{
    
    switch (_segmented_status.selectedSegmentIndex) {
        case 0:
            _array = [NSMutableArray arrayWithArray:_untreatedArray];
            break;
            
        case 1:
            _array = [NSMutableArray arrayWithArray:_processingArray];
            break;
        default:
            _array = [NSMutableArray arrayWithArray:_solovedArray];
            break;
    }

    [_tableView reloadData];
 


}

#pragma mark - UITableviewDatasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    HouseKeepingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"HouseKeepingCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
    }
    HouseKeepingForm *form = (HouseKeepingForm*)[_array objectAtIndex:[indexPath row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.form = form;
    return cell;

}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HouseKeepingForm *form = [_array objectAtIndex:[indexPath row]];
    if (form.deal_status==3) {
        return 181;
    }
    else
        return 153;
//    HouseKeepingCell *cell =(HouseKeepingCell *) [tableView cellForRowAtIndexPath:indexPath];
//    return cell.cellHeight;

}

#pragma mark - HouseKeepingCellDelegate methods
/*
 评价反馈，项目完成，分配员工
 */
- (void)feedBack:(HouseKeepingForm *)form
{
    FeedbackViewController *vc = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
    vc.form = form;
    vc.feedbackType = HThousekeeping;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)finishHouseKeepingItem:(HouseKeepingForm *)form
{
    /*
     'housekeeping_id_string': ''家政项目id（多个项目 以字符串形式发送 如： 1,3,4）'

     */
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer new];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",form.housekeeping_id], @"housekeeping_id_string",nil];
    
    [manager POST:api_housekeeping_complete parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"success"]) {
            [self getHouseKeepingContent];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];
}
    



- (void)chooseHouseKeepingWorker:(HouseKeepingForm *)form
{
/*
 'housekeeping_id_string': ''家政项目id（多个项目 以字符串形式发送 如： 1,3,4）'
 'deal_person_id': 处理人id',

 */
    WorkerListViewController *vc = [[WorkerListViewController alloc]init];
   // vc.delegate = self;
    vc.serviceType = HTHousekeepingService;
    vc.form = form;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
