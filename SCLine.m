//
//  SCLine.m
//  SalesCase
//
//  Created by Devon DuVernet on 12-12-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCLine.h"
#import "SCItem.h"
#import "SCOrder.h"


@implementation SCLine

@dynamic quantity;
@dynamic item;
@dynamic order;
@dynamic price;
@dynamic lineDescription;


- (float)amount
{
    float quantity = [self.quantity floatValue];
    float price = [self.price floatValue];
    return quantity * price;
}


@end
