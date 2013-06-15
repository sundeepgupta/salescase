//
//  SCAddress.h
//  SalesCase2
//
//  Created by Devon DuVernet on 13-02-05.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCCustomer;

@interface SCAddress : NSManagedObject

@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * contactName;
@property (nonatomic, strong) NSString * countrySubDivisionCode;
@property (nonatomic, strong) NSString * line1;
@property (nonatomic, strong) NSString * line2;
@property (nonatomic, strong) NSString * line3;
@property (nonatomic, strong) NSString * line4;
@property (nonatomic, strong) NSString * notes;
@property (nonatomic, strong) NSString * postalCode;
@property (nonatomic, strong) NSString * qbId;
@property (nonatomic, strong) NSString * tag;
@property (nonatomic, strong) NSString * country;
@property (nonatomic, strong) NSString * line5;
@property (nonatomic, strong) SCCustomer *owningCustomer;

- (NSArray *)lines;
- (NSArray *)fiveLines;

@end
