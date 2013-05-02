//
//  SCOrder.m
//  SalesCase2
//
//  Created by Devon DuVernet on 13-02-07.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SCOrder.h"
#import "SCCustomer.h"
#import "SCEmailToSend.h"
#import "SCLine.h"
#import "SCSalesRep.h"
#import "SCSalesTerm.h"
#import "SCShipMethod.h"

#import "SCItem.h"


@implementation SCOrder

//@dynamic confirmed;
@dynamic createDate;
@dynamic lastActivityDate;
@dynamic orderDescription;
@dynamic poNumber;
@dynamic scOrderId;
@dynamic shipDate;
//@dynamic synced;
@dynamic customer;
@dynamic lines;
@dynamic salesRep;
@dynamic salesTerm;
@dynamic shipMethod;
@dynamic emailQueue;
@dynamic status;

- (CGFloat)totalAmount
{
    float total=0;
    for(SCLine *line in self.lines)
    {
        total += [line.quantity floatValue] * [line.item.price floatValue];
    }
    return total;
}

- (NSString *)singleLetterStatus
{
    if ([self.status isEqualToString:SYNCED_STATUS]) {
        return @"S";
    } else if ([self.status isEqualToString:CONFIRMED_STATUS]) {
        return @"C";
    } else {
        return @"D";
    }
}

- (NSString *)fullStatus
{
    if ([self.status isEqualToString:SYNCED_STATUS]) {
        return @"Synced";
    } else if ([self.status isEqualToString:CONFIRMED_STATUS]) {
        return @"Confirmed";
    } else {
        return @"Draft";
    }
}


@end
