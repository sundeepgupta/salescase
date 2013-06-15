//
//  SCSalesRep.h
//  SalesCase2
//
//  Created by Devon DuVernet on 13-01-28.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCCustomer, SCOrder;

@interface SCSalesRep : NSManagedObject

@property (nonatomic, strong) NSString * initials;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * repId;
@property (nonatomic, strong) NSSet *customerList;
@property (nonatomic, strong) NSSet *orderList;
@end

@interface SCSalesRep (CoreDataGeneratedAccessors)

- (void)addCustomerListObject:(SCCustomer *)value;
- (void)removeCustomerListObject:(SCCustomer *)value;
- (void)addCustomerList:(NSSet *)values;
- (void)removeCustomerList:(NSSet *)values;
- (void)addOrderListObject:(SCOrder *)value;
- (void)removeOrderListObject:(SCOrder *)value;
- (void)addOrderList:(NSSet *)values;
- (void)removeOrderList:(NSSet *)values;

//- (NSString *)nameOrInitials;

@end
