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
#import "SCPhone.h"


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
@dynamic status;
@dynamic image;

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



-(NSString *)phoneForTag:(NSString *)tag
{
    NSString *returnString = @"";
    for (SCPhone *phone in self.phoneList)
    {
        if ([phone.tag isEqualToString:tag])
            returnString = [NSString stringWithFormat:@"%@%@", returnString, phone.freeFormNumber];
    }
    return returnString;
}


@end


@implementation ImageToDataTransformer

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}

- (id)transformedValue:(id)value {
	NSData *data = UIImagePNGRepresentation(value);
	return data;
}

- (id)reverseTransformedValue:(id)value {
	UIImage *uiImage = [[UIImage alloc] initWithData:value];
	return uiImage;
}

@end
