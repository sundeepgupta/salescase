//
//  SCIntuitLoginVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-20.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCIntuitLoginVC.h"
#import "SCGlobal.h"
#import "SCWebApp.h"

#import "SCIntuitLoginPopoverVC.h"

@interface SCIntuitLoginVC ()

@property (strong, nonatomic) SCGlobal *global;
@property (strong, nonatomic) UIPopoverController *pc;

//IB Stuff
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *finishedIntuitLoginButton;

@end

@implementation SCIntuitLoginVC

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
    self.title = @"Login To Intuit App Center";
    self.global = [SCGlobal sharedGlobal];

    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (![self.global.webApp getTenant]) {
        [self.global.webApp setTenant];
    }
    NSMutableString *url = [[NSMutableString alloc] init];
    [url appendString:WEB_APP_URL];
    [url appendString:OAUTH_REQUEST_URL_EXT];
    [url appendString:@"?tenant="];
    [url appendString:[self.global.webApp getTenant]];
    NSURL *requestUrl = [NSURL URLWithString:url];
    NSURLRequest *httpRequest = [NSURLRequest requestWithURL:requestUrl];
    [self.webView loadRequest:httpRequest];
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
    [self setActivityIndicator:nil];
    [self setFinishedIntuitLoginButton:nil];
    [super viewDidUnload];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
    
    //set focus and bring up keyboard (only supported in iOS 6) - not working
//    if ([webView respondsToSelector:@selector(keyboardDisplayRequiresUserAction)]) {
//        webView.keyboardDisplayRequiresUserAction = NO;
////        [webView loadHTMLString:@"<script>document.getElementById(\"signUpSignInWidgetSignInLoginName\").focus();</script>" baseURL:nil];
//        [webView stringByEvaluatingJavaScriptFromString:@"('#signUpSignInWidgetSignInLoginName').focus();"];
//    }
    
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.pc = nil;
}

#pragma mark - IB Methods
- (IBAction)finishedIntuitLoginButtonPress:(UIBarButtonItem *)sender {
    NSError *error = nil;
    NSMutableDictionary *responseError = nil;
    
    //TESTING
    //    oAuthIsValid = NO;
    
    if (self.pc) {
        [self.pc dismissPopoverAnimated:YES];
        self.pc = nil;
    } else {
        BOOL oAuthIsValid = [self.global.webApp oAuthTokenIsValid:&error responseError:&responseError];
        //TESTING
        //    oAuthIsValid = NO
        
        if  (oAuthIsValid) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.global.webApp setSynced];
        } else {
            UIViewController *intuitLoginPopoverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCIntuitLoginPopoverVC"];
            self.pc = [[UIPopoverController alloc] initWithContentViewController:intuitLoginPopoverVC];
            self.pc.delegate = self;
            [self.pc presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

@end
