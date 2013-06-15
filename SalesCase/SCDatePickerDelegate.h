//
//  SCDatePickerDelegate.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-23.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCDatePickerDelegate <NSObject>
@optional
- (void)passDate:(NSDate *)date;
@end
