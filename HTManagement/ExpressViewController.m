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

@interface ExpressViewController ()

@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSMutableArray *receivedArray;
@property (nonatomic, strong) NSMutableArray *unreceivedArray;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UITableView *expressTable;
@property (nonatomic, strong) UISegmentedControl *segmented_status;
@property (nonatomic, strong) ExpressForm *expressForm;

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
    if (ios7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;

    }
    self.navigationItem.title = @"快递领取";
	// Do any additional setup after loading the view.
    _expressForm = [ExpressForm new];
    
    [self initArrays];
    [self setupTableView];
    [self setupSegmentedControl];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getUserExpress];
    
    
}

- (void)initArrays
{
    _array = [NSMutableArray array];
    _unreceivedArray = [ NSMutableArray array];
    _receivedArray = [NSMutableArray array];


}

- (void)setupTableView
{
    _expressTable = [[UITableView alloc]initWithFrame:CGRectMake(5, 30, 310, iPhone5?474:386)style:UITableViewStylePlain];
    _expressTable.delegate = self;
    _expressTable.dataSource = self;
    [self.view addSubview:_expressTable];

}
- (void)setupSegmentedControl
{
    
    _segmented_status = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"未领取", @"已领取", nil]];
    _segmented_status.frame = CGRectMake(0, 0, 320, 30);
    _segmented_status.selectedSegmentIndex = 0;
    _segmented_status.segmentedControlStyle = UISegmentedControlStyleBar;
    _segmented_status.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_segmented_status addTarget:self action:@selector(refreshTableViewWithStatus) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmented_status];
    
}

- (void)getUserExpress
{
    if ([_receivedArray count]||[_unreceivedArray count]) {
        [_receivedArray removeAllObjects];
        [_unreceivedArray removeAllObjects];
        
    }
   
    NSString *idstring;
    if (isAdmin)
        idstring = [NSString stringWithFormat:@"%d",_info.community_id];
    
    else
        idstring = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user_profile"] objectForKey:@"community_id"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *status = [@"未领取" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _unreceivedArray  = [NSMutableArray arrayWithArray:[_expressForm getExpressesFormWith:api_get_expresses_by_status communityID:idstring expressesStatus:status]] ;
        
        status = [@"领取" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _receivedArray  = [NSMutableArray arrayWithArray:[_expressForm getExpressesFormWith:api_get_expresses_by_status communityID:idstring expressesStatus:status]] ;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshTableViewWithStatus];
        });
    });
    
    

    
    //[self refreshTableViewWithStatus];
    

}

- (void)refreshTableViewWithStatus
{
    switch (_segmented_status.selectedSegmentIndex) {
        case 0:
            _array = [NSMutableArray arrayWithArray:_unreceivedArray];
            break;
       
        default:
            _array = [NSMutableArray arrayWithArray:_receivedArray];
            break;
    }
    
    [_expressTable reloadData];
    


}


#pragma mark - UITableviewDelegate methods


#pragma mark - UITableviewDatasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    ExpressForm *form = (ExpressForm*)[_array objectAtIndex:[indexPath row]];
    

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
        [self getUserExpress];
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
