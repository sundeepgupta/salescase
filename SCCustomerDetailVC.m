//
//  SCCustomerDetailVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-07.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCCustomerDetailVC.h"
#import "SCGlobal.h"
#import "SCOrderMasterVC.h"
#import "SCCustomer.h"
#import "SCAddress.h"
#import "SCSalesRep.h"
#import "SCSalesTerm.h"
#import "SCCustomersVC.h"
#import "SCOrder.h"
#import "SCDataObject.h"
#import "SCLookMasterVC.h"

@interface SCCustomerDetailVC ()
@property (strong, nonatomic) SCGlobal *global;
@property (strong, nonatomic) SCDataObject *dataObject;
//@property (strong, nonatomic) SCOrderMasterVC *orderMasterVC;

//IB Stuff
@property (strong, nonatomic) IBOutlet UIButton *changeCustomerButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *address1Label;
@property (strong, nonatomic) IBOutlet UILabel *address2Label;
@property (strong, nonatomic) IBOutlet UILabel *address3Label;
@property (strong, nonatomic) IBOutlet UILabel *address4Label;
@property (strong, nonatomic) IBOutlet UILabel *address5Label;
@property (strong, nonatomic) IBOutlet UILabel *mainPhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *mobilePhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *faxLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *repLabel;
@property (strong, nonatomic) IBOutlet UILabel *termsLabel;
@property (strong, nonatomic) IBOutlet UILabel *shipTo1Label;
@property (strong, nonatomic) IBOutlet UILabel *shipTo2Label;
@property (strong, nonatomic) IBOutlet UILabel *shipTo3Label;
@property (strong, nonatomic) IBOutlet UILabel *shipTo4Label;
@property (strong, nonatomic) IBOutlet UILabel *shipTo5Label;

@end

@implementation SCCustomerDetailVC

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
    self.global = [SCGlobal sharedGlobal];
    self.dataObject = self.global.dataObject;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.global.dataObject.openOrder) {
        [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
        self.navigationItem.hidesBackButton = YES;
        
        //get titles
        UINavigationController *masterNC = self.splitViewController.viewControllers[0];
        SCOrderMasterVC *masterVC = (SCOrderMasterVC *)masterNC.topViewController;
        self.title = [masterVC menuItemLabelForVC:self];

        self.customer = self.dataObject.openOrder.customer;
        if (!self.customer) { //if no customers has been loaded, bring up the modal so they can choose
            [self presentCustomerList];
        }
    } else {
        self.title = self.customer.dbaName;
        self.changeCustomerButton.hidden = YES;
        [self.nextButton setTitle:@"New Order With Customer" forState:UIControlStateNormal];
    }
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.global.dataObject.openOrder) {
        //Highlight OrderMasterVC cell if order mode
        UINavigationController *masterNC = self.splitViewController.viewControllers[0];
        SCOrderMasterVC *masterVC = (SCOrderMasterVC *)masterNC.topViewController;
        [masterVC processAppearedDetailVC:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    
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
    [self setChangeCustomerButton:nil];
    [self setCustomerNameLabel:nil];
    [self setCompanyNameLabel:nil];
    [self setContactNameLabel:nil];
    [self setContactTitleLabel:nil];
    [self setAddress1Label:nil];
    [self setAddress2Label:nil];
    [self setAddress3Label:nil];
    [self setAddress4Label:nil];
    [self setAddress5Label:nil];
    [self setMainPhoneLabel:nil];
    [self setMobilePhoneLabel:nil];
    [self setFaxLabel:nil];
    [self setEmailLabel:nil];
    [self setRepLabel:nil];
    [self setTermsLabel:nil];
    [self setShipTo1Label:nil];
    [self setShipTo2Label:nil];
    [self setShipTo3Label:nil];
    [self setShipTo4Label:nil];
    [self setShipTo5Label:nil];
    [self setNextButton:nil];
    [super viewDidUnload];
}

#pragma mark - Custom Methods
-(NSString *)formatString:(NSString *)stringToFormat
{
    if (stringToFormat)
    {
        return stringToFormat;
    }
    else
    {
        return @"";
    }
}

- (void)loadData
{
    self.customerNameLabel.text = [self formatString:self.customer.name];
    self.companyNameLabel.text = [self formatString:self.customer.dbaName ];
    self.contactNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@%@", [self formatString:self.customer.title], [self formatString:self.customer.givenName ], self.customer.middleName ? [NSString stringWithFormat:@"%@ ", self.customer.middleName] : @"", [self formatString:self.customer.familyName]];
    self.contactTitleLabel.text = [self formatString:self.customer.title];
    
    NSArray *billingLines = [self.customer.primaryBillingAddress addressBlock];
    NSArray *billingLabels = [NSArray arrayWithObjects:self.address1Label, self.address2Label, self.address3Label, self.address4Label, self.address5Label, nil];
    [SCCustomerDetailVC loadAddressDataFromLines:billingLines toLabels:billingLabels];
    
    NSArray *shippingLines = [self.customer.primaryShippingAddress addressBlock];
    NSArray *shippingLabels = [NSArray arrayWithObjects:self.shipTo1Label, self.shipTo2Label, self.shipTo3Label, self.shipTo4Label, self.shipTo5Label, nil];
    [SCCustomerDetailVC loadAddressDataFromLines:shippingLines toLabels:shippingLabels];
    
    self.mainPhoneLabel.text = [self.customer phoneForTag:MAIN_PHONE_TAG];
    self.mobilePhoneLabel.text = [self.customer phoneForTag:MOBILE_PHONE_TAG];
    self.faxLabel.text = [self.customer phoneForTag:FAX_PHONE_TAG];
    self.emailLabel.text = [self.customer mainEmail];
    self.repLabel.text = [NSString stringWithFormat:@"%@", self.customer.salesRep.name ?self.customer.salesRep.name :@""];
    self.termsLabel.text = [NSString stringWithFormat:@"%@", [self formatString:self.customer.salesTerms.name]];
    
    
}

+ (void)loadAddressDataFromLines:(NSArray *)lines toLabels:(NSArray *)labels
{
    for (NSInteger i = 0; i < 5; i++) {
        UILabel *label = labels[i];
        if (i < lines.count) {
            label.text = lines[i];
        } else {
            label.text = @"";
        }
    }
}

- (void)presentCustomerList
{
    UINavigationController *customersNC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomersNC"];
    SCCustomersVC *customersVC = (SCCustomersVC *)customersNC.topViewController;
    customersVC.delegate = self;
    [self presentViewController:customersNC animated:YES completion:nil];
}

#pragma mark - Protocol methods
- (void)passCustomer:(SCCustomer *)customer
{ //this only gets called in order mode
    
    if (self.customer && self.customer != customer) { //user changed the customer that was previously set
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Customer Changed"
                                                        message:@"This order's rep and terms will now match this customer's default rep and terms."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok, got it!", nil];
        [alert show];
    }
    self.customer = customer;
    self.dataObject.openOrder.customer = customer;
    self.dataObject.openOrder.salesRep = customer.salesRep;
    self.dataObject.openOrder.salesTerm = customer.salesTerms;
    [self.dataObject saveOrder:self.dataObject.openOrder];
    [self loadData];
}

#pragma mark - IB Methods
- (IBAction)changeCustomerButtonPress:(UIButton *)sender
{
    [self presentCustomerList];
}

- (IBAction)nextButtonPress:(UIButton *)sender {
    if (self.global.dataObject.openOrder) { //save & continue to item cart
        UIViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCItemCartVC"];
        [self.navigationController pushViewController:nextVC animated:YES];
    } else { //start order with current customer
        UINavigationController *masterNC = self.splitViewController.viewControllers[0];
        SCLookMasterVC *masterVC = (SCLookMasterVC *)masterNC.topViewController;
        [masterVC startOrderModeWithCustomer:self.customer];
        
        
    }
}




@end
