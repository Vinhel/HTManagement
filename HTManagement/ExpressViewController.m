//
//  ExpressViewController.m
//  HTManagement
//
//  Created by lyn on 14-1-2.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "ExpressViewController.h"
#import "AFNetworking.h"
#import "ExpressForm.h"
#import "ChooseTypeViewController.h"
#import "FeedbackViewController.h"
#import "HMSegmentedControl.h"

@interface ExpressViewController ()

@property (nonatomic, strong) NSMutableArray *receivedArray;
@property (nonatomic, strong) NSMutableArray *unreceivedArray;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UITableView *unreceivedTable;
@property (nonatomic, strong) UITableView *receivedTable;
@property (nonatomic, strong) ExpressForm *expressForm;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView *baseView;
@end

@implementation ExpressViewController

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
    if (ios7) self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"快递领取";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTableView)];
    
    _expressForm = [ExpressForm new];
    [self initArrays];
    [self setupTableView];
    [self setupSegmentedControl];
    [self getUserExpressWithStatus:@"未领取"];

}

- (void)refreshTableView
{
    switch (self.segmentedControl.selectedIndex) {
            case 0:
                [_unreceivedArray removeAllObjects];
                [self getUserExpressWithStatus:@"未领取"];
                break;
            case 1:
                [_receivedArray removeAllObjects];
                [self getUserExpressWithStatus:@"领取"];
                break;
            default:
                break;
    }
    
}

- (void)initArrays
{
    _array = [NSMutableArray array];
    _unreceivedArray = [ NSMutableArray array];
   
}

- (void)setupTableView
{
    self.baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, Screen_width, Screen_height - HeightOfStatusBar - HeightOfNavigationBar - 30 - HeightOfTabBar)];
    self.baseView.scrollEnabled = NO;
    self.baseView.backgroundColor = [UIColor clearColor];
    self.unreceivedTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, self.baseView.frame.size.height) style:UITableViewStylePlain];
    self.unreceivedTable.dataSource = self;
    self.unreceivedTable.delegate = self;
    [self.baseView addSubview:self.unreceivedTable];
    
    self.receivedTable = [[UITableView alloc]initWithFrame:CGRectMake(Screen_width, 0, Screen_width, self.baseView.frame.size.height) style:UITableViewStylePlain];
    self.receivedTable.dataSource = self;
    self.receivedTable.delegate = self;
    [self.baseView addSubview:self.receivedTable];
    
    [self.view addSubview:self.baseView];


}
- (void)setupSegmentedControl
{
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 30)];
    [self.segmentedControl setSectionTitles:@[@"未领取",@"已领取"]];
    [self.segmentedControl setSelectedIndex:0];
    [self.segmentedControl setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0f]];
    [self.segmentedControl setBackgroundColor:[UIColor whiteColor]];
    [self.segmentedControl setTextColor:[UIColor blackColor]];
    [self.segmentedControl setSelectionIndicatorColor:[UIColor greenColor]];
    [self.view addSubview:self.segmentedControl];
    [self.segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)valueChanged:(HMSegmentedControl *)control
{
    switch (control.selectedIndex) {
        case 0:
            if (!_unreceivedArray) {
                [self getUserExpressWithStatus:@"未领取"];
            }
            break;
        default:
            if (!_receivedArray) {
                _receivedArray = [NSMutableArray array];
                [self getUserExpressWithStatus:@"领取"];
            }
            break;
    }

    [self.baseView setContentOffset:CGPointMake(Screen_width * self.segmentedControl.selectedIndex, 0)];

}

- (void)refreshTableViewWithStatus
{
    switch (self.segmentedControl.selectedIndex) {
        case 0:
            [_unreceivedTable reloadData];
            break;
        default:
            [_receivedTable reloadData];
            break;
    }
}

- (void)getUserExpressWithStatus:(NSString *)statusstring
{
  
   
    NSString *idstring = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user_profile"] objectForKey:@"community_id"];
 
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *status = [statusstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _array = [NSMutableArray arrayWithArray:[_expressForm getExpressesFormWith:api_get_expresses_by_status communityID:idstring expressesStatus:status]] ;
        if ([statusstring isEqualToString:@"未领取"]) {
            _unreceivedArray = _array;
        }
        else{
            _receivedArray = _array;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshTableViewWithStatus];
        });
    });
    
    

    
    //[self refreshTableViewWithStatus];
    

}




#pragma mark - UITableviewDelegate methods


#pragma mark - UITableviewDatasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _unreceivedTable)
        _array = _unreceivedArray;
    else
        _array = _receivedArray;
    return [_array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    ExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ExpressCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
    }
   // ExpressForm *form = (ExpressForm*)[_array objectAtIndex:[indexPath row]];
    ExpressForm *form ;
    if (tableView == _unreceivedTable)
        form = [_unreceivedArray objectAtIndex:[indexPath row]];
    else
        form = [_receivedArray objectAtIndex:[indexPath row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.expressForm = form;
    return cell;

}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpressForm *form = (ExpressForm *)[_array objectAtIndex:[indexPath row]];
    if ([form.get_time isEqualToString:@"None"]) {
        return 94;
    }
  else
    return 140;
    
}

#pragma mark - ExpressCellDelagate methods
- (void)chooseGetExpressType:(ExpressForm *)expressForm
{

  //  NSLog(@"hello");
    ChooseTypeViewController *vc = [[ChooseTypeViewController alloc]initWithNibName:@"ChooseTypeViewController" bundle:nil];
    vc.form = expressForm;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)feedBack:(ExpressForm *)expressForm
{
    FeedbackViewController *vc = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
    vc.form = expressForm;
    vc.feedbackType = HTexpress;
    [self.navigationController pushViewController:vc animated:YES];


}

- (void)finishExpress:(ExpressForm *)expressForm
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer new];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",expressForm.express_id], @"express_id_string",nil];
    
    [manager POST:api_express_complete parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [self getUserExpressWithStatus:@"未领取"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
