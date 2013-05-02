//
//  SCOrderPDFVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-31.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCOrderPDFVC.h"
#import "SCOrderPDFRenderer.h"
#import "SCGlobal.h"
#import "SCDataObject.h"
#import "SCOrderMasterVC.h"
#import "SCOrder.h"
#import "SCConfirmDeleteVC.h"
#import "SCLookMasterVC.h"
#import "SCEmailOrderVC.h"
#import "SCCustomer.h"

@interface SCOrderPDFVC ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) SCGlobal *global;
@property (strong, nonatomic) SCDataObject *dataObject;
@property (strong, nonatomic) UIPopoverController *deleteOrderPC;
@property (strong, nonatomic) UIPopoverController *emailOrderPC;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@end

@implementation SCOrderPDFVC

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
    self.global = [SCGlobal sharedGlobal];
    self.dataObject = self.global.dataObject;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.dataObject.openOrder) {
        self.order = self.dataObject.openOrder;
        
        //hide edit button
        NSMutableArray *toolBarButtons = self.toolbarItems.mutableCopy;
        [toolBarButtons removeObject:self.editButton];
        self.toolbarItems = toolBarButtons;

        //get titles
        UINavigationController *masterNC = self.splitViewController.viewControllers[0];
        SCOrderMasterVC *masterVC = (SCOrderMasterVC *)masterNC.topViewController;
        self.title = [masterVC menuItemLabelForVC:self];
        
    } else {
        self.title = [self titleString];
        if ([self.order.status isEqualToString:SYNCED_STATUS]) {
            //disable the edit button
            self.editButton.enabled = NO;
        }
    }
    
    //generate the pdf and show it here
    SCOrderPDFRenderer *renderer =  [self.storyboard instantiateViewControllerWithIdentifier:@"SCOrderPDFRenderer"];
    renderer.order = self.order;
    [renderer view]; //this is needed to load up the labels and other views in this VC
    [renderer createPDF];
    [self viewPDFDocumentNamed:PDF_FILENAME];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.global.dataObject.openOrder) {
        UINavigationController *masterNC = self.splitViewController.viewControllers[0];
        SCOrderMasterVC *masterVC = (SCOrderMasterVC *)masterNC.topViewController;
        [masterVC processAppearedDetailVC:self];
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

#pragma mark - Custom Methods
- (NSString *)titleString
{
    NSString *status = [self.order fullStatus];
    return [NSString stringWithFormat:@"Order #%@ (%@)", self.order.scOrderId, status];
}

- (NSString *)pathForFileName:(NSString *)name withFileNameExtension:(NSString *)extension
{
    NSString *nameWithExtension = [NSString stringWithFormat:@"%@.%@", name, extension];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:nameWithExtension];
}

- (void)emailOrderTo:(NSArray *)toRecipients andCCTo:(NSArray *)cCRecipients andBCCTo:(NSArray *)bCCRecipients
{
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    
    //Get the user's company name
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *companyInfo = [defaults objectForKey:USER_COMPANY_INFO];
    NSString *userCompanyName = companyInfo[USER_COMPANY_NAME];
    
    
    
    NSString *subject = [NSString stringWithFormat:@"Order #%@ from %@", self.order.scOrderId, userCompanyName];
    NSString *fileName = [NSString stringWithFormat:@"Order %@", self.order.scOrderId];
    NSString *body = [NSString stringWithFormat:@"Dear %@,\n\nA copy of your order is attached to this email. We appreciate your business, thank you.\n\n", self.order.customer.dbaName];
    
    NSString *pdfPath = [self pathForFileName:PDF_FILENAME withFileNameExtension:PDF_FILENAME_EXTENSION];
    if (pdfPath) {
        NSData *pdfData = [NSData dataWithContentsOfFile:pdfPath];
        [self.webView loadData:pdfData MIMEType:PDF_MIME_TYPE textEncodingName:PDF_TEXT_ENCODING baseURL:nil];
        [mailer addAttachmentData:pdfData mimeType:PDF_MIME_TYPE fileName:fileName];
    }
    
    [mailer setSubject:subject];
    [mailer setToRecipients:toRecipients];
    [mailer setCcRecipients:cCRecipients];
    [mailer setBccRecipients:bCCRecipients];
    [mailer setMessageBody:body isHTML:NO];
    [self presentViewController:mailer animated:YES completion:nil];
}

#pragma mark - IB methods
- (IBAction)emailButtonPress:(UIBarButtonItem *)sender {
    if ([MFMailComposeViewController canSendMail]) {
        SCEmailOrderVC *emailOrderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCEmailOrderVC"];
        self.emailOrderPC = [[UIPopoverController alloc] initWithContentViewController:emailOrderVC];
        emailOrderVC.delegate = self;
        [self.emailOrderPC presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Email"
                                                        message:@"Looks like your device isn't setup to send emails."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)printButtonPress:(UIBarButtonItem *)sender {
}

- (IBAction)deleteButtonPress:(UIBarButtonItem *)sender {
    SCConfirmDeleteVC *deleteOrderVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SCConfirmDeleteVC class])];
    self.deleteOrderPC = [[UIPopoverController alloc] initWithContentViewController:deleteOrderVC];
    deleteOrderVC.delegate = self; 
    [self.deleteOrderPC presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)editButtonPress:(UIBarButtonItem *)sender {
    //only visible in look mode and when not synced
    UINavigationController *masterNC = self.splitViewController.viewControllers[0];
    SCLookMasterVC *masterVC = (SCLookMasterVC *)masterNC.topViewController;
    [masterVC startOrderModeWithOrder:self.order]; 
}

#pragma mark - DeleteOrder delegate
- (void)passConfirmDeleteButtonPress
{
    [self.dataObject deleteObject:self.order];
    //Go back to Look Mode, or pop back to OrdersVC
    if (self.dataObject.openOrder) {
        UINavigationController *masterNC = self.splitViewController.viewControllers[0];
        SCOrderMasterVC *masterVC = (SCOrderMasterVC *)masterNC.topViewController;
        [masterVC closeOrderMode];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.deleteOrderPC dismissPopoverAnimated:YES];
}

#pragma mark - EmailOrder Delegate
- (void)passRecipients:(NSArray *)recipients
{
    [self.emailOrderPC dismissPopoverAnimated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *companyInfo = [defaults objectForKey:USER_COMPANY_INFO];
    NSMutableArray *toRecipients = [[NSMutableArray alloc] init];
    NSMutableArray *cCRecipients = [[NSMutableArray alloc] init];
    NSMutableArray *bCCRecipients = [[NSMutableArray alloc] init];
    for (NSString *recipient in recipients) {
        if([recipient isEqualToString:@"Customer"]) {
            [toRecipients addObject:[self.order.customer mainEmail]];
        }
        if ([recipient isEqualToString:@"Office"]) {
            [cCRecipients addObject:[companyInfo objectForKey:USER_COMPANY_EMAIL]];
        }
        if ([recipient isEqualToString:@"Me"]) {
            //get from SalesCase login email?  or..
        }
    }
    [self emailOrderTo:toRecipients andCCTo:cCRecipients andBCCTo:bCCRecipients];
}

#pragma mark - MFMailComposerViewController Delegate Methods
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewPDFDocumentNamed:(NSString *)name
{
    NSString *pdfPath = [self pathForFileName:name withFileNameExtension:@"pdf"];
    if (pdfPath) {
        NSData *pdfData = [NSData dataWithContentsOfFile:pdfPath];
        [self.webView loadData:pdfData MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
    }
}

- (void)viewDidUnload {
    [self setEditButton:nil];
    [super viewDidUnload];
}
@end
