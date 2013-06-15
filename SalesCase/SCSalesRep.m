//
//  SCSalesRep.m
//  SalesCase2
//
//  Created by Devon DuVernet on 13-01-28.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SCSalesRep.h"
#import "SCCustomer.h"
#import "SCOrder.h"


@implementation SCSalesRep

@dynamic initials;
@dynamic name;
@dynamic repId;
@dynamic customerList;
@dynamic orderList;


//Force user to have name set for reps
//- (NSString *)nameOrInitials
//{
//    if (self.name) {
//        return self.name;
//    } else {
//        return self.initials;
//    }
//}

@end
