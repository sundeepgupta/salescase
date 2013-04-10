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
#import "SCPhone.h"
#import "SCEmail.h"
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
-(NSString *)stringForAddressLineNumber:(int)lineNumber fromAddress:(SCAddress *)address
{
    NSString *returnString = @"";
    switch (lineNumber) {
        case 1: {
            if (address.line1) {
                returnString = [NSString stringWithFormat:@"%@", address.line1];
            }
            break;
        }
        case 2: {
            if (address.line2) {
                returnString = [NSString stringWithFormat:@"%@", address.line2];
            }
            break;
        }
        case 3: {
            if (address.line3) {
                returnString = [NSString stringWithFormat:@"%@", address.line3];
            }
            break;
        }
        case 4: {
            if (address.line4) {
                returnString = [NSString stringWithFormat:@"%@", address.line4];
            }
            // Line 4 seems to be reserved for the ZIP + PROVINCE + COUNTRY,
            if (address.city) {
                BOOL foundCity = '\0';
                BOOL foundProvince;
                BOOL foundZip;
                
                if (address.city) {
                    NSRange cityRange = [returnString rangeOfString:address.city options:NSCaseInsensitiveSearch];
                    foundCity = cityRange.location != NSNotFound;
                }
                if (address.countrySubDivisionCode) {
                    NSRange provinceRange = [returnString rangeOfString:address.countrySubDivisionCode options:NSCaseInsensitiveSearch];
                    foundProvince = provinceRange.location != NSNotFound;
                }
                if (address.postalCode) {
                    NSRange zipRange = [returnString rangeOfString:address.postalCode options:NSCaseInsensitiveSearch];
                    foundZip = zipRange.location != NSNotFound;
                }
                if( !foundCity || !foundProvince || !foundZip ) {
                    NSString *cityLine = @"";
                    if (address.city) {
                        cityLine = [NSString stringWithFormat:@"%@%@, ", cityLine, address.city];
                    }
                    if (address.countrySubDivisionCode) {
                        cityLine = [NSString stringWithFormat:@"%@%@ ", cityLine, address.countrySubDivisionCode];
                    }
                    if (address.postalCode) {
                        cityLine = [NSString stringWithFormat:@"%@%@ ", cityLine, address.postalCode];
                    }
                    if (address.country) {
                        cityLine = [NSString stringWithFormat:@"%@%@", cityLine, address.country];
                    }
                    returnString = [NSString stringWithFormat:@"%@%@", returnString, cityLine];
                }
            }
            
            break;
        }
        case 5: {
            if (address.line5) {
                returnString = [NSString stringWithFormat:@"%@", address.line5];
            }
            break;
        }
        default:
            break;
    }
    return returnString;
}

-(NSString *)stringForPhoneTag:(NSString *)phoneTag fromPhoneList:(NSSet *)phoneList
{
    NSString *returnString = @"";
    for (SCPhone *phone in phoneList)
    {
        if ([phone.tag isEqualToString:phoneTag])
            returnString = [NSString stringWithFormat:@"%@%@", returnString, phone.freeFormNumber];
    }
    return returnString;
}

//Moved this to SCCustomer class
//-(NSString *)stringForEmail:(NSSet *)emailList
//{
//    NSString *returnString = @"";
//    // For now only show Business = Mail email
//    for (SCEmail *email in emailList)
//    {
//        if ([email.tag isEqualToString:@"Business"])
//            returnString = [NSString stringWithFormat:@"%@%@", returnString, email.address];
//    }
//    return returnString;
//}

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
    self.address1Label.text = [self stringForAddressLineNumber:1 fromAddress:self.customer.primaryBillingAddress ];
    self.address2Label.text = [self stringForAddressLineNumber:2 fromAddress:self.customer.primaryBillingAddress ];
    self.address3Label.text = [self stringForAddressLineNumber:3 fromAddress:self.customer.primaryBillingAddress ];
    self.address4Label.text = [self stringForAddressLineNumber:4 fromAddress:self.customer.primaryBillingAddress ];
    self.address5Label.text = [self stringForAddressLineNumber:5 fromAddress:self.customer.primaryBillingAddress ];
    self.mainPhoneLabel.text = [self stringForPhoneTag:@"Business" fromPhoneList:self.customer.phoneList];
    self.mobilePhoneLabel.text = [self stringForPhoneTag:@"Mobile" fromPhoneList:self.customer.phoneList];
    self.faxLabel.text = [self stringForPhoneTag:@"Fax" fromPhoneList:self.customer.phoneList];
    self.emailLabel.text = [self.customer mainEmail];
    self.repLabel.text = [NSString stringWithFormat:@"%@", self.customer.salesRep.name ?self.customer.salesRep.name :@""];
    self.termsLabel.text = [NSString stringWithFormat:@"%@", [self formatString:self.customer.salesTerms.name]];
    self.shipTo1Label.text = [self stringForAddressLineNumber:1 fromAddress:self.customer.primaryShippingAddress ];
    self.shipTo2Label.text = [self stringForAddressLineNumber:2 fromAddress:self.customer.primaryShippingAddress ];
    self.shipTo3Label.text = [self stringForAddressLineNumber:3 fromAddress:self.customer.primaryShippingAddress ];
    self.shipTo4Label.text = [self stringForAddressLineNumber:4 fromAddress:self.customer.primaryShippingAddress ];
    self.shipTo5Label.text = [self stringForAddressLineNumber:5 fromAddress:self.customer.primaryShippingAddress ];
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
