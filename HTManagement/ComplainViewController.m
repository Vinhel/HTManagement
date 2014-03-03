//
//  ComplainViewController.m
//  HTManagement
//
//  Created by lyn on 14-1-5.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "ComplainViewController.h"
#import "ComplainForm.h"
#import "AFNetworking.h"
#import "CreateComplainViewController.h"
#import "HMSegmentedControl.h"


@interface ComplainViewController ()

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) ComplainForm *complainForm;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
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

@implementation ComplainViewController

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
    

    _complainForm = [ComplainForm new];
    if (ios7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
	// Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTableView)];
   

    [self initArrays];
    [self setupSegmentedControl];
    [self setupTableView];
}
- (void)setupTableView{
    
    
    self.baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, Screen_width, Screen_height - HeightOfStatusBar - HeightOfNavigationBar - 30)];
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
    if (isWorker) {
        [self getUserComplainsWithStatus:@"4"];
    }
    else
        [self getUserComplainsWithStatus:@"1"];

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
                [self getUserComplainsWithStatus:@"4"];
                break;
            case 1:
                [_uncompletedArray removeAllObjects];
                [self getUserComplainsWithStatus:@"2"];
                break;
            default:
                [_completedArray removeAllObjects];
                [self getUserComplainsWithStatus:@"3"];
                break;
        }
    }
    else{
        switch (self.segmentedControl.selectedIndex) {
            case 0:
                [_unacceptedArray removeAllObjects];
                [self getUserComplainsWithStatus:@"1"];
                break;
            case 1:
                [_acceptedArray removeAllObjects];
                [self getUserComplainsWithStatus:@"4"];
            case 2:
                [_uncompletedArray removeAllObjects];
                [self getUserComplainsWithStatus:@"2"];
            default:
                [_completedArray removeAllObjects];
                [self getUserComplainsWithStatus:@"3"];
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
                    [self getUserComplainsWithStatus:@"4"];
                }
                break;
                
            case 1:
                if (!_uncompletedArray) {
                    _uncompletedArray = [NSMutableArray array];
                    [self getUserComplainsWithStatus:@"2"];
                }
                break;
            case 2:
                if (!_completedArray) {
                    _completedArray = [NSMutableArray array];
                    [self getUserComplainsWithStatus:@"3"];
                    
                }
            default:
                break;
        }
    }
    else{
        switch (control.selectedIndex) {
            case 0:
                if (!_unacceptedArray) {
                    [self getUserComplainsWithStatus:@"1"];
                }
                break;
                
            case 1:
                if (!_acceptedArray) {
                    _acceptedArray = [NSMutableArray array];
                    [self getUserComplainsWithStatus:@"4"];
                }
            case 2:
                if (!_uncompletedArray) {
                    _uncompletedArray = [NSMutableArray array];
                    [self getUserComplainsWithStatus:@"2"];
                }
                break;
            case 3:
                if (!_completedArray) {
                    _completedArray = [NSMutableArray array];
                    [self getUserComplainsWithStatus:@"3"];
                    
                }
            default:
                break;
        }
    }
    [self.baseView setContentOffset:CGPointMake(Screen_width * self.segmentedControl.selectedIndex, 0)];
    
}



- (void)addComplainForm
{

    CreateComplainViewController *createForm = [[CreateComplainViewController alloc]initWithNibName:@"CreateComplainViewController" bundle:nil];
    [self.navigationController pushViewController:createForm animated:YES];

}

- (void)refreshTableViewWithStatus
{if (isWorker) {
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

- (void)getUserComplainsWithStatus:(NSString *)status
{
    
   /*
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
        NSString *status = [@"4" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _untreatedArray  = [NSMutableArray arrayWithArray:[_complainForm getComplainsFormWith:api_get_complains_by_status communityID:idstring  complainsStatus:status]] ;
        
        status = [@"2" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _processingArray  = [NSMutableArray arrayWithArray:[_complainForm getComplainsFormWith:api_get_complains_by_status communityID:idstring  complainsStatus:status]] ;
        
        status = [@"3" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _solovedArray = [NSMutableArray arrayWithArray:[_complainForm getComplainsFormWith:api_get_complains_by_status communityID:idstring  complainsStatus:status]];
        dispatch_async(dispatch_get_main_queue(),^{
        
            [self refreshTableViewWithStatus];
        
        });
    
    });
    
    */
    NSString *idstring = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user_profile"] objectForKey:@"community_id"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       // _array  = [NSMutableArray arrayWithArray:[_complainForm getFormWith:api_get_repairs_by_status communityID:idstring repairStatus:status]] ;
        _array = [NSMutableArray arrayWithArray:[_complainForm getComplainsFormWith:api_get_complains_by_status communityID:idstring complainsStatus:status]] ;
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
    
    ComplainCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ComplainCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    ComplainForm *form;
    if (tableView == _unacceptedTable) {
        form = [_unacceptedArray objectAtIndex:[indexPath row]];
    }
    else if (tableView ==_acceptedTable)
        form = [_acceptedArray objectAtIndex:[indexPath row]];
    else if (tableView ==_uncompletedTable)
        form = [_uncompletedArray objectAtIndex:[indexPath row]];
    else if (tableView ==_completedTable)
        form = [_completedArray objectAtIndex:[indexPath row]];
    
    cell.complainForm = form;

    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)click:(id)sender
{


    NSLog(@"hello");


}


#pragma mark - tableview delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	return cell.frame.size.height;
    
}

#pragma mark - complainCell delegate methods

- (void)finishComplainItem:(ComplainForm *)form
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer new];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",form.complainId], @"complains_id_string",nil];
    
    [manager POST:api_complain_complete parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"success"]) {
            [self getUserComplainsWithStatus:@"2"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];
    
}


- (void)chooseComplainWorker:(ComplainForm *)form
{
    WorkerListViewController *vc = [[WorkerListViewController alloc]init];
    vc.serviceType = HTComplainService;
    vc.form = form;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)feedBack:(ComplainForm *)form
{
    FeedbackViewController *vc = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
    vc.form = form;
    vc.feedbackType = HTcomplain;
    [self.navigationController pushViewController:vc animated:YES];


}

- (void)acceptComplain:(ComplainForm *)form
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer new];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",form.complainId], @"complains_id_string",nil];
    NSLog(@"dict %@",dict);
    [manager POST:api_complain_accept parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"success"]) {
            [self getUserComplainsWithStatus:@"4"];
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
