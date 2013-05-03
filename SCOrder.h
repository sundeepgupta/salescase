//
//  SCOrder.h
//  SalesCase2
//
//  Created by Devon DuVernet on 13-02-07.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCCustomer, SCEmailToSend, SCLine, SCSalesRep, SCSalesTerm, SCShipMethod;

@interface SCOrder : NSManagedObject

@property (nonatomic, strong) NSDate * createDate;
@property (nonatomic, strong) NSDate * lastActivityDate;
@property (nonatomic, strong) NSString * orderDescription;
@property (nonatomic, strong) NSString * poNumber;
@property (nonatomic, strong) NSNumber * scOrderId;
@property (nonatomic, strong) NSDate * shipDate;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) SCCustomer *customer;
@property (nonatomic, strong) NSSet *lines;
@property (nonatomic, strong) SCSalesRep *salesRep;
@property (nonatomic, strong) SCSalesTerm *salesTerm;
@property (nonatomic, strong) SCShipMethod *shipMethod;
@property (nonatomic, strong) NSSet *emailQueue;

- (float)totalAmount;
- (NSString *)fullStatus;
- (NSString *)singleLetterStatus;

@end

@interface SCOrder (CoreDataGeneratedAccessors)

- (void)addLinesObject:(SCLine *)value;
- (void)removeLinesObject:(SCLine *)value;
- (void)addLines:(NSSet *)values;
- (void)removeLines:(NSSet *)values;
- (void)addEmailQueueObject:(SCEmailToSend *)value;
- (void)removeEmailQueueObject:(SCEmailToSend *)value;
- (void)addEmailQueue:(NSSet *)values;
- (void)removeEmailQueue:(NSSet *)values;
@end
