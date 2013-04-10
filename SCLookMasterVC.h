//
//  SCLookMasterVC.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-05.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCSyncVCDelegate.h"
#import <MessageUI/MessageUI.h>

@class SCOrder, SCCustomer, SCItem;

@interface SCLookMasterVC : UITableViewController <SCSyncVCDelegate, MFMailComposeViewControllerDelegate>

- (NSString *)menuItemLabelForVC:(UIViewController *)vC;
- (void)startOrderMode;
- (void)startOrderModeWithCustomer:(SCCustomer *)customer;
- (void)startOrderModeWithItem:(SCItem *)item;
- (void)startOrderModeWithOrder:(SCOrder *)order;

- (BOOL)dataExists;
- (void)presentNoDataVC;

- (void)emailSupport;
@end
