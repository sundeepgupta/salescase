//
//  SCNewCustomerVC.h
//  SalesCase
//
//  Created by Sundeep Gupta on 13-04-15.
//  Copyright (c) 2013 EnhanceTrade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPopoverTableDelegate.h"
#import "SCCustomersVCDelegate.h"
#import "SCCustomerDetailVCDelegate.h"

@class SCCustomer, SCAddress, SCOrder;

@interface SCCustomerDetailVC : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, SCPopoverTableDelegate, SCCustomersVCDelegate, UIPopoverControllerDelegate> //UIImagePickerControllerDelegate, UINavigationControllerDelegate are for capturing a photo via camera

@property (strong, nonatomic) SCCustomer *customer;
@property (weak, nonatomic) id <SCCustomerDetailVCDelegate> delegate;

+ (void)loadAddressDataFromLines:(NSArray *)lines toLabels:(NSArray *)labels;

@end
