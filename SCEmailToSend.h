//
//  SCEmailToSend.h
//  SalesCase2
//
//  Created by Devon DuVernet on 13-02-07.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCOrder;

@interface SCEmailToSend : NSManagedObject

@property (nonatomic, strong) NSNumber * toMe;
@property (nonatomic, strong) NSNumber * toCustomer;
@property (nonatomic, strong) NSNumber * toOffice;
@property (nonatomic, strong) SCOrder *orderForEmail;

@end
