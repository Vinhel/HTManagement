//
//  LoginViewController.m
//  HTManagement
//
//  Created by lyn on 13-12-17.
//  Copyright (c) 2013年 SFI-china. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "FirstViewController.h"
#import "ResidentViewController.h"
#import "RepairViewController.h"
#import "ComplainViewController.h"
#import "ExpressViewController.h"
#import "PersonalViewController.h"
#import "HomeViewController.h"
#import "ServicesViewController.h"
#import "WorkerViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIImageView *inputView;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, assign) BOOL  CENTERCHANGED;
@property (nonatomic, strong) UIView *backView;
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
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    [self.backView setBackgroundColor:[UIColor colorWithRed:7 / 255.0 green:178 / 255.0 blue:230 / 255.0 alpha:1]];
    _logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    _logoView.image = [UIImage imageNamed:@"logo"];
    _logoView.center = CGPointMake(160, 100);
    [self.backView addSubview:_logoView];
    
    _inputView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 60)];
    _inputView.center = CGPointMake(160, 210);
    _inputView.image = [UIImage imageNamed:@"input"];
    _inputView.userInteractionEnabled = YES;
    [self.backView addSubview:_inputView];
    
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
    [self.backView addSubview:_doneButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)];
    [self.view addGestureRecognizer:tap];
    if (iPhone5) {
        CGPoint center = CGPointMake(160, 200);
        self.backView.center = center;
    }
    [self.view addSubview:self.backView];
    _CENTERCHANGED = NO;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!iPhone5) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
  
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.backView.center;
        center.y = center.y + 30;
        self.backView.center = center;
        _CENTERCHANGED = NO;
    } completion:nil];

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
        [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"identity"] forKey:@"role"];
        [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"user_profile"][0]  forKey:@"user_profile"];
  
        if ([[responseObject objectForKey:@"info"]isEqualToString:@"login successful"])
        {
            
            [self bindBaiduPush];
            
            if ([[responseObject objectForKey:@"identity"]isEqualToString:@"worker"]) {
                
                UITabBarController *tab = [UITabBarController new];
                RepairViewController *repair = [RepairViewController new];
                ComplainViewController *complain = [ComplainViewController new];
                ExpressViewController *express = [ExpressViewController new];
                WorkerViewController *personal = [WorkerViewController new];
                
                UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:personal];
                UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:repair];
                UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:complain];
                UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:express];
                tab.viewControllers = @[nav1,nav2,nav3,nav4];
                
                [tab.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab_select_indicator"]];
                [tab.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bg"]];
                nav1.tabBarItem.title = @"报修";
                nav2.tabBarItem.title = @"投诉";
                nav3.tabBarItem.title = @"快递";
                nav4.tabBarItem.title = @"个人中心";
                
                
                nav1.tabBarItem.image = [UIImage imageNamed:@"报修"];
                nav2.tabBarItem.image = [UIImage imageNamed:@"投诉"];
                nav3.tabBarItem.image = [UIImage imageNamed:@"快递"];
                nav4.tabBarItem.image = [UIImage imageNamed:@"person"];
                [self presentViewController:tab animated:YES completion:nil];
               
   
        }
            if ([[responseObject objectForKey:@"identity"]isEqualToString:@"admin"]) {
                [self alertShowWithMessage:@"不支持管理员登陆"];
            }
            
            else
            {
                UITabBarController *tab = [[UITabBarController alloc]init];
                HomeViewController *home = [HomeViewController new];
                ServicesViewController *services = [ServicesViewController new];
                PersonalViewController *personal = [PersonalViewController new];
                
                UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:home];
                UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:services];
                UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:personal];
                tab.viewControllers = @[nav1, nav2, nav3];
                [tab.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bg"]];
                [tab.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab_select_indicator"]];

                
                nav1.tabBarItem.title = @"首页";
                nav2.tabBarItem.title = @"物业服务";
                nav3.tabBarItem.title = @"个人中心";
                
                nav1.tabBarItem.image = [UIImage imageNamed:@"首页"];
                nav2.tabBarItem.image = [UIImage imageNamed:@"物业服务"];
                nav3.tabBarItem.image = [UIImage imageNamed:@"person"];
             
                [self presentViewController:tab animated:NO completion:nil];
            
            
            }
            
            
        }
        else{
            [self alertShowWithMessage:@"用户名或密码错误"];
        
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertShowWithMessage:@"连不上服务器"];
    }];
    
    
    
}

- (void)bindBaiduPush
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"channelid"],@"channel_id",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"user_id",@"ios",@"device_type",nil];
    [manager POST:api_bind parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        NSLog(@"response %@",responseObject);
    
    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"error %@",error);
     }
     
     ];

}

- (void)presentViewController
{
    UINavigationController *nav =[ [UINavigationController alloc]initWithRootViewController:[FirstViewController new]];
    [self presentViewController:nav animated:YES completion:nil];
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
#pragma mark -  TextFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!_CENTERCHANGED && !iPhone5) {
        [UIView animateWithDuration:0.2 animations:^{
            CGPoint center = self.backView.center;
            center.y = center.y - 30;
            self.backView.center = center;
            _CENTERCHANGED = YES;
        } completion:nil];
    }
   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
