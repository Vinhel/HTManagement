//
//  LoginViewController.m
//  HTManagement
//
//  Created by lyn on 13-12-17.
//  Copyright (c) 2013年 SFI-china. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "RootsViewController.h"
@interface LoginViewController ()

@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *passwordField;

@end

@implementation LoginViewController

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

}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor colorWithRed:7 / 255.0 green:178 / 255.0 blue:230 / 255.0 alpha:1];
    
    _contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [_contentView setImage:[UIImage imageNamed:@"background.png"]];
    [_contentView setUserInteractionEnabled:YES];
    [self.view addSubview:_contentView];

    _nameField = [[UITextField alloc]initWithFrame:CGRectMake(90, 200, 180, 20)];
    [_nameField setupDoneToolBar:YES];
    [_contentView addSubview:_nameField];
    
    _passwordField = [[UITextField alloc]initWithFrame:CGRectMake(90, 235, 180, 20)];
    [_passwordField setSecureTextEntry:YES];
    [_passwordField setupDoneToolBar:YES];
    [_contentView addSubview:_passwordField];
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, 300, 240, 30)];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"登录条1"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"登录条2"] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];

}

- (void)login
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    NSString *nameString = _nameField.text;
    NSString *passwordString = _passwordField.text;
  
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:nameString,@"username",passwordString,@"password",nil];
    [manager POST:api_user_login parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response %@",responseObject);
        RootsViewController *root = [[RootsViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
       // nav.title = @"首页";
        [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"identity"] forKey:@"role"];
        if (!isAdmin) {
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"user_profile"][0]  forKey:@"user_profile"];
        }
        NSLog(@"community id %@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_profile"] objectForKey:@"community_id"]);
        if ([[responseObject objectForKey:@"info"]isEqualToString:@"login successful"]) {
            [self presentViewController:nav animated:YES completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];
    

}
/*
 
 identity = resident;
 info = "login successful";
 "user_profile" =     (
 {
 address = 54;
 "community_id" = 1;
 email = "user@126.com";
 floor = 1;
 id = 6;

 
 */


/**

 - (void)uploadRepairForm
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer new];
    NSDictionary *parameters = @{@"content": @"我要投诉",@"category":@"个人报修",@"category_item_id":@"20"};
    NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"default@2x.jpg"],0.2);
    [manager POST:@"http://192.168.1.113:8000/api/repair/create/" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //upload_repair_img
        //[formData appendPartWithFileData:filePath name:@"upload_repair_img" error:nil];
        [formData appendPartWithFileData:data name:@"upload_repair_img" fileName:@"default@2x.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
