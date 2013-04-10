//
//  SCCustomerDetailVC.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-07.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCustomersVCDelegate.h"

@class SCCustomer, SCAddress, SCOpenOrderC, SCOrder;

@interface SCCustomerDetailVC : UIViewController <SCCustomersVCDelegate>

@property (nonatomic, strong) SCCustomer *customer;



@end



