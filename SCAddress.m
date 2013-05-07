//
//  SCAddress.m
//  SalesCase2
//
//  Created by Devon DuVernet on 13-02-05.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SCAddress.h"
#import "SCCustomer.h"


@implementation SCAddress

@dynamic city;
@dynamic contactName;
@dynamic countrySubDivisionCode;
@dynamic line1;
@dynamic line2;
@dynamic line3;
@dynamic line4;
@dynamic notes;
@dynamic postalCode;
@dynamic qbId;
@dynamic tag;
@dynamic country;
@dynamic line5;
@dynamic owningCustomer;



- (NSArray *)lines
{
    NSMutableArray *lines = [[NSMutableArray alloc] init];
    
   //These 7 lines are used for entering new customers so they must be checked.
    if (self.line1)        [lines addObject:self.line1];
    if (self.line2)        [lines addObject:self.line2];
    if (self.line3)        [lines addObject:self.line3];
    if (self.city)        [lines addObject:self.city];
    if (self.countrySubDivisionCode) [lines addObject:self.countrySubDivisionCode];
    if (self.postalCode) [lines addObject:self.postalCode];
    if (self.country) [lines addObject:self.country];
    
    //Lines 4 and 5 are sometimes used if coming from IPP (in place of other lines above)
    if (self.line4)        [lines addObject:self.line4];
    if (self.line5)        [lines addObject:self.line5];

    //Not sure if ever used, but adding just in case
    if (self.notes) [lines addObject:self.notes];
  
    return lines;
}

- (NSArray *)fiveLines
{
    NSMutableArray *lines = [[NSMutableArray alloc] init];
    if (self.line1) [lines addObject:self.line1];
    if (self.line2) [lines addObject:self.line2];
    if (self.line3) [lines addObject:self.line3];
    
    //put city , state, zip into one line
    NSString *city;
    if (self.city) city = self.city;
    else city = @"";

    NSString *countrySubDivisionCode;
    if (self.countrySubDivisionCode) countrySubDivisionCode = self.countrySubDivisionCode;
    else countrySubDivisionCode = @"";
    
    NSString *postalCode;
    if (self.postalCode) postalCode = self.postalCode;
    else postalCode = @"";

    if (city.length + countrySubDivisionCode.length + postalCode.length != 0) {
        NSString *cityStateZipLine = [NSString stringWithFormat:@"%@, %@ %@", city, countrySubDivisionCode, postalCode];
        [lines addObject:cityStateZipLine];
    }
    
    if (self.country) [lines addObject:self.country];

    return lines;
}













@end
