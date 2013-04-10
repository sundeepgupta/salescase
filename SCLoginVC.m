//
//  SCLoginVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-13.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCLoginVC.h"
#import "SCIntuitLoginVC.h"

@interface SCLoginVC ()

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation SCLoginVC

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
    self.title = @"Login";
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.emailTextField selectAll:self.emailTextField];
    
    //Disable the login button if textField is empty
    if (self.emailTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        self.loginButton.enabled = NO;
        self.loginButton.alpha = 0.5;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewDidUnload {
    [self setEmailTextField:nil];
    [self setPasswordTextField:nil];
    [self setLoginButton:nil];
    [super viewDidUnload];
}

#pragma mark - TextField Delegates
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    
    //Enable/disable the login button.  string.length == 0 means Backspace key pressed.  Do later.

//        if (textField.text.length <= 1) {
//            if (string.length == 0) {
//                self.loginButton.enabled = NO;
//                self.loginButton.alpha = 0.5;
//            }
//            } else {
//                self.saveToOrderButton.enabled = YES;
//                self.saveToOrderButton.alpha = 1;
//            }
//        } else {
//            self.saveToOrderButton.enabled = YES;
//            self.saveToOrderButton.alpha = 1;
//        }
    self.loginButton.enabled = YES;
    self.loginButton.alpha = 1;
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{ //disable the save button
    self.loginButton.enabled = NO;
    self.loginButton.alpha = 0.5;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField) {
        [textField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self login];
    }
    return YES;
}


#pragma mark - Custom methods
- (void)login
{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //    SCIntuitLoginVC *intuitLoginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCIntuitLoginVC"];
    //    [self.navigationController pushViewController:intuitLoginVC animated:YES];
}

#pragma mark - IB Methods
- (IBAction)loginButtonPress:(UIButton *)sender {
    [self login];
}

@end
