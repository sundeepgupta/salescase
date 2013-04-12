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



- (NSArray *)addressBlock
{
    NSMutableArray *block = [[NSMutableArray alloc] init];
    
    //QB made a mess of this, so hoping for the best here.
    //Line 1 and 2 seem to be always consistent.  Everything else cna change.  
    if (self.line1)
        [block addObject:self.line1];
    if (self.line2)
        [block addObject:self.line2];
    if (self.line3)
        [block addObject:self.line3];        
    
    if (self.city)
        [block addObject:self.city];

    //This seems to be the notes field every time.  But sometimes doesn't make it either into IPP either.
    if (self.line4)
        [block addObject:self.line4];
    
    //I don't think Line 5 ever exists in the IPP object
    if (self.line5)
        [block addObject:self.line5];
    
 
    
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
    
    
    return block;
}














@end
