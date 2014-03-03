//
//  CreateRepairFormViewController.m
//  HTManagement
//
//  Created by lyn on 13-12-25.
//  Copyright (c) 2013年 SFI-china. All rights reserved.
//

#import "CreateRepairFormViewController.h"
#import "AFNetworking.h"

@interface CreateRepairFormViewController ()

@property (nonatomic, strong) NSMutableArray *personalArray;
@property (nonatomic, strong) NSMutableArray *publicArray;
@property (nonatomic, strong) NSMutableArray *publicNameArray;
@property (nonatomic, strong) NSMutableArray *personalNameArray;
@property (nonatomic, strong) NSIndexPath    *selectedIndex;
@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, strong) DropDownList *dropDownList;

@end

@implementation CreateRepairFormViewController

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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [_content setupDoneToolBar:YES];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sand"]];

    _imageView.layer.borderWidth = 1;
    _imageView.layer.borderColor = [[UIColor grayColor] CGColor];
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseImg)];
    [_imageView addGestureRecognizer:tap];

    self.picker = [[UIImagePickerController alloc]init];
    self.picker.allowsEditing = YES;
    self.picker.delegate = self;
    
    [_typeButton addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
    [_priceButton addTarget:self action:@selector(choosePrice:) forControlEvents:UIControlEventTouchUpInside];
    [_submitButton addTarget:self action:@selector(submitForm:) forControlEvents:UIControlEventTouchUpInside];

    _personalArray = [NSMutableArray array];
    _publicArray = [NSMutableArray array];
    _publicNameArray = [NSMutableArray array];
    _personalNameArray = [NSMutableArray array];

}


#pragma mark - DropDownListDelegate Methods

- (void)dropDownListDelegateMethod:(id)sender WithIndex:(NSIndexPath *)index
{
   NSString *string = (NSString *)sender;
    if ([string isEqualToString:@"个人报修"]||[string isEqualToString:@"公共报修"]) {
        [_typeButton setTitle:string forState:UIControlStateNormal];
        [self addRepairContentWithString:string];
    }
    else{
        [_priceButton setTitle:string forState:UIControlStateNormal];
        _selectedIndex = index;
    }
   _dropDownList = nil;

    
}

#pragma mark -

/*
 初始化个人报修和公共报修的内容
 */

- (void)addRepairContentWithString:(NSString *)string
{
    if ([string isEqualToString:@"个人报修"]&&[_personalArray  count] == 0)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer new];
        NSString *param = [@"个人" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager GET:[api_get_repair_item stringByAppendingString:param] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            for (NSDictionary *dict in [responseObject objectForKey:@"items_list"]) {
                [_personalArray addObject:dict];
            }
            [self preparePersonalNameArray];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error %@",error);
        }];
    }
    if ([string isEqualToString:@"公共报修"]&&[_publicArray count]==0)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer new];
        NSString *param = [@"公共" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager GET:[api_get_repair_item stringByAppendingString:param] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            for (NSDictionary *dict in [responseObject objectForKey:@"items_list"]) {
                [_publicArray addObject:dict];
            }
            [self preparePublicNameArray];
        }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"error %@",error);
        }];
    }

}

/*
 填充个人报修器材
 */
- (void)preparePersonalNameArray
{
    for (NSDictionary *dict in _personalArray) {
        [_personalNameArray addObject:[dict objectForKey:@"item_name"]];
    }

}
/*
 填充公共报修器材
 */
- (void)preparePublicNameArray
{

    for (NSDictionary *dict in _publicArray) {
        [_publicNameArray addObject:[dict objectForKey:@"item_name"]];
    }

}

#pragma mark - Button click methods

- (void)chooseType:(id)sender
{
    NSArray *array = [NSArray arrayWithObjects:@"个人报修",@"公共报修", nil];
    
    if (_dropDownList == nil) {
        _dropDownList = [DropDownList new];
        _dropDownList.delegate = self;
        [_dropDownList showDropDownList:sender withContentArray:array withHeight:80];
    }
    else{
        [_dropDownList hideDropDownList:sender];
        _dropDownList = nil;
    }
    
    
}

- (void)choosePrice:(id)sender
{
    NSArray *array;
    
    if ([_typeButton.titleLabel.text isEqualToString:@"个人报修"]) {
        array = [NSArray arrayWithArray:_personalNameArray];
    }
    if ([_typeButton.titleLabel.text isEqualToString:@"公共报修"]) {
        array = [NSArray arrayWithArray:_publicNameArray];
    }
    if (_dropDownList == nil) {
        _dropDownList = [DropDownList new];
        _dropDownList.delegate = self;
        [_dropDownList showDropDownList:sender withContentArray:array  withHeight:160];
    }
    else{
        [_dropDownList hideDropDownList:sender];
        _dropDownList = nil;
    }

}

- (void)chooseImg
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.imageView];
}

- (void)submitForm:(id)sender
{
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer new];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    NSLog(@"personarray %@\n publicarray %@",_personalArray,_publicArray);
    
    NSString *contentString = _content.text;
    NSString *category = _typeButton.titleLabel.text;
    NSString *item_id;
   
    if ([category isEqualToString:@"个人报修"]) {
        NSDictionary *dict = [_personalArray objectAtIndex:[_selectedIndex row]];
        item_id = [dict objectForKey:@"item_id"] ;
    }
    if ([category isEqualToString:@"公共报修"])
    {
        NSDictionary *dict = [_publicArray objectAtIndex:[_selectedIndex row]];
        item_id = [dict objectForKey:@"item_id"] ;
        
    }
    if ([category isEqualToString:@"个人报修"]||[category isEqualToString:@"公共报修"]) {
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:contentString,@"content",category,@"category",item_id,@"category_item_id", nil];
        [manager POST:api_repair_create parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
        {
             NSData *data;
             NSString *typeString ;
            NSString *filename ;
             if (UIImagePNGRepresentation(_imageView.image))
             {
                 data = UIImagePNGRepresentation(_imageView.image);
                 typeString = @"image/png";
                 filename = @"img.png";
             }
             else
             {
                 data = UIImageJPEGRepresentation(_imageView.image, 1);
                 typeString = @"image/jpeg";
                 filename = @"img.jpg";

             }
             [formData appendPartWithFileData:data  name:@"upload_repair_img" fileName:filename mimeType:typeString];
             
         } success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"responseObject %@",responseObject);
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
   
    
    

}


#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.picker animated:YES completion:nil];

        }
    }
    else if (buttonIndex == 1) {
        
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:YES completion:nil];

    }
    
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [self.picker dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark - UIImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"info %@",info);
    UIImage *edit = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imageView.image = edit;
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideKeyboard
{
    [self.content resignFirstResponder];

}


- (IBAction)dismissKeyBoard
{
    [self.content resignFirstResponder];
}

#pragma mark - UITextTiewDelegate methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"text view string : %@",textView.text);
    NSString *editedString = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([editedString isEqualToString:@""]) {
        self.placeLabel.alpha = 1;

    }
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{

    self.placeLabel.alpha = 0;

}


#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
