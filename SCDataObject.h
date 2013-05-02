//
//  SCDataObject.H
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
@property (strong, nonatomic) SCCustomer *openCustomer;
@property (strong) NSManagedObjectContext *managedObjectContext;

-(NSManagedObject *)newObject:(NSString *)entityName;
- (SCOrder *)newOrder;
-(SCCustomer *)newCustomer;

- (void)saveOrder:(SCOrder *)order;
-(void) deleteObject:(NSManagedObject *)order;

-(void) savePhoneNumber:(NSString *)phoneNumber withTag:(NSString *)tag forCustomer:(SCCustomer *)customer;
-(void) saveEmail:(NSString *)newAddress forCustomer:(SCCustomer *)customer;

-(NSArray *)customersWithStatus:(NSString *)status withError:(NSError **)error;
- (NSArray *)customerNames:(NSError **)error;





// Managed Object Context Operations
-(void) saveContext;


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



// Helpers
-(void) saveAddressList:(NSDictionary *)addresses forCustomer:(SCCustomer *)customer;
-(void) savePhoneList:(NSDictionary *)phones forCustomer:(SCCustomer *)customer;
-(void) saveEmailList:(NSDictionary *)emails forCustomer:(SCCustomer *)customer;
// returns dictionary data - to handle null cases
-(NSString *) dictionaryData:(NSDictionary *)dictionaryData forKey:(NSString *)forKey;




@end
