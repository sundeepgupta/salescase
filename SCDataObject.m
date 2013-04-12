//
//  SCDataObject.m
//  SalesCase
//
//  Created by Devon DuVernet on 12-12-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <objc/runtime.h>
#import "SCDataObject.h"
#import "SCOrder.h"
#import "SCCustomer.h"
#import "SCGlobal.h"

@interface SCDataObject() 

@end

@implementation SCDataObject
//@synthesize self.managedObjectContext;

//SKG's methods

- (SCOrder *)newOrder
{
    NSDate *currentDate = [NSDate date];
    SCOrder *order = [NSEntityDescription insertNewObjectForEntityForName:@"SCOrder" inManagedObjectContext:self.managedObjectContext];
    order.createDate = currentDate;
    order.scOrderId = [self newScOrderIdWithDate:currentDate];
    [self saveOrder:order];
    return order;
}

- (void)saveOrder:(SCOrder *)order
{
    order.lastActivityDate = [NSDate date];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error saving context from saveOrder: %@", [error localizedDescription]);
    }
}

-(void) deleteOrder:(SCOrder *)order
{
    NSError *error;
    [self.managedObjectContext deleteObject:order];
    if (![self.managedObjectContext save:&error]) NSLog(@"Error deleting order: %@", [error localizedDescription]);
}

- (SCLine *)newLine
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"SCLine" inManagedObjectContext:self.managedObjectContext];
}

-(void) deleteLine:(SCLine *)line
{
    NSError *error;
    [self.managedObjectContext deleteObject:line];
    if (![self.managedObjectContext save:&error]) NSLog(@"Error deleting line: %@", [error localizedDescription]);
}

-(SCItem *)newItem
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"SCItem" inManagedObjectContext:self.managedObjectContext];
}




//- (SCOrder *)updateOrder:(SCOrder *)order withCustomer:(SCCustomer *)customer
//{//set the order's Rep and Terms based on the customer - but check to see if they already exist since user has the option of adding the customer after setting order options.  If they do exist and are different, we should ask the user which values they want to keep.  We can save this for later, but for now, just overwrite the order options based on the customer.
//    
//    order.customer = customer;
//    if (customer.salesRep) {
//      order.salesRep = customer.salesRep;
//    }
//    if (customer.salesTerms) {
//        order.salesTerm = customer.salesTerms;
//    }
////    [self saveContextWithOrder:order];
//    return order;
//}





-(NSNumber *)incrementMaxSCOrderId
{
    NSNumber *result;
    NSUserDefaults *stand = [NSUserDefaults standardUserDefaults];
    NSString *maxSCOrderIdKeyName = @"maxSCOrderId";
    NSObject *maxSCOrderID = [stand objectForKey:maxSCOrderIdKeyName];
    if (maxSCOrderID != nil && [maxSCOrderID isKindOfClass:[NSNumber class]])
    {
        result = @([(NSNumber *)maxSCOrderID intValue] + 1);
        [stand setValue:result forKey:maxSCOrderIdKeyName];
    }
    else
    {
        result = @1;
        [stand setValue:result forKey:maxSCOrderIdKeyName];
    }
    return result;
}

-(NSNumber *)newScOrderIdWithDate:(NSDate *)date
{
    /*
     * in incremental fashion
    int newScOrderId = [[self incrementMaxSCOrderId] intValue] + 1;
    return [NSNumber numberWithInt:newScOrderId];
     */
    
    //Using timestamp instead

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSString *orderString = [dateString substringFromIndex:2];
    orderString = [orderString substringToIndex:[orderString length] - 1];
    
    
    
    NSNumber *returnNumber = @([orderString longLongValue]);
    return returnNumber;
}



-(void)saveContext
{
    NSError *error;
    if (![self.managedObjectContext save:&error]) NSLog(@"Error saving context: %@", [error localizedDescription]);
}

-(SCItem *)createItemInContext
{
    SCItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"SCItem" inManagedObjectContext:self.managedObjectContext];
    return item;
}

-(SCCustomer *)createCustomerInContext
{
    SCCustomer *customer = [NSEntityDescription insertNewObjectForEntityForName:@"SCCustomer" inManagedObjectContext:self.managedObjectContext];
    return customer;
}

-(NSManagedObject *)newEntityIntoContext:(NSString *)entityName
{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    return object;
}

// READ
-(NSArray *) fetchCustomersInContext
{
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SCCustomer" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"dbaName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByName]];
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

-(NSArray *) fetchOrdersInContext:(NSError **)error
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SCOrder" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"scOrderId" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortByName]];
    
    NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:error];
    return fetchResult;
}

-(NSArray *) fetchAllObjectsOfType:(NSString *)entityName
{
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchResult;
}


-(NSArray *) fetchItemsInContext
{
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SCItem" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByName]];
    
    NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchResult;
}

-(NSArray *) fetchCustomersInContextIdOnly
{
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SCCustomer" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setIncludesPropertyValues:NO];
    [fetchRequest setEntity:entity];
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}


-(NSArray *) fetchItemsInContextIdOnly
{
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SCItem" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchResult;
}

-(NSManagedObject *) getEntityType:(NSString *)entityForName byIdentifier:(NSString *)idName idValue:(NSString *)idValue
{
    NSError *error;
    NSManagedObject *returnItem;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityForName inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", idName, idValue];
    //    [NSPredicate pred
    [fetchRequest setPredicate:predicate];
    NSArray *resultArray =  [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([resultArray count] == 1)
    {
        returnItem = resultArray[0];
    }
    else
    {
        returnItem = nil;
    }
    return returnItem;    
}


// CREATE/UPDATE
-(SCOrder *) placeOrderWithItemsData:(NSArray *)selectedLinesData 
                        withCustomer:(SCCustomer *)customer 
                         isConfirmed:(NSNumber *)isConfirmed
                        withPONumber:(NSString *)poNumber
                withOrderDescription:(NSString *)orderDescription
                        withSalesRep:(SCSalesRep *)selectedSalesRep
                      withShipMethod:(SCShipMethod *)selectedShipMethod
                       withSalesTerm:(SCSalesTerm *)selectedSalesTerms
                        withShipDate:(NSDate *)selectedShipDate
{
    NSError *error;
    SCOrder *order = (SCOrder *) [self newEntityIntoContext:@"SCOrder"];
    //Predetermined properties
    order.scOrderId = [self newScOrderIdWithDate:[NSDate date]];
    //NSLog(@"Order ID: %@", order.scOrderId);
    order.createDate = [NSDate date];
    order.lastActivityDate = order.createDate;
    order.synced = @NO;
    order.orderDescription = @"String to describe the order";
    
    order.customer = customer;
    [order setConfirmed:(NSNumber *)isConfirmed];
    for (NSDictionary *lineData in selectedLinesData)
    {
        //        SCLine *line = [SCLine createInContext:self.managedObjectContext];
        SCLine *line = (SCLine *) [self newEntityIntoContext:@"SCLine"];
        line.item = lineData[@"item"];
        line.quantity = lineData[@"lineQuantity"];
        line.order = order;
    }
    order.orderDescription = orderDescription;
    order.poNumber = poNumber;
    order.confirmed = isConfirmed;
    order.salesRep = selectedSalesRep;
    order.shipMethod = selectedShipMethod;
    order.salesTerm = selectedSalesTerms;
    order.shipDate = selectedShipDate;
    order.lastActivityDate = [NSDate date];
    if (![self.managedObjectContext save:&error]) NSLog(@"Whoops, error saving context while placing order: %@", [error localizedDescription]);
    return order;
}

-(SCOrder *) updateOrder:(SCOrder *)order 
           withItemsData:(NSArray *)selectedLinesData 
            withCustomer:(SCCustomer *)customer 
             isConfirmed:(NSNumber *)isConfirmed
            withPONumber:(NSString *)poNumber
    withOrderDescription:(NSString *)orderDescription
            withSalesRep:(SCSalesRep *)selectedSalesRep
          withShipMethod:(SCShipMethod *)selectedShipMethod
           withSalesTerm:(SCSalesTerm *)selectedSalesTerms
            withShipDate:(NSDate *)selectedShipDate
{
    order.customer = customer;
    //[customer addOrderListObject:order];
    // Remove all lines and add the new ones back -
    [order removeLines:order.lines];
    for (NSDictionary *lineData in selectedLinesData)
    {
        SCLine *line = (SCLine *) [self newEntityIntoContext:@"SCLine"];
        line.item = lineData[@"item"];
        //[line.item addOwningLinesObject:line];
        line.quantity = lineData[@"lineQuantity"];
        //line.order = order;
        [order addLinesObject:line];        
    }
    order.poNumber = (NSString *)poNumber;
    order.orderDescription = orderDescription;
    order.confirmed = isConfirmed;
    order.salesRep = selectedSalesRep;
    order.shipMethod = selectedShipMethod;
    order.salesTerm = selectedSalesTerms;
    order.shipDate = selectedShipDate;
    order.lastActivityDate = [NSDate date];
    @try{
        NSError* error = nil;
        if (![self.managedObjectContext save:&error]) NSLog(@"Whoops, error saving context while updating order");
    }
    @catch (NSException *exception) {
        NSLog(@"Exception thrown: %@", exception);
    }
    @finally {
    }
    return order;
}
-(void) removeAllEntityType:(NSString *)entityName
{
    NSError *error;
    for (NSManagedObject *object in [self fetchAllObjectsOfType:entityName])
    {
        [self.managedObjectContext deleteObject:object];
    }
    if (![self.managedObjectContext save:&error]) NSLog(@"Error clearing customers from context: %@", [error localizedDescription]);
}


-(void) removeCustomersFromContext
{
    NSError *error;
    for (SCCustomer *customerToDelete in [self fetchCustomersInContextIdOnly])
    {
        [self.managedObjectContext deleteObject:customerToDelete];
    }
    if (![self.managedObjectContext save:&error]) NSLog(@"Error clearing customers from context: %@", [error localizedDescription]);
    //? if (error) [error release];
}

-(void) removeItemsFromContext
{
    NSError *error;
    for (SCItem *itemToDelete in [self fetchItemsInContextIdOnly])
    {
        [self.managedObjectContext deleteObject:itemToDelete];
    }
    if (![self.managedObjectContext save:&error]) NSLog(@"Error clearing items from context: %@", [error localizedDescription]);    
}
-(void) removeOrdersFromContext
{
    //
}

-(void) removeOrderFromContext:(SCOrder *)order
{
    NSError *error;
    [self.managedObjectContext deleteObject:order];
    if (![self.managedObjectContext save:&error]) NSLog(@"Whoops, error saving context: %@", [error localizedDescription]);
}

-(void) removeQueuedEmailFromContext:(SCEmailToSend *)email
{
    NSError *error;
    [self.managedObjectContext deleteObject:email];
    if (![self.managedObjectContext save:&error]) NSLog(@"Whoops, error saving context: %@", [error localizedDescription]);
}


/* Helper methods */

/*
 * Because sometimes you need to deal with null! So make sure it's a string
 */
-(NSString *) dictionaryData:(NSDictionary *)dictionaryData forKey:(NSString *)forKey
{
    if ([[[dictionaryData valueForKey:forKey] class] isSubclassOfClass:[NSString class]]) 
        return [dictionaryData valueForKey:forKey];
    else 
        return nil;
}



-(void) getAddressList:(NSDictionary *)addresses forCustomer:(SCCustomer *)customer
{
    [customer removeAddressList:customer.addressList];
    NSDictionary *billingAddressData = [addresses valueForKey:@"Billing"];
    NSDictionary *shippingAddressData = [addresses valueForKey:@"Shipping"];
    if (billingAddressData)
    {
        SCAddress *billingAddress = (SCAddress *) [self newEntityIntoContext:@"SCAddress"];
        billingAddress.qbId = [self dictionaryData:billingAddressData forKey:@"Id"];
        billingAddress.line1 = [self dictionaryData:billingAddressData forKey:@"Line1"]; 
        billingAddress.line2 = [self dictionaryData:billingAddressData forKey:@"Line2"]; 
        billingAddress.line3 = [self dictionaryData:billingAddressData forKey:@"Line3"];
        billingAddress.line4 = [self dictionaryData:billingAddressData forKey:@"Line4"];
        billingAddress.line5 = [self dictionaryData:billingAddressData forKey:@"Line5"];
        billingAddress.city = [self dictionaryData:billingAddressData forKey:@"City"];
        billingAddress.postalCode = [self dictionaryData:billingAddressData forKey:@"PostalCode"];
        billingAddress.country = [self dictionaryData:billingAddressData forKey:@"Country"];
        billingAddress.countrySubDivisionCode = [self dictionaryData:billingAddressData forKey:@"CountrySubDivisionCode"];
        billingAddress.tag = @"Billing";
        //billingAddress.owningCustomer = customer;
        customer.primaryBillingAddress = billingAddress;
        [customer addAddressListObject:billingAddress];
        
    }

    if (shippingAddressData)
    {
        SCAddress *shippingAddress  = (SCAddress *) [self newEntityIntoContext:@"SCAddress"];
        shippingAddress.city = [self dictionaryData:shippingAddressData forKey:@"City"]; 
        shippingAddress.line1 = [self dictionaryData:shippingAddressData forKey:@"Line1"]; 
        shippingAddress.line2 = [self dictionaryData:shippingAddressData forKey:@"Line2"]; 
        shippingAddress.line3 = [self dictionaryData:shippingAddressData forKey:@"Line3"];
        shippingAddress.line4 = [self dictionaryData:shippingAddressData forKey:@"Line4"];
        shippingAddress.line5 = [self dictionaryData:shippingAddressData forKey:@"Line5"];
        shippingAddress.city = [self dictionaryData:shippingAddressData forKey:@"City"];
        shippingAddress.postalCode = [self dictionaryData:shippingAddressData forKey:@"PostalCode"];
        shippingAddress.country = [self dictionaryData:shippingAddressData forKey:@"Country"];
        shippingAddress.countrySubDivisionCode = [self dictionaryData:shippingAddressData forKey:@"CountrySubDivisionCode"];
        shippingAddress.tag = @"Shipping"; 
        //shippingAddress.owningCustomer = customer;
        customer.primaryShippingAddress = shippingAddress;
        [customer addAddressListObject:shippingAddress];
    }
}

-(void) getPhoneList:(NSDictionary *)phones forCustomer:(SCCustomer *)customer
{
    [customer removePhoneList:customer.phoneList];
    for (NSString *phoneTag in phones)
    {
        SCPhone *phone = [NSEntityDescription insertNewObjectForEntityForName:@"SCPhone"  inManagedObjectContext:self.managedObjectContext];
        phone.tag = phoneTag;
        phone.freeFormNumber = [self dictionaryData:[phones valueForKey:phoneTag] forKey:@"FreeFormNumber"];
        [customer addPhoneListObject:phone];
        //phone.owningCustomer = customer;
    }
}

-(void) getEmailList:(NSDictionary *)emails forCustomer:(SCCustomer *)customer
{
    [customer removeEmailList:customer.emailList];
    for (NSString *emailTag in emails)
    {
        SCEmail *email = [NSEntityDescription insertNewObjectForEntityForName:@"SCEmail"  inManagedObjectContext:self.managedObjectContext];
        email.tag = emailTag;
        email.address = [self dictionaryData:[emails valueForKey:emailTag] forKey:@"Address"];
        [customer addEmailListObject:email];
        //email.owningCustomer = customer;
    }
}


/* SOME OLD TESTING FUNCTIONS, meant to be deleted */
-(void) resetContextWithModel:(NSManagedObjectModel *)model inStore:(NSPersistentStoreCoordinator *)storeCoordinator
{
    NSError *err = nil;
    NSPersistentStore *store = [[storeCoordinator persistentStores] lastObject];
    NSURL *storeURL = store.URL;
    
    self.managedObjectContext = nil;
    model = nil;
    storeCoordinator = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:storeURL.path])
        [fileManager removeItemAtURL:storeURL error:&err];
    else
        NSLog(@"Whoops, error clearing context");
}

//deprecated....
//old place order method, should be deprecated
-(SCOrder *) placeOrderWithItemsData:(NSArray *)selectedLinesData withCustomer:(SCCustomer *)customer isConfirmed:(NSNumber *)isConfirmed
{
    NSError *error;
    SCOrder *order = (SCOrder *) [self newEntityIntoContext:@"SCOrder"];
    //Predetermined properties
    order.createDate = [NSDate date];
    order.lastActivityDate = order.createDate;
    order.synced = @NO;
    order.orderDescription = @"String to describe the order";
    
    order.customer = customer;
    [order setConfirmed:(NSNumber *)isConfirmed];
    for (NSDictionary *lineData in selectedLinesData)
    {
        //        SCLine *line = [SCLine createInContext:self.managedObjectContext];
        SCLine *line = (SCLine *) [self newEntityIntoContext:@"SCLine"];
        line.item = lineData[@"item"];
        line.quantity = lineData[@"lineQuantity"];
        line.order = order;
    }
    if (![self.managedObjectContext save:&error]) NSLog(@"Whoops, error saving context while placing order: %@", [error localizedDescription]);
    return order;
}

//old place order method should be deprecated
-(SCOrder *) updateOrder:(SCOrder *)order 
           withItemsData:(NSArray *)selectedLinesData 
            withCustomer:(SCCustomer *)customer 
{
    NSError *error = nil;
    NSManagedObjectContext *moc = [order managedObjectContext]; 
    order.lastActivityDate = [NSDate date];
    order.customer = customer;
    [customer addOrderListObject:order];
    // Remove all lines and add the new ones back -
    [order removeLines:order.lines];
    for (NSDictionary *lineData in selectedLinesData)
    {
        //        SCLine *line = [SCLine createInContext:moc];
        SCLine *line = (SCLine *) [self newEntityIntoContext:@"SCLine"];
        line.item = lineData[@"item"];
        //[line.item addOwningLinesObject:line];
        line.quantity = lineData[@"lineQuantity"];
        line.order = order;
        //[order addLinesObject:line];        
    }
    if (![moc save:&error]) NSLog(@"Whoops, error saving context while updating order: %@", [error localizedDescription]);
    return order;
}



@end