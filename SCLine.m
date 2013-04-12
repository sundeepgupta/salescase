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

- (float)amount
{
    float quantity = [self.quantity floatValue];
    float price = [self.item.price floatValue];
    return quantity * price;
}


//+(SCLine *)createInContext:(NSManagedObjectContext *) context
//{
//    SCLine *line = [NSEntityDescription insertNewObjectForEntityForName:@"SCLine" inManagedObjectContext:context];
//    return line;
//}


@end