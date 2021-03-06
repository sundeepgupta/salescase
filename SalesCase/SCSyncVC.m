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
@property (strong, nonatomic) NSMutableSet *affectedOrders;
@property (strong, nonatomic) NSMutableString *affectedOrdersMessage;

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
    
    [SCDesignHelpers addBackgroundToView:self.view];
    [SCDesignHelpers addTopShadowToView:self.view];

}

- (void)viewWillAppear:(BOOL)animated
{
    //disable and back button
    self.closeButton.enabled = NO;
    self.navigationItem.hidesBackButton = YES;
    
    self.affectedOrders = [[NSMutableSet alloc] init]; //reset this array on each sync
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
    NSDictionary *repsResponseError = nil;
    NSDictionary *termsResponseError = nil;
    NSDictionary *shipViasResponseError = nil;
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
        
        [self processAffectedOrders];
        
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
    NSError *customersError = nil;
    NSError *itemsError = nil;
    NSError *ordersError = nil;
    NSError *newCustomersError = nil;
    
    NSDictionary *oAuthResponseError;
    NSDictionary *ordersResponseError;
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
            [syncErrorString appendFormat:@"Failed to download customers.  Error: \n%@", customersError];
            hadSyncError = YES;
        }
        
        if (![self downloadItems:&itemsError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to sync items.  Error: \n%@", itemsError];
            hadSyncError = YES;
        }
        
        [self processAffectedOrders];
        
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
    NSError *updatedCustomersError = nil;
    NSDictionary *oAuthResponseError;
    NSDictionary *newCustomersResponseError;
    NSDictionary *updatedCustomersResponseError;
    BOOL hadSyncError = NO;
    NSMutableString *syncErrorString = [NSMutableString stringWithString:@""];
    if ([self.webApp oAuthTokenIsValid:&oAuthError responseError:&oAuthResponseError]) {
        
        if (![self uploadUpdatedCustomers:&updatedCustomersError responseError:&updatedCustomersResponseError]) {
            if (syncErrorString.length != 0) {
                [syncErrorString appendString:@"\n\n"];
            }
            [syncErrorString appendFormat:@"Failed to update customers. Error: %@\nResponse Error: %@\nMessage: %@\nErrorDetail: %@\nCustomer Name: %@", updatedCustomersError, updatedCustomersResponseError[@"error"], updatedCustomersResponseError[@"msg"], updatedCustomersResponseError[@"errorDetail"], updatedCustomersResponseError[@"name"]];
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
        [self handleFinishedSyncErrorWithStatus:hadSyncError withErrorString:syncErrorString];
    } else { //Connection not good, couldn't even start syncing.
        [self handleConnectionErrorWithOAuthError:oAuthError withOAuthResponseError:oAuthResponseError];
    }
    [self processAffectedOrders];
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
    [self processAffectedOrders];
    [self finalizeView];
}

- (void)handleFinishedSyncErrorWithStatus:(BOOL)hadSyncError withErrorString:(NSString *)syncErrorString
{
    if (hadSyncError) {
        self.titleLabel.text = @"Synced With Errors";
        self.textView.text = syncErrorString;
    } else {
        self.titleLabel.text = @"Synced Successfully";
        self.textView.text = @"";
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
    
    if (self.affectedOrdersMessage) {
        self.textView.text = [self.textView.text stringByAppendingString:self.affectedOrdersMessage];
    }
}

- (void)processAffectedOrders
{
    //make affected orders drafts and build the message string for UI
    if (self.affectedOrders.count > 0) {
        NSString *customerName = @"*Deleted Customer*";
        self.affectedOrdersMessage = [[NSMutableString alloc] initWithString:@"\n\nConfirmed orders set to Draft status due to deleted customers/items:\n\n"];
        for (SCOrder *order in self.affectedOrders) {
            if ([order.status isEqualToString:CONFIRMED_STATUS]) {
                order.status = DRAFT_STATUS;

                //setup the string
                if (order.customer) {
                    customerName = order.customer.name;
                }
                [self.affectedOrdersMessage appendFormat:@"%@ - %@\n", order.scOrderId, customerName];
            }
        }
    }
}

- (NSArray *)allIppObjectsFromUrlExt:(NSString *)urlExt error:(NSError **)error
{
    //Get all of the objects (not just the chunk limit which is set to 50)
    NSInteger page = 1;
    BOOL done = NO;
    NSMutableArray *allIppObjects = [[NSMutableArray alloc] init];
    while (!done) {
        NSArray *responseArray = [self.webApp arrayFromUrlExtension:urlExt withPageNumber:page error:error];
        if (!responseArray) {
            return nil;
        }
        if (responseArray.count == 0) {
            done = YES;
        } else {
            [allIppObjects addObjectsFromArray:responseArray];
            page++;
        }
    }
    return allIppObjects;
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
    NSArray *allIppObjects = [self allIppObjectsFromUrlExt:LIST_CUSTOMERS_URL_EXT error:error];
    if (!allIppObjects) {
        return NO;
    }
        
    //Update and add new items from IPP into SC
    for (NSDictionary *ippObjectDict in allIppObjects)
    {
        SCCustomer *scObject = (SCCustomer *) [self.dataObject getEntityType:ENTITY_SCCUSTOMER byIdentifier:@"customerId" idValue:ippObjectDict[@"Id"]];
        SCCustomer *justUploadedObject = (SCCustomer *) [self.dataObject getEntityType:ENTITY_SCCUSTOMER byIdentifier:@"name" idValue:ippObjectDict[@"Name"]];
        SCCustomer *objectToSave;
        if (scObject) {
            objectToSave = scObject;
        } else if (justUploadedObject) {
            objectToSave = justUploadedObject;
        } else {
            objectToSave = (SCCustomer *) [self.dataObject newObject:ENTITY_SCCUSTOMER];
            objectToSave.orderList = nil;
        }
        
        objectToSave.name = [self.dataObject dictionaryData:ippObjectDict forKey:@"Name"];
        objectToSave.dbaName = [self.dataObject dictionaryData:ippObjectDict forKey:@"DBAName"];
        objectToSave.givenName = [self.dataObject dictionaryData:ippObjectDict forKey:@"GivenName"];
        objectToSave.middleName = [self.dataObject dictionaryData:ippObjectDict forKey:@"MiddleName"];
        objectToSave.familyName = [self.dataObject dictionaryData:ippObjectDict forKey:@"FamilyName"];
        objectToSave.title = [self.dataObject dictionaryData:ippObjectDict forKey:@"Title"];
        objectToSave.customerId = [ippObjectDict valueForKey:@"Id"];
        objectToSave.qbId = [ippObjectDict valueForKey:@"ExternalKey"];

        NSString *syncToken = (NSString *)[ippObjectDict valueForKey:@"SyncToken"];
        if ([ [syncToken class] isSubclassOfClass:[NSString class]])  objectToSave.syncToken = @(syncToken.integerValue);
        
        objectToSave.status = SYNCED_STATUS;
        
        NSDictionary *addresses = [ippObjectDict valueForKey:@"Address"];
        [self.dataObject saveAddressList:addresses forCustomer:objectToSave];
        
        NSDictionary *phones = [ippObjectDict valueForKey:@"Phone"];
        [self.dataObject savePhoneList:phones forCustomer:objectToSave];
        
        NSDictionary *emails = [ippObjectDict valueForKey:@"Email"];
        [self.dataObject saveEmailList:emails forCustomer:objectToSave];
        objectToSave.salesRep = (SCSalesRep *) [self.dataObject getEntityType:ENTITY_SCSALESREP byIdentifier:@"repId" idValue:[ippObjectDict valueForKey:@"SalesRepId"]];
        objectToSave.salesTerms = (SCSalesTerm *) [self.dataObject getEntityType:ENTITY_SCSALESTERM byIdentifier:@"termId" idValue:[ippObjectDict valueForKey:@"SalesTermId"]];
        
        if (![self.dataObject.managedObjectContext save:error] ) {
            return NO;
        }
    }
    
    
    //chedk for deleted objects from IPP list, and delete them in SC
    NSArray *scObjects = [self.dataObject fetchCustomersInContext];
    for (SCCustomer *scObject in scObjects) {
        
        BOOL matchFound = NO;
        NSInteger ippIndex = 0;
        while (ippIndex < allIppObjects.count && !matchFound) {
            NSDictionary *ippDict = allIppObjects[ippIndex];
            NSString *ippObjectId = ippDict[@"Id"];
            if ([scObject.customerId isEqualToString:ippObjectId]) {
                matchFound = YES;
                
                //update scItem here?
                //mark ippItem as being processed?
            }
            ippIndex++;
        }
        
        //if no match, process deleted item
        if (!matchFound) {
            NSLog(@"customer id to delete: %@", scObject.name);            
            if (scObject.orderList.count > 0) {
                [self.affectedOrders addObjectsFromArray:scObject.orderList.allObjects];
            }
            [self.dataObject deleteObject:scObject];
        }
    }

    return YES;
}

- (BOOL)downloadItems:(NSError **)error 
{
    NSArray *allIppObjects = [self allIppObjectsFromUrlExt:LIST_ITEMS_URL_EXT error:error];
    if (!allIppObjects) {
        return NO;
    }
    
    //Update and add new items from IPP into SC
    for (NSDictionary *ippObjectDict in allIppObjects)
    {
        SCItem *oldObject = (SCItem *) [self.dataObject getEntityType:ENTITY_SCITEM byIdentifier:@"itemId" idValue:[ippObjectDict valueForKey:@"Id"]];
        SCItem *newObject;
        if (oldObject) {
            newObject = oldObject;
        } else {
            newObject = (SCItem *)[self.dataObject newObject:ENTITY_SCITEM];
        }
        
        //required fields
        newObject.itemId = [ippObjectDict valueForKey:@"Id"];
        newObject.name = [ippObjectDict valueForKey:@"Name"];
        
        //optional fields
        NSString *description = (NSString *)ippObjectDict[@"Description"];
        if ([[description class] isSubclassOfClass:[NSString class]]) newObject.itemDescription = description;
        
        NSString *qOH = (NSString *)[ippObjectDict valueForKey:@"Quantity"];
        if ([ [qOH class] isSubclassOfClass:[NSString class]])
            newObject.quantityOnHand = @([qOH floatValue])  ;
        
        NSString *priceString = (NSString *)[ippObjectDict valueForKey:@"Price"];
        if ([[ priceString class] isSubclassOfClass:[NSString class]])
            newObject.price = (NSNumber *)@([priceString floatValue]);
        
        NSString *quantityOnSalesOrderString = (NSString *)[ippObjectDict valueForKey:@"QuantityOnSalesOrder"];
        if ([[ quantityOnSalesOrderString class] isSubclassOfClass:[NSString class]])
            newObject.quantityOnSalesOrder = (NSNumber *)@([quantityOnSalesOrderString floatValue]);
        
        NSString *quantityOnPurchaseString = (NSString *)[ippObjectDict valueForKey:@"QuantityOnPurchase"];
        if ([[ quantityOnPurchaseString class] isSubclassOfClass:[NSString class]])
            newObject.quantityOnPurchase = (NSNumber *)@([quantityOnPurchaseString floatValue]);
        
        if (![self.dataObject.managedObjectContext save:error] ) {
            return NO;
        }
    }
    
    //chedk for deleted objects from IPP list, and delete them in SC
    NSArray *scObjects = [self.dataObject fetchItemsInContext];
    for (SCItem *scObject in scObjects) {
        
        BOOL matchFound = NO;
        NSInteger ippIndex = 0;
        while (ippIndex < allIppObjects.count && !matchFound) {
            NSDictionary *ippDict = allIppObjects[ippIndex];
            NSString *ippObjectId = ippDict[@"Id"];
            if ([scObject.itemId isEqualToString:ippObjectId]) {
                matchFound = YES;
                
                //update scItem here?
                //mark ippItem as being processed?
            }
            ippIndex++;
        }
        
        //If no match found, the items was deleted from QB, so handle it
        if (!matchFound) {
            NSLog(@"item id to delete: %@", scObject.name);            
            if (scObject.owningLines > 0) {
                for (SCLine *line in scObject.owningLines) {
                    [self.affectedOrders addObject:line.order];
                }
            }
            [self.dataObject deleteObject:scObject]; //model is set to cascade delets so this code will delete the lines for us
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
                NSString *postString = [self postStringFromCustomer:customer];
        
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

- (BOOL)uploadUpdatedCustomers:(NSError **)error responseError:(NSDictionary **)responseError
{
    NSArray *customers = [self.dataObject objectsOfType:ENTITY_SCCUSTOMER withStatus:UPDATED_STATUS withError:error];
    if (!customers) {
        return NO;
    }
    
    NSURL *url = [self.webApp urlFromUrlExtension:UPDATE_CUSTOMER_URL_EXT];
    
    for (SCCustomer *customer in customers) {
        
        NSMutableString *postString = [self postStringFromCustomer:customer];
        //updating customers needs id and synctoken
        [postString appendFormat:@"&Id=%@", customer.customerId];
        [postString appendFormat:@"&SyncToken=%@", customer.syncToken];
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
            [*responseError setValue:customer.name forKey:@"name"];
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
            NSArray *lines = [self.dataObject linesSortedByIdForOrder:order];
            for (SCLine *line in lines) {
                
                NSString *descriptionToSend;
                if (line.lineDescription) descriptionToSend = [line.lineDescription urlEncodeUsingEncoding:NSUTF8StringEncoding];
                else descriptionToSend = @"";
                    
                NSString *lineId = [SCDataObject idFromObject:line];
                [postString appendFormat:@"&line[%@][id]=%@&line[%@][quantity]=%@&line[%@][price]=%@&line[%@][description]=%@", lineId, line.item.itemId, lineId, line.quantity, lineId, line.price, lineId, descriptionToSend];
                NSLog(@"line id: %@", lineId);
            }
            
            NSURLRequest *request = [self.webApp requestFromUrl:url withPostString:postString];
            
            //DEBUG
            NSArray *explodedString = [postString componentsSeparatedByString:@"&"];
            for (NSString *string in explodedString) {
                NSLog(@"&%@\n", string);
            }
//            NSLog(@"request: %@\npost string: %@", request, postString);
            //END DEBUG
            
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


- (NSMutableString *)postStringFromCustomer:(SCCustomer *)customer
{
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
    
    return postString;
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
