//
//  ScanRepairFormViewController.m
//  HTManagement
//
//  Created by lyn on 13-12-26.
//  Copyright (c) 2013年 SFI-china. All rights reserved.
//

#import "ScanRepairFormViewController.h"
#import "AFNetworking.h"

@interface ScanRepairFormViewController ()

@property (nonatomic, strong) MBProgressHUD *HUD;
@end

@implementation ScanRepairFormViewController

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

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_repairForm) {
        _typeLabel.text = _repairForm.repair_type;
        NSLog(@"idnum %d",_repairForm.idNum);
        _itemLabel.text = [NSString stringWithFormat:@"维修器材id号:%d",_repairForm.idNum];
        _contentView.text = _repairForm.content;
        _contentView.layer.borderWidth = 1;
        
       
        NSLog(@"_imgsrc %@",_repairForm.imgSrc);
        NSLog(@"%@",[imagePath stringByAppendingString:_repairForm.imgSrc]);
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[imagePath stringByAppendingString:_repairForm.imgSrc]]]];
        _imageView.layer.borderWidth = 1;
        if (image) {
            [_imageView setImage:image];
        }
        else
            [_imageView setImage:[UIImage imageNamed:@"报修"]];
        switch (_repairForm.deal_status) {
            case 1:
            {
                [_statusButton setTitle:@"未处理" forState:UIControlStateNormal];
                [_statusButton setEnabled:NO];
            }
                break;
            case 2:
            {
                [_statusButton setTitle:@"处理中" forState:UIControlStateNormal];
               // [_statusButton setEnabled:NO];
                   [_statusButton addTarget:self action:@selector(uploadPleased) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            default:
            {
                if (_repairForm.pleased == 0) {
                    [_statusButton setTitle:@"处理完成" forState:UIControlStateNormal];
                    [_statusButton addTarget:self action:@selector(uploadPleased) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    [_statusButton setTitle:@"已反馈" forState:UIControlStateNormal];
                    [_statusButton setEnabled:NO];
                
                }
                
            }
                break;
        }
    }
 


}

- (void)uploadPleased
{
    FeedbackViewController *viewController = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];

}

#pragma mark - FeedbackSubmitDelegate methods 

- (void)submitWithPleased:(NSInteger)num WithContent:(NSString *)content
{
    NSLog(@"num:%d,content: %@",num,content);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    /*
     {
     'repair_id': '投诉id号',
     'response_content': '反馈内容',
     'selected_pleased':'满意度'（1,2,3,4,5）5个数字选一个(默认是0)
     }
     */
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_repairForm.idNum],@"repair_id",content,@"response_content",[NSString stringWithFormat:@"%d",num],@"selected_pleased", nil];
    
    [manager POST:api_repair_response parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject %@",responseObject);
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        
        [self.view addSubview:_HUD];
        _HUD.labelText = @"满意度提交完成";
        _HUD.mode = MBProgressHUDModeText;
        [_HUD showAnimated:YES whileExecutingBlock:^{
            [self doTask];
        } completionBlock:^{
            [_HUD removeFromSuperview];
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }
     ];
    
    

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
