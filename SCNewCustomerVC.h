//
//  SCNewCustomerVC.h
//  SalesCase
//
//  Created by Sundeep Gupta on 13-04-15.
//  Copyright (c) 2013 EnhanceTrade. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCCustomer;

@interface SCNewCustomerVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) SCCustomer *customer;

@end
