//
//  SCOrderMasterVC.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-07.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCConfirmDeleteVCDelegate.h"

@class SCOrder;

@interface SCOrderMasterVC : UITableViewController <SCConfirmDeleteVCDelegate>


//This is a work around for not being able to animate the detail view when order mode starts, when order mode views are fronted by a nav controller.  So I dropped the nav controller and now we have to keep track of the stack once order mode starts.
@property int numberOfLookModeViews;


- (void)closeOrderMode;
- (void)processAppearedDetailVC:(UIViewController *)vC;
- (NSString *)menuItemLabelForVC:(UIViewController *)vC;
+ (NSString *)masterVCTitleFromOrder:(SCOrder *)order;

@end
