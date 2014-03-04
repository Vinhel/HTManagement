//
//  LoginViewController.m
//  HTManagement
//
//  Created by lyn on 13-12-17.
//  Copyright (c) 2013年 SFI-china. All rights reserved.
//

#import "LoginViewController.h"
#import "RootsViewController.h"
#import "AFNetworking.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "RepairViewController.h"
#import "ComplainViewController.h"
#import "ExpressViewController.h"


@interface LoginViewController ()

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIImageView *inputView;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

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
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:7 / 255.0 green:178 / 255.0 blue:230 / 255.0 alpha:1]];
    
    _logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    _logoView.image = [UIImage imageNamed:@"logo"];
    _logoView.center = CGPointMake(160, 100);
    [self.view addSubview:_logoView];
    
    _inputView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 60)];
    _inputView.center = CGPointMake(160, 210);
    _inputView.image = [UIImage imageNamed:@"input"];
    _inputView.userInteractionEnabled = YES;
    [self.view addSubview:_inputView];
    
    _usernameTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 240, 30)];
    _usernameTextField.placeholder = @"用户名";
    _usernameTextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    _usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    _passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 30, 240, 30)];
    _passwordTextField.placeholder = @"密码";
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [_inputView addSubview:_usernameTextField];
    [_inputView addSubview:_passwordTextField];
    
    _usernameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _usernameTextField.delegate = self;
    
    _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTextField.delegate = self;
    _doneButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 260, 280, 30)];
    [_doneButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [self.view addSubview:_doneButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)login:(id)sender
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    NSString *nameString = _usernameTextField.text;
    NSString *passwordString = _passwordTextField.text;
    
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:nameString,@"username",passwordString,@"password",nil];
    [manager POST:api_user_login parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response %@",responseObject);
        RootsViewController *roots = [RootsViewController new];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:roots];
        [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"identity"] forKey:@"role"];
        if (!isAdmin) {
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"user_profile"][0]  forKey:@"user_profile"];
        }
        NSLog(@"community id %@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_profile"] objectForKey:@"community_id"]);
        if ([[responseObject objectForKey:@"info"]isEqualToString:@"login successful"]) {
           // [self presentViewController:nav animated:YES completion:nil];
            
            //tabbarcontrol
            
            UITabBarController *tab = [UITabBarController new];
            
            RepairViewController *repair = [RepairViewController new];
            ComplainViewController *complain = [ComplainViewController new];
            ExpressViewController *express = [ExpressViewController new];
            
            UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:repair];
            UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:complain];
            UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:express];
            tab.viewControllers = @[nav1,nav2,nav3];
            
            [tab.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab_select_indicator"]];
            [tab.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bg"]];
            nav1.tabBarItem.title = @"报修";
            nav2.tabBarItem.title = @"投诉";
            nav3.tabBarItem.title = @"快递";
          
            nav1.tabBarItem.image = [UIImage imageNamed:@"报修"];
            nav2.tabBarItem.image = [UIImage imageNamed:@"投诉"];
            nav3.tabBarItem.image = [UIImage imageNamed:@"快递"];
            [self presentViewController:tab animated:YES completion:nil];
            
            //[self presentViewController];
            
        }
        else{
            [self alertShowWithMessage:@"用户名或密码错误"];
        
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertShowWithMessage:@"连不上服务器"];
    }];
    
    
    
}

- (void)presentViewController
{
    UINavigationController *nav =[ [UINavigationController alloc]initWithRootViewController:[FirstViewController new]];
     UINavigationController *nav2 =[ [UINavigationController alloc]initWithRootViewController:[SecondViewController new]];
    UITabBarController *tab = [[UITabBarController alloc]init];
    tab.viewControllers = @[nav,nav2];
    [self presentViewController:tab animated:YES completion:nil];
}

- (void)alertShowWithMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alertView show];


}


- (void)resignKeyboard
{
    [_passwordTextField resignFirstResponder];
    [_usernameTextField resignFirstResponder];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
