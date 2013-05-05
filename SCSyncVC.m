//
//  SCSyncVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-21.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCSyncVC.h"
#import "SCGlobal.h"
#import "SCWebApp.h"
#import "SCDataObject.h"
#import "SCCustomer.h"
#import "SCOrder.h"
#import "SCItem.h"
#import "SCSalesRep.h"
#import "SCSalesTerm.h"
#import "SCShipMethod.h"
#import "SCLine.h"
#import "NSString+URLEncoding.h"

@interface SCSyncVC ()
@property (strong, nonatomic) SCGlobal *global;
@property (strong, nonatomic) SCWebApp *webApp;
@property (strong, nonatomic) SCDataObject *dataObject;

//IB Stuff

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeButton;
@end

@implementation SCSyncVC

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
    self.title = @"Sync";
    self.global = [SCGlobal sharedGlobal];
    self.webApp = self.global.webApp;
    self.dataObject = self.global.dataObject;
}

- (void)viewWillAppear:(BOOL)animated
{
    //disable and back button
    self.closeButton.enabled = NO;
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    switch (self.syncMethod) {
        case EVERYTHING_SYNC:
            [self syncEverything];
            break;
        case COMPANY_INFO_SYNC:
            [self syncCompanyInfo];
            break;
        case ORDERS_SYNC:
            [self syncOrders];
            break;
        case CUSTOMERS_SYNC:
            [self syncCustomers];
            break;
        case ITEMS_SYNC:
            [self syncItems];
            break;
        default:
            break;
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
    [self setTitleLabel:nil];
    [self setActivityIndicator:nil];
    [self setTextView:nil];
    [self setCloseButton:nil];
    [super viewDidUnload];
}

#pragma mark - Sundeep's Methods
- (void)syncEverything
{
    //This function really should be an amalgamation of the other sync methods, so optimize later
    
    NSError *oAuthError = nil;
    NSError *companyInfoError = nil;
    NSError *repsError = nil;
    NSError *termsError = nil;
    NSError *shipViasError = nil;
    NSError *customersError = nil;
    NSError *itemsError = nil;
    NSError *ordersError = nil;
    NSError *newCustomersError = nil;
    
    NSDictionary *oAuthResponseError;
//    NSDictionary *companyInfoResponseError = nil;
    NSDictionary *repsResponseError = nil;
    NSDictionary *termsResponseError = nil;
    NSDictionary *shipViasResponseError = nil;
//    NSDictionary *customersResponseError = nil;
//    NSDictionary *itemsResponseError = nil;
    NSDictionary *ordersResponseError;
    NSDictionary *newCustomersResponseError;
    BOOL hadSyncError = NO;
    NSMutableString *syncErrorString = [NSMutableString stringWithString:@""];
    
    if ([self.webApp oAuthTokenIsValid:&oAuthError responseError:&oAuthResponseError]) {
        
        if (![self downloadCompanyInfo:&companyInfoError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to sync company info. Error: \n%@", companyInfoError];
            hadSyncError = YES;
        }      
        
        if (![self downloadReps:&repsError responseError:&repsResponseError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to sync reps.\nError: %@\nResponse Error: %@", repsError, repsResponseError[@"error"]];
            hadSyncError = YES;
        }
        
        if (![self downloadTerms:&termsError responseError:&termsResponseError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to sync terms.  Error: \n%@", termsError];
            hadSyncError = YES;
        }
        
        if (![self downloadShipVias:&shipViasError responseError:&shipViasResponseError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to sync ship vias.  Error: \n%@", shipViasError];
            hadSyncError = YES;
        }
        
        if (![self uploadNewCustomers:&newCustomersError responseError:&newCustomersResponseError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to upload new customers. Error: %@\nResponse Error: %@\nMessage: %@\nErrorDetail: %@\nCustomer Name: %@", newCustomersError, newCustomersResponseError[@"error"], newCustomersResponseError[@"msg"], newCustomersResponseError[@"errorDetail"], newCustomersResponseError[@"name"]];
            hadSyncError = YES;
        }
        
        if (![self downloadCustomers:&customersError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to sync customers.  Error: \n%@", customersError];
            hadSyncError = YES;
        }
        
        if (![self downloadItems:&itemsError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to sync items.  Error: \n%@", itemsError];
            hadSyncError = YES;
        }
        
        if (![self uploadOrders:&ordersError responseError:&ordersResponseError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to sync orders. Error: %@\nResponse Error: %@\nMessage: %@\nErrorDetail: %@\nSCOrderID: %@", ordersError, ordersResponseError[@"error"], ordersResponseError[@"msg"], ordersResponseError[@"errorDetail"], ordersResponseError[@"SCOrderID"]];
            hadSyncError = YES;
        }
        
        [self handleFinishedSyncErrorWithStatus:hadSyncError withErrorString:syncErrorString];
        
    } else { //Connection not good, couldn't even start syncing.
        [self handleConnectionErrorWithOAuthError:oAuthError withOAuthResponseError:oAuthResponseError];
    }
    [self finalizeView];
}

- (void)syncCompanyInfo
{
    NSError *connectionError = nil;
    NSError *companyInfoError = nil;
    NSError *repsError = nil;
    NSError *termsError = nil;
    NSError *shipViasError = nil;
    
    NSDictionary *oAuthResponseError;
    NSDictionary *repsResponseError = nil;
    NSDictionary *termsResponseError = nil;
    NSDictionary *shipViasResponseError = nil;
    
    BOOL hadSyncError = NO;
    NSMutableString *syncErrorString = [NSMutableString stringWithString:@""];
    
    if ([self.webApp oAuthTokenIsValid:&connectionError responseError:&oAuthResponseError]) {
        
        if (![self downloadCompanyInfo:&companyInfoError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to sync company info. Error: \n%@", companyInfoError];
            hadSyncError = YES;
        }
        
        if (![self downloadReps:&repsError responseError:&repsResponseError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to sync reps.\nError: %@\nResponse Error: %@", repsError, repsResponseError[@"error"]];
            hadSyncError = YES;
        }
        
        if (![self downloadTerms:&termsError responseError:&termsResponseError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to sync terms.  Error: \n%@", termsError];
            hadSyncError = YES;
        }
        
        if (![self downloadShipVias:&shipViasError responseError:&shipViasResponseError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to sync ship vias.  Error: \n%@", shipViasError];
            hadSyncError = YES;
        }
                
        if (hadSyncError) {
            self.titleLabel.text = @"Synced With Errors";
            self.textView.text = syncErrorString;
        } else {
            self.titleLabel.text = @"Synced Successfully";
            self.textView.text = @"Sync finished without errors.";
        }
        
    } else { //Connection not good, couldn't even start syncing.
        //        hadConnectionError = YES;
        
        self.titleLabel.text = @"Sync Failed";
        
        if (![self.webApp isOnline:&connectionError]) {
            self.textView.text = [NSString stringWithFormat:@"Can't connect to the internet. Error: \n%@", connectionError];
        } else if (![self.webApp canConnectToSalesCaseWebApp:&connectionError]) {
            self.textView.text = [NSString stringWithFormat:@"Can't connect to SalesCase servers. Error: \n%@", connectionError];
        } else {
            self.textView.text = [NSString stringWithFormat:@"Can't connect to your App Center account. Error: %@\nResponse Error: %@\nMessage: %@\nErrorDetail: %@", connectionError, oAuthResponseError[@"error"], oAuthResponseError[@"msg"], oAuthResponseError[@"errorDetail"]];
        }
    }
    [self finalizeView];
}

- (void)syncOrders
{    
    NSError *oAuthError = nil;
    NSError *ordersError = nil;
    NSDictionary *oAuthResponseError;
    NSDictionary *ordersResponseError;
    BOOL hadSyncError = NO;
    NSMutableString *syncErrorString = [NSMutableString stringWithString:@""];
    if ([self.webApp oAuthTokenIsValid:&oAuthError responseError:&oAuthResponseError]) {
        if (![self uploadOrders:&ordersError responseError:&ordersResponseError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to sync orders. Error: %@\nResponse Error: %@\nMessage: %@\nErrorDetail: %@\nSCOrderID: %@", ordersError, ordersResponseError[@"error"], ordersResponseError[@"msg"], ordersResponseError[@"errorDetail"], ordersResponseError[@"SCOrderID"]];
            hadSyncError = YES;
        }
        [self handleFinishedSyncErrorWithStatus:hadSyncError withErrorString:syncErrorString];
    } else { //Connection not good, couldn't even start syncing.
        [self handleConnectionErrorWithOAuthError:oAuthError withOAuthResponseError:oAuthResponseError];
    }
    [self finalizeView];
}

- (void)syncCustomers
{
    NSError *oAuthError = nil;
    NSError *customersError = nil;
    NSError *newCustomersError = nil;
    NSDictionary *oAuthResponseError;
    NSDictionary *newCustomersResponseError;
    BOOL hadSyncError = NO;
    NSMutableString *syncErrorString = [NSMutableString stringWithString:@""];
    if ([self.webApp oAuthTokenIsValid:&oAuthError responseError:&oAuthResponseError]) {
        if (![self uploadNewCustomers:&newCustomersError responseError:&newCustomersResponseError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to upload new customers. Error: %@\nResponse Error: %@\nMessage: %@\nErrorDetail: %@\nCustomer Name: %@", newCustomersError, newCustomersResponseError[@"error"], newCustomersResponseError[@"msg"], newCustomersResponseError[@"errorDetail"], newCustomersResponseError[@"name"]];
            hadSyncError = YES;
        }
        
        if (![self downloadCustomers:&customersError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to sync customers.  Error: \n%@", customersError];
            hadSyncError = YES;
        }
        [self handleFinishedSyncErrorWithStatus:hadSyncError withErrorString:syncErrorString];
    } else { //Connection not good, couldn't even start syncing.
        [self handleConnectionErrorWithOAuthError:oAuthError withOAuthResponseError:oAuthResponseError];
    }
    [self finalizeView];
}

- (void)syncItems
{
    NSError *oAuthError = nil;
    NSError *itemsError = nil;
    NSDictionary *oAuthResponseError;
    BOOL hadSyncError = NO;
    NSMutableString *syncErrorString = [NSMutableString stringWithString:@""];
    if ([self.webApp oAuthTokenIsValid:&oAuthError responseError:&oAuthResponseError]) {
        if (![self downloadItems:&itemsError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to sync items.  Error: \n%@", itemsError];
            hadSyncError = YES;
        }
        [self handleFinishedSyncErrorWithStatus:hadSyncError withErrorString:syncErrorString];
    } else { //Connection not good, couldn't even start syncing.
        [self handleConnectionErrorWithOAuthError:oAuthError withOAuthResponseError:oAuthResponseError];
    }
    [self finalizeView];
}

- (void)handleFinishedSyncErrorWithStatus:(BOOL)hadSyncError withErrorString:(NSString *)syncErrorString
{
    if (hadSyncError) {
        self.titleLabel.text = @"Synced With Errors";
        self.textView.text = syncErrorString;
    } else {
        self.titleLabel.text = @"Synced Successfully";
        self.textView.text = @"Sync finished without errors.";
    }
}

- (void)handleConnectionErrorWithOAuthError:(NSError *)oAuthError withOAuthResponseError:(NSDictionary *)oAuthResponseError
{
    self.titleLabel.text = @"Sync Failed";
    
    NSError *connectionError = nil;
    if (![self.webApp isOnline:&connectionError]) {
        self.textView.text = [NSString stringWithFormat:@"Can't connect to the internet. Error: \n%@", connectionError];
    } else if (![self.webApp canConnectToSalesCaseWebApp:&connectionError]) {
        self.textView.text = [NSString stringWithFormat:@"Can't connect to SalesCase servers. Error: \n%@", connectionError];
    } else {
        self.textView.text = [NSString stringWithFormat:@"Can't connect to your App Center account. Error: %@\nResponse Error: %@\nMessage: %@\nErrorDetail: %@", oAuthError, oAuthResponseError[@"error"], oAuthResponseError[@"msg"], oAuthResponseError[@"errorDetail"]];
    }
}

- (void)finalizeView
{
    //Set the view components
    [self.activityIndicator stopAnimating];
    self.closeButton.enabled = YES;
    self.navigationItem.hidesBackButton = NO;
}

-(BOOL) downloadCompanyInfo:(NSError **)error
{
    NSDictionary *responseDict = [self.webApp dictionaryFromUrlExtension:LIST_COMPANY_INFO_URL_EXT error:error];
    if (!responseDict) {
        return NO;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:responseDict forKey:USER_COMPANY_INFO];
    [defaults synchronize];
    return YES;
}

- (BOOL)downloadReps:(NSError **)error responseError:(NSDictionary **)responseError {
    NSArray *responseArray = [self.webApp arrayFromUrlExtension:LIST_SALES_REPS_URL_EXT withPageNumber:-1 error:error responseError:responseError];  
    if (!responseArray) {
        return NO;
    }
    if (responseArray.count == 0) {
        return YES;
    }
    
    for (NSDictionary *newRepDict in responseArray) {
        SCSalesRep *newRep;
        SCSalesRep *oldRep = (SCSalesRep *) [self.dataObject getEntityType:ENTITY_SCSALESREP byIdentifier:@"repId" idValue:[newRepDict valueForKey:@"Id"]];
        if(oldRep) {
            newRep = oldRep;
        }
        else {
            newRep = (SCSalesRep *) [self.dataObject newObject:ENTITY_SCSALESREP];
        }
        newRep.repId = [newRepDict valueForKey:@"Id"];
        newRep.name = (NSString *)[self.dataObject dictionaryData:newRepDict forKey:@"Name"];
//        newRep.initials = (NSString *)[self.dataObject dictionaryData:newRepDict forKey:@"Initials"];
    }
    return [self.dataObject.managedObjectContext save:error];
}

- (BOOL)downloadTerms:(NSError **)error responseError:(NSDictionary **)responseError
{
    NSArray *responseArray = [self.webApp arrayFromUrlExtension:LIST_SALES_TERMS_URL_EXT withPageNumber:-1 error:error responseError:responseError];
    if (!responseArray) {
        return NO;
    }
    if (responseArray.count == 0) {
        return YES;
    }
    for (NSDictionary *newTermDict in responseArray)
    {
        SCSalesTerm *newTerm;
        
        SCSalesTerm *oldTerm = (SCSalesTerm *) [self.dataObject getEntityType:ENTITY_SCSALESTERM
                                                                      byIdentifier:@"termId"
                                                                           idValue:[newTermDict valueForKey:@"Id"]
                                                     ];
        if(oldTerm)
        {
            newTerm = oldTerm;
        }
        else
        {
            newTerm  = (SCSalesTerm *) [self.dataObject newObject:ENTITY_SCSALESTERM];
        }
        newTerm.termId = [self.dataObject dictionaryData:newTermDict forKey:@"Id"];
//        newTerm.dueDays = [self.dataObject dictionaryData:newTermDict forKey:@"DueDays"];
//        newTerm.discountDays = [self.dataObject dictionaryData:newTermDict forKey:@"DiscountDays"];
        newTerm.name = [self.dataObject dictionaryData:newTermDict forKey:@"Name"];
//        newTerm.type = [self.dataObject dictionaryData:newTermDict forKey:@"Type"];
    }
    return [self.dataObject.managedObjectContext save:error];
}

- (BOOL)downloadShipVias:(NSError **)error responseError:(NSDictionary **)responseError
{
    NSArray *responseArray = [self.webApp arrayFromUrlExtension:LIST_SHIP_METHODS_URL_EXT withPageNumber:-1 error:error responseError:responseError];
    if (!responseArray) {
        return NO;
    }
    if (responseArray.count == 0) {
        return YES;
    }
    for (NSDictionary *newShipViaDict in responseArray)
    {
        SCShipMethod *newShipVia;
        SCShipMethod *oldShipVia = (SCShipMethod *) [self.dataObject getEntityType:ENTITY_SCSHIPMETHOD
                                                                          byIdentifier:@"id"
                                                                               idValue:[newShipViaDict valueForKey:@"Id"]
                                                         ];
        if (oldShipVia)
        {
            newShipVia = oldShipVia;
        }
        else
        {
            newShipVia = (SCShipMethod *) [self.dataObject newObject:ENTITY_SCSHIPMETHOD];
        }
        newShipVia.id = [self.dataObject dictionaryData:newShipViaDict forKey:@"Id"];
        newShipVia.name = [self.dataObject dictionaryData:newShipViaDict forKey:@"Name"];
    }
    return [self.dataObject.managedObjectContext save:error];
}

- (BOOL)downloadCustomers:(NSError **)error 
{
    NSInteger page = 1;
    BOOL done = NO;
    BOOL didSave;
    
    while (!done) {
        NSArray *responseArray = [self.webApp arrayFromUrlExtension:LIST_CUSTOMERS_URL_EXT withPageNumber:page error:error];
        if (!responseArray) {
            return NO;
        }
        
        if (responseArray.count == 0) {
            done = YES;
        } else {
            for (NSDictionary *ippCustomerDict in responseArray) {
                SCCustomer *oldCustomer = (SCCustomer *) [self.dataObject getEntityType:ENTITY_SCCUSTOMER byIdentifier:@"customerId" idValue:[ippCustomerDict valueForKey:@"Id"]];
                
                SCCustomer *justUploadedCustomer = (SCCustomer *) [self.dataObject getEntityType:ENTITY_SCCUSTOMER byIdentifier:@"name" idValue:ippCustomerDict[@"Name"]];
                
                SCCustomer *newCustomer;
                if (oldCustomer) {
                    newCustomer = oldCustomer;
                } else if (justUploadedCustomer) {
                    newCustomer = justUploadedCustomer;
                } else {
                    newCustomer = (SCCustomer *) [self.dataObject newObject:ENTITY_SCCUSTOMER];
                    newCustomer.orderList = nil;
                }
                
                newCustomer.name = [self.dataObject dictionaryData:ippCustomerDict forKey:@"Name"];
                newCustomer.dbaName = [self.dataObject dictionaryData:ippCustomerDict forKey:@"DBAName"];
                newCustomer.givenName = [self.dataObject dictionaryData:ippCustomerDict forKey:@"GivenName"];
                newCustomer.middleName = [self.dataObject dictionaryData:ippCustomerDict forKey:@"MiddleName"];
                newCustomer.familyName = [self.dataObject dictionaryData:ippCustomerDict forKey:@"FamilyName"];
                newCustomer.title = [self.dataObject dictionaryData:ippCustomerDict forKey:@"Title"];
                newCustomer.customerId = [ippCustomerDict valueForKey:@"Id"];
                newCustomer.qbId = [ippCustomerDict valueForKey:@"ExternalKey"];
                
                newCustomer.status = SYNCED_STATUS;
                
                
                NSDictionary *addresses = [ippCustomerDict valueForKey:@"Address"];
                [self.dataObject saveAddressList:addresses forCustomer:newCustomer];
                
                NSDictionary *phones = [ippCustomerDict valueForKey:@"Phone"];
                [self.dataObject savePhoneList:phones forCustomer:newCustomer];
                
                NSDictionary *emails = [ippCustomerDict valueForKey:@"Email"];
                [self.dataObject saveEmailList:emails forCustomer:newCustomer];
                newCustomer.salesRep = (SCSalesRep *) [self.dataObject getEntityType:ENTITY_SCSALESREP byIdentifier:@"repId" idValue:[ippCustomerDict valueForKey:@"SalesRepId"]];
                newCustomer.salesTerms = (SCSalesTerm *) [self.dataObject getEntityType:ENTITY_SCSALESTERM byIdentifier:@"termId" idValue:[ippCustomerDict valueForKey:@"SalesTermId"]];
            }
            didSave = [self.dataObject.managedObjectContext save:error];
            if (!didSave) {
                return NO;
            }
            page = page + 1;
        }
    }
    return YES;
}

- (BOOL)downloadItems:(NSError **)error 
{
    NSInteger page = 1;
    BOOL done = NO;
    BOOL didSave;
    
    while (!done) {
        NSArray *responseArray = [self.webApp arrayFromUrlExtension:LIST_ITEMS_URL_EXT withPageNumber:page error:error];
        if (!responseArray) {
            return NO;
        }
        
        if (responseArray.count == 0) {
            done = YES;
        } else {
            for (NSDictionary *newItemDict in responseArray)
            {
                SCItem *oldItem = (SCItem *) [self.dataObject getEntityType:ENTITY_SCITEM
                                                               byIdentifier:@"itemId"
                                                                    idValue:[newItemDict valueForKey:@"Id"]
                                              ];
                SCItem *newItem;
                
                if (oldItem)
                {
                    newItem = oldItem;
                    
                }
                else
                {
                    newItem = (SCItem *)[self.dataObject newObject:@"SCItem"];
                }
                newItem.itemId = [newItemDict valueForKey:@"Id"];
                newItem.name = [newItemDict valueForKey:@"Name"];
                newItem.itemDescription = [newItemDict valueForKey:@"Description"];
                
                NSString *qOH = (NSString *)[newItemDict valueForKey:@"Quantity"];
                if ([ [qOH class] isSubclassOfClass:[NSString class]])
                    newItem.quantityOnHand = @([qOH floatValue])  ;
                
                NSString *priceString = (NSString *)[newItemDict valueForKey:@"Price"];
                if ([[ priceString class] isSubclassOfClass:[NSString class]])
                    newItem.price = (NSNumber *)@([priceString floatValue]);
                
                NSString *quantityOnSalesOrderString = (NSString *)[newItemDict valueForKey:@"QuantityOnSalesOrder"];
                if ([[ quantityOnSalesOrderString class] isSubclassOfClass:[NSString class]])
                    newItem.quantityOnSalesOrder = (NSNumber *)@([quantityOnSalesOrderString floatValue]);
                
                NSString *quantityOnPurchaseString = (NSString *)[newItemDict valueForKey:@"QuantityOnPurchase"];
                if ([[ quantityOnPurchaseString class] isSubclassOfClass:[NSString class]])
                    newItem.quantityOnPurchase = (NSNumber *)@([quantityOnPurchaseString floatValue]);

            }
            didSave = [self.dataObject.managedObjectContext save:error];
            if (!didSave) {
                return NO;
            }
            page = page + 1;
        }
    }
    return YES;
}

- (BOOL)uploadNewCustomers:(NSError **)error responseError:(NSDictionary **)responseError
{
    NSArray *customers = [self.dataObject objectsOfType:ENTITY_SCCUSTOMER withStatus:NEW_STATUS withError:error];
    if (!customers) {
        return NO;
    }
    
    NSURL *url = [self.webApp urlFromUrlExtension:SEND_CUSTOMER_URL_EXT];
    
    for (SCCustomer *customer in customers) {
        //Handle required fields first (which are validated during user input)
        NSMutableString *postString = [NSMutableString stringWithFormat:@"Name=%@", [customer.name urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        //BillTo1 is required, but being handled by web app for better UX
        
        
        //OPtional fields (dbaName is pretending to be required in the app for PDF purposes)
        if (customer.dbaName) [postString appendFormat:@"&DBAName=%@", [customer.dbaName urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        if (customer.givenName) [postString appendFormat:@"&GivenName=%@", [customer.givenName urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        if (customer.familyName) [postString appendFormat:@"&FamilyName=%@", [customer.familyName urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        
        if ([customer phoneForTag:MAIN_PHONE_TAG].length != 0) [postString appendFormat:@"&BusinessPhone=%@", [[customer phoneForTag:MAIN_PHONE_TAG] urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        if ([customer phoneForTag:FAX_PHONE_TAG].length != 0) [postString appendFormat:@"&FaxPhone=%@", [[customer phoneForTag:FAX_PHONE_TAG] urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        if ([customer mainEmail].length != 0) [postString appendFormat:@"&BusinessEmail=%@", [[customer mainEmail] urlEncodeUsingEncoding:NSUTF8StringEncoding]];

        if (customer.primaryBillingAddress.line1) [postString appendFormat:@"&BillTo1=%@", [customer.primaryBillingAddress.line1 urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        if (customer.primaryBillingAddress.line2) [postString appendFormat:@"&BillTo2=%@", [customer.primaryBillingAddress.line2 urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        if (customer.primaryBillingAddress.line3) [postString appendFormat:@"&BillTo3=%@", [customer.primaryBillingAddress.line3 urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        if (customer.primaryBillingAddress.city) [postString appendFormat:@"&BillToCity=%@", [customer.primaryBillingAddress.city urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        if (customer.primaryBillingAddress.country) [postString appendFormat:@"&BillToCountry=%@", [customer.primaryBillingAddress.country urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        if (customer.primaryBillingAddress.countrySubDivisionCode) [postString appendFormat:@"&BillToCountrySubDivisionCode=%@", [customer.primaryBillingAddress.countrySubDivisionCode urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        if (customer.primaryBillingAddress.postalCode) [postString appendFormat:@"&BillToPostalCode=%@", [customer.primaryBillingAddress.postalCode urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        
        if (customer.primaryShippingAddress.line1) [postString appendFormat:@"&ShipTo1=%@", [customer.primaryShippingAddress.line1 urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        if (customer.primaryShippingAddress.line2) [postString appendFormat:@"&ShipTo2=%@", [customer.primaryShippingAddress.line2 urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        if (customer.primaryShippingAddress.line3) [postString appendFormat:@"&ShipTo3=%@", [customer.primaryShippingAddress.line3 urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        if (customer.primaryShippingAddress.city) [postString appendFormat:@"&ShipToCity=%@", [customer.primaryShippingAddress.city urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        if (customer.primaryShippingAddress.country) [postString appendFormat:@"&ShipToCountry=%@", [customer.primaryShippingAddress.country urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        if (customer.primaryShippingAddress.countrySubDivisionCode) [postString appendFormat:@"&ShipToCountrySubDivisionCode=%@", [customer.primaryShippingAddress.countrySubDivisionCode urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        if (customer.primaryShippingAddress.postalCode) [postString appendFormat:@"&ShipToPostalCode=%@", [customer.primaryShippingAddress.postalCode urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        
        if (customer.salesRep.repId) [postString appendFormat:@"&SalesRepId=%@", customer.salesRep.repId];
        if (customer.salesTerms.termId) [postString appendFormat:@"&SalesTermId=%@", customer.salesTerms.termId];
        
        NSURLRequest *request = [self.webApp requestFromUrl:url withPostString:postString];
        
        //DEBUG
        NSLog(@"request: %@\npost string: %@", request, postString);
        
        NSDictionary *responseDictionary = [self.webApp dictionaryFromRequest:request error:error];
        if (!responseDictionary) {
            [*responseError setValue:customer.name forKey:@"name"];
            return NO;
        }
        
        if ([(NSString *)responseDictionary[@"result"] isEqualToString:@"Success"] ) {
            customer.status = SYNCED_STATUS;
            
            // Consider moving this outside the loop if performance appears bad
            [self.dataObject saveContext];
        } else {
            *responseError = responseDictionary.mutableCopy;
            
            
            //get the error code
            NSString *errorCode = [*responseError valueForKey:@"error"];
            if ([errorCode isEqualToString:@"-3002"]) { //customer name not unique - someone likely uploaded a new customer into IPP
                
                //rename customer.name
                NSMutableString *newName = customer.name.mutableCopy;
                NSRange range = NSMakeRange(newName.length - 1, 1);
                [newName replaceCharactersInRange:range withString:@"*"];
                customer.name = newName; //if don't do this, the download will overwrite this customer
                [self.dataObject saveContext];
                [*responseError setValue:[NSString stringWithFormat:@"SalesCase customer renamed to %@. All linked orders set to Draft status and will not upload.", customer.name] forKey:@"name"];

                //handle orders attached to this customer - put them all in draft mode so they don't sync
                for (SCOrder *order in customer.orderList) {
                    order.status = DRAFT_STATUS;
                }
            }
            
            return NO;
        }
    }
    return YES;
}

- (BOOL)uploadOrders:(NSError **)error responseError:(NSDictionary **)responseError
{
    NSArray *orders = [self.dataObject fetchOrdersInContext:error];
    if (!orders) {
        return NO;
    }
    
    NSURL *url = [self.webApp urlFromUrlExtension:SEND_ORDER_URL_EXT];
    
    for (SCOrder *order in orders)
    {
        // Only sync orders with status "confirmed"
        if ([order.status isEqualToString:CONFIRMED_STATUS]) //don't need to check for customer here or 0 line items because not allowing these orders to be changed to confirmed status.
        {
            //Required fields
            NSMutableString *postString = [NSMutableString stringWithFormat:@"customerid=%@",order.customer.customerId];
            [postString appendFormat:@"&scorderid=%@", order.scOrderId];
            
            //Optional fields
            NSString *createDate = [SCGlobal stringFromDate:order.createDate];
            [postString appendFormat:@"&txndate=%@", createDate];
            
            if (order.salesRep) [postString appendFormat:@"&salesrepid=%@", order.salesRep.repId];
            if (order.salesTerm) {
                [postString appendFormat:@"&salestermid=%@", order.salesTerm.termId];
//                [postString appendFormat:@"&salestermname=%@", [order.salesTerm.name urlEncodeUsingEncoding:NSUTF8StringEncoding]];
            }
            if (order.shipDate) {
                NSString *dateString = [SCGlobal stringFromDate:order.shipDate];
                [postString appendFormat:@"&shipdate=%@", dateString];
            }
            if (order.shipMethod) [postString appendFormat:@"&shipmethodid=%@", order.shipMethod.id];
            if (order.orderDescription) [postString appendFormat:@"&notes=%@", [order.orderDescription urlEncodeUsingEncoding:NSUTF8StringEncoding]];
            if (order.poNumber) [postString appendFormat:@"&ponumber=%@", [order.poNumber urlEncodeUsingEncoding:NSUTF8StringEncoding]];
            
            //Line items (at least 1 is required)
            NSArray *lines = (NSArray *) order.lines;
            for (SCLine *line in lines) {
                [postString appendFormat:@"&line[%@][id]=%@&line[%@][quantity]=%@", line.item.itemId, line.item.itemId, line.item.itemId, line.quantity];
            }
            
            NSURLRequest *request = [self.webApp requestFromUrl:url withPostString:postString];
            
            //DEBUG
            NSLog(@"request: %@\npost string: %@", request, postString);
            
            NSDictionary *responseDictionary = [self.webApp dictionaryFromRequest:request error:error];
            if (!responseDictionary) {
                [*responseError setValue:order.scOrderId forKey:@"SCOrderID"];
                return NO;
            }
            
            if ([(NSString *) responseDictionary[@"result"] isEqualToString:@"Success"] )
            {
                order.status = SYNCED_STATUS;
                // Consider moving this outside the loop if performance appears bad
                [self.dataObject saveOrder:order];
            }
            else
            {
                *responseError = responseDictionary.mutableCopy;
                [*responseError setValue:order.scOrderId forKey:@"SCOrderID"];
                return NO;
            }
        }
    }
    return YES;
}


-(NSString *)addressAsRequestString:(SCAddress *)address withPrefix:(NSString *)prefix
{
    NSMutableString *postString = (NSMutableString *) @"";
   
    // Required fields
    if (address)
    {
        if (address.city)
            postString = (NSMutableString *) [NSString stringWithFormat:@"%@%@addresscity=%@",postString, prefix, [address.city urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        else
            postString = (NSMutableString *) [NSString stringWithFormat:@"%@%@addresscity=%@",postString, prefix, @"City unknown"];
        
        if (address.countrySubDivisionCode)
            postString = (NSMutableString *) [NSString stringWithFormat:@"%@&%@addresssubdivisioncode=%@",postString, prefix, [address.countrySubDivisionCode urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        else
            postString = (NSMutableString *) [NSString stringWithFormat:@"%@&%@addresssubdivisioncode=%@",postString, prefix, @"--"];
        
        if (address.line1)
            postString = (NSMutableString *) [NSString stringWithFormat:@"%@&%@addressline1=%@",postString, prefix, [address.line1 urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        else
            postString = (NSMutableString *) [NSString stringWithFormat:@"%@&%@addressline1=%@",postString, prefix, @"Address unknown"];
        
        //Non-required fields
        postString = (NSMutableString *) [NSString stringWithFormat:@"%@&%@addressline2=%@",postString, prefix, [address.line2 urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        postString = (NSMutableString *) [NSString stringWithFormat:@"%@&%@addressline3=%@",postString, prefix, [address.line3 urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        postString = (NSMutableString *) [NSString stringWithFormat:@"%@&%@addressline4=%@",postString, prefix, [address.line4 urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    }
    else // Need to pass *something*
    {
        postString = (NSMutableString *) [NSString stringWithFormat:@"%@%@addresscity=%@",postString, prefix, @"City unknown"];
        postString = (NSMutableString *) [NSString stringWithFormat:@"%@&%@addresssubdivisioncode=%@",postString, prefix, @"--"];
        postString = (NSMutableString *) [NSString stringWithFormat:@"%@&%@addressline1=%@",postString, prefix, @"Address unknown"];
    }
    return postString;
}

#pragma mark - IB Methods
- (IBAction)closeButtonPress:(UIBarButtonItem *)sender {
    [self.delegate passCloseSyncButtonPress];
}

@end
