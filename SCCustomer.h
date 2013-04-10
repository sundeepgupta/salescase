//
//  SCCustomer.h
//  SalesCase2
//
//  Created by Devon DuVernet on 13-02-05.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCAddress, SCEmail, SCOrder, SCSalesRep, SCSalesTerm;

@interface SCCustomer : NSManagedObject

@property (nonatomic, strong) NSString * customerId;
@property (nonatomic, strong) NSString * familyName;
@property (nonatomic, strong) NSString * givenName;
@property (nonatomic, strong) NSString * middleName;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * dbaName;
@property (nonatomic, strong) NSString * notes;
@property (nonatomic, strong) NSString * qbId;
@property (nonatomic, strong) NSString * shipVia;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * country;
@property (nonatomic, strong) NSSet *addressList;
@property (nonatomic, strong) NSSet *emailList;
@property (nonatomic, strong) NSSet *orderList;
@property (nonatomic, strong) NSSet *phoneList;
@property (nonatomic, strong) SCAddress *primaryBillingAddress;
@property (nonatomic, strong) SCAddress *primaryShippingAddress;
@property (nonatomic, strong) SCSalesRep *salesRep;
@property (nonatomic, strong) SCSalesTerm *salesTerms;
@end

@interface SCCustomer (CoreDataGeneratedAccessors)

- (void)addAddressListObject:(SCAddress *)value;
- (void)removeAddressListObject:(SCAddress *)value;
- (void)addAddressList:(NSSet *)values;
- (void)removeAddressList:(NSSet *)values;
- (void)addEmailListObject:(SCEmail *)value;
- (void)removeEmailListObject:(SCEmail *)value;
- (void)addEmailList:(NSSet *)values;
- (void)removeEmailList:(NSSet *)values;
- (void)addOrderListObject:(SCOrder *)value;
- (void)removeOrderListObject:(SCOrder *)value;
- (void)addOrderList:(NSSet *)values;
- (void)removeOrderList:(NSSet *)values;
- (void)addPhoneListObject:(NSManagedObject *)value;
- (void)removePhoneListObject:(NSManagedObject *)value;
- (void)addPhoneList:(NSSet *)values;
- (void)removePhoneList:(NSSet *)values;

-(NSString *)mainEmail;

@end
