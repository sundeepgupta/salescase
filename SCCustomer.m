//
//  SCCustomer.m
//  SalesCase2
//
//  Created by Devon DuVernet on 13-02-05.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SCCustomer.h"
#import "SCAddress.h"
#import "SCEmail.h"
#import "SCOrder.h"
#import "SCSalesRep.h"
#import "SCSalesTerm.h"


@implementation SCCustomer

@dynamic customerId;
@dynamic familyName;
@dynamic givenName;
@dynamic middleName;
@dynamic name;
@dynamic dbaName;
@dynamic notes;
@dynamic qbId;
@dynamic shipVia;
@dynamic title;
@dynamic country;
@dynamic addressList;
@dynamic emailList;
@dynamic orderList;
@dynamic phoneList;
@dynamic primaryBillingAddress;
@dynamic primaryShippingAddress;
@dynamic salesRep;
@dynamic salesTerms;

-(NSString *)mainEmail
{ // For now only show Business/Main email
    NSString *returnString = @"";
    for (SCEmail *email in self.emailList)
    {
        if ([email.tag isEqualToString:@"Business"]) 
            returnString = [NSString stringWithFormat:@"%@%@", returnString, email.address];
    }
    return returnString;
}









@end
