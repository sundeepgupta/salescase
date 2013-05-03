//
//  SCLine.h
//  SalesCase
//
//  Created by Devon DuVernet on 12-12-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCItem, SCOrder;

@interface SCLine : NSManagedObject

@property (nonatomic, strong) NSNumber * quantity;
@property (nonatomic, strong) SCItem *item;
@property (nonatomic, strong) SCOrder *order;

- (float)amount;


@end
