//
//  testData.h
//  SalesCase
//
//  Created by Devon DuVernet on 12-12-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
 This is really just a suite of functions for data management - syncing with
 the web app or interacting with the managed object context.
 
 No instance methods.
 */

#import <Foundation/Foundation.h>



#import "SCAddress.h"

#import "SCItem.h"
#import "SCLine.h"

#import "SCPhone.h"
#import "SCEmail.h"
#import "SCSalesRep.h"
#import "SCSalesTerm.h"
#import "SCShipMethod.h"
#import "SCEmailToSend.h"

#import "UIDevice+IdentifierAddition.h"

@class SCOrder, SCCustomer, SCGlobal;


@interface SCDataObject : NSObject

//SKG's stuff
@property (strong, nonatomic) SCGlobal *global;
@property (strong, nonatomic) SCOrder *openOrder;

- (SCOrder *)newOrder;
- (void)saveOrder:(SCOrder *)order;
-(void) deleteOrder:(SCOrder *)order;
- (SCLine *)newLine;
-(void) deleteLine:(SCLine *)line;

-(SCItem *)newItem;







@property (strong) NSManagedObjectContext *managedObjectContext;

// Managed Object Context Operations
-(void) saveContext;
-(NSManagedObject *)newEntityIntoContext:(NSString *)entityName;
-(SCItem *)createItemInContext;
-(SCCustomer *)createCustomerInContext;

// Read
-(NSArray *) fetchAllObjectsOfType:(NSString *)entityName;
// Select Only the ID
-(NSArray *) fetchCustomersInContextIdOnly;
-(NSArray *) fetchItemsInContextIdOnly;
// unnecessary custom fetches unles ID
-(NSArray *) fetchCustomersInContext;
-(NSArray *) fetchItemsInContext;
-(NSArray *) fetchOrdersInContext:(NSError **)error;

// Select an object by an id - presumed unique
-(NSManagedObject *) getEntityType:(NSString *)entityForName byIdentifier:(NSString *)idName idValue:(NSString *)idValue;


// Create/Update
-(SCOrder *) placeOrderWithItemsData:(NSArray *)selectedLinesData 
                        withCustomer:(SCCustomer *)customer 
                         isConfirmed:(NSNumber *)isConfirmed
                        withPONumber:(NSString *)poNumber
                withOrderDescription:(NSString *)orderDescription
                        withSalesRep:(SCSalesRep *)selectedSalesRep
                      withShipMethod:(SCShipMethod *)selectedShipMethod
                       withSalesTerm:(SCSalesTerm *)selectedSalesTerms
                        withShipDate:(NSDate *)selectedShipDate;
-(SCOrder *) updateOrder:(SCOrder *)order 
           withItemsData:(NSArray *)selectedLinesData 
            withCustomer:(SCCustomer *)customer 
             isConfirmed:(NSNumber *)isConfirmed
            withPONumber:(NSString *)poNumber
    withOrderDescription:(NSString *)orderDescription
            withSalesRep:(SCSalesRep *)selectedSalesRep
          withShipMethod:(SCShipMethod *)selectedShipMethod
           withSalesTerm:(SCSalesTerm *)selectedSalesTerms
            withShipDate:(NSDate *)selectedShipDate;
//Delete
//Generic:
-(void) removeAllEntityType:(NSString *)entityName;
//Other (should remove)
-(void) removeCustomersFromContext;
-(void) removeItemsFromContext;
-(void) removeOrdersFromContext;
-(void) removeOrderFromContext:(SCOrder *)order;
-(void) removeQueuedEmailFromContext:(SCEmailToSend *)email;

// Helpers
-(void) getAddressList:(NSDictionary *)addresses forCustomer:(SCCustomer *)customer;
-(void) getPhoneList:(NSDictionary *)phones forCustomer:(SCCustomer *)customer;
-(void) getEmailList:(NSDictionary *)emails forCustomer:(SCCustomer *)customer;
// returns dictionary data - to handle null cases
-(NSString *) dictionaryData:(NSDictionary *)dictionaryData forKey:(NSString *)forKey;

// Testing functions only - remove when ready
-(void) resetContextWithModel:(NSManagedObjectModel *)model inStore:(NSPersistentStoreCoordinator *)storeCoordinator;



@end
