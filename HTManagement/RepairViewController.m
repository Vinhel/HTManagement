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
#import "HMSegmentedControl.h"


@interface RepairViewController ()
@property (nonatomic, strong) RepairForm *repairForm;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UIScrollView *baseView;
@property (nonatomic, strong) UITableView *unacceptedTable;
@property (nonatomic, strong) UITableView *acceptedTable;
@property (nonatomic, strong) UITableView *uncompletedTable;
@property (nonatomic, strong) UITableView *completedTable;
@property (nonatomic, strong) NSMutableArray *unacceptedArray;
@property (nonatomic, strong) NSMutableArray *acceptedArray;
@property (nonatomic, strong) NSMutableArray *uncompletedArray;
@property (nonatomic, strong) NSMutableArray *completedArray;




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
    
    self.navigationItem.title = @"报修";
    _repairForm = [RepairForm new];
    if (ios7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
	// Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTableView)];
 
  
    [self initArrays];
    [self setupSegmentedControl];
    [self setupTableView];
    if (isWorker) {
        [self getUserRepairsWithStatus:@"4"];
    }
    else
        [self getUserRepairsWithStatus:@"1"];
}
- (void)setupTableView{
    
    self.baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, Screen_width, Screen_height - HeightOfStatusBar - HeightOfNavigationBar - 30 - HeightOfTabBar)];
    self.baseView.scrollEnabled = NO;
    self.baseView.backgroundColor = [UIColor clearColor];
    if (!isWorker) {
        self.unacceptedTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, self.baseView.frame.size.height) style:UITableViewStylePlain];
        self.unacceptedTable.dataSource = self;
        self.unacceptedTable.delegate = self;
        [self.baseView addSubview:self.unacceptedTable];
        
        self.acceptedTable = [[UITableView alloc]initWithFrame:CGRectMake(Screen_width, 0, Screen_width, self.baseView.frame.size.height) style:UITableViewStylePlain];
        self.acceptedTable.dataSource = self;
        self.acceptedTable.delegate = self;
        [self.baseView addSubview:self.acceptedTable];
        
        self.uncompletedTable = [[UITableView alloc]initWithFrame:CGRectMake(Screen_width * 2, 0, Screen_width, self.baseView.frame.size.height) style:UITableViewStylePlain];
        self.uncompletedTable.dataSource = self;
        self.uncompletedTable.delegate = self;
        [self.baseView addSubview:self.uncompletedTable];
        
        self.completedTable = [[UITableView alloc]initWithFrame:CGRectMake(Screen_width * 3, 0, Screen_width, self.baseView.frame.size.height) style:UITableViewStylePlain];
        self.completedTable.dataSource = self;
        self.completedTable.delegate = self;
        [self.baseView addSubview:self.completedTable];
    }
    
    else
    {
        self.unacceptedTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, self.baseView.frame.size.height) style:UITableViewStylePlain];
        self.unacceptedTable.dataSource = self;
        self.unacceptedTable.delegate = self;
        [self.baseView addSubview:self.unacceptedTable];
        
        self.uncompletedTable = [[UITableView alloc]initWithFrame:CGRectMake(Screen_width * 1, 0, Screen_width, self.baseView.frame.size.height) style:UITableViewStylePlain];
        self.uncompletedTable.dataSource = self;
        self.uncompletedTable.delegate = self;
        [self.baseView addSubview:self.uncompletedTable];
        
        self.completedTable = [[UITableView alloc]initWithFrame:CGRectMake(Screen_width * 2, 0, Screen_width, self.baseView.frame.size.height) style:UITableViewStylePlain];
        self.completedTable.dataSource = self;
        self.completedTable.delegate = self;
        [self.baseView addSubview:self.completedTable];
        
    }
    [self.view addSubview:self.baseView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
}

- (void)initArrays
{
    _array = [NSMutableArray array];
    _unacceptedArray = [NSMutableArray array];
}

- (void)setupSegmentedControl
{
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 30)];
    NSArray *titles = [NSArray array];
    if (isWorker)
        titles = @[@"未受理",@"处理中",@"处理完成"];
    else
        titles = @[@"未分配",@"未受理",@"处理中",@"处理完成"];
    [self.segmentedControl setSectionTitles:titles];
    [self.segmentedControl setSelectedIndex:0];
    [self.segmentedControl setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0f]];
    [self.segmentedControl setBackgroundColor:[UIColor whiteColor]];
    [self.segmentedControl setTextColor:[UIColor blackColor]];
    [self.segmentedControl setSelectionIndicatorColor:[UIColor greenColor]];
    [self.view addSubview:self.segmentedControl];
    [self.segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)refreshTableView
{
    if (isWorker)
    {
        switch (self.segmentedControl.selectedIndex) {
            case 0:
                [_unacceptedArray removeAllObjects];
                [self getUserRepairsWithStatus:@"4"];
                break;
            case 1:
                [_uncompletedArray removeAllObjects];
                [self getUserRepairsWithStatus:@"2"];
                break;
            default:
                [_completedArray removeAllObjects];
                [self getUserRepairsWithStatus:@"3"];
                break;
        }
    }
    else{
        switch (self.segmentedControl.selectedIndex) {
            case 0:
                [_unacceptedArray removeAllObjects];
                [self getUserRepairsWithStatus:@"1"];
                break;
            case 1:
                [_acceptedArray removeAllObjects];
                [self getUserRepairsWithStatus:@"4"];
            case 2:
                [_uncompletedArray removeAllObjects];
                [self getUserRepairsWithStatus:@"2"];
            default:
                [_completedArray removeAllObjects];
                [self getUserRepairsWithStatus:@"3"];
                break;
        }
        
    }

}

- (void)valueChanged:(HMSegmentedControl *)control
{
    if (isWorker) {
        switch (control.selectedIndex) {
            case 0:
                if (!_unacceptedArray) {
                    [self getUserRepairsWithStatus:@"4"];
                }
                break;
                
            case 1:
                if (!_uncompletedArray) {
                    _uncompletedArray = [NSMutableArray array];
                    [self getUserRepairsWithStatus:@"2"];
                }
                break;
            case 2:
                if (!_completedArray) {
                    _completedArray = [NSMutableArray array];
                    [self getUserRepairsWithStatus:@"3"];
                    
                }
            default:
                break;
        }
    }
    else{
        switch (control.selectedIndex) {
            case 0:
                if (!_unacceptedArray) {
                    [self getUserRepairsWithStatus:@"1"];
                }
                break;
            
            case 1:
                if (!_acceptedArray) {
                    _acceptedArray = [NSMutableArray array];
                    [self getUserRepairsWithStatus:@"4"];
                }
            case 2:
                if (!_uncompletedArray) {
                    _uncompletedArray = [NSMutableArray array];
                    [self getUserRepairsWithStatus:@"2"];
                }
                break;
            case 3:
                if (!_completedArray) {
                    _completedArray = [NSMutableArray array];
                    [self getUserRepairsWithStatus:@"3"];
                    
                }
            default:
                break;
        }
    }
    [self.baseView setContentOffset:CGPointMake(Screen_width * self.segmentedControl.selectedIndex, 0)];

}
- (void)addRepairForm
{
    CreateRepairFormViewController *createForm = [[CreateRepairFormViewController alloc]initWithNibName:@"CreateRepairViewController" bundle:nil];
    [self.navigationController pushViewController:createForm animated:YES];
    
}
- (void)refreshTableViewWithStatus
{
    
    if (isWorker) {
        switch (self.segmentedControl.selectedIndex) {
            case 0:
                [_unacceptedTable reloadData ];
            break;
            case 1:
                [_uncompletedTable reloadData];
                break;
    
            default:
                [_completedTable reloadData];
                break;
        }
    }
  else
  {
      switch (self.segmentedControl.selectedIndex) {
          case 0:
              [_unacceptedTable reloadData ];
              break;
          case 1:
              [_acceptedTable reloadData];
              break;
          case 2:
              [_uncompletedTable reloadData];
          default:
              [_completedTable reloadData];
              break;
      }
  }
}

- (void)getUserRepairsWithStatus:(NSString *)status
{
    
    NSString *idstring = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user_profile"] objectForKey:@"community_id"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _array  = [NSMutableArray arrayWithArray:[_repairForm getRepairFormWith:api_get_repairs_by_status communityID:idstring repairStatus:status]] ;
        if (isWorker) {
            switch ([status integerValue]) {
                case 4:
                    _unacceptedArray = _array;
                    break;
                case 2:
                    _uncompletedArray = _array;
                    break;
                case 3:
                    _completedArray = _array;
                default:
                    break;
            }
        }
        else{
            switch ([status integerValue]) {
                case 1:
                    _unacceptedArray = _array;
                    break;
                case 2:
                    _acceptedArray = _array;
                case 3:
                    _uncompletedArray = _array;
                    break;
                case 4:
                    _completedArray = _array;
                default:
                    break;
            }
        }
        dispatch_async(dispatch_get_main_queue(),^{
            
            [self refreshTableViewWithStatus];
            
        });
    });
}
#pragma mark - UITableviewDatasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _unacceptedTable)
        _array = _unacceptedArray;
    else if (tableView == _acceptedTable)
        _array = _acceptedArray;
    else if (tableView == _uncompletedTable)
        _array = _uncompletedArray;
    else
        _array = _completedArray;
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
    
   // RepairForm *form = [self.array objectAtIndex:[indexPath row]];
    RepairForm *form;
    if (tableView == _unacceptedTable) {
        form = [_unacceptedArray objectAtIndex:[indexPath row]];
    }
    else if (tableView ==_acceptedTable)
        form = [_acceptedArray objectAtIndex:[indexPath row]];
    else if (tableView ==_uncompletedTable)
        form = [_uncompletedArray objectAtIndex:[indexPath row]];
    else if (tableView ==_completedTable)
        form = [_completedArray objectAtIndex:[indexPath row]];
    
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
            [self getUserRepairsWithStatus:@"2"];
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

- (void)acceptRepair:(RepairForm *)form
{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer new];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",form.idNum], @"repair_id_string",nil];
    
    [manager POST:api_repair_accept parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"success"]) {
            [self getUserRepairsWithStatus:@"4"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];


}
#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
