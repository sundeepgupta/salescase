//
//  SCNewCustomerVC.m
//  SalesCase
//
//  Created by Sundeep Gupta on 13-04-15.
//  Copyright (c) 2013 EnhanceTrade. All rights reserved.
//

#import "SCNewCustomerVC.h"
#import "SCCustomer.h"

@interface SCNewCustomerVC ()

@property (strong, nonatomic) IBOutlet UIButton *captureImageButton;
@end

@implementation SCNewCustomerVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (void)captureImage
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
//        imagePicker.allowsEditing = YES; 
        
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Camera Unavailable" message:@"You're camera seems to be unavailable." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - Image Picker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //get and save the image
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.captureImageButton setImage:image forState:UIControlStateNormal];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    self.customer.image = image;
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IB Methods
- (IBAction)captureButtonPress:(UIButton *)sender {
    [self captureImage];
}
- (void)viewDidUnload {
    [self setCaptureImageButton:nil];
    [super viewDidUnload];
}
@end
