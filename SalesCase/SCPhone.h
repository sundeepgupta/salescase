//
//  SCPhone.h
//  SalesCase
//
//  Created by Devon DuVernet on 12-12-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCCustomer;

@interface SCPhone : NSManagedObject

@property (nonatomic, strong) NSString * deviceType;
@property (nonatomic, strong) NSString * freeFormNumber;
@property (nonatomic, strong) NSString * qbId;
@property (nonatomic, strong) NSString * tag;
@property (nonatomic, strong) SCCustomer *owningCustomer;

@end
