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
    
 
    
//    This was Al's version, which doesn't work.  
//    NSString *line4;
//    if (self.line4) {
//        line4 = self.line4;
//    }
//    // Line 4 seems to be reserved for the ZIP + PROVINCE + COUNTRY,
//    if (self.city) {
//        BOOL foundCity = '\0';
//        BOOL foundProvince;
//        BOOL foundZip;
//        
//        if (self.city) {
//            NSRange cityRange = [line4 rangeOfString:self.city options:NSCaseInsensitiveSearch];
//            foundCity = cityRange.location != NSNotFound;
//        }
//        if (self.countrySubDivisionCode) {
//            NSRange provinceRange = [line4 rangeOfString:self.countrySubDivisionCode options:NSCaseInsensitiveSearch];
//            foundProvince = provinceRange.location != NSNotFound;
//        }
//        if (self.postalCode) {
//            NSRange zipRange = [line4 rangeOfString:self.postalCode options:NSCaseInsensitiveSearch];
//            foundZip = zipRange.location != NSNotFound;
//        }
//        if( !foundCity || !foundProvince || !foundZip ) {
//            NSString *cityLine = @"";
//            if (self.city) {
//                cityLine = [NSString stringWithFormat:@"%@%@, ", cityLine, self.city];
//            }
//            if (self.countrySubDivisionCode) {
//                cityLine = [NSString stringWithFormat:@"%@%@ ", cityLine, self.countrySubDivisionCode];
//            }
//            if (self.postalCode) {
//                cityLine = [NSString stringWithFormat:@"%@%@ ", cityLine, self.postalCode];
//            }
//            if (self.country) {
//                cityLine = [NSString stringWithFormat:@"%@%@", cityLine, self.country];
//            }
//            line4 = [NSString stringWithFormat:@"%@%@", line4, cityLine];
//        }
//    }
//    if (line4)
//        [block addObject:line4];
    

    
    //DEBUG
//    for (int i = 0; i < block.count; i++) {
//        NSLog(@"%d: %@", i + 1, block[i]);
//    }
    
    
    return lines;
}














@end
