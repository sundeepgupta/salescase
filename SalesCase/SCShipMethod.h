//
//  SCShipMethod.h
//  SalesCase2
//
//  Created by Devon DuVernet on 13-01-29.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCOrder;

@interface SCShipMethod : NSManagedObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSSet *orderList;
@end

@interface SCShipMethod (CoreDataGeneratedAccessors)

- (void)addOrderListObject:(SCOrder *)value;
- (void)removeOrderListObject:(SCOrder *)value;
- (void)addOrderList:(NSSet *)values;
- (void)removeOrderList:(NSSet *)values;
@end
