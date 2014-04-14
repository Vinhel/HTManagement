//
//  FeedbackViewController.m
//  HTManagement
//
//  Created by lyn on 14-1-9.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "FeedbackViewController.h"
#import "StarRatingView.h"
#import "AFNetworking.h"

#define kBaseNum 4

@interface FeedbackViewController ()

@property (nonatomic, strong) StarRatingView *ratingView;
@property (nonatomic, strong) MBProgressHUD *HUD;
@end

@implementation FeedbackViewController

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
    [_contentView setupDoneToolBar:YES];
    _contentView.layer.borderWidth = 0.5;
    _contentView.layer.borderColor = [[UIColor grayColor]CGColor];
    _contentView.layer.cornerRadius = 5;
    _ratingView = [[StarRatingView alloc]initWithFrame:CGRectMake(10, 30, 250, 50)];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:_ratingView];
}

#pragma mark Button clicked methods

- (IBAction)submitButtonClicked:(id)sender
{
    NSDictionary *dict;
    NSString *string;
    
    switch (self.feedbackType) {
        case HTexpress:
            /*
             'express_id': '快递id号',
             'response_content': '反馈内容',
             'selected_pleased':'满意度'（1,2,3,4,5）5个数字选一个(默认是0)
             
             */
            //self.form = (ExpressForm *)self.form;
            dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[_form express_id]],@"express_id",[NSString stringWithFormat:@"%@",_contentView.text],@"response_content",[NSString stringWithFormat:@"%d",kBaseNum -_ratingView.ratingNum] ,@"selected_pleased",nil];
            string = api_express_response;
            break;
        case HThousekeeping:
            /*
             'housekeeping_id': '家政项目id',
             'response_content': 内容',
             'selected_pleased': '满意度（ 1,2,3,4,5）',
             
             */
            dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[_form housekeeping_id]],@"housekeeping_id",[NSString stringWithFormat:@"%@",_contentView.text],@"response_content",[NSString stringWithFormat:@"%d",kBaseNum - _ratingView.ratingNum] ,@"selected_pleased",nil];
            string = api_housekeeping_response;
            break;
       
       case HTcomplain:
            
            /*
             'complain_id': '投诉id号',
             'response_content': '反馈内容',
             'selected_pleased':'满意度'（1,2,3,4,5）5个数字选一个(默认是0)
             
             */
            dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[_form complainId]],@"complain_id",[NSString stringWithFormat:@"%@",_contentView.text],@"response_content",[NSString stringWithFormat:@"%d",kBaseNum - _ratingView.ratingNum] ,@"selected_pleased",nil];
            string = api_complain_response;
            break;
            
        case HTrepair:
            /*
             'repair_id': '投诉id号',
             'response_content': '反馈内容',
             'selected_pleased':'满意度'（1,2,3,4,5）5个数字选一个(默认是0)
             */
            dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[_form idNum]],@"repair_id",[NSString stringWithFormat:@"%@",_contentView.text],@"response_content",[NSString stringWithFormat:@"%d",kBaseNum - _ratingView.ratingNum] ,@"selected_pleased",nil];
            string = api_repair_response;
            break;
        default:
            break;
    }
    
  //  [self.navigationController popViewControllerAnimated:YES];
    NSLog(@" test %@",self.contentView.text );
    if (_ratingView.ratingNum == 0 && [self.contentView.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您还没有描述" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer new];
        manager.responseSerializer = [AFJSONResponseSerializer new];
        
   
        
        [manager POST:string parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (void)doTask
{
    sleep(1.5);
}


#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
        [UIView animateWithDuration:0.2 animations:^{
            
            //self.view.center.y = self.view.center.y + 138;
            CGPoint center = self.view.center;
            center.y = center.y - 138;
            self.view.center = center;
            
        } completion:nil];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.2 animations:^{
        
        //self.view.center.y = self.view.center.y + 138;
        CGPoint center = self.view.center;
        center.y = center.y + 138;
        self.view.center = center;
        
    } completion:nil];

}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
