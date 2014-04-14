//
//  ChangePasswordViewController.m
//  HTManagement
//
//  Created by Lyn on 14-4-13.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "AFNetworking.h"
@interface ChangePasswordViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation ChangePasswordViewController

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
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, 300, 200) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.layer.borderWidth = 0.5;
    _tableView.layer.borderColor = [[UIColor grayColor]CGColor];
    _tableView.layer.cornerRadius = 5;
    [self.view addSubview:_tableView];
    if (ios7) {
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(changePassword:)];
    // Do any additional setup after loading the view.
}

- (void)changePassword:(id)sender
{
    UITableViewCell *cell1 = (UITableViewCell *)[_tableView viewWithTag:101];
    UITextField *field1 = (UITextField *)[cell1 viewWithTag:111];
    NSString *password1 = field1.text;
    
    UITableViewCell *cell2 = (UITableViewCell *)[_tableView viewWithTag:102];
    UITextField *field2 = (UITextField *)[cell2 viewWithTag:222];
    NSString *password2 = field2.text;
    
    
    UITableViewCell *cell3 = (UITableViewCell *)[_tableView viewWithTag:103];
    UITextField *field3 = (UITextField *)[cell3 viewWithTag:333];
    NSString *password3 = field3.text;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    manager.responseSerializer = [AFJSONResponseSerializer new];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:password1, @"old_password", password2, @"new_password", password3, @"repeat_password", nil];

    [manager POST:api_user_changepassword parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
        _HUD.labelText = @"提交完成";
        _HUD.mode = MBProgressHUDModeText;
        [_HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1.5);
        } completionBlock:^{
            [_HUD removeFromSuperview];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];
    
}


#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"changecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CGRect textFieldRect = CGRectMake(20, 5, 280, 35);
    UITextField *textFiled = [[UITextField alloc]initWithFrame:textFieldRect];
    textFiled.secureTextEntry = YES;
    textFiled.clearButtonMode = YES;
    textFiled.returnKeyType = UIReturnKeyDone;
    textFiled.delegate = self;
    
    switch ([indexPath row]) {
        case 0:
            cell.tag = 101;
            textFiled.tag = 111;
            textFiled.placeholder = @"请输入旧密码";
            break;
        case 1:
            cell.tag = 102;
            textFiled.tag = 222;
            textFiled.placeholder = @"请输入新密码";
            break;
        case 2:
            cell.tag = 103;
            textFiled.tag = 333;
            textFiled.placeholder = @"请再次输入新密码";
            break;
        default:
            break;
    }
    [cell.contentView addSubview:textFiled];
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
