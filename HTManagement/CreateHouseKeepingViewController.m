//
//  CreateHouseKeepingViewController.m
//  HTManagement
//
//  Created by lyn on 14-1-5.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "CreateHouseKeepingViewController.h"
#import "ChooseHouseKeepingCell.h"
#import "HouseKeepItem.h"
#import "AFNetworking.h"
@interface CreateHouseKeepingViewController ()

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;


@end

@implementation CreateHouseKeepingViewController

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
    _array = [NSMutableArray array];
    if (ios7) self.edgesForExtendedLayout = UIRectEdgeNone;
	
	
  
	// Do any additional setup after loading the view.
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submitForm)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitForm)];
    [self setupTableView];
    [self getHouseKeepingItem];
}

#pragma mark - submit form

- (void)submitForm
{
    if (self.selectedIndexPath) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer new];
        manager.responseSerializer = [AFJSONResponseSerializer new];
        HouseKeepItem *item =(HouseKeepItem*) [_array objectAtIndex:[self.selectedIndexPath row]];
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",item.item_id],@"housekeeping_item_string", nil];
        
        [manager POST:api_user_submit_housekeeping parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _HUD = [[MBProgressHUD alloc] initWithView:self.view];
            
            [self.view addSubview:_HUD];
            _HUD.labelText = @"提交完成";
            _HUD.mode = MBProgressHUDModeText;
            [_HUD showAnimated:YES whileExecutingBlock:^{
                [self doTask];
            } completionBlock:^{
                [_HUD removeFromSuperview];
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }];

           
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error %@",error);
        }];
        
    }


}
/*
 延时两秒
 */
- (void)doTask
{
    sleep(1.5);
}
#pragma mark - 

- (void)setupTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, iPhone5?504:416)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

- (void)getHouseKeepingItem
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer new];
    [manager GET:api_get_all_housekeepingItem parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response %@",responseObject);
        _pageCount = [[responseObject objectForKey:@"page_count"] integerValue];
        for (NSDictionary *dict in [responseObject objectForKey:@"items_list"]) {
            HouseKeepItem *form = [[HouseKeepItem alloc]initWithDictionary:dict];
            [_array addObject:form];
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];


}

#pragma mark - UITableviewDatasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    ChooseHouseKeepingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ChooseHouseKeepingCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;



    }
    HouseKeepItem *form = (HouseKeepItem*)[_array objectAtIndex:[indexPath row]];
    
    cell.priceLabel.text = form.price_description;
    cell.remarkLabel.text = form.item_remarks;
    cell.contentLabel.text = form.item_content;
    cell.itemLabel.text = form.item_name;

    if ([self.selectedIndexPath isEqual:indexPath])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    


    return cell;
    
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 153;
    
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
