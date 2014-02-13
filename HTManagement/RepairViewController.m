//
//  FirstViewController.m
//  HTManagement
//
//  Created by lyn on 13-12-23.
//  Copyright (c) 2013年 SFI-china. All rights reserved.
//

#import "RepairViewController.h"
#import "AFNetworking.h"
#import "RepairForm.h"
#import "CreateRepairFormViewController.h"
#import "WorkerListViewController.h"
#import "FeedbackViewController.h"

@interface RepairViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *untreatedArray;
@property (nonatomic, strong) NSMutableArray *processingArray;
@property (nonatomic, strong) NSMutableArray *solovedArray;
@property (nonatomic, strong) UISegmentedControl *segmented_status;
@property (nonatomic, strong) RepairForm *repairForm;
@end

@implementation RepairViewController

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
    
    
    _repairForm = [RepairForm new];
    if (ios7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
	// Do any additional setup after loading the view.
    if (isResident) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRepairForm)];
    }
    
    [self initArrays];
    [self setupSegmentedControl];
    [self setupTableView];}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getUserRepairs];
    
    
}
- (void)initArrays
{
    _array = [NSMutableArray array];
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
- (void)addRepairForm
{
    
    CreateRepairFormViewController *createForm = [[CreateRepairFormViewController alloc]initWithNibName:@"CreateRepairViewController" bundle:nil];
    [self.navigationController pushViewController:createForm animated:YES];
    
}
- (void)setupTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 30, 310, iPhone5?474:386)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
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

- (void)getUserRepairs
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
        _untreatedArray  = [NSMutableArray arrayWithArray:[_repairForm getRepairFormWith:api_get_repairs_by_status communityID:idstring repairStatus:status]] ;
        
        status = [@"处理中" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _processingArray  = [NSMutableArray arrayWithArray:[_repairForm getRepairFormWith:api_get_repairs_by_status communityID:idstring repairStatus:status]] ;
        
        status = [@"已处理" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _solovedArray = [NSMutableArray arrayWithArray:[_repairForm getRepairFormWith:api_get_repairs_by_status communityID:idstring repairStatus:status]];
        dispatch_async(dispatch_get_main_queue(),^{
            
            [self refreshTableViewWithStatus];
            
        });
        
    });
    
    
    
}
#pragma mark - UITableviewDatasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"identifier";
    
    RepairCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RepairCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    RepairForm *form = [self.array objectAtIndex:[indexPath row]];
    cell.repairForm = form;
    
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}



#pragma mark - tableview delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	return cell.frame.size.height;
   // return 256;
}

#pragma mark - repairCell delegate methods

- (void)finishRepairItem:(RepairForm *)form
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer new];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",form.idNum], @"repair_id_string",nil];
    
    [manager POST:api_repair_complete parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"success"]) {
            [self getUserRepairs];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];
    
}


- (void)chooseRepairWorker:(RepairForm *)form
{
    WorkerListViewController *vc = [[WorkerListViewController alloc]init];
    vc.serviceType = HTRepairService;
    vc.form = form;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)feedBack:(RepairForm *)form
{
    FeedbackViewController *vc = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
    vc.form = form;
    vc.feedbackType = HTrepair;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
