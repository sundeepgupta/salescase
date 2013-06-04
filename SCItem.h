//
//  SCItem.h
//  SalesCase2
//
//  Created by Devon DuVernet on 13-01-30.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCLine;

@interface SCItem : NSManagedObject

@property (nonatomic, strong) NSString * itemDescription;
@property (nonatomic, strong) NSString * itemId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * price;
@property (nonatomic, strong) NSString * qbId;
@property (nonatomic, strong) NSNumber * quantityOnHand;
@property (nonatomic, strong) NSNumber * quantityOnSalesOrder;
@property (nonatomic, strong) NSNumber * quantityOnPurchase;
@property (nonatomic, strong) NSSet *owningLines;

@end

@interface SCItem (CoreDataGeneratedAccessors)

- (void)addOwningLinesObject:(SCLine *)value;
- (void)removeOwningLinesObject:(SCLine *)value;
- (void)addOwningLines:(NSSet *)values;
- (void)removeOwningLines:(NSSet *)values;
@end
