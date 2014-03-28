//
//  ChooseTypeViewController.m
//  HTManagement
//
//  Created by lyn on 14-1-20.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "ChooseTypeViewController.h"
#import "AFNetworking.h"



@interface ChooseTypeViewController ()

@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation ChooseTypeViewController

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
    // Do any additional setup after loading the view from its nib.
    
    if (ios7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    
    _typeControl.selectedSegmentIndex = 0;
    _timeControl.selectedSegmentIndex = 0;
}

- (IBAction)buttonClicked:(id)sender
{
    
    
    if (self.form) {
        {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer new];
            manager.responseSerializer = [AFJSONResponseSerializer new];
        
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.form.express_id],@"express_id", [NSString stringWithFormat:@"%d",_typeControl.selectedSegmentIndex + 1],@"express_type" ,[_timeControl titleForSegmentAtIndex:_timeControl.selectedSegmentIndex] ,
                @"allowable_get_express_time",nil];
            
            [manager POST:api_user_obtain_express parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            
        }    }

}

- (void)doTask
{
    sleep(1.5);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
