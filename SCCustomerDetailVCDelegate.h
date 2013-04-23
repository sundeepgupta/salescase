//
//  SCCustomerDetailVCDelegate.h
//  SalesCase
//
//  Created by Sundeep Gupta on 13-04-19.
//  Copyright (c) 2013 EnhanceTrade. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCCustomer;

@protocol SCCustomerDetailVCDelegate <NSObject>
@required
- (void)passSavedCustomer:(SCCustomer *)customer;

@end
