//
//  CreateComplainViewController.m
//  HTManagement
//
//  Created by lyn on 14-1-5.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "CreateComplainViewController.h"
#import "AFNetworking.h"

@interface CreateComplainViewController ()

@property (nonatomic, strong) DropDownList *dropDownList;
@property (nonatomic, strong) MBProgressHUD *HUD;
@end

@implementation CreateComplainViewController

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
    if (ios7)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [_contentView setupDoneToolBar:YES];
    
    _typeBtn.layer.borderWidth = 1;
    _typeBtn.layer.borderColor = [[UIColor grayColor] CGColor];
  //  [_typeBtn addTarget:self action:@selector(chooseComplainType) forControlEvents:UIControlEventTouchUpInside];
    

    _contentView.layer.borderWidth = 1;
    _contentView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _imgView.layer.borderWidth = 1;
    _imgView.layer.borderColor = [[UIColor grayColor] CGColor];
    _imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseImg)];
    [_imgView addGestureRecognizer:tap];
    
    self.imgPicker = [[UIImagePickerController alloc]init];
    self.imgPicker.allowsEditing = YES;
    self.imgPicker.delegate = self;
    
 
}

- (IBAction)chooseComplainType
{
    NSArray *array = [NSArray arrayWithObjects:@"安全投诉",@"环境投诉",@"员工投诉", nil];
    
    if (_dropDownList == nil) {
        _dropDownList = [DropDownList new];
        _dropDownList.delegate = self;
        [_dropDownList showDropDownList:_typeBtn withContentArray:array withHeight:120];
    }
    else{
        [_dropDownList hideDropDownList:_typeBtn];
        _dropDownList = nil;
    }

}
- (void)dropDownListDelegateMethod:(id)sender WithIndex:(NSIndexPath *)index
{
    NSString *string = (NSString *)sender;
    
    [_typeBtn setTitle:string forState:UIControlStateNormal];
    _dropDownList = nil;
    
}

- (void)chooseImg
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

#pragma mark - sumbit methods

- (IBAction)submit:(id)sender
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_contentView.text],@"content",[NSString stringWithFormat:@"%@",_typeBtn.titleLabel.text],@"category", nil];
    NSLog(@"dict %@,content:%@",[dict objectForKey:@"category"],[dict objectForKey:@"content"]);
    [manager POST:api_complain_create parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        NSData *data;
        NSString *typeString ;
        if (UIImagePNGRepresentation(_imgView.image))
        {
            data = UIImagePNGRepresentation(_imgView.image);
            typeString = @"image/png";
        }
        else
        {
            data = UIImageJPEGRepresentation(_imgView.image, 1);
            typeString = @"image/jpeg";
        }
        [formData appendPartWithFileData:data  name:@"upload_complain_img" fileName:@"img" mimeType:typeString];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response %@",[responseObject objectForKey:@"info"]);
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imgPicker animated:YES completion:nil];
            
        }
    }
    else if (buttonIndex == 1) {
        
        self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imgPicker animated:YES completion:nil];
        
    }
    
    
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
    
    
}


#pragma mark - UIImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"info %@",info);
    UIImage *edit = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imgView.image = edit;
    [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
