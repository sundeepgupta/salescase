//
//  SCSalesTerm.h
//  SalesCase2
//
//  Created by Devon DuVernet on 13-01-28.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCCustomer, SCOrder;

@interface SCSalesTerm : NSManagedObject

@property (nonatomic, strong) NSString * discountDays;
@property (nonatomic, strong) NSString * dueDays;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * termId;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSSet *customer;
@property (nonatomic, strong) SCOrder *orderList;
@end

@interface SCSalesTerm (CoreDataGeneratedAccessors)

- (void)addCustomerObject:(SCCustomer *)value;
- (void)removeCustomerObject:(SCCustomer *)value;
- (void)addCustomer:(NSSet *)values;
- (void)removeCustomer:(NSSet *)values;
@end
