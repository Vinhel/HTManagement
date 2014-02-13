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
#import "RepairCell.h"
#import "CreateComplainViewController.h"

@interface ComplainViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *untreatedArray;
@property (nonatomic, strong) NSMutableArray *processingArray;
@property (nonatomic, strong) NSMutableArray *solovedArray;
@property (nonatomic, strong) UISegmentedControl *segmented_status;
@property (nonatomic, strong) ComplainForm *complainForm;
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
    if (isResident) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addComplainForm)];
    }

    [self initArrays];
    [self setupSegmentedControl];
    [self setupTableView];}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    [self getUserComplains];


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
- (void)addComplainForm
{

    CreateComplainViewController *createForm = [[CreateComplainViewController alloc]initWithNibName:@"CreateComplainViewController" bundle:nil];
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

- (void)getUserComplains
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
        _untreatedArray  = [NSMutableArray arrayWithArray:[_complainForm getComplainsFormWith:api_get_complains_by_status communityID:idstring  complainsStatus:status]] ;
        
        status = [@"处理中" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _processingArray  = [NSMutableArray arrayWithArray:[_complainForm getComplainsFormWith:api_get_complains_by_status communityID:idstring  complainsStatus:status]] ;
        
        status = [@"已处理" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _solovedArray = [NSMutableArray arrayWithArray:[_complainForm getComplainsFormWith:api_get_complains_by_status communityID:idstring  complainsStatus:status]];
        dispatch_async(dispatch_get_main_queue(),^{
        
            [self refreshTableViewWithStatus];
        
        });
    
    });
    
    
/*
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer new];
    
        NSString *urlString = nil;
    if (isAdmin) {
        urlString =[NSString stringWithFormat:api_get_all_complains,1,_info.community_id];
    }
    else{
    
        urlString = api_own_complain;
    }
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response %@",responseObject);
        
        NSString *keyString = nil;
        if (isAdmin)
            keyString = @"complains_list";
        
        else
            keyString = @"complain_list";
        for (NSDictionary *dict in [responseObject objectForKey:keyString]) {
            ComplainForm *form = [[ComplainForm alloc]initWithDictionary:dict];
            NSLog(@"form %@",form.handler);
            switch ([[dict objectForKey:@"deal_status"] integerValue]) {
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
#pragma mark - UITableviewDatasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    ComplainForm *form = [self.array objectAtIndex:[indexPath row]];
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
            [self getUserComplains];
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

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
