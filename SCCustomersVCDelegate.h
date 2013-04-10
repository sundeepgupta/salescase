//
//  SCCustomersVCDelegate.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-17.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCCustomer;

@protocol SCCustomersVCDelegate <NSObject>
@optional
- (void)passCustomer:(SCCustomer *)customer;
@end
